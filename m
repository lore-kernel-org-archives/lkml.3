Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453Ab3I3MnZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 08:43:25 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:26964 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848Ab3I3MnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 08:43:22 -0400
Date: Mon, 30 Sep 2013 15:42:16 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Dominik Paulus <dominik.paulus@fau.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Anthony Foiani <anthony.foiani@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@i4.cs.fau.de, linux-kernel@vger.kernel.org,
        tobias.polzer@fau.de, Ilija Hadzic <ihadzic@research.bell-labs.com>
Subject: Re: [PATCHv3  13/16] staging: usbip: Wrap kernel_sendmsg()/recvmsg()
Message-ID: <20130930124216.GJ6192@mwanda>
References: <20130925233638.GA21396@kroah.com>
 <1380390173-3746-1-git-send-email-dominik.paulus@fau.de>
 <1380390173-3746-13-git-send-email-dominik.paulus@fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380390173-3746-13-git-send-email-dominik.paulus@fau.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 28, 2013 at 07:42:50PM +0200, Dominik Paulus wrote:
> @@ -352,34 +352,29 @@ int usbip_recv(struct socket *sock, void *buf, int size)
>  
>  	usbip_dbg_xmit("enter\n");
>  
> -	if (!sock || !buf || !size) {
> -		pr_err("invalid arg, sock %p buff %p size %d\n", sock, buf,
> +	if (!ud || !buf || !size) {
> +		pr_err("invalid arg, ud %p buff %p size %d\n", ud, buf,
>  		       size);

"size" can fit on the first line now.

		pr_err("invalid arg, ud %p buff %p size %d\n", ud, buf, size);

>  		return -EINVAL;
>  	}
>  
> -	do {
> -		sock->sk->sk_allocation = GFP_NOIO;
> -		iov.iov_base    = buf;
> -		iov.iov_len     = size;
> -		msg.msg_name    = NULL;
> -		msg.msg_namelen = 0;
> -		msg.msg_control = NULL;
> -		msg.msg_controllen = 0;
> -		msg.msg_namelen    = 0;
> -		msg.msg_flags      = MSG_NOSIGNAL;
> -
> -		result = kernel_recvmsg(sock, &msg, &iov, 1, size, MSG_WAITALL);
> -		if (result <= 0) {
> -			pr_debug("receive sock %p buf %p size %u ret %d total %d\n",
> -				 sock, buf, size, result, total);
> -			goto err;
> -		}
> -
> -		size -= result;
> -		buf += result;
> -		total += result;
> -	} while (size > 0);
> +	ud->tcp_socket->sk->sk_allocation = GFP_NOIO;
> +	iov.iov_base    = buf;
> +	iov.iov_len     = size;
> +	msg.msg_name    = NULL;
> +	msg.msg_namelen = 0;
> +	msg.msg_control = NULL;
> +	msg.msg_controllen = 0;
> +	msg.msg_namelen    = 0;
> +	msg.msg_flags      = MSG_NOSIGNAL;
> +
> +	result = usbip_recvmsg(ud, &msg, &iov, 1, size, MSG_WAITALL);
> +

Don't put a blank line here.

> +	if (result < 0) {
> +		pr_debug("receive sock %p buf %p size %u ret %d total %d\n",
> +			 ud->tcp_socket, buf, size, result, total);
> +		return result;
> +	}
>  

regards,
dan carpenter
