Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932905AbaLJSuH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 13:50:07 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:35707 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932674AbaLJSuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 13:50:05 -0500
Message-ID: <548895D9.6090402@suse.cz>
Date: Wed, 10 Dec 2014 19:50:01 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Denis Du <dudenis2000@yahoo.ca>, gregkh@linuxfoundation.org,
        jmmahler@gmail.com
CC: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: Re: [PATCH] TTY: Fix the missing lock for the TTY ldisc buffer
References: <5488931C.4040308@yahoo.ca>
In-Reply-To: <5488931C.4040308@yahoo.ca>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2014, 07:38 PM, Denis Du wrote:
> 
> Hi, Guys:

Hi, are you sending this using some robot? I think I have seen like ten
copies of this patch already.

> It was found that the 3.12 kernel tty layer will lose or corrupt data
> when have a full-duplex communication, especially in high baud rate, for
> example 230k for my OMAP5 uart. Eventually I found there is lock missing
> between copy data to ldisc layer buffer and copy data from the same
> buffer to user space. I believe this issue existed since 3.8
> kernel(since this kernel , it start to remove most of the spin-locks)
> and I didn't find any fix even through 3.17 kernel. This patch was
> tested to be works great with no any data loss again on 3.12 kernel.
> 
> This patch was built for the latest kernel, but I cannot test it.
> Somebody may give a test.
> 
> I did try to use the existed lock atomic_read_lock, but it doesn’t work.

Anyway, adding Peter Hurley to CC who was working on eliminating locks
from this code lately. More precisely since 3.12 we have no locks there,
which would explain why are you seeing it starting 3.12.

> Signed-off-by: Hui Du <dudenis2000@yahoo.ca>
> 
> ---
>  drivers/tty/n_tty.c |    9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
> index 2e900a9..6e5c6ae 100644
> --- a/drivers/tty/n_tty.c
> +++ b/drivers/tty/n_tty.c
> @@ -125,6 +125,7 @@ struct n_tty_data {
>  
>      struct mutex atomic_read_lock;
>      struct mutex output_lock;
> +    struct mutex read_buf_lock;
>  };
>  
>  static inline size_t read_cnt(struct n_tty_data *ldata)
> @@ -1691,7 +1692,7 @@ n_tty_receive_buf_common(struct tty_struct *tty,
> const unsigned char *cp,
>      int room, n, rcvd = 0;
>  
>      down_read(&tty->termios_rwsem);
> -
> +    mutex_lock(&ldata->read_buf_lock);
>      while (1) {
>          room = receive_room(tty);
>          n = min(count, room);
> @@ -1710,6 +1711,7 @@ n_tty_receive_buf_common(struct tty_struct *tty,
> const unsigned char *cp,
>  
>      tty->receive_room = room;
>      n_tty_check_throttle(tty);
> +    mutex_unlock(&ldata->read_buf_lock);
>      up_read(&tty->termios_rwsem);
>  
>      return rcvd;
> @@ -1876,6 +1878,7 @@ static int n_tty_open(struct tty_struct *tty)
>      ldata->overrun_time = jiffies;
>      mutex_init(&ldata->atomic_read_lock);
>      mutex_init(&ldata->output_lock);
> +    mutex_init(&ldata->read_buf_lock);
>  
>      tty->disc_data = ldata;
>      reset_buffer_flags(tty->disc_data);
> @@ -1939,6 +1942,7 @@ static int copy_from_read_buf(struct tty_struct *tty,
>      size_t tail = ldata->read_tail & (N_TTY_BUF_SIZE - 1);
>  
>      retval = 0;
> +    mutex_lock(&ldata->read_buf_lock);
>      n = min(read_cnt(ldata), N_TTY_BUF_SIZE - tail);
>      n = min(*nr, n);
>      if (n) {
> @@ -1954,6 +1958,7 @@ static int copy_from_read_buf(struct tty_struct *tty,
>          *b += n;
>          *nr -= n;
>      }
> +    mutex_unlock(&ldata->read_buf_lock);
>      return retval;
>  }
>  
> @@ -1992,6 +1997,7 @@ static int canon_copy_from_read_buf(struct
> tty_struct *tty,
>      bool eof_push = 0;
>  
>      /* N.B. avoid overrun if nr == 0 */
> +    mutex_lock(&ldata->read_buf_lock);
>      n = min(*nr, read_cnt(ldata));
>      if (!n)
>          return 0;
> @@ -2052,6 +2058,7 @@ static int canon_copy_from_read_buf(struct
> tty_struct *tty,
>              ldata->push = 0;
>          tty_audit_push(tty);
>      }
> +    mutex_unlock(&ldata->read_buf_lock);
>      return eof_push ? -EAGAIN : 0;
>  }
>  


-- 
js
suse labs
