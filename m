Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732Ab3AXQPg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 11:15:36 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:59185 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478Ab3AXQPe convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:10:1>);
	Thu, 24 Jan 2013 11:15:34 -0500
Message-Id: <51016C3202000078000B943E@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Thu, 24 Jan 2013 16:15:30 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "KY Srinivasan" <kys@microsoft.com>
Cc: "olaf@aepfle.de" <olaf@aepfle.de>, "bp@alien8.de" <bp@alien8.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>
Subject: RE: [PATCH RESEND 1/1] X86: Handle Hyper-V vmbus interrupts as
 special hypervisor interrupts
References: <1358990259-22551-1-git-send-email-kys@microsoft.com>
 <5101035D02000078000B8FFD@nat28.tlf.novell.com>
 <27092660926e4d3f80394697cc0dc858@SN2PR03MB061.namprd03.prod.outlook.com>
In-Reply-To: <27092660926e4d3f80394697cc0dc858@SN2PR03MB061.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 24.01.13 at 17:07, KY Srinivasan <kys@microsoft.com> wrote:

> 
>> -----Original Message-----
>> From: Jan Beulich [mailto:JBeulich@suse.com]
>> Sent: Thursday, January 24, 2013 3:48 AM
>> To: KY Srinivasan
>> Cc: olaf@aepfle.de; bp@alien8.de; apw@canonical.com; x86@kernel.org;
>> tglx@linutronix.de; devel@linuxdriverproject.org; 
> gregkh@linuxfoundation.org;
>> jasowang@redhat.com; linux-kernel@vger.kernel.org; hpa@zytor.com 
>> Subject: Re: [PATCH RESEND 1/1] X86: Handle Hyper-V vmbus interrupts as
>> special hypervisor interrupts
>> 
>> >>> On 24.01.13 at 02:17, "K. Y. Srinivasan" <kys@microsoft.com> wrote:
>> > @@ -69,6 +74,11 @@ static void __init ms_hyperv_init_platform(void)
>> >  	       ms_hyperv.features, ms_hyperv.hints);
>> >
>> >  	clocksource_register_hz(&hyperv_cs, NSEC_PER_SEC/100);
>> > +
>> > +	/*
>> > +	 * Setup the IDT for hypervisor callback.
>> > +	 */
>> > +	alloc_intr_gate(HYPERVISOR_CALLBACK_VECTOR,
>> hyperv_callback_vector);
>> 
>> Isn't doing this unconditionally here as problematic as the call to
>> clocksource_register_hz() turned out to be when Xen's Hyper-V
>> shim reacts to the CPUID inquiry above?
> 
> I was not sure what to make this conditional on at run-time. To the extent
> that Xen emulation of Hyper-V is complete, this will be a problem. Does Xen
> return all the "feature bits" of Hyper-V. I could discriminate on a feature 
> that
> Xen does not plan to emulate.

I've no idea what plans there might be, but that's the code
there is currently:

int cpuid_viridian_leaves(unsigned int leaf, unsigned int *eax,
                          unsigned int *ebx, unsigned int *ecx,
                          unsigned int *edx)
{
    struct domain *d = current->domain;

    if ( !is_viridian_domain(d) )
        return 0;

    leaf -= 0x40000000;
    if ( leaf > 6 )
        return 0;

    *eax = *ebx = *ecx = *edx = 0;
    switch ( leaf )
    {
    case 0:
        *eax = 0x40000006; /* Maximum leaf */
        *ebx = 0x7263694d; /* Magic numbers  */
        *ecx = 0x666F736F;
        *edx = 0x76482074;
        break;
    case 1:
        *eax = 0x31237648; /* Version number */
        break;
    case 2:
        /* Hypervisor information, but only if the guest has set its
           own version number. */
        if ( d->arch.hvm_domain.viridian.guest_os_id.raw == 0 )
            break;
        *eax = 1; /* Build number */
        *ebx = (xen_major_version() << 16) | xen_minor_version();
        *ecx = 0; /* SP */
        *edx = 0; /* Service branch and number */
        break;
    case 3:
        /* Which hypervisor MSRs are available to the guest */
        *eax = (CPUID3A_MSR_APIC_ACCESS |
                CPUID3A_MSR_HYPERCALL   |
                CPUID3A_MSR_VP_INDEX);
        break;
    case 4:
        /* Recommended hypercall usage. */
        if ( (d->arch.hvm_domain.viridian.guest_os_id.raw == 0) ||
             (d->arch.hvm_domain.viridian.guest_os_id.fields.os < 4) )
            break;
        *eax = (CPUID4A_MSR_BASED_APIC |
                CPUID4A_RELAX_TIMER_INT);
        *ebx = 2047; /* long spin count */
        break;
    }

    return 1;
}

Question is - considering you stated that this is supported
starting in Win8, doesn't Hyper-V itself announce that
capability in some explicit way?

Jan

