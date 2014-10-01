Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751148AbaJAEfM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 00:35:12 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:58659 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbaJAEfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 00:35:10 -0400
Message-ID: <1412138102.21488.20.camel@debian>
Subject: Re: [PATCH] x86, MCE, AMD: save IA32_MCi_STATUS before
 machine_check_poll() resets it
From: Chen Yucong <slaoub@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: tony.luck@intel.com, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 01 Oct 2014 12:35:02 +0800
In-Reply-To: <20140930100940.GD4639@pd.tnic>
References: <1411438561-24319-1-git-send-email-slaoub@gmail.com>
	 <1411460354.25617.3.camel@debian> <20140929120546.GB6495@pd.tnic>
	 <1412037578.21488.11.camel@debian> <20140930072553.GA4639@pd.tnic>
	 <1412070991.16556.12.camel@cyc> <20140930100940.GD4639@pd.tnic>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-09-30 at 12:09 +0200, Borislav Petkov wrote:
> On Tue, Sep 30, 2014 at 05:56:31PM +0800, Chen Yucong wrote:
> > I just clear it to avoid that the mce_log() call logs the above
> > threshold event again in machine_check_poll().
> 
> Ok, that's a good point, please put it in the commit message.
> 
> > It is just used for scanning other banks for recording other valid
> > error information.
> 
> This is actually not what we want - we want to log the errors which
> cause the overflow first and then the rest. So you don't need the goto
> but simply have the machine_check_poll() at the end. 


From: Chen Yucong <slaoub@gmail.com>

machine_check_poll() will reset IA32_MCi_STATUS register to zero.
So we need to save the content of IA32_MCi_STATUS MSRs before
calling machine_check_poll() for logging threshold interrupt event.

mce_setup() does not gather the content of IA32_MCG_STATUS, so it
should be read explicitly. Moreover, we need to clear IA32_MCx_STATUS
to avoid that mce_log() logs the processed threshold event again
at next time.

Signed-off-by: Chen Yucong <slaoub@gmail.com>
---
 arch/x86/kernel/cpu/mcheck/mce_amd.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
index f8c56bd..643e6a2 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -274,6 +274,7 @@ static void amd_threshold_interrupt(void)
 	struct mce m;
 
 	mce_setup(&m);
+	rdmsrl(MSR_IA32_MCG_STATUS, m.mcgstatus);
 
 	/* assume first bank caused it */
 	for (bank = 0; bank < mca_cfg.banks; ++bank) {
@@ -305,24 +306,27 @@ static void amd_threshold_interrupt(void)
 			     (high & MASK_LOCKED_HI))
 				continue;
 
-			/*
-			 * Log the machine check that caused the threshold
-			 * event.
-			 */
-			machine_check_poll(MCP_TIMESTAMP,
-					this_cpu_ptr(&mce_poll_banks));
-
 			if (high & MASK_OVERFLOW_HI) {
 				rdmsrl(address, m.misc);
 				rdmsrl(MSR_IA32_MCx_STATUS(bank), m.status);
+				if (m.status & MCI_STATUS_ADDRV)
+					rdmsrl(MSR_IA32_MCx_ADDR(bank), m.addr);
 				m.bank = K8_MCE_THRESHOLD_BASE
 				       + bank * NR_BLOCKS
 				       + block;
 				mce_log(&m);
+
+				wrmsrl(MSR_IA32_MCx_STATUS(bank), 0);
 				return;
 			}
 		}
 	}
+
+	/*
+	 * Log the machine check that caused the threshold event.
+	 */
+	machine_check_poll(MCP_TIMESTAMP,
+				this_cpu_ptr(&mce_poll_banks));
 }
 
 /*
-- 
1.7.10.4



