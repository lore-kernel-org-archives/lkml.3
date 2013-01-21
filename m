Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106Ab3AUP2L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 10:28:11 -0500
Received: from mail.skyhub.de ([78.46.96.112]:40526 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752627Ab3AUP2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 10:28:09 -0500
Date: Mon, 21 Jan 2013 16:31:05 +0100
From: Borislav Petkov <bp@alien8.de>
To: Stefan Bader <stefan.bader@canonical.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andre Przywara <andre@andrep.de>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Garrett <mjg@redhat.com>
Subject: Re: kernel 3.7+ cpufreq regression on AMD system running as dom0
Message-ID: <20130121153105.GE4445@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Stefan Bader <stefan.bader@canonical.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Andre Przywara <andre@andrep.de>,
	"xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Garrett <mjg@redhat.com>
References: <50F42B3E.7090602@canonical.com>
 <20130114163445.GA4867@liondog.tnic>
 <20130115175305.GA12449@phenom.dumpdata.com>
 <20130115181839.GC8101@liondog.tnic>
 <20130118190015.GC11351@phenom.dumpdata.com>
 <20130118200331.GF4062@pd.tnic>
 <50FD32FA.7010306@canonical.com>
 <20130121124255.GB4823@pd.tnic>
 <50FD58CF.8080101@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <50FD58CF.8080101@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 03:03:43PM +0000, Stefan Bader wrote:
> From 9870926d4a847e36c0f61921762fd50f1c92f75d Mon Sep 17 00:00:00 2001
> From: Stefan Bader <stefan.bader@canonical.com>
> Date: Mon, 14 Jan 2013 16:17:00 +0100
> Subject: [PATCH] ACPI: Check MSR valid bit before using P-state frequencies
> 
> To fix incorrect P-state frequencies which can happen on
> some AMD systems f594065faf4f9067c2283a34619fc0714e79a98d
>   "ACPI: Add fixups for AMD P-state figures"
> introduced a quirk to obtain the correct values by reading
> from AMD specific MSRs.
> 
> This did cause a regression when running a kernel using that
> quirk under Xen which does (currently) not pass through MSR
> reads to the HW. Instead the guest gets a 0 in return.
> And this seems to cause a failure to initialize the ondemand
> governour (hard to say for sure as all P-states appear to run
> at the same frequency).
> 
> While this should also be fixed in the hypervisor (to allow
> a guest to read that MSR), this patch is intended to work
> around the issue in the meantime. In discussion it turned out
> that indeed real HW/BIOSes may choose to not set the valid bit
> and thus mark the P-state as invalid. So this could be considered
> a fix for broken BIOSes that also works around the issue on Xen.
> 
> [v2] Reword description text and use helper for bit index.
> Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
> Cc: stable@vger.kernel.org # v3.7..
> ---
>  drivers/acpi/processor_perflib.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/drivers/acpi/processor_perflib.c b/drivers/acpi/processor_perflib.c
> index 836bfe0..caa042e 100644
> --- a/drivers/acpi/processor_perflib.c
> +++ b/drivers/acpi/processor_perflib.c
> @@ -340,6 +340,17 @@ static void amd_fixup_frequency(struct
> acpi_processor_px *px, int i)
>  	if ((boot_cpu_data.x86 == 0x10 && boot_cpu_data.x86_model < 10)
>  	    || boot_cpu_data.x86 == 0x11) {
>  		rdmsr(MSR_AMD_PSTATE_DEF_BASE + index, lo, hi);
> +		/*
> +		 * MSR C001_0064+:
> +		 * Bit 63: PstateEn. Read-write. 1=The P-state specified by
> +		 * this MSR is valid. 0=The P-state specified by this MSR is
> +		 * not valid. The purpose of this register is to indicate if
> +		 * the rest of the P-state information in the register is
> +		 * valid after a reset; it controls no hardware.
> +		 */

Maybe this comment is a but too long and it contains that idiotic
processor manual speak :-). It should've contained only the first
sentence: "PstateEn. If set, the P-state is valid."

But maybe Rafael could correct it while committing, no reason to resend
for that only.

Acked-by: Borislav Petkov <bp@suse.de>


> +		if (!(hi & BIT(31)))
> +			return;
> +
>  		fid = lo & 0x3f;
>  		did = (lo >> 6) & 7;
>  		if (boot_cpu_data.x86 == 0x10)
> -- 
> 1.8.0

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
