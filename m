Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932702AbaBEUqT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:46:19 -0500
Received: from ja.ssi.bg ([178.16.129.10]:60691 "EHLO ja.home.ssi.bg"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S932601AbaBEUqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:46:14 -0500
X-Greylist: delayed 432 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Feb 2014 15:46:03 EST
Date: Wed, 5 Feb 2014 22:36:21 +0200 (EET)
From: Julian Anastasov <ja@ssi.bg>
X-X-Sender: ja@ja.home.ssi.bg
To: Paul Gortmaker <paul.gortmaker@windriver.com>
cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>,
        Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [v2.6.34-stable 032/213] ipvs: fix info leak in
 getsockopt(IP_VS_SO_GET_TIMEOUT)
In-Reply-To: <1391630568-49251-33-git-send-email-paul.gortmaker@windriver.com>
Message-ID: <alpine.LFD.2.11.1402052234230.1496@ja.home.ssi.bg>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com> <1391630568-49251-33-git-send-email-paul.gortmaker@windriver.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


	Hello,

On Wed, 5 Feb 2014, Paul Gortmaker wrote:

> From: Mathias Krause <minipli@googlemail.com>
> 
>                    -------------------
>     This is a commit scheduled for the next v2.6.34 longterm release.
>     http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
>     If you see a problem with using this for longterm, please comment.
>                    -------------------
> 
> commit 2d8a041b7bfe1097af21441cb77d6af95f4f4680 upstream.
> 
> If at least one of CONFIG_IP_VS_PROTO_TCP or CONFIG_IP_VS_PROTO_UDP is
> not set, __ip_vs_get_timeouts() does not fully initialize the structure
> that gets copied to userland and that for leaks up to 12 bytes of kernel
> stack. Add an explicit memset(0) before passing the structure to
> __ip_vs_get_timeouts() to avoid the info leak.

	I guess, this patch is not needed after commit
"ipvs: initialize returned data in do_ip_vs_get_ctl" because
the memset is already moved into __ip_vs_get_timeouts().

> Signed-off-by: Mathias Krause <minipli@googlemail.com>
> Cc: Wensong Zhang <wensong@linux-vs.org>
> Cc: Simon Horman <horms@verge.net.au>
> Cc: Julian Anastasov <ja@ssi.bg>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> ---
>  net/netfilter/ipvs/ip_vs_ctl.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
> index 36dc1d88c2fa..bd9d805a85a6 100644
> --- a/net/netfilter/ipvs/ip_vs_ctl.c
> +++ b/net/netfilter/ipvs/ip_vs_ctl.c
> @@ -2469,6 +2469,7 @@ do_ip_vs_get_ctl(struct sock *sk, int cmd, void __user *user, int *len)
>  	{
>  		struct ip_vs_timeout_user t;
>  
> +		memset(&t, 0, sizeof(t));
>  		__ip_vs_get_timeouts(&t);
>  		if (copy_to_user(user, &t, sizeof(t)) != 0)
>  			ret = -EFAULT;
> -- 
> 1.8.5.2

Regards

--
Julian Anastasov <ja@ssi.bg>
