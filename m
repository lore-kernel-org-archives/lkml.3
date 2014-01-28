Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595AbaA1TaM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 14:30:12 -0500
Received: from mga11.intel.com ([192.55.52.93]:25122 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754636AbaA1TaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 14:30:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,737,1384329600"; 
   d="scan'208";a="466116288"
Date: Tue, 28 Jan 2014 11:35:15 -0800
From: David Cohen <david.a.cohen@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Fei Yang <fei.yang@intel.com>,
        "Mark F. Brown" <mark.f.brown@intel.com>,
        Kuppuswamy Sathyanarayanan 
	<sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: Re: [PATCH v2 3/4] x86: intel-mid: add Merrifield platform support
Message-ID: <20140128193515.GB11722@psi-dev26.jf.intel.com>
References: <1387224459-25746-1-git-send-email-david.a.cohen@linux.intel.com>
 <1387224459-25746-4-git-send-email-david.a.cohen@linux.intel.com>
 <CAErSpo4ymfSdZ5an4zt+C=5asUW=vz000d32mPZkF-S5N_uynA@mail.gmail.com>
 <20140128013013.GA31626@psi-dev26.jf.intel.com>
 <CAErSpo52sXXKkJZ=bMMZw4G0Z0AJ=-u+Ov14+qp=S+y9LCP=Rg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo52sXXKkJZ=bMMZw4G0Z0AJ=-u+Ov14+qp=S+y9LCP=Rg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 11:40:57AM -0700, Bjorn Helgaas wrote:
> On Mon, Jan 27, 2014 at 6:30 PM, David Cohen
> <david.a.cohen@linux.intel.com> wrote:
> > Hi Bjorn,
> >
> > On Mon, Jan 27, 2014 at 05:52:30PM -0700, Bjorn Helgaas wrote:
> >> On Mon, Dec 16, 2013 at 1:07 PM, David Cohen
> >> <david.a.cohen@linux.intel.com> wrote:
> >> > This code was partially based on Mark Brown's previous work.
> >> >
> >> > Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
> >> > Signed-off-by: Fei Yang <fei.yang@intel.com>
> >> > Cc: Mark F. Brown <mark.f.brown@intel.com>
> >> > Cc: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
> >>
> >> I know this has already been merged to Linus' tree, but it looks funny to me.
> >>
> >> > --- a/arch/x86/platform/intel-mid/intel_mid_weak_decls.h
> >> > +++ b/arch/x86/platform/intel-mid/intel_mid_weak_decls.h
> >> > @@ -16,3 +16,4 @@
> >> >   */
> >> >  extern void * __cpuinit get_penwell_ops(void) __attribute__((weak));
> >> >  extern void * __cpuinit get_cloverview_ops(void) __attribute__((weak));
> >> > +extern void * __init get_tangier_ops(void) __attribute__((weak));
> >>
> >> We should use "__weak" instead of the gcc-specific "__attribute__((weak))".
> >>
> >> I don't think it's a good idea to use __weak on a declaration in a
> >> header file.  If there are ever multiple definitions of the symbol,
> >> they are *all* made weak symbols, and one is chosen based on link
> >> order, which is error-prone.  I only see one definition now, but the
> >> whole point of weak is to allow multiple definitions, so this looks
> >> like a problem waiting to happen.  See 10629d711ed, for example.
> >>
> >> It look me a bit to figure out that these get_*_ops() functions are
> >> used by INTEL_MID_OPS_INIT, which constructs the name using a macro,
> >> so grep/cscope/etc. don't see any users.  A comment pointing to
> >> INTEL_MID_OPS_INIT would be helpful.
> >>
> >> What's the reason for making these symbols weak?  Normally we use weak
> >> to make a generic default version of a function, while allowing
> >> architectures to replace the default with their own version if
> >> necessary.  But I don't see that happening here.  Maybe I'm just
> >> missing it, like I missed the uses of get_tangier_ops(), et al.
> >
> > Intel mid was implemented in such way that we should select which soc to
> > be used in compilation time. Depending on the selection, mfld.c or
> > mrfl.c could not be compiled then some symbols wouldn't be available.
> >
> > But IMHO this is a bad legacy design that exists in there, so I started
> > to rework it as you can see in this commit:
> >
> > commit 4cb9b00f42e07830310319a07e6c91413ee8153e
> > Author: David Cohen <david.a.cohen@linux.intel.com>
> > Date:   Mon Dec 16 17:37:26 2013 -0800
> >
> >     x86, intel-mid: Remove deprecated X86_MDFLD and X86_WANT_INTEL_MID
> >     configs
> >
> > I'm sending more patches soon and getting rid of intel_mid_weak_decls.h
> > file is in my TODO list.
> 
> Sounds good.  While you're looking at it, I have similar questions
> about ipc_device_handler() and msic_generic_platform_data().  It's not
> clear to me why they should be weak.

I'm afraid that's gargabe I missed. It supposed to be removed already.

The original upstreamed patch set needed it, since all platform data
were gathered in a board.c file and some of them could not be compiled.
You can see it here:
http://us.generation-nt.com/answer/patch-v2-00-10-rework-arch-x86-platform-mrst-intel-mid-help-212689892.html

But I reworked this approach and added a sfi_device() macro to let
compiler to gather all the platform data, thus board.c file doesn't
exist. It means it is not necessary anymore to be weak. I can send a
patch right away fixing it.

Thanks for pointing that out.

Br, David

> 
> Bjorn
