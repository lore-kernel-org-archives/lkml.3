Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288AbaI3Ajv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 20:39:51 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:55366 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754452AbaI3Ajt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 20:39:49 -0400
Message-ID: <1412037578.21488.11.camel@debian>
Subject: Re: [PATCH] x86, MCE, AMD: save IA32_MCi_STATUS before
 machine_check_poll() resets it
From: Chen Yucong <slaoub@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: tony.luck@intel.com, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 30 Sep 2014 08:39:38 +0800
In-Reply-To: <20140929120546.GB6495@pd.tnic>
References: <1411438561-24319-1-git-send-email-slaoub@gmail.com>
	 <1411460354.25617.3.camel@debian> <20140929120546.GB6495@pd.tnic>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-09-29 at 14:05 +0200, Borislav Petkov wrote:
> > machine_check_poll() will reset IA32_MCi_STATUS register to zero.
> > So we need to save the content of IA32_MCi_STATUS MSRs before
> > calling machine_check_poll() for logging threshold interrupt event.
> > 
> > mce_setup() does not gather the content of IA32_MCG_STATUS, so it
> > should be read explicitly.
> > 
> > Signed-off-by: Chen Yucong <slaoub@gmail.com>
> > ---
> >  arch/x86/kernel/cpu/mcheck/mce_amd.c |   13 ++++++++++++-
> >  1 file changed, 12 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c
> b/arch/x86/kernel/cpu/mcheck/mce_amd.c
> > index f8c56bd..9148b4d 100644
> > --- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
> > +++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
> > @@ -275,6 +275,12 @@ static void amd_threshold_interrupt(void)
> >  
> >       mce_setup(&m);
> >  
> > +     /*
> > +      * mce_setup() can't gather the content of IA32_MCG_STATUS,
> > +      * so it should be read explicitly.
> > +      */
> 
> No need for that comment.
> 
> > +     rdmsrl(MSR_IA32_MCG_STATUS, m.mcgstatus);
> > +
> >       /* assume first bank caused it */
> >       for (bank = 0; bank < mca_cfg.banks; ++bank) {
> >               if (!(per_cpu(bank_map, m.cpu) & (1 << bank)))
> > @@ -305,6 +311,12 @@ static void amd_threshold_interrupt(void)
> >                            (high & MASK_LOCKED_HI))
> >                               continue;
> >  
> > +                     /*
> > +                      * machine_check_poll() will reset
> IA32_MCi_STATUS
> > +                      * register to zero, save it for use later.
> > +                      */
> > +                     rdmsrl(MSR_IA32_MCx_STATUS(bank), m.status);
> 
> Actually, to be more future-proof, I'd like to do the AMD-specific
> logging first, i.e. before machine_check_poll() so that any future
> changes there don't influence what we do in mce_amd.c.
> 
> So please move the machine_check_poll() call behind the
> 
>         if (high & MASK_OVERFLOW_HI) { 
machine_check_poll() will scan all banks, so I think we can move it out
of the loop body.

thx!
cyc


From: Chen Yucong

machine_check_poll() will reset IA32_MCi_STATUS register to zero.
So we need to save the content of IA32_MCi_STATUS MSRs before
calling machine_check_poll() for logging threshold interrupt event.

mce_setup() does not gather the content of IA32_MCG_STATUS, so it
should be read explicitly. And we also need to save MSR_IA32_MCx_ADDR
if MCI_STATUS_ADDRV bit field is valid.  

Signed-off-by: Chen Yucong <slaoub@gmail.com>
---
 arch/x86/kernel/cpu/mcheck/mce_amd.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
index f8c56bd..f5a5beb 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -274,6 +274,7 @@ static void amd_threshold_interrupt(void)
 	struct mce m;
 
 	mce_setup(&m);
+	rdmsrl(MSR_IA32_MCG_STATUS, m.mcgstatus);
 
 	/* assume first bank caused it */
 	for (bank = 0; bank < mca_cfg.banks; ++bank) {
@@ -305,24 +306,28 @@ static void amd_threshold_interrupt(void)
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
-				return;
+
+				wrmsrl(MSR_IA32_MCx_STATUS(bank), 0);
+				goto log_mcheck;
 			}
 		}
 	}
+
+log_mcheck:
+	/*
+	 * Log the machine check that caused the threshold event.
+	 */
+	machine_check_poll(MCP_TIMESTAMP,
+				this_cpu_ptr(&mce_poll_banks));
 }
 
 /*
-- 
1.7.10.4




