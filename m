Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096Ab3IEOUr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 10:20:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49105 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752822Ab3IEOUp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 10:20:45 -0400
Date: Thu, 5 Sep 2013 17:16:36 +0300
From: Gleb Natapov <gleb@redhat.com>
To: KY Srinivasan <kys@microsoft.com>
Cc: "x86@kernel.org" <x86@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "JBeulich@suse.com" <JBeulich@suse.com>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH V2 1/1] X86: Hyper-V: Get the local APIC timer frequency
 from the hypervisor
Message-ID: <20130905141636.GA22751@redhat.com>
References: <1378233023-4512-1-git-send-email-kys@microsoft.com>
 <20130904094014.GB7402@redhat.com>
 <e70c81ed3b6f455c90ac24d6ffa2b5d2@SN2PR03MB061.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e70c81ed3b6f455c90ac24d6ffa2b5d2@SN2PR03MB061.namprd03.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 04, 2013 at 03:16:30PM +0000, KY Srinivasan wrote:
> 
> 
> > -----Original Message-----
> > From: Gleb Natapov [mailto:gleb@redhat.com]
> > Sent: Wednesday, September 04, 2013 2:40 AM
> > To: KY Srinivasan
> > Cc: x86@kernel.org; gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> > devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> > jasowang@redhat.com; tglx@linutronix.de; hpa@zytor.com;
> > JBeulich@suse.com; bp@alien8.de
> > Subject: Re: [PATCH V2 1/1] X86: Hyper-V: Get the local APIC timer frequency
> > from the hypervisor
> > 
> > On Tue, Sep 03, 2013 at 11:30:23AM -0700, K. Y. Srinivasan wrote:
> > > Hyper-V supports a mechanism for retrieving the local APIC frequency.Use this
> > and bypass
> > > the calibration code in the kernel. This would allow us to boot the Linux kernel
> > as a
> > > "modern VM" on Hyper-V where many of the legacy devices (such as PIT) are
> > not emulated.
> > >
> > > I would like to thank Olaf Hering <olaf@aepfle.de>, Jan Beulich
> > <JBeulich@suse.com> and
> > > H. Peter Anvin <h.peter.anvin@intel.com> for their help in this effort.
> > >
> > > In this version of the patch, I have addressed Jan's comments.
> > >
> > > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > > ---
> > >  arch/x86/include/uapi/asm/hyperv.h |   19 +++++++++++++++++++
> > >  arch/x86/kernel/cpu/mshyperv.c     |   24 ++++++++++++++++++++++++
> > >  2 files changed, 43 insertions(+), 0 deletions(-)
> > >
> > > diff --git a/arch/x86/include/uapi/asm/hyperv.h
> > b/arch/x86/include/uapi/asm/hyperv.h
> > > index b80420b..b8f1c01 100644
> > > --- a/arch/x86/include/uapi/asm/hyperv.h
> > > +++ b/arch/x86/include/uapi/asm/hyperv.h
> > > @@ -27,6 +27,19 @@
> > >  #define HV_X64_MSR_VP_RUNTIME_AVAILABLE		(1 << 0)
> > >  /* Partition Reference Counter (HV_X64_MSR_TIME_REF_COUNT) available*/
> > >  #define HV_X64_MSR_TIME_REF_COUNT_AVAILABLE	(1 << 1)
> > > +
> > > +/*
> > > + * There is a single feature flag that signifies the presence of the MSR
> > > + * that can be used to retrieve both the local APIC Timer frequency as
> > > + * well as the TSC frequency.
> > > + */
> > > +
> > > +/* Local APIC timer frequency MSR (HV_X64_MSR_APIC_FREQUENCY) is
> > available */
> > > +#define HV_X64_MSR_APIC_FREQUENCY_AVAILABLE (1 << 11)
> > > +
> > > +/* TSC frequency MSR (HV_X64_MSR_TSC_FREQUENCY) is available */
> > > +#define HV_X64_MSR_TSC_FREQUENCY_AVAILABLE (1 << 11)
> > > +
> > >  /*
> > >   * Basic SynIC MSRs (HV_X64_MSR_SCONTROL through HV_X64_MSR_EOM
> > >   * and HV_X64_MSR_SINT0 through HV_X64_MSR_SINT15) available
> > > @@ -136,6 +149,12 @@
> > >  /* MSR used to read the per-partition time reference counter */
> > >  #define HV_X64_MSR_TIME_REF_COUNT		0x40000020
> > >
> > > +/* MSR used to retrieve the TSC frequency */
> > > +#define HV_X64_MSR_TSC_FREQUENCY		0x40000022
> > > +
> > You do not use this MSR in the patch, but in general how it suppose to
> > work during migration if host TSC frequency changes?
> 
> TSC related migration issues are distinct from how we calibrate the TSC frequency. This MSR
> allows you to retrieve the TSC frequency without having to do explicit calibration.
> 
But the value retrieved can be obsolete by the time guest sues it due to
migration.

> To address the migration issues; the hypervisor provides additional information on the host
> that you are running that can be used to compensate for differences in TSC across hosts.  
> 
Are you referring to "Reference TSC Page" here?

--
			Gleb.
