Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253Ab3ARUDi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 15:03:38 -0500
Received: from mail.skyhub.de ([78.46.96.112]:52382 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751335Ab3ARUDh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 15:03:37 -0500
Date: Fri, 18 Jan 2013 21:03:31 +0100
From: Borislav Petkov <bp@alien8.de>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Stefan Bader <stefan.bader@canonical.com>,
        Andre Przywara <andre@andrep.de>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Garrett <mjg@redhat.com>
Subject: Re: kernel 3.7+ cpufreq regression on AMD system running as dom0
Message-ID: <20130118200331.GF4062@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Stefan Bader <stefan.bader@canonical.com>,
	Andre Przywara <andre@andrep.de>,
	"xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Garrett <mjg@redhat.com>
References: <50F42B3E.7090602@canonical.com>
 <20130114163445.GA4867@liondog.tnic>
 <20130115175305.GA12449@phenom.dumpdata.com>
 <20130115181839.GC8101@liondog.tnic>
 <20130118190015.GC11351@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130118190015.GC11351@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 02:00:15PM -0500, Konrad Rzeszutek Wilk wrote:
> I did not explain myself well. The fix is OK - it just that the
> hypervisor causes the quirk to not work correctly. Hmm, I wonder if
> there BIOSes that do the same thing (cause the MSR to return 0). Per
> you estimation of BIOS quality, it seems that this could happen.

Yeah, I don't think there's a limit to the amount of SNAFU a BIOS can
cause :-).

> Oh, I was not thinking DMI per-say. I was thinking something similar to
> DMI-quirk API. But for the ACPI subsystem, so it would be:
> 
> 	if (ARM)
> 		... these quirks neccessary
> 	if (AMD)
> 		.. these quirks
> 
> and then the ACPI code can make the calls to this ACPI-quirk API to
> figure out whether it needs to modulate values. But this is all
> hand-waving at this point.

Yeah, those CPUs are just a very small set to even warrant a quirk API.

[ … ]

> Right, that information is gathered from the MSRs. I think the Xen would
> need to do this since it can do the MSRs correctly and modify the P-states.
> 
> So something like this in the hypervisor maybe (not even tested):

Yeah, something like that. Basically you can copy the quirk down to the
hypervisor.

But, Andre was explaining to me the other day that those P-states
frequencies are not that important.

Let me explain: the ondemand governor, for example, computes idle time
and each time it needs to increase, it switches straight up to the
highest frequency. When it decreases the freq. though, it goes down in a
staircase manner, going over all P-states, AFAICT.

So we use them but not for all decisions. The question is, what does the
xen governor(s) do?

If it only uses the frequencies for reporting, then it is not that big
of a deal. If it uses their values for switching decisions, then it
probably needs the correct ones.

> diff --git a/xen/arch/x86/acpi/cpufreq/powernow.c b/xen/arch/x86/acpi/cpufreq/powernow.c
> index a9b7792..54e7808 100644
> --- a/xen/arch/x86/acpi/cpufreq/powernow.c
> +++ b/xen/arch/x86/acpi/cpufreq/powernow.c
> @@ -146,7 +146,40 @@ static int powernow_cpufreq_target(struct cpufreq_policy *policy,
>  
>      return 0;
>  }
> +#define MSR_AMD_PSTATE_DEF_BASE     0xc0010064
> +static void amd_fixup_frequency(struct xen_processor_px *px, int i)
> +{
> +	u32 hi, lo, fid, did;
> +	int index = px->control & 0x00000007;
> +
> +	if (boot_cpu_data.x86_vendor != X86_VENDOR_AMD)
> +		return;
> +
> +	if ((boot_cpu_data.x86 == 0x10 && boot_cpu_data.x86_model < 10)
> +	    || boot_cpu_data.x86 == 0x11) {
> +		rdmsr(MSR_AMD_PSTATE_DEF_BASE + index, lo, hi);
> +        /* Bit 63 indicates whether contents are valid */
> +        if (!(hi & 0x80000000))
> +            return;

Something's funny with this indentation.

> +
> +		fid = lo & 0x3f;
> +		did = (lo >> 6) & 7;
> +		if (boot_cpu_data.x86 == 0x10)
> +			px->core_frequency = (100 * (fid + 0x10)) >> did;
> +		else
> +			px->core_frequency = (100 * (fid + 8)) >> did;
> +	}
> +}
> +
> +static void amd_fixup_freq(struct processor_performance *perf)
> +{
>  
> +    int i;
> +
> +    for (i = 0; i < perf->state_count; i++)
> +        amd_fixup_frequency(perf->states, i);
> +
> +}
>  static int powernow_cpufreq_verify(struct cpufreq_policy *policy)
>  {
>      struct acpi_cpufreq_data *data;
> @@ -158,6 +191,8 @@ static int powernow_cpufreq_verify(struct cpufreq_policy *policy)
>  
>      perf = &processor_pminfo[policy->cpu]->perf;
>  
> +    amd_fixup_freq(perf);
> +
>      cpufreq_verify_within_limits(policy, 0, 
>          perf->states[perf->platform_limit].core_frequency * 1000);

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
