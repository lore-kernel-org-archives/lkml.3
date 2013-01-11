Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930Ab3AKG2C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 01:28:02 -0500
Received: from mga02.intel.com ([134.134.136.20]:40534 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754360Ab3AKG2B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 01:28:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,449,1355126400"; 
   d="scan'208";a="270797101"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Colin Cross <ccross@android.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Don Zickus <dzickus@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH] hardlockup: detect hard lockups without NMIs using
 secondary cpus
Thread-Topic: [PATCH] hardlockup: detect hard lockups without NMIs using
 secondary cpus
Thread-Index: AQHN78Np2YJIVLMNAUOviwyW+f22bphDqdvQ
Date: Fri, 11 Jan 2013 06:27:51 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A20129C@SHSMSX101.ccr.corp.intel.com>
References: <1357783059-13923-1-git-send-email-ccross@android.com>
	<27240C0AC20F114CBF8149A2696CBE4A200DD9@SHSMSX101.ccr.corp.intel.com>
	<CAMbhsRS5S=bRWOAA_ft3josCX9kvarrqPX-sLnO02vB0NfZJ+w@mail.gmail.com>
	<27240C0AC20F114CBF8149A2696CBE4A2010CB@SHSMSX101.ccr.corp.intel.com>
 <CAMbhsRQC0VSbp_A00S-MOa1y_GqCywQF0rmAZt3h0N7U8HBOLg@mail.gmail.com>
In-Reply-To: <CAMbhsRQC0VSbp_A00S-MOa1y_GqCywQF0rmAZt3h0N7U8HBOLg@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: ccross@google.com [mailto:ccross@google.com] On Behalf Of Colin
> Cross
> Sent: Friday, January 11, 2013 2:18 PM
> To: Liu, Chuansheng
> Cc: linux-kernel@vger.kernel.org; Andrew Morton; Don Zickus; Ingo Molnar;
> Thomas Gleixner; linux-arm-kernel@lists.infradead.org
> Subject: Re: [PATCH] hardlockup: detect hard lockups without NMIs using
> secondary cpus
> 
> On Thu, Jan 10, 2013 at 9:57 PM, Liu, Chuansheng
> <chuansheng.liu@intel.com> wrote:
> >
> >
> >> -----Original Message-----
> >> From: ccross@google.com [mailto:ccross@google.com] On Behalf Of Colin
> >> Cross
> >> Sent: Friday, January 11, 2013 1:34 PM
> >> To: Liu, Chuansheng
> >> Cc: linux-kernel@vger.kernel.org; Andrew Morton; Don Zickus; Ingo Molnar;
> >> Thomas Gleixner; linux-arm-kernel@lists.infradead.org
> >> Subject: Re: [PATCH] hardlockup: detect hard lockups without NMIs using
> >> secondary cpus
> >>
> >> On Thu, Jan 10, 2013 at 5:39 PM, Liu, Chuansheng
> >> <chuansheng.liu@intel.com> wrote:
> >> >
> >> >
> >> >> -----Original Message-----
> >> >> From: Colin Cross [mailto:ccross@android.com]
> >> >> Sent: Thursday, January 10, 2013 9:58 AM
> >> >> To: linux-kernel@vger.kernel.org
> >> >> Cc: Andrew Morton; Don Zickus; Ingo Molnar; Thomas Gleixner; Liu,
> >> >> Chuansheng; linux-arm-kernel@lists.infradead.org; Colin Cross
> >> >> Subject: [PATCH] hardlockup: detect hard lockups without NMIs using
> >> >> secondary cpus
> >> >>
> >> >> Emulate NMIs on systems where they are not available by using timer
> >> >> interrupts on other cpus.  Each cpu will use its softlockup hrtimer
> >> >> to check that the next cpu is processing hrtimer interrupts by
> >> >> verifying that a counter is increasing.
> >> >>
> >> >> This patch is useful on systems where the hardlockup detector is not
> >> >> available due to a lack of NMIs, for example most ARM SoCs.
> >> >> Without this patch any cpu stuck with interrupts disabled can
> >> >> cause a hardware watchdog reset with no debugging information,
> >> >> but with this patch the kernel can detect the lockup and panic,
> >> >> which can result in useful debugging info.
> >> >>
> >> >> Signed-off-by: Colin Cross <ccross@android.com>
> >> >> +static void watchdog_check_hardlockup_other_cpu(void)
> >> >> +{
> >> >> +     int cpu;
> >> >> +     cpumask_t cpus = watchdog_cpus;
> >> >> +
> >> >> +     /*
> >> >> +      * Test for hardlockups every 3 samples.  The sample period is
> >> >> +      *  watchdog_thresh * 2 / 5, so 3 samples gets us back to
> slightly
> >> over
> >> >> +      *  watchdog_thresh (over by 20%).
> >> >> +      */
> >> >> +     if (__this_cpu_read(hrtimer_interrupts) % 3 != 0)
> >> >> +             return;
> >> >> +
> > Another feeling is about __this_cpu_read(hrtimer_interrupts) % 3 != 0,
> > It will cause the actual timeout value for hard lockup detection is not very fix,
> or even
> > very short.
> > Sometimes using 3 samples can detect the lockup case, but sometimes 1
> sample.
> > Is it the case?
> 
> I'm not sure what you mean.  The mod 3 will cause every 3rd timer (12
> seconds, assuming watchdog_thresh = 10) to check hrtimer_interrupts
> vs. hrtimer_interrupts_saved, and then update it.  The sampling should
> be fixed and very accurate.  It will cause a panic/warning between 12
> and 24 seconds after a cpu stops processing timer interrupts,
> depending on the alignment of the hrtimers between the two cpus.
> 
You are right, thanks.
