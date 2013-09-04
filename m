Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762955Ab3IDPQg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 11:16:36 -0400
Received: from mail-bl2lp0212.outbound.protection.outlook.com ([207.46.163.212]:49562
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756587Ab3IDPQe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 11:16:34 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Gleb Natapov <gleb@redhat.com>
CC: "x86@kernel.org" <x86@kernel.org>,
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
Thread-Index: AQHOqM30I+mkPB2b1kKq/5YqjRysqJm1U+cAgABcLfA=
Date: Wed, 4 Sep 2013 15:16:30 +0000
Message-ID: <e70c81ed3b6f455c90ac24d6ffa2b5d2@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1378233023-4512-1-git-send-email-kys@microsoft.com>
 <20130904094014.GB7402@redhat.com>
In-Reply-To: <20130904094014.GB7402@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [174.61.203.63]
x-forefront-prvs: 095972DF2F
x-forefront-antispam-report: SFV:NSPM;SFS:(24454002)(13464003)(377454003)(189002)(199002)(51704005)(83072001)(81816001)(80022001)(81686001)(65816001)(81342001)(47976001)(81542001)(47736001)(74876001)(50986001)(76576001)(56776001)(80976001)(59766001)(77982001)(76786001)(76796001)(54316002)(79102001)(66066001)(33646001)(63696002)(56816003)(53806001)(54356001)(76482001)(69226001)(31966008)(51856001)(74502001)(4396001)(47446002)(19580405001)(83322001)(77096001)(49866001)(74706001)(74662001)(19580395003)(74316001)(74366001)(46102001)(24736002)(15583001);DIR:OUT;SFP:;SCL:1;SRVR:SN2PR03MB063;H:SN2PR03MB061.namprd03.prod.outlook.com;CLIP:174.61.203.63;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: DuplicateDomain-a84fc36a-4ed7-4e57-ab1c-3e967bcbad48.microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Gleb Natapov [mailto:gleb@redhat.com]
> Sent: Wednesday, September 04, 2013 2:40 AM
> To: KY Srinivasan
> Cc: x86@kernel.org; gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> jasowang@redhat.com; tglx@linutronix.de; hpa@zytor.com;
> JBeulich@suse.com; bp@alien8.de
> Subject: Re: [PATCH V2 1/1] X86: Hyper-V: Get the local APIC timer frequency
> from the hypervisor
> 
> On Tue, Sep 03, 2013 at 11:30:23AM -0700, K. Y. Srinivasan wrote:
> > Hyper-V supports a mechanism for retrieving the local APIC frequency.Use this
> and bypass
> > the calibration code in the kernel. This would allow us to boot the Linux kernel
> as a
> > "modern VM" on Hyper-V where many of the legacy devices (such as PIT) are
> not emulated.
> >
> > I would like to thank Olaf Hering <olaf@aepfle.de>, Jan Beulich
> <JBeulich@suse.com> and
> > H. Peter Anvin <h.peter.anvin@intel.com> for their help in this effort.
> >
> > In this version of the patch, I have addressed Jan's comments.
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > ---
> >  arch/x86/include/uapi/asm/hyperv.h |   19 +++++++++++++++++++
> >  arch/x86/kernel/cpu/mshyperv.c     |   24 ++++++++++++++++++++++++
> >  2 files changed, 43 insertions(+), 0 deletions(-)
> >
> > diff --git a/arch/x86/include/uapi/asm/hyperv.h
> b/arch/x86/include/uapi/asm/hyperv.h
> > index b80420b..b8f1c01 100644
> > --- a/arch/x86/include/uapi/asm/hyperv.h
> > +++ b/arch/x86/include/uapi/asm/hyperv.h
> > @@ -27,6 +27,19 @@
> >  #define HV_X64_MSR_VP_RUNTIME_AVAILABLE		(1 << 0)
> >  /* Partition Reference Counter (HV_X64_MSR_TIME_REF_COUNT) available*/
> >  #define HV_X64_MSR_TIME_REF_COUNT_AVAILABLE	(1 << 1)
> > +
> > +/*
> > + * There is a single feature flag that signifies the presence of the MSR
> > + * that can be used to retrieve both the local APIC Timer frequency as
> > + * well as the TSC frequency.
> > + */
> > +
> > +/* Local APIC timer frequency MSR (HV_X64_MSR_APIC_FREQUENCY) is
> available */
> > +#define HV_X64_MSR_APIC_FREQUENCY_AVAILABLE (1 << 11)
> > +
> > +/* TSC frequency MSR (HV_X64_MSR_TSC_FREQUENCY) is available */
> > +#define HV_X64_MSR_TSC_FREQUENCY_AVAILABLE (1 << 11)
> > +
> >  /*
> >   * Basic SynIC MSRs (HV_X64_MSR_SCONTROL through HV_X64_MSR_EOM
> >   * and HV_X64_MSR_SINT0 through HV_X64_MSR_SINT15) available
> > @@ -136,6 +149,12 @@
> >  /* MSR used to read the per-partition time reference counter */
> >  #define HV_X64_MSR_TIME_REF_COUNT		0x40000020
> >
> > +/* MSR used to retrieve the TSC frequency */
> > +#define HV_X64_MSR_TSC_FREQUENCY		0x40000022
> > +
> You do not use this MSR in the patch, but in general how it suppose to
> work during migration if host TSC frequency changes?

TSC related migration issues are distinct from how we calibrate the TSC frequency. This MSR
allows you to retrieve the TSC frequency without having to do explicit calibration.

To address the migration issues; the hypervisor provides additional information on the host
that you are running that can be used to compensate for differences in TSC across hosts.  

Regards,

K. Y
