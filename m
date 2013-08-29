Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485Ab3H2Bcc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 21:32:32 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:33806 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443Ab3H2Bc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 21:32:29 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Joe Perches <joe@perches.com>
Cc: Tim Gardner <tim.gardner@canonical.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, Gao feng <gaofeng@cn.fujitsu.com>
References: <1377714286-51816-1-git-send-email-tim.gardner@canonical.com>
	<1377715873.1928.47.camel@joe-AO722> <521E4AE6.7080703@canonical.com>
	<1377739568.1928.64.camel@joe-AO722>
Date: Wed, 28 Aug 2013 18:32:19 -0700
In-Reply-To: <1377739568.1928.64.camel@joe-AO722> (Joe Perches's message of
	"Wed, 28 Aug 2013 18:26:08 -0700")
Message-ID: <87bo4h5ljw.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/nY2QdCkEjWPpildZKbVdTAUgjl/7H1eE=
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
X-Spam-Combo: ;Joe Perches <joe@perches.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH net-next 1/1] net: neighbour: Simplify ifdefs around neigh_app_ns()
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches <joe@perches.com> writes:

> On Wed, 2013-08-28 at 13:09 -0600, Tim Gardner wrote:
>> On 08/28/2013 12:51 PM, Joe Perches wrote:
>> > On Wed, 2013-08-28 at 12:24 -0600, Tim Gardner wrote:
>> >> Drop a couple of ifdef/endif pairs by moving the ifdef
>> >> surrounding neigh_app_ns() to the interior of neigh_app_ns().
>> > []
>> >> This is an admittedly trivial change. I stumbled on it while trying to figure
>> >> out why Ubuntu doesn't have CONFIG_ARPD enabled.
>
>> > I'd be more inclined to make neigh_app_ns static inline
>> > in the .h file and remove the EXPORT_SYMBOL
>
>> I thought about that as well, but then you'd have to extern
>> __neigh_notify(), which is currently a static function and large enough
>> to not really be suitable for inlining. Seems like unnecessary churn to me.
>
> Hi Tim.
>
> As is, this makes the call to neight_app_ns
> impossible to optimize away.
>
> Perhaps this:
>
> (this does add a possibly unused neigh_notify as a global symbol)
>
> Rename __neigh_notify to neigh_notify and make public
> Add static inline neigh_app_ns
> Remove #ifdefs around use of neigh_app_ns

Again.  Why not just remove CONFIG_ARPD entirely?  A config option to
compile out a single line of code seems like a real waste.

Eric

> ---
>
> Compile tested only
>
>  include/net/neighbour.h | 10 +++++++++-
>  net/core/neighbour.c    | 15 +++------------
>  net/ipv4/arp.c          |  2 --
>  net/ipv6/ndisc.c        |  2 --
>  4 files changed, 12 insertions(+), 17 deletions(-)
>
> diff --git a/include/net/neighbour.h b/include/net/neighbour.h
> index 536501a..a08b0a7 100644
> --- a/include/net/neighbour.h
> +++ b/include/net/neighbour.h
> @@ -249,7 +249,15 @@ static inline struct net *pneigh_net(const struct pneigh_entry *pneigh)
>  	return read_pnet(&pneigh->net);
>  }
>  
> -void neigh_app_ns(struct neighbour *n);
> +void neigh_notify(struct neighbour *n, int type, int flags);
> +
> +static inline void neigh_app_ns(struct neighbour *n)
> +{
> +#ifdef CONFIG_ARPD
> +	neigh_notify(n, RTM_GETNEIGH, NLM_F_REQUEST);
> +#endif
> +}
> +
>  void neigh_for_each(struct neigh_table *tbl,
>  		    void (*cb)(struct neighbour *, void *), void *cookie);
>  void __neigh_for_each_release(struct neigh_table *tbl,
> diff --git a/net/core/neighbour.c b/net/core/neighbour.c
> index 60533db..6ec5f86 100644
> --- a/net/core/neighbour.c
> +++ b/net/core/neighbour.c
> @@ -50,7 +50,6 @@ do {						\
>  #define PNEIGH_HASHMASK		0xF
>  
>  static void neigh_timer_handler(unsigned long arg);
> -static void __neigh_notify(struct neighbour *n, int type, int flags);
>  static void neigh_update_notify(struct neighbour *neigh);
>  static int pneigh_ifdown(struct neigh_table *tbl, struct net_device *dev);
>  
> @@ -103,7 +102,7 @@ static void neigh_cleanup_and_release(struct neighbour *neigh)
>  	if (neigh->parms->neigh_cleanup)
>  		neigh->parms->neigh_cleanup(neigh);
>  
> -	__neigh_notify(neigh, RTM_DELNEIGH, 0);
> +	neigh_notify(neigh, RTM_DELNEIGH, 0);
>  	neigh_release(neigh);
>  }
>  
> @@ -2215,7 +2214,7 @@ nla_put_failure:
>  static void neigh_update_notify(struct neighbour *neigh)
>  {
>  	call_netevent_notifiers(NETEVENT_NEIGH_UPDATE, neigh);
> -	__neigh_notify(neigh, RTM_NEWNEIGH, 0);
> +	neigh_notify(neigh, RTM_NEWNEIGH, 0);
>  }
>  
>  static int neigh_dump_table(struct neigh_table *tbl, struct sk_buff *skb,
> @@ -2735,7 +2734,7 @@ static inline size_t neigh_nlmsg_size(void)
>  	       + nla_total_size(4); /* NDA_PROBES */
>  }
>  
> -static void __neigh_notify(struct neighbour *n, int type, int flags)
> +void neigh_notify(struct neighbour *n, int type, int flags)
>  {
>  	struct net *net = dev_net(n->dev);
>  	struct sk_buff *skb;
> @@ -2759,14 +2758,6 @@ errout:
>  		rtnl_set_sk_err(net, RTNLGRP_NEIGH, err);
>  }
>  
> -#ifdef CONFIG_ARPD
> -void neigh_app_ns(struct neighbour *n)
> -{
> -	__neigh_notify(n, RTM_GETNEIGH, NLM_F_REQUEST);
> -}
> -EXPORT_SYMBOL(neigh_app_ns);
> -#endif /* CONFIG_ARPD */
> -
>  #ifdef CONFIG_SYSCTL
>  static int zero;
>  static int int_max = INT_MAX;
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
