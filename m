Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935029Ab3IDPDu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 11:03:50 -0400
Received: from mail-bl2lp0210.outbound.protection.outlook.com ([207.46.163.210]:53943
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934783Ab3IDPDt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 11:03:49 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Jan Beulich <JBeulich@suse.com>
CC: "olaf@aepfle.de" <olaf@aepfle.de>, "bp@alien8.de" <bp@alien8.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>
Subject: RE: [PATCH V2 1/1] X86: Hyper-V: Get the local APIC timer frequency
 from the hypervisor
Thread-Topic: [PATCH V2 1/1] X86: Hyper-V: Get the local APIC timer
 frequency from the hypervisor
Thread-Index: AQHOqM30I+mkPB2b1kKq/5YqjRysqJm1K++AgAB4eOA=
Date: Wed, 4 Sep 2013 15:03:44 +0000
Message-ID: <999b0deb4e3b45f39651fb1a4673f355@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1378233023-4512-1-git-send-email-kys@microsoft.com>
 <5226FA9702000078000F0387@nat28.tlf.novell.com>
In-Reply-To: <5226FA9702000078000F0387@nat28.tlf.novell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [174.61.203.63]
x-forefront-prvs: 095972DF2F
x-forefront-antispam-report: SFV:NSPM;SFS:(189002)(199002)(51704005)(377454003)(24454002)(13464003)(65816001)(46102001)(83322001)(19580405001)(51856001)(31966008)(47446002)(74502001)(74662001)(50986001)(47976001)(81542001)(81342001)(4396001)(49866001)(47736001)(80022001)(66066001)(69226001)(59766001)(77982001)(56776001)(54316002)(74366001)(74876001)(53806001)(19580395003)(80976001)(63696002)(81816001)(79102001)(83072001)(74316001)(56816003)(54356001)(76576001)(76786001)(81686001)(77096001)(74706001)(76482001)(76796001)(33646001)(15583001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:SN2PR03MB062;H:SN2PR03MB061.namprd03.prod.outlook.com;CLIP:174.61.203.63;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: DuplicateDomain-a84fc36a-4ed7-4e57-ab1c-3e967bcbad48.microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Jan Beulich [mailto:JBeulich@suse.com]
> Sent: Wednesday, September 04, 2013 12:17 AM
> To: KY Srinivasan
> Cc: olaf@aepfle.de; bp@alien8.de; apw@canonical.com; x86@kernel.org;
> tglx@linutronix.de; devel@linuxdriverproject.org; gregkh@linuxfoundation.org;
> jasowang@redhat.com; linux-kernel@vger.kernel.org; hpa@zytor.com
> Subject: Re: [PATCH V2 1/1] X86: Hyper-V: Get the local APIC timer frequency
> from the hypervisor
> 
> >>> On 03.09.13 at 20:30, "K. Y. Srinivasan" <kys@microsoft.com> wrote:
> > @@ -76,6 +80,26 @@ static void __init ms_hyperv_init_platform(void)
> >  	printk(KERN_INFO "HyperV: features 0x%x, hints 0x%x\n",
> >  	       ms_hyperv.features, ms_hyperv.hints);
> >
> > +	if (ms_hyperv.features & HV_X64_MSR_APIC_FREQUENCY_AVAILABLE) {
> > +		/*
> > +		 * Get the APIC frequency.
> > +		 */
> > +		rdmsrl(HV_X64_MSR_APIC_FREQUENCY, hv_lapic_frequency);
> > +		hv_lapic_frequency /= HZ;
> > +		lapic_timer_frequency = hv_lapic_frequency;
> > +		printk(KERN_INFO "HyperV: LAPIC Timer Frequency: %#x\n",
> > +				lapic_timer_frequency);
> > +
> > +		/*
> > +		 * On Hyper-V, when we are booting off an EFI firmware stack,
> > +		 * we do not have many legacy devices including PIC, PIT etc.
> > +		 */
> > +		if (efi_enabled(EFI_BOOT)) {
> > +			printk(KERN_INFO "HyperV: Using null_legacy_pic\n");
> > +			legacy_pic = &null_legacy_pic;
> > +		}
> 
> And this check is really connected to the feature check around the
> whole block, rather than being independent? (I'd also think that
> this latter message would suffice to be KERN_DEBUG).

I felt it was safer to first check for the feature  since if the feature is not
there, we need to calibrate based on PIT. Furthermore, the feature is available
even in legacy environments when we are not booting on an EFI stack.

Regards,

K. Y

> 
> Jan

