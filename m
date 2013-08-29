Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274Ab3H2XjW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 19:39:22 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:56549 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200Ab3H2XjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 19:39:20 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Tim Gardner <tim.gardner@canonical.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, Gao feng <gaofeng@cn.fujitsu.com>,
        Joe Perches <joe@perches.com>, Veaceslav Falico <vfalico@redhat.com>
References: <8761upbd6h.fsf@xmission.com>
	<1377779927-28500-1-git-send-email-tim.gardner@canonical.com>
Date: Thu, 29 Aug 2013 16:39:04 -0700
In-Reply-To: <1377779927-28500-1-git-send-email-tim.gardner@canonical.com>
	(Tim Gardner's message of "Thu, 29 Aug 2013 06:38:47 -0600")
Message-ID: <87wqn4ysmf.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1//DahZQWi+rMBzXLAtzV9HLjJ62A9KQvE=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4982]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.2 T_XMDrugObfuBody_14 obfuscated drug references
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Tim Gardner <tim.gardner@canonical.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH net-next v2] net: neighbour: Remove CONFIG_ARPD
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Gardner <tim.gardner@canonical.com> writes:

> This config option is superfluous in that it only guards a call
> to neigh_app_ns(). Enabling CONFIG_ARPD by default has no
> change in behavior. There will now be call to __neigh_notify()
> for each ARP resolution, which has no impact unless there is a
> user space daemon waiting to receive the notification, i.e.,
> the case for which CONFIG_ARPD was designed anyways.

This looks good to me, and much less magic to maintain.

Eric


> Suggested-by: Eric W. Biederman <ebiederm@xmission.com>
Reviewed-by: "Eric W. Biederman" <ebiederm@xmission.com>

> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
> Cc: James Morris <jmorris@namei.org>
> Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
> Cc: Patrick McHardy <kaber@trash.net>
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> Cc: Gao feng <gaofeng@cn.fujitsu.com>
> Cc: Joe Perches <joe@perches.com>
> Cc: Veaceslav Falico <vfalico@redhat.com>
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> ---
>
> Eric's suggestion to simply remove the config option makes sense
> to me. If acceptable then I'll submit a patch series that also removes
> CONFIG_ARPD from the various arch defconfigs.
>
>  net/core/neighbour.c |    2 --
>  net/ipv4/Kconfig     |   16 ----------------
>  net/ipv4/arp.c       |    2 --
>  net/ipv6/ndisc.c     |    2 --
>  4 files changed, 22 deletions(-)
>
> diff --git a/net/core/neighbour.c b/net/core/neighbour.c
> index 60533db..6072610 100644
> --- a/net/core/neighbour.c
> +++ b/net/core/neighbour.c
> @@ -2759,13 +2759,11 @@ errout:
>  		rtnl_set_sk_err(net, RTNLGRP_NEIGH, err);
>  }
>  
> -#ifdef CONFIG_ARPD
>  void neigh_app_ns(struct neighbour *n)
>  {
>  	__neigh_notify(n, RTM_GETNEIGH, NLM_F_REQUEST);
>  }
>  EXPORT_SYMBOL(neigh_app_ns);
> -#endif /* CONFIG_ARPD */
>  
>  #ifdef CONFIG_SYSCTL
>  static int zero;
> diff --git a/net/ipv4/Kconfig b/net/ipv4/Kconfig
> index 37cf1a6..05c57f0 100644
> --- a/net/ipv4/Kconfig
> +++ b/net/ipv4/Kconfig
> @@ -259,22 +259,6 @@ config IP_PIMSM_V2
>  	  gated-5). This routing protocol is not used widely, so say N unless
>  	  you want to play with it.
>  
> -config ARPD
> -	bool "IP: ARP daemon support"
> -	---help---
> -	  The kernel maintains an internal cache which maps IP addresses to
> -	  hardware addresses on the local network, so that Ethernet
> -	  frames are sent to the proper address on the physical networking
> -	  layer. Normally, kernel uses the ARP protocol to resolve these
> -	  mappings.
> -
> -	  Saying Y here adds support to have an user space daemon to do this
> -	  resolution instead. This is useful for implementing an alternate
> -	  address resolution protocol (e.g. NHRP on mGRE tunnels) and also for
> -	  testing purposes.
> -
> -	  If unsure, say N.
> -
>  config SYN_COOKIES
>  	bool "IP: TCP syncookie support"
>  	---help---
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
