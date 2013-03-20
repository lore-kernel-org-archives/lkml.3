Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756347Ab3CTR4v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 13:56:51 -0400
Received: from 95-31-19-74.broadband.corbina.ru ([95.31.19.74]:53619 "EHLO
	mail.izyk.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756079Ab3CTR4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 13:56:49 -0400
Message-ID: <5149F85E.8080502@izyk.ru>
Date: Wed, 20 Mar 2013 21:56:46 +0400
From: Ilya Zykov <linux@izyk.ru>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH] tty: Fix race condition if flushing tty flip buffers
References: <5149AFD0.8020604@izyk.ru> <1363800043-21449-1-git-send-email-peter@hurleysoftware.com>
In-Reply-To: <1363800043-21449-1-git-send-email-peter@hurleysoftware.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.03.2013 21:20, Peter Hurley wrote:
> As Ilya Zykov identified in his patch 'PROBLEM: Race condition in
> tty buffer's function flush_to_ldisc()', a race condition exists
> which allows a parallel flush_to_ldisc() to flush and free the tty
> flip buffers while those buffers are in-use. For example,
> 
>   CPU 0                         |  CPU 1                                  |  CPU 2
>                                 | flush_to_ldisc()                        |
>                                 |  grab spin lock                         |
> tty_buffer_flush()              |                                         | flush_to_ldisc()
>  wait for spin lock             |                                         |  wait for spin lock
>                                 |   if (!test_and_set_bit(TTYP_FLUSHING)) |
>                                 |    while (next flip buffer)             |
>                                 |     ...                                 |
>                                 |     drop spin lock                      |
>   grab spin lock                |                                         |
>    if (test_bit(TTYP_FLUSHING)) |                                         |
>     set_bit(TTYP_FLUSHPENDING)  |      receive_buf()                      |
>     drop spin lock              |                                         |
>                                 |                                         |   grab spin lock
>                                 |                                         |    if (!test_and_set_bit(TTYP_FLUSHING))
>                                 |                                         |    if (test_bit(TTYP_FLUSHPENDING))
>                                 |                                         |    __tty_buffer_flush()
> 
> CPU 2 has just flushed and freed all tty flip buffers while CPU 1 is
> transferring data from the head flip buffer.
> 
> The original patch was rejected under the assumption that parallel
> flush_to_ldisc() was not possible. Because of necessary changes to
> the workqueue api, work items can execute in parallel on SMP.
> 
> This patch differs slightly from the original patch by testing for
> a pending flush _after_ each receive_buf(), since TTYP_FLUSHPENDING
> can only be set while the lock is dropped around receive_buf().
> 
> Reported-by: Ilya Zykov <linux@izyk.ru>
> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
> ---
>  drivers/tty/tty_buffer.c | 22 ++++++++++------------
>  1 file changed, 10 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
> index bb11993..9fd8acd 100644
> --- a/drivers/tty/tty_buffer.c
> +++ b/drivers/tty/tty_buffer.c
> @@ -449,11 +449,6 @@ static void flush_to_ldisc(struct work_struct *work)
>  				tty_buffer_free(port, head);
>  				continue;
>  			}
> -			/* Ldisc or user is trying to flush the buffers
> -			   we are feeding to the ldisc, stop feeding the
> -			   line discipline as we want to empty the queue */
> -			if (test_bit(TTYP_FLUSHPENDING, &port->iflags))
> -				break;
>  			if (!tty->receive_room)
>  				break;
>  			if (count > tty->receive_room)
> @@ -465,17 +460,20 @@ static void flush_to_ldisc(struct work_struct *work)
>  			disc->ops->receive_buf(tty, char_buf,
>  							flag_buf, count);
>  			spin_lock_irqsave(&buf->lock, flags);
> +			/* Ldisc or user is trying to flush the buffers.
> +			   We may have a deferred request to flush the
> +			   input buffer, if so pull the chain under the lock
> +			   and empty the queue */
> +			if (test_bit(TTYP_FLUSHPENDING, &port->iflags)) {
> +				__tty_buffer_flush(port);
> +				clear_bit(TTYP_FLUSHPENDING, &port->iflags);
> +				wake_up(&tty->read_wait);
> +				break;
> +			}
>  		}
>  		clear_bit(TTYP_FLUSHING, &port->iflags);
>  	}
>  
> -	/* We may have a deferred request to flush the input buffer,
> -	   if so pull the chain under the lock and empty the queue */
> -	if (test_bit(TTYP_FLUSHPENDING, &port->iflags)) {
> -		__tty_buffer_flush(port);
> -		clear_bit(TTYP_FLUSHPENDING, &port->iflags);
> -		wake_up(&tty->read_wait);
> -	}
>  	spin_unlock_irqrestore(&buf->lock, flags);
>  
>  	tty_ldisc_deref(disc);
> 

Acked-by: Ilya Zykov <linux@izyk.ru>

