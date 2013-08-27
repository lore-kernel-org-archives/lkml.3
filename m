Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723Ab3H0HZp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 03:25:45 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:33956 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321Ab3H0HZo convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:8:1>);
	Tue, 27 Aug 2013 03:25:44 -0400
Message-Id: <521C709202000078000EE9E5@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Tue, 27 Aug 2013 08:25:38 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: <olaf@aepfle.de>, <apw@canonical.com>, <x86@kernel.org>,
        <devel@linuxdriverproject.org>, <gregkh@linuxfoundation.org>,
        <jasowang@redhat.com>, <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH 1/1] X86: Hyper-V: Get the local APIC timer
 frequency from the hypervisor
References: <1377560535-8184-1-git-send-email-kys@microsoft.com>
In-Reply-To: <1377560535-8184-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 27.08.13 at 01:42, "K. Y. Srinivasan" <kys@microsoft.com> wrote:
> Hyper-V supports a mechanism for retrieving the local API frequency.

"APIC"?

> @@ -27,6 +27,13 @@
>  #define HV_X64_MSR_VP_RUNTIME_AVAILABLE		(1 << 0)
>  /* Partition Reference Counter (HV_X64_MSR_TIME_REF_COUNT) available*/
>  #define HV_X64_MSR_TIME_REF_COUNT_AVAILABLE	(1 << 1)
> +
> +/* Local APIC timer frequency MSR (HV_X64_MSR_APIC_FREQUENCY) is available */
> +#define HV_X64_MSR_APIC_FREQUENCY_AVAILABLE (1 << 11)
> +
> +/* TSC frequency MSR (HV_X64_MSR_TSC_FREQUENCY) is available */
> +#define HV_X64_MSR_TSC_FREQUENCY_AVAILABLE (1 << 11)

Are these two really the same bit? If so, why two different names?

> @@ -136,6 +143,12 @@
>  /* MSR used to read the per-partition time reference counter */
>  #define HV_X64_MSR_TIME_REF_COUNT		0x40000020
>  
> +/* MSR used to retrive the TSC frequency */
> +#define HV_X64_MSR_TSC_FREQUENCY		0x40000022
> +
> +/* MSR used to retrive the local APIC timer frequency */
> +#define HV_X64_MSR_APIC_FREQUENCY		0x40000023

"retrieve" (twice)?

> @@ -76,6 +77,22 @@ static void __init ms_hyperv_init_platform(void)
>  	printk(KERN_INFO "HyperV: features 0x%x, hints 0x%x\n",
>  	       ms_hyperv.features, ms_hyperv.hints);
>  
> +	if (ms_hyperv.features & HV_X64_MSR_APIC_FREQUENCY_AVAILABLE) {
> +		/*
> +		 * There is no need to calibrate APIC timer frequency;
> +		 * nor is there a need to calibrate timer.
> +		 */
> +		legacy_pic = &null_legacy_pic;

This clearly disables more than just the calibration, so the comment
may be misleading to future readers.

> +
> +		/*
> +		 * Get the APIC frequency.
> +		 */
> +		rdmsrl(HV_X64_MSR_APIC_FREQUENCY, lapic_timer_frequency);
> +		lapic_timer_frequency /= HZ;

Is this safe? I.e. are the high 32 bits of the MSR guaranteed to
be zero, now and forever?

> +		printk(KERN_INFO "HyperV: LAPIC Timer Frequency: 0x%x\n",
> +				lapic_timer_frequency);

As a minor note, I generally recommend using %#x as being one
byte shorter than the spelled out 0x%x.

Jan

