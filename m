Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909AbaJBNMQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 09:12:16 -0400
Received: from mail.skyhub.de ([78.46.96.112]:53475 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751978AbaJBNMO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 09:12:14 -0400
Date: Thu, 2 Oct 2014 15:12:06 +0200
From: Borislav Petkov <bp@alien8.de>
To: Chen Yucong <slaoub@gmail.com>
Cc: tony.luck@intel.com, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, MCE, AMD: save IA32_MCi_STATUS before
 machine_check_poll() resets it
Message-ID: <20141002131206.GA16452@pd.tnic>
References: <1411438561-24319-1-git-send-email-slaoub@gmail.com>
 <1411460354.25617.3.camel@debian>
 <20140929120546.GB6495@pd.tnic>
 <1412037578.21488.11.camel@debian>
 <20140930072553.GA4639@pd.tnic>
 <1412070991.16556.12.camel@cyc>
 <20140930100940.GD4639@pd.tnic>
 <1412138102.21488.20.camel@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1412138102.21488.20.camel@debian>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01, 2014 at 12:35:02PM +0800, Chen Yucong wrote:
> On Tue, 2014-09-30 at 12:09 +0200, Borislav Petkov wrote:
> > On Tue, Sep 30, 2014 at 05:56:31PM +0800, Chen Yucong wrote:
> > > I just clear it to avoid that the mce_log() call logs the above
> > > threshold event again in machine_check_poll().
> > 
> > Ok, that's a good point, please put it in the commit message.
> > 
> > > It is just used for scanning other banks for recording other valid
> > > error information.
> > 
> > This is actually not what we want - we want to log the errors which
> > cause the overflow first and then the rest. So you don't need the goto
> > but simply have the machine_check_poll() at the end. 
> 
> 
> From: Chen Yucong <slaoub@gmail.com>
> 
> machine_check_poll() will reset IA32_MCi_STATUS register to zero.
> So we need to save the content of IA32_MCi_STATUS MSRs before
> calling machine_check_poll() for logging threshold interrupt event.
> 
> mce_setup() does not gather the content of IA32_MCG_STATUS, so it
> should be read explicitly. Moreover, we need to clear IA32_MCx_STATUS
> to avoid that mce_log() logs the processed threshold event again
> at next time.
> 
> Signed-off-by: Chen Yucong <slaoub@gmail.com>
> ---
>  arch/x86/kernel/cpu/mcheck/mce_amd.c |   18 +++++++++++-------
>  1 file changed, 11 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
> index f8c56bd..643e6a2 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
> @@ -274,6 +274,7 @@ static void amd_threshold_interrupt(void)
>  	struct mce m;
>  
>  	mce_setup(&m);
> +	rdmsrl(MSR_IA32_MCG_STATUS, m.mcgstatus);
>  
>  	/* assume first bank caused it */
>  	for (bank = 0; bank < mca_cfg.banks; ++bank) {
> @@ -305,24 +306,27 @@ static void amd_threshold_interrupt(void)
>  			     (high & MASK_LOCKED_HI))
>  				continue;
>  
> -			/*
> -			 * Log the machine check that caused the threshold
> -			 * event.
> -			 */
> -			machine_check_poll(MCP_TIMESTAMP,
> -					this_cpu_ptr(&mce_poll_banks));
> -
>  			if (high & MASK_OVERFLOW_HI) {
>  				rdmsrl(address, m.misc);
>  				rdmsrl(MSR_IA32_MCx_STATUS(bank), m.status);
> +				if (m.status & MCI_STATUS_ADDRV)
> +					rdmsrl(MSR_IA32_MCx_ADDR(bank), m.addr);
>  				m.bank = K8_MCE_THRESHOLD_BASE
>  				       + bank * NR_BLOCKS
>  				       + block;
>  				mce_log(&m);
> +
> +				wrmsrl(MSR_IA32_MCx_STATUS(bank), 0);
>  				return;

Ok, this return is still bugging me - we're logging the error which
caused the counter overflow but we go and explicitly clear _STATUS so
that machine_check_poll doesn't pick up the same error again.

Even though, machine_check_poll is intended to log the thresholding
error.

Which actually makes me think that that machine_check_poll is actually
completely useless there. IOW, how about that instead:

---
From: Chen Yucong <slaoub@gmail.com>
Date: Thu, 2 Oct 2014 14:48:19 +0200
Subject: [PATCH] x86, MCE, AMD: Correct thresholding error logging

mce_setup() does not gather the content of IA32_MCG_STATUS, so it
should be read explicitly. Moreover, we need to clear IA32_MCx_STATUS
to avoid that mce_log() logs the processed threshold event again
at next time.

But we do the logging ourselves and machine_check_poll() is completely
useless there. So kill it.

Signed-off-by: Chen Yucong <slaoub@gmail.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/kernel/cpu/mcheck/mce_amd.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
index 1c54d3d61a4d..9ce64955559d 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -270,14 +270,13 @@ void mce_amd_feature_init(struct cpuinfo_x86 *c)
 static void amd_threshold_interrupt(void)
 {
 	u32 low = 0, high = 0, address = 0;
+	int cpu = smp_processor_id();
 	unsigned int bank, block;
 	struct mce m;
 
-	mce_setup(&m);
-
 	/* assume first bank caused it */
 	for (bank = 0; bank < mca_cfg.banks; ++bank) {
-		if (!(per_cpu(bank_map, m.cpu) & (1 << bank)))
+		if (!(per_cpu(bank_map, cpu) & (1 << bank)))
 			continue;
 		for (block = 0; block < NR_BLOCKS; ++block) {
 			if (block == 0) {
@@ -309,20 +308,21 @@ static void amd_threshold_interrupt(void)
 			 * Log the machine check that caused the threshold
 			 * event.
 			 */
-			machine_check_poll(MCP_TIMESTAMP,
-					&__get_cpu_var(mce_poll_banks));
-
-			if (high & MASK_OVERFLOW_HI) {
-				rdmsrl(address, m.misc);
-				rdmsrl(MSR_IA32_MCx_STATUS(bank), m.status);
-				m.bank = K8_MCE_THRESHOLD_BASE
-				       + bank * NR_BLOCKS
-				       + block;
-				mce_log(&m);
-				return;
-			}
+			if (high & MASK_OVERFLOW_HI)
+				goto log;
 		}
 	}
+	return;
+
+log:
+	mce_setup(&m);
+	rdmsrl(MSR_IA32_MCG_STATUS, m.mcgstatus);
+	rdmsrl(address, m.misc);
+	rdmsrl(MSR_IA32_MCx_STATUS(bank), m.status);
+	m.bank = K8_MCE_THRESHOLD_BASE + bank * NR_BLOCKS + block;
+	mce_log(&m);
+
+	wrmsrl(MSR_IA32_MCx_STATUS(bank), 0);
 }
 
 /*
-- 
2.0.0

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
