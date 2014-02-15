Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087AbaBOAZS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 19:25:18 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:41760 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788AbaBOAZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 19:25:16 -0500
Date: Fri, 14 Feb 2014 16:25:05 -0800
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Scott Wood <scottwood@freescale.com>
Cc: Linux PPC <linuxppc-dev@lists.ozlabs.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Lijun Pan <Lijun.Pan@freescale.com>, Li Yang <leoli@freescale.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Paul Bolle <pebolle@tiscali.nl>,
        Priyanka Jain <Priyanka.Jain@freescale.com>,
        Tang Yuantian <yuantian.tang@freescale.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v2 10/11] powerpc/perf: add kconfig option for hypervisor
 provided counters
Message-ID: <20140215002505.GA2991@negative>
References: <1392415338-16288-1-git-send-email-cody@linux.vnet.ibm.com>
 <1392415338-16288-11-git-send-email-cody@linux.vnet.ibm.com>
 <1392417133.6733.624.camel@snotra.buserror.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392417133.6733.624.camel@snotra.buserror.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021500-0320-0000-0000-0000027844A6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 04:32:13PM -0600, Scott Wood wrote:
> On Fri, 2014-02-14 at 14:02 -0800, Cody P Schafer wrote:
> > Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
> > ---
> >  arch/powerpc/perf/Makefile             | 2 ++
> >  arch/powerpc/platforms/Kconfig.cputype | 6 ++++++
> >  2 files changed, 8 insertions(+)
> > 
> > diff --git a/arch/powerpc/perf/Makefile b/arch/powerpc/perf/Makefile
> > index 60d71ee..f9c083a 100644
> > --- a/arch/powerpc/perf/Makefile
> > +++ b/arch/powerpc/perf/Makefile
> > @@ -11,5 +11,7 @@ obj32-$(CONFIG_PPC_PERF_CTRS)	+= mpc7450-pmu.o
> >  obj-$(CONFIG_FSL_EMB_PERF_EVENT) += core-fsl-emb.o
> >  obj-$(CONFIG_FSL_EMB_PERF_EVENT_E500) += e500-pmu.o e6500-pmu.o
> >  
> > +obj-$(CONFIG_HV_PERF_CTRS) += hv-24x7.o hv-gpci.o hv-common.o
> > +
> >  obj-$(CONFIG_PPC64)		+= $(obj64-y)
> >  obj-$(CONFIG_PPC32)		+= $(obj32-y)
> > diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
> > index 434fda3..dcc67cd 100644
> > --- a/arch/powerpc/platforms/Kconfig.cputype
> > +++ b/arch/powerpc/platforms/Kconfig.cputype
> > @@ -364,6 +364,12 @@ config PPC_PERF_CTRS
> >         help
> >           This enables the powerpc-specific perf_event back-end.
> >  
> > +config HV_PERF_CTRS
> > +       def_bool y
> > +       depends on PERF_EVENTS && PPC_HAVE_PMU_SUPPORT
> > +       help
> > +         Enable access to perf counters provided by the hypervisor
> 
> Please don't add default-y stuff that is platform-specific, and
> definitely point out that platform dependency in the config description
> -- I have to look elsewhere in the patchset to determine that this is
> for "Power Hypervisor".  PPC_HAVE_PMU_SUPPORT is enabled by all 6xx
> builds, even for hardware like e300 that doesn't have PMU at all (it has
> the FSL embedded perfmon instead), much less this hv interface.
> 
> And yes, PPC_PERF_CTRS has the same problem and should be fixed. :-)

Yep, I just based this one on what PPC_PERF_CTRS was doing.

How about the following:

+config HV_PERF_CTRS
+       bool "Perf Hypervisor supplied counters"
+       default y
+       depends on PERF_EVENTS && PPC_HAVE_PMU_SUPPORT && PPC_PSERIES
+       help
+	  Enable access to hypervisor supplied counters in perf. Currently,
+	  this enables code that uses the hcall GetPerfCounterInfo and 24x7
+	  interfaces to retrieve counters. GPCI exists on Power 6 and later
+	  systems. 24x7 is available on Power 8 systems.
+
+          If unsure, select Y.

And relocated to arch/powerpc/platforms/Kconfig (as this isn't really
strictly "cputype" related).

