Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295Ab3ARTiR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 14:38:17 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:34633 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751905Ab3ARTiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 14:38:15 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dI9371I1432Izz1ee6h1de0h1202h1e76h1d1ah1d2ahzz17326ah8275dhz2dh668h839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1155h)
X-WSS-ID: 0MGU6JJ-01-AVP-02
X-M-MSG: 
Message-ID: <50F9A49C.20802@amd.com>
Date: Fri, 18 Jan 2013 14:38:04 -0500
From: Boris Ostrovsky <boris.ostrovsky@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Borislav Petkov <bp@alien8.de>, Stefan Bader <stefan.bader@canonical.com>,
        Andre Przywara <andre@andrep.de>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Garrett <mjg@redhat.com>
Subject: Re: [Xen-devel] kernel 3.7+ cpufreq regression on AMD system running
 as dom0
References: <50F42B3E.7090602@canonical.com> <20130114163445.GA4867@liondog.tnic> <20130115175305.GA12449@phenom.dumpdata.com> <20130115181839.GC8101@liondog.tnic> <20130118190015.GC11351@phenom.dumpdata.com>
In-Reply-To: <20130118190015.GC11351@phenom.dumpdata.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2013 02:00 PM, Konrad Rzeszutek Wilk wrote:
>
> Right, that information is gathered from the MSRs. I think the Xen would
> need to do this since it can do the MSRs correctly and modify the P-states.
>
> So something like this in the hypervisor maybe (not even tested):

Is there any harm in allowing dom0 read P-state registers?

Something along these lines:

diff -r 40881d58e991 xen/arch/x86/traps.c
--- a/xen/arch/x86/traps.c	Thu Jan 17 14:47:04 2013 -0500
+++ b/xen/arch/x86/traps.c	Fri Jan 18 09:32:51 2013 -0500
@@ -2535,7 +2535,7 @@ static int emulate_privileged_op(struct
          case MSR_K8_PSTATE7:
              if ( boot_cpu_data.x86_vendor != X86_VENDOR_AMD )
                  goto fail;
-            if ( !is_cpufreq_controller(v->domain) )
+            if ( d->domain_id != 0 )
              {
                  regs->eax = regs->edx = 0;
                  break;


(It does seem to fix the bug too)

-boris


>
> diff --git a/xen/arch/x86/acpi/cpufreq/powernow.c b/xen/arch/x86/acpi/cpufreq/powernow.c
> index a9b7792..54e7808 100644
> --- a/xen/arch/x86/acpi/cpufreq/powernow.c
> +++ b/xen/arch/x86/acpi/cpufreq/powernow.c
> @@ -146,7 +146,40 @@ static int powernow_cpufreq_target(struct cpufreq_policy *policy,
>
>       return 0;
>   }
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
>   static int powernow_cpufreq_verify(struct cpufreq_policy *policy)
>   {
>       struct acpi_cpufreq_data *data;
> @@ -158,6 +191,8 @@ static int powernow_cpufreq_verify(struct cpufreq_policy *policy)
>
>       perf = &processor_pminfo[policy->cpu]->perf;
>
> +    amd_fixup_freq(perf);
> +
>       cpufreq_verify_within_limits(policy, 0,
>           perf->states[perf->platform_limit].core_frequency * 1000);
>
>
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
>

