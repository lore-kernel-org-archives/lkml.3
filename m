Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413Ab3H0Qhg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 12:37:36 -0400
Received: from mail-by2lp0244.outbound.protection.outlook.com ([207.46.163.244]:6483
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752532Ab3H0Qhf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 12:37:35 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Jan Beulich <JBeulich@suse.com>
CC: "olaf@aepfle.de" <olaf@aepfle.de>, "apw@canonical.com" <apw@canonical.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>
Subject: RE: [PATCH 1/1] X86: Hyper-V: Get the local APIC timer frequency
 from the hypervisor
Thread-Topic: [PATCH 1/1] X86: Hyper-V: Get the local APIC timer frequency
 from the hypervisor
Thread-Index: AQHOorBDqCjHqTGU0EK8UsLWhPDGYZmop+AAgACZ4iA=
Date: Tue, 27 Aug 2013 16:37:32 +0000
Message-ID: <e748dc167d444e85b16c649cb8437165@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1377560535-8184-1-git-send-email-kys@microsoft.com>
 <521C709202000078000EE9E5@nat28.tlf.novell.com>
In-Reply-To: <521C709202000078000EE9E5@nat28.tlf.novell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:4898:80e8:ed31::4]
x-forefront-prvs: 0951AB0A30
x-forefront-antispam-report: SFV:NSPM;SFS:(13464003)(199002)(24454002)(377454003)(51704005)(189002)(53806001)(74876001)(47736001)(74316001)(54316002)(76482001)(56776001)(47976001)(81542001)(69226001)(54356001)(47446002)(31966008)(81342001)(74662001)(74502001)(74706001)(80022001)(77096001)(80976001)(56816003)(76576001)(65816001)(77982001)(79102001)(59766001)(51856001)(63696002)(46102001)(33646001)(49866001)(83072001)(4396001)(74366001)(19580395003)(76796001)(19580405001)(83322001)(81816001)(76786001)(81686001)(50986001)(15583001)(24736002)(3826001);DIR:OUT;SFP:;SCL:1;SRVR:SN2PR03MB061;H:SN2PR03MB061.namprd03.prod.outlook.com;CLIP:2001:4898:80e8:ed31::4;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: DuplicateDomain-a84fc36a-4ed7-4e57-ab1c-3e967bcbad48.microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Jan Beulich [mailto:JBeulich@suse.com]
> Sent: Tuesday, August 27, 2013 12:26 AM
> To: KY Srinivasan
> Cc: olaf@aepfle.de; apw@canonical.com; x86@kernel.org;
> devel@linuxdriverproject.org; gregkh@linuxfoundation.org;
> jasowang@redhat.com; linux-kernel@vger.kernel.org; hpa@zytor.com
> Subject: Re: [PATCH 1/1] X86: Hyper-V: Get the local APIC timer frequency from
> the hypervisor
> 
> >>> On 27.08.13 at 01:42, "K. Y. Srinivasan" <kys@microsoft.com> wrote:
> > Hyper-V supports a mechanism for retrieving the local API frequency.
> 
> "APIC"?
> 
> > @@ -27,6 +27,13 @@
> >  #define HV_X64_MSR_VP_RUNTIME_AVAILABLE		(1 << 0)
> >  /* Partition Reference Counter (HV_X64_MSR_TIME_REF_COUNT) available*/
> >  #define HV_X64_MSR_TIME_REF_COUNT_AVAILABLE	(1 << 1)
> > +
> > +/* Local APIC timer frequency MSR (HV_X64_MSR_APIC_FREQUENCY) is
> available */
> > +#define HV_X64_MSR_APIC_FREQUENCY_AVAILABLE (1 << 11)
> > +
> > +/* TSC frequency MSR (HV_X64_MSR_TSC_FREQUENCY) is available */
> > +#define HV_X64_MSR_TSC_FREQUENCY_AVAILABLE (1 << 11)
> 
> Are these two really the same bit? If so, why two different names?
> 
> > @@ -136,6 +143,12 @@
> >  /* MSR used to read the per-partition time reference counter */
> >  #define HV_X64_MSR_TIME_REF_COUNT		0x40000020
> >
> > +/* MSR used to retrive the TSC frequency */
> > +#define HV_X64_MSR_TSC_FREQUENCY		0x40000022
> > +
> > +/* MSR used to retrive the local APIC timer frequency */
> > +#define HV_X64_MSR_APIC_FREQUENCY		0x40000023
> 
> "retrieve" (twice)?
> 
> > @@ -76,6 +77,22 @@ static void __init ms_hyperv_init_platform(void)
> >  	printk(KERN_INFO "HyperV: features 0x%x, hints 0x%x\n",
> >  	       ms_hyperv.features, ms_hyperv.hints);
> >
> > +	if (ms_hyperv.features & HV_X64_MSR_APIC_FREQUENCY_AVAILABLE) {
> > +		/*
> > +		 * There is no need to calibrate APIC timer frequency;
> > +		 * nor is there a need to calibrate timer.
> > +		 */
> > +		legacy_pic = &null_legacy_pic;
> 
> This clearly disables more than just the calibration, so the comment
> may be misleading to future readers.
> 
> > +
> > +		/*
> > +		 * Get the APIC frequency.
> > +		 */
> > +		rdmsrl(HV_X64_MSR_APIC_FREQUENCY,
> lapic_timer_frequency);
> > +		lapic_timer_frequency /= HZ;
> 
> Is this safe? I.e. are the high 32 bits of the MSR guaranteed to
> be zero, now and forever?
> 
> > +		printk(KERN_INFO "HyperV: LAPIC Timer Frequency: 0x%x\n",
> > +				lapic_timer_frequency);
> 
> As a minor note, I generally recommend using %#x as being one
> byte shorter than the spelled out 0x%x.
> 
> Jan

Thanks Jan. I will fix the issues you have pointed out and resubmit the patch.

Regards,

K. Y
