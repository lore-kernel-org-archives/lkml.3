Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751769AbaJZVBj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 17:01:39 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:61750 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbaJZVBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 17:01:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Heena Sirwani <heenasirwani@gmail.com>, linux-kernel@vger.kernel.org,
        john.stultz@linaro.org
Subject: Re: [PATCH v5] timekeeping: Added a function to return tv_sec portion of ktime_get_ts64()
Date: Sun, 26 Oct 2014 22:01:28 +0100
Message-ID: <6577930.2pEqZJjtqW@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <alpine.DEB.2.11.1410251705550.5308@nanos>
References: <20141025123406.GA13128@heena.com> <alpine.DEB.2.11.1410251705550.5308@nanos>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Nz1k8Xe3ALrgpAwuoUb4kS02o7HHYWgT0GCKKGgeFxH
 lfDFCcbMTQ9plCzgkoHmAfNx4x6tSqiU3lkZX6E3ukuHge8byv
 BAH9dfcDBri+bAzQ9DvRk3n/9otA7aNm+Rb487oWJd1DCpt11w
 sZ1hsf4B+4fAWZtOFW39OtxbAEmLGh8GwEHMNVpK+k7KIxV4XI
 PeaTPglISo1DRWIVGenxWbF4q2adTGmCBSng01Bsg27P+2Plee
 zCJabO49Z2idFvLky/U4GY4mPV9BFDHMNCupTjeon+ImIekvkx
 UbKo4I0mgIEqOEk7oEUtSRUWeudxAnktyAub5LcYU34f84J+wQ
 jjVFjjHCP+jLy1bCl/lA=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 25 October 2014 17:12:48 Thomas Gleixner wrote:
> I'd rather have an extra field in the timekeeper
> 
>     u64 xtime_sec;
> +   u64 ktime_sec;
> 
> and update this in tk_update_ktime_data() so the readout function
> boils down to
> 
> time64_t ktime_get_seconds(void)
> {
> #if BITS_PER_LONG < 64
>         u64 sec;
>         int seq;
> 
>         do {
>                 seq = read_seqcount_begin(&tk_core.seq);
>                 sec = tk->ktime_sec;
>         } while (read_seqcount_retry(&tk_core.seq, seq));
> 
>         return sec;
> #else
>         return tk->ktime_sec;
> #endif
> }
> 
> So 64bit can do w/o the seqcount and 32bit avoids all extra math, right?
> 

But where would you set ktime_sec? My first thought was tk_update_ktime_data(),
but would then either be slightly wrong because it doesn't take the current
xtime_nsec + tk->wall_to_monotonic.tv_nsec into account, if we do

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index ec1791fae965..d72a456c6bd3 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -426,8 +426,8 @@ static inline void tk_update_ktime_data(struct timekeeper *tk)
 	 *	nsec = base_mono + now();
 	 * ==> base_mono = (xtime_sec + wtm_sec) * 1e9 + wtm_nsec
 	 */
-	nsec = (s64)(tk->xtime_sec + tk->wall_to_monotonic.tv_sec);
-	nsec *= NSEC_PER_SEC;
+	tk->ktime_sec = (s64)(tk->xtime_sec + tk->wall_to_monotonic.tv_sec);
+	nsec = tk->ktime_sec * NSEC_PER_SEC;
 	nsec += tk->wall_to_monotonic.tv_nsec;
 	tk->tkr.base_mono = ns_to_ktime(nsec);
 

or we'd have to add an expensive timekeeping_get_ns() call:

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index ec1791fae965..d4c95b815de6 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -426,9 +426,11 @@ static inline void tk_update_ktime_data(struct timekeeper *tk)
 	 *	nsec = base_mono + now();
 	 * ==> base_mono = (xtime_sec + wtm_sec) * 1e9 + wtm_nsec
 	 */
-	nsec = (s64)(tk->xtime_sec + tk->wall_to_monotonic.tv_sec);
-	nsec *= NSEC_PER_SEC;
-	nsec += tk->wall_to_monotonic.tv_nsec;
+	tk->ktime_sec = (s64)(tk->xtime_sec + tk->wall_to_monotonic.tv_sec);
+	nsec = tk->wall_to_monotonic.tv_nsec;
+	if ((nsec + timekeeping_get_ns()) > NSEC_PER_SEC)
+		tk->ktime_sec += 1;
+	nsec += tk->ktime_sec * NSEC_PER_SEC;
 	tk->tkr.base_mono = ns_to_ktime(nsec);
 
 	/* Update the monotonic raw base */

	Arnd
