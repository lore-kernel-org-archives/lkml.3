Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057Ab3CFDcX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 22:32:23 -0500
Received: from mga01.intel.com ([192.55.52.88]:55441 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751215Ab3CFDcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 22:32:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,791,1355126400"; 
   d="scan'208";a="295574175"
Date: Wed, 6 Mar 2013 11:31:14 +0800
From: Feng Tang <feng.tang@intel.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@linux.intel.com>, x86@kernel.org,
        Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org, gong.chen@linux.intel.com
Subject: Re: [RFC PATCH v2 0/4] Add support for S3 non-stop TSC support.
Message-ID: <20130306033114.GB12517@feng-snb>
References: <1362450426-4232-1-git-send-email-feng.tang@intel.com>
 <20130305035302.GA5239@feng-snb>
 <20130305043203.GA26678@obsidianresearch.com>
 <51358E17.8000106@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51358E17.8000106@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 05, 2013 at 02:17:59PM +0800, John Stultz wrote:
> On 03/05/2013 12:32 PM, Jason Gunthorpe wrote:
> >On Tue, Mar 05, 2013 at 11:53:02AM +0800, Feng Tang wrote:
> >
> >>>// Drops some small precision along the way but is simple..
> >>>static inline u64 cyclecounter_cyc2ns_128(const struct cyclecounter *cc,
> >>>                                           cycle_t cycles)
> >>>{
> >>>     u64 max = U64_MAX/cc->mult;
> >>>     u64 num = cycles/max;
> >>>     u64 result = num * ((max * cc->mult) >> cc->shift);
> >>>     return result + cyclecounter_cyc2ns(cc, cycles - num*cc->mult);
> >>>}
> >
> Probably want to use clocksource instead of cyclecounter, but I
> think Jason's approach sounds ok. I might suggest that you initially
> make the function static to the timekeeping code, just so we don't
> get unexpected users.

Thought more about it, can we directly make clocksource_cyc2ns() cover
the overflow case? Something like:

diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index aa7032c..1ecc872 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -274,7 +274,16 @@ static inline u32 clocksource_hz2mult(u32 hz, u32 shift_constant)
  */
 static inline s64 clocksource_cyc2ns(cycle_t cycles, u32 mult, u32 shift)
 {
-	return ((u64) cycles * mult) >> shift;
+	u64 max = ULLONG_MAX / mult;
+	s64 nsec = 0;
+
+	/* The (mult * cycles) may overflow 64 bits, so add a max check */
+	if (cycles > max) {
+		nsec = ((max * mult) >> shift) * (cycles / max);
+		cycles %= max;
+	}
+	nsec += ((u64) cycles * mult) >> shift;
+	return nsec;
 }

Thanks,
Feng
 
 

