Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751649Ab3CNSX4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 14:23:56 -0400
Received: from mail.skyhub.de ([78.46.96.112]:44735 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895Ab3CNSXy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 14:23:54 -0400
Date: Thu, 14 Mar 2013 19:23:46 +0100
From: Borislav Petkov <bp@alien8.de>
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: JBeulich@suse.com, chegger@amazon.de, linux-kernel@vger.kernel.org,
        linux-edac@vger.kernel.org, xen-devel@lists.xen.org
Subject: Re: [PATCH] x86/mce: Use MCG_CAP MSR to find out number of banks on
 AMD
Message-ID: <20130314182346.GD10190@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>, JBeulich@suse.com,
	chegger@amazon.de, linux-kernel@vger.kernel.org,
	linux-edac@vger.kernel.org, xen-devel@lists.xen.org
References: <1363277478-1941-1-git-send-email-boris.ostrovsky@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1363277478-1941-1-git-send-email-boris.ostrovsky@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 12:11:18PM -0400, Boris Ostrovsky wrote:
> Currently number of error reporting register banks is hardcoded to
> 6 on AMD processors. This may break in virtualized scenarios when
> a hypervisor prefers to report fewer banks that the physical HW
> provides.
> 
> Since number of supported banks is reported in MSR_IA32_MCG_CAP[7:0]
> that's what we should use.

Yes, I definitely like it.

A couple of suggestions below :

> 
> Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> ---
>  arch/x86/kernel/cpu/mcheck/mce_amd.c | 21 +++++++++++++--------
>  1 file changed, 13 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
> index 1ac581f..cb7c739 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
> @@ -33,7 +33,6 @@
>  #include <asm/mce.h>
>  #include <asm/msr.h>
>  
> -#define NR_BANKS          6
>  #define NR_BLOCKS         9
>  #define THRESHOLD_MAX     0xFFF
>  #define INT_TYPE_APIC     0x00020000
> @@ -57,9 +56,9 @@ static const char * const th_names[] = {
>  	"execution_unit",
>  };
>  
> -static DEFINE_PER_CPU(struct threshold_bank * [NR_BANKS], threshold_banks);
> +static DEFINE_PER_CPU(struct threshold_bank **, threshold_banks);
>  
> -static unsigned char shared_bank[NR_BANKS] = {
> +static unsigned char shared_bank[MAX_NR_BANKS] = {

This shared_bank thing is a kinda clumsy way of saying that bank 4 is
shared. Great, with this change we're allocating a static array of 32
unsigned chars just to ask whether bank 4 is shared. :-)

I know, I know, this was there before but maybe we could clean it up
properly while at it.

IOW, we probably want to kill that in a pre-patch and replace the test
with:

	/* is this a shared bank */
	if (bank == 4)

The comment should explain why we're testing this way.

For the future, if we get more shared banks, we could introduce a
is_shared_bank() helper but no need to do it just yet.

>  	0, 0, 0, 0, 1
>  };
>  
> @@ -214,7 +213,7 @@ void mce_amd_feature_init(struct cpuinfo_x86 *c)
>  	unsigned int bank, block;
>  	int offset = -1;
>  
> -	for (bank = 0; bank < NR_BANKS; ++bank) {
> +	for (bank = 0; bank < mca_cfg.banks; ++bank) {
>  		for (block = 0; block < NR_BLOCKS; ++block) {
>  			if (block == 0)
>  				address = MSR_IA32_MC0_MISC + bank * 4;
> @@ -276,7 +275,7 @@ static void amd_threshold_interrupt(void)
>  	mce_setup(&m);
>  
>  	/* assume first bank caused it */
> -	for (bank = 0; bank < NR_BANKS; ++bank) {
> +	for (bank = 0; bank < mca_cfg.banks; ++bank) {
>  		if (!(per_cpu(bank_map, m.cpu) & (1 << bank)))
>  			continue;
>  		for (block = 0; block < NR_BLOCKS; ++block) {
> @@ -467,7 +466,7 @@ static __cpuinit int allocate_threshold_blocks(unsigned int cpu,
>  	u32 low, high;
>  	int err;
>  
> -	if ((bank >= NR_BANKS) || (block >= NR_BLOCKS))
> +	if ((bank >= mca_cfg.banks) || (block >= NR_BLOCKS))
>  		return 0;
>  
>  	if (rdmsr_safe_on_cpu(cpu, address, &low, &high))
> @@ -637,7 +636,12 @@ static __cpuinit int threshold_create_device(unsigned int cpu)
>  	unsigned int bank;
>  	int err = 0;
>  
> -	for (bank = 0; bank < NR_BANKS; ++bank) {
> +	per_cpu(threshold_banks, cpu) = kzalloc(sizeof(struct threshold_bank *)
> +		* mca_cfg.banks, GFP_KERNEL);

per_cpu accesses are not cheap. You should define a local pointer here
and use it instead in all the calls and do the per_cpu assignment only
at the end:

	per_cpu(threshold_banks, cpu) = local_ptr;

> +	if (per_cpu(threshold_banks, cpu) == NULL)
> +		return -ENOMEM;

Which makes this test much more readable too:

	if (!local_ptr)
		return -ENOMEM;


Btw, those threshold_{create,remove}_device are the hotplug callbacks
and the alloc/dealloc looks right but you might want to stress them a
bit by taking cores on- and offline while testing, just in case.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
