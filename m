Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410Ab3H1Xgw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 19:36:52 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:49076 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755171Ab3H1Xgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 19:36:50 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Tim Gardner <tim.gardner@canonical.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, Gao feng <gaofeng@cn.fujitsu.com>,
        Joe Perches <joe@perches.com>
References: <1377714286-51816-1-git-send-email-tim.gardner@canonical.com>
Date: Wed, 28 Aug 2013 16:36:38 -0700
In-Reply-To: <1377714286-51816-1-git-send-email-tim.gardner@canonical.com>
	(Tim Gardner's message of "Wed, 28 Aug 2013 12:24:46 -0600")
Message-ID: <8761upbd6h.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/w4eutGEY6gYt+63pa6bBOG9hN89XwEvk=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4959]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_04 7+ unique symbols in subject
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Tim Gardner <tim.gardner@canonical.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH net-next 1/1] net: neighbour: Simplify ifdefs around neigh_app_ns()
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Gardner <tim.gardner@canonical.com> writes:

> Drop a couple of ifdef/endif pairs by moving the ifdef
> surrounding neigh_app_ns() to the interior of neigh_app_ns().

Can we please just remove the CONFIG_ARPD option entirely.

There really is no savings to keeping this option configurable and the
option only removes a netlink notification.

> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
> Cc: James Morris <jmorris@namei.org>
> Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
> Cc: Patrick McHardy <kaber@trash.net>
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> Cc: Gao feng <gaofeng@cn.fujitsu.com>
> Cc: Joe Perches <joe@perches.com>
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> ---
>
> This is an admittedly trivial change. I stumbled on it while trying to figure
> out why Ubuntu doesn't have CONFIG_ARPD enabled.
>
>  net/core/neighbour.c |    4 ++--
>  net/ipv4/arp.c       |    2 --
>  net/ipv6/ndisc.c     |    2 --
>  3 files changed, 2 insertions(+), 6 deletions(-)
>
> diff --git a/net/core/neighbour.c b/net/core/neighbour.c
> index 60533db..049dd9e 100644
> --- a/net/core/neighbour.c
> +++ b/net/core/neighbour.c
> @@ -2759,13 +2759,13 @@ errout:
>  		rtnl_set_sk_err(net, RTNLGRP_NEIGH, err);
>  }
>  
> -#ifdef CONFIG_ARPD
>  void neigh_app_ns(struct neighbour *n)
>  {
> +#ifdef CONFIG_ARPD
>  	__neigh_notify(n, RTM_GETNEIGH, NLM_F_REQUEST);
> +#endif /* CONFIG_ARPD */
>  }
>  EXPORT_SYMBOL(neigh_app_ns);
> -#endif /* CONFIG_ARPD */
>  
>  #ifdef CONFIG_SYSCTL
>  static int zero;
> diff --git a/net/ipv4/arp.c b/net/ipv4/arp.c
> index 4429b01..7808093 100644
> --- a/net/ipv4/arp.c
> +++ b/net/ipv4/arp.c
> @@ -368,9 +368,7 @@ static void arp_solicit(struct neighbour *neigh, struct sk_buff *skb)
>  	} else {
>  		probes -= neigh->parms->app_probes;
>  		if (probes < 0) {
> -#ifdef CONFIG_ARPD
>  			neigh_app_ns(neigh);
> -#endif
>  			return;
>  		}
>  	}
> diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
> index 04d31c2..d5693ad 100644
> --- a/net/ipv6/ndisc.c
> +++ b/net/ipv6/ndisc.c
> @@ -663,9 +663,7 @@ static void ndisc_solicit(struct neighbour *neigh, struct sk_buff *skb)
>  		}
>  		ndisc_send_ns(dev, neigh, target, target, saddr);
>  	} else if ((probes -= neigh->parms->app_probes) < 0) {
> -#ifdef CONFIG_ARPD
>  		neigh_app_ns(neigh);
> -#endif
>  	} else {
>  		addrconf_addr_solict_mult(target, &mcaddr);
>  		ndisc_send_ns(dev, NULL, target, &mcaddr, saddr);
