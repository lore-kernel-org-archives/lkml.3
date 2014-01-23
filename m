Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751600AbaAWP20 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 10:28:26 -0500
Received: from mga09.intel.com ([134.134.136.24]:54616 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001AbaAWP2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 10:28:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,706,1384329600"; 
   d="scan'208";a="471342192"
Date: Thu, 23 Jan 2014 17:35:28 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Bin Gao <bin.gao@intel.com>, x86@kernel.org
Subject: Re: [PATCH] x86, tsc: Add missing Baytrail frequency to the table
Message-ID: <20140123153528.GJ18029@intel.com>
References: <1390475043-27457-1-git-send-email-mika.westerberg@linux.intel.com>
 <20140123150912.7ee822a0@alan.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140123150912.7ee822a0@alan.etchedpixels.co.uk>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 03:09:12PM +0000, One Thousand Gnomes wrote:
> On Thu, 23 Jan 2014 13:04:03 +0200
> Mika Westerberg <mika.westerberg@linux.intel.com> wrote:
> 
> > Baytrail is based on Silvermont core so MSR_FSB_FREQ[2:0] == 0 means that
> > the CPU reference clock runs at 83.3MHz. Without this we crash a bit later
> > with backtrace looking like:
> 
> Would it not be wise to also make the code robust against future failures
> of this kind and at least bitch rather than divide by 0 ?

Yes, it makes sense. I wasn't sure how to do that properly, though.

The following patch seems to work in that case.

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index a3acbac2ee72..1e54deb56b33 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -655,10 +655,11 @@ unsigned long native_calibrate_tsc(void)
 	local_irq_save(flags);
 	i = try_msr_calibrate_tsc(&fast_calibrate);
 	local_irq_restore(flags);
-	if (i >= 0) {
-		if (i == 0)
-			pr_warn("Fast TSC calibration using MSR failed\n");
+	if (i > 0) {
 		return fast_calibrate;
+	} else if (i == 0) {
+		pr_warn("Fast TSC calibration using MSR failed\n");
+		/* Continue with the normal calibration */
 	}
 
 	local_irq_save(flags);
