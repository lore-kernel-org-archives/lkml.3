Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757129Ab3IMAG5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 20:06:57 -0400
Received: from mail-bn1lp0155.outbound.protection.outlook.com ([207.46.163.155]:2924
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754787Ab3IMAG4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 20:06:56 -0400
From: KY Srinivasan <kys@microsoft.com>
To: KY Srinivasan <kys@microsoft.com>, "x86@kernel.org" <x86@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "JBeulich@suse.com" <JBeulich@suse.com>, "bp@alien8.de" <bp@alien8.de>
Subject: RE: [PATCH V2 1/1] X86: Hyper-V: Get the local APIC timer frequency
 from the hypervisor
Thread-Topic: [PATCH V2 1/1] X86: Hyper-V: Get the local APIC timer
 frequency from the hypervisor
Thread-Index: AQHOqM30I+mkPB2b1kKq/5YqjRysqJnC17Cg
Date: Fri, 13 Sep 2013 00:06:52 +0000
Message-ID: <dd29077371564a14b2d317d2291db8a9@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1378233023-4512-1-git-send-email-kys@microsoft.com>
In-Reply-To: <1378233023-4512-1-git-send-email-kys@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:4898:80e8:ed31::2]
x-forefront-prvs: 0968D37274
x-forefront-antispam-report: SFV:NSPM;SFS:(51704005)(189002)(199002)(377454003)(13464003)(19580405001)(19580395003)(51856001)(83322001)(53806001)(80022001)(46102001)(74502001)(47446002)(31966008)(74662001)(83072001)(81342001)(81542001)(74706001)(69226001)(74876001)(56776001)(54316002)(76482001)(4396001)(47736001)(47976001)(49866001)(63696002)(76576001)(77982001)(56816003)(77096001)(65816001)(59766001)(76786001)(76796001)(81686001)(50986001)(79102001)(80976001)(81816001)(54356001)(74316001)(33646001)(1511001)(74366001)(921001)(1121002)(3826001)(24736002)(15583001);DIR:OUT;SFP:;SCL:1;SRVR:SN2PR03MB061;H:SN2PR03MB061.namprd03.prod.outlook.com;CLIP:2001:4898:80e8:ed31::2;FPR:;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: DuplicateDomain-a84fc36a-4ed7-4e57-ab1c-3e967bcbad48.microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: K. Y. Srinivasan [mailto:kys@microsoft.com]
> Sent: Tuesday, September 03, 2013 11:30 AM
> To: x86@kernel.org; gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> jasowang@redhat.com; tglx@linutronix.de; hpa@zytor.com;
> JBeulich@suse.com; bp@alien8.de
> Cc: KY Srinivasan
> Subject: [PATCH V2 1/1] X86: Hyper-V: Get the local APIC timer frequency from
> the hypervisor
> 
> Hyper-V supports a mechanism for retrieving the local APIC frequency.Use this
> and bypass
> the calibration code in the kernel. This would allow us to boot the Linux kernel as
> a
> "modern VM" on Hyper-V where many of the legacy devices (such as PIT) are not
> emulated.
> 
> I would like to thank Olaf Hering <olaf@aepfle.de>, Jan Beulich
> <JBeulich@suse.com> and
> H. Peter Anvin <h.peter.anvin@intel.com> for their help in this effort.
> 
> In this version of the patch, I have addressed Jan's comments.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> ---
>  arch/x86/include/uapi/asm/hyperv.h |   19 +++++++++++++++++++
>  arch/x86/kernel/cpu/mshyperv.c     |   24 ++++++++++++++++++++++++
>  2 files changed, 43 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/include/uapi/asm/hyperv.h
> b/arch/x86/include/uapi/asm/hyperv.h
> index b80420b..b8f1c01 100644
> --- a/arch/x86/include/uapi/asm/hyperv.h
> +++ b/arch/x86/include/uapi/asm/hyperv.h
> @@ -27,6 +27,19 @@
>  #define HV_X64_MSR_VP_RUNTIME_AVAILABLE		(1 << 0)
>  /* Partition Reference Counter (HV_X64_MSR_TIME_REF_COUNT) available*/
>  #define HV_X64_MSR_TIME_REF_COUNT_AVAILABLE	(1 << 1)
> +
> +/*
> + * There is a single feature flag that signifies the presence of the MSR
> + * that can be used to retrieve both the local APIC Timer frequency as
> + * well as the TSC frequency.
> + */
> +
> +/* Local APIC timer frequency MSR (HV_X64_MSR_APIC_FREQUENCY) is
> available */
> +#define HV_X64_MSR_APIC_FREQUENCY_AVAILABLE (1 << 11)
> +
> +/* TSC frequency MSR (HV_X64_MSR_TSC_FREQUENCY) is available */
> +#define HV_X64_MSR_TSC_FREQUENCY_AVAILABLE (1 << 11)
> +
>  /*
>   * Basic SynIC MSRs (HV_X64_MSR_SCONTROL through HV_X64_MSR_EOM
>   * and HV_X64_MSR_SINT0 through HV_X64_MSR_SINT15) available
> @@ -136,6 +149,12 @@
>  /* MSR used to read the per-partition time reference counter */
>  #define HV_X64_MSR_TIME_REF_COUNT		0x40000020
> 
> +/* MSR used to retrieve the TSC frequency */
> +#define HV_X64_MSR_TSC_FREQUENCY		0x40000022
> +
> +/* MSR used to retrieve the local APIC timer frequency */
> +#define HV_X64_MSR_APIC_FREQUENCY		0x40000023
> +
>  /* Define the virtual APIC registers */
>  #define HV_X64_MSR_EOI				0x40000070
>  #define HV_X64_MSR_ICR				0x40000071
> diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
> index 71a39f3..b3dc639 100644
> --- a/arch/x86/kernel/cpu/mshyperv.c
> +++ b/arch/x86/kernel/cpu/mshyperv.c
> @@ -15,6 +15,7 @@
>  #include <linux/clocksource.h>
>  #include <linux/module.h>
>  #include <linux/hardirq.h>
> +#include <linux/efi.h>
>  #include <linux/interrupt.h>
>  #include <asm/processor.h>
>  #include <asm/hypervisor.h>
> @@ -23,6 +24,7 @@
>  #include <asm/desc.h>
>  #include <asm/idle.h>
>  #include <asm/irq_regs.h>
> +#include <asm/i8259.h>
> 
>  struct ms_hyperv_info ms_hyperv;
>  EXPORT_SYMBOL_GPL(ms_hyperv);
> @@ -67,6 +69,8 @@ static struct clocksource hyperv_cs = {
> 
>  static void __init ms_hyperv_init_platform(void)
>  {
> +	u64	hv_lapic_frequency;
> +
>  	/*
>  	 * Extract the features and hints
>  	 */
> @@ -76,6 +80,26 @@ static void __init ms_hyperv_init_platform(void)
>  	printk(KERN_INFO "HyperV: features 0x%x, hints 0x%x\n",
>  	       ms_hyperv.features, ms_hyperv.hints);
> 
> +	if (ms_hyperv.features & HV_X64_MSR_APIC_FREQUENCY_AVAILABLE) {
> +		/*
> +		 * Get the APIC frequency.
> +		 */
> +		rdmsrl(HV_X64_MSR_APIC_FREQUENCY, hv_lapic_frequency);
> +		hv_lapic_frequency /= HZ;
> +		lapic_timer_frequency = hv_lapic_frequency;
> +		printk(KERN_INFO "HyperV: LAPIC Timer Frequency: %#x\n",
> +				lapic_timer_frequency);
> +
> +		/*
> +		 * On Hyper-V, when we are booting off an EFI firmware stack,
> +		 * we do not have many legacy devices including PIC, PIT etc.
> +		 */
> +		if (efi_enabled(EFI_BOOT)) {
> +			printk(KERN_INFO "HyperV: Using null_legacy_pic\n");
> +			legacy_pic = &null_legacy_pic;
> +		}
> +	}
> +
>  	if (ms_hyperv.features & HV_X64_MSR_TIME_REF_COUNT_AVAILABLE)
>  		clocksource_register_hz(&hyperv_cs, NSEC_PER_SEC/100);
>  }
> --
> 1.7.4.1

Peter,

Let me know if you want me to address any additional issues in this patch.


Regards,

K. Y
