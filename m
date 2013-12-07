Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758032Ab3LGCir (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 21:38:47 -0500
Received: from mail-qe0-f51.google.com ([209.85.128.51]:46079 "EHLO
	mail-qe0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766Ab3LGCiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 21:38:46 -0500
Message-ID: <52A28A33.4080306@gmail.com>
Date: Fri, 06 Dec 2013 21:38:43 -0500
From: Vlad Yasevich <vyasevich@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Zhi Yong Wu <zwu.kernel@gmail.com>, davem@davemloft.net
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH 1/2] macvtap: remove useless codes in macvtap_aio_read()
 and macvtap_recvmsg()
References: <1386363300-19040-1-git-send-email-zwu.kernel@gmail.com>
In-Reply-To: <1386363300-19040-1-git-send-email-zwu.kernel@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2013 03:54 PM, Zhi Yong Wu wrote:
> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> 
> By checking related codes, it is impossible that ret > len or total_len,
> so we should remove some useless coeds in both above functions.

Looks like commit 6680ec68eff47d36f67b4351bc9836fd6cba9532
Author: Jason Wang <jasowang@redhat.com>
Date:   Thu Jul 25 13:00:33 2013 +0800

    tuntap: hardware vlan tx support

Introduced a change in tun_put_user() where we can
never return a length longer then len or total_len.
This has an effect that is now impossible to signal
truncated status.  It seems like a potential loss
of functionality and it might make sense to restore it.

-vlad
> 
> Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> ---
>  drivers/net/macvtap.c |    5 -----
>  1 files changed, 0 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
> index 4c6f84c..7f4ccdd 100644
> --- a/drivers/net/macvtap.c
> +++ b/drivers/net/macvtap.c
> @@ -871,7 +871,6 @@ static ssize_t macvtap_aio_read(struct kiocb *iocb, const struct iovec *iv,
>  	}
>  
>  	ret = macvtap_do_read(q, iv, len, file->f_flags & O_NONBLOCK);
> -	ret = min_t(ssize_t, ret, len); /* XXX copied from tun.c. Why? */
>  out:
>  	return ret;
>  }
> @@ -1104,10 +1103,6 @@ static int macvtap_recvmsg(struct kiocb *iocb, struct socket *sock,
>  		return -EINVAL;
>  	ret = macvtap_do_read(q, m->msg_iov, total_len,
>  			  flags & MSG_DONTWAIT);
> -	if (ret > total_len) {
> -		m->msg_flags |= MSG_TRUNC;
> -		ret = flags & MSG_TRUNC ? ret : total_len;
> -	}
>  	return ret;
>  }
>  
> 

