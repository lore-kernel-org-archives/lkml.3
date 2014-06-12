Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045AbaFLOKJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 10:10:09 -0400
Received: from www.linutronix.de ([62.245.132.108]:41660 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674AbaFLOKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 10:10:04 -0400
Date: Thu, 12 Jun 2014 16:09:32 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Johannes Berg <johannes@sipsolutions.net>
cc: LKML <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org,
        Stephen Hemminger <shemminger@linux-foundation.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: net_timedelta() affected by settimeofday() (was: [patch 12/13]
 net: mac80211: Remove silly timespec dance)
In-Reply-To: <1402564914.8095.9.camel@jlt4.sipsolutions.net>
Message-ID: <alpine.DEB.2.10.1406121605470.5170@nanos>
References: <20140611234024.103571777@linutronix.de>   <20140611234607.683770899@linutronix.de>   <1402555774.4224.1.camel@jlt4.sipsolutions.net>   <alpine.DEB.2.10.1406121017500.5170@nanos>   <1402562114.8095.3.camel@jlt4.sipsolutions.net>  
 (sfid-20140612_103558_525847_209A5C98) <1402562399.8095.5.camel@jlt4.sipsolutions.net>  <alpine.DEB.2.10.1406121047280.5170@nanos> <1402564914.8095.9.camel@jlt4.sipsolutions.net>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jun 2014, Johannes Berg wrote:

> On Thu, 2014-06-12 at 10:57 +0200, Thomas Gleixner wrote:
> 
> > > > Right, but isn't that odd? Suddenly your delay measurement here might be
> > > > minutes, hours, or years if you settimeofday() between timestamping and
> > > > calculating the delta. That seems very strange to me, why would that be
> > > > the right behaviour in any way?
> > 
> > Indeed. clock monotonic is the appropriate one for measurements.
> 
> And that's what we had here with ktime_get_ts()? I thought so, just
> making sure.
>  
> > > > Now, it seems that there are only two current users of net_timedelta()
> > > > (in DCCP) so perhaps it's not too late to change some of this?
> > > > 
> > > > Maybe in general the skb timestamp should be based on a different clock
> > > > and only adjusted to real time when used in userspace?
> > 
> > You have the same problem then, just at a different place:
> > 
> >     ts = ktime_get();
> > 
> > 			settimeofday()
> > 			   offset_mono_to_real = new value;
> > 
> >     userts = mono_to_real(ts);
> 
> Right. I'm not really sure if that's an issue though.
> 
> > But maybe that's not a real issue, as ktime_get_real() can race with
> > settimeofday() or NTP as well.
> > 
> >    ts = ktime_get_real();
> > 				settimeofday();
> >    userts = ts;
> > 
> > So the user might see a weird timestamp for a packet, which cannot be
> > correlated with the user space gettimeofday().
> 
> Right, once settimeofday() is called the timestamps from before/during
> it can't really be correlated any more.
> 
> This is part of the userspace API already, but might it have been better
> to expose the monotonic clock, since userspace can also get at it? Not
> sure.
> 
> Either way it's an issue I guess; however I'm thinking your patch is
> making it worse for the measurement in this particular code (where the
> userspace issue doesn't come in, it should never be accessible there)

Fair enough. Still the timespec is silly. Here is an updated version.

Thanks,

	tglx

------------------>

Subject: net: Mac80211: Remove silly timespec dance
From: Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 11 Jun 2014 23:59:18 -0000

Converting time from one format to another seems to give coders a warm
and fuzzy feeling.

Use the proper interfaces.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: John W. Linville <linville@tuxdriver.com>
---
 net/mac80211/status.c |    7 ++-----
 net/mac80211/tx.c     |    5 +----
 2 files changed, 3 insertions(+), 9 deletions(-)


Index: tip/net/mac80211/status.c
===================================================================
--- tip.orig/net/mac80211/status.c
+++ tip/net/mac80211/status.c
@@ -473,8 +473,6 @@ static void ieee80211_tx_latency_end_msr
 					    struct sta_info *sta,
 					    struct ieee80211_hdr *hdr)
 {
-	ktime_t skb_dprt;
-	struct timespec dprt_time;
 	u32 msrmnt;
 	u16 tid;
 	u8 *qc;
@@ -506,9 +504,8 @@ static void ieee80211_tx_latency_end_msr
 
 	tx_lat = &sta->tx_lat[tid];
 
-	ktime_get_ts(&dprt_time); /* time stamp completion time */
-	skb_dprt = ktime_set(dprt_time.tv_sec, dprt_time.tv_nsec);
-	msrmnt = ktime_to_ms(ktime_sub(skb_dprt, skb_arv));
+	/* Calculate the latency */
+	msrmnt = ktime_to_ms(ktime_sub(ktime_get(), skb_arv);
 
 	if (tx_lat->max < msrmnt) /* update stats */
 		tx_lat->max = msrmnt;
Index: tip/net/mac80211/tx.c
===================================================================
--- tip.orig/net/mac80211/tx.c
+++ tip/net/mac80211/tx.c
@@ -1767,15 +1767,12 @@ fail:
 static void ieee80211_tx_latency_start_msrmnt(struct ieee80211_local *local,
 					      struct sk_buff *skb)
 {
-	struct timespec skb_arv;
 	struct ieee80211_tx_latency_bin_ranges *tx_latency;
 
 	tx_latency = rcu_dereference(local->tx_latency);
 	if (!tx_latency)
 		return;
-
-	ktime_get_ts(&skb_arv);
-	skb->tstamp = ktime_set(skb_arv.tv_sec, skb_arv.tv_nsec);
+	skb->tstamp = ktime_get();
 }
 
 /**
