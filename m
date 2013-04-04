Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764180Ab3DDRvr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 13:51:47 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57185 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764161Ab3DDRvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 13:51:45 -0400
Date: Thu, 4 Apr 2013 13:51:17 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: David Woodhouse <dwmw2@infradead.org>, Prarit Bhargava <prarit@redhat.com>,
        Don Zickus <dzickus@redhat.com>, Jiang Liu <jiang.liu@huawei.com>,
        Asit Mallick <asit.k.mallick@intel.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        iommu@lists.linux-foundation.org, Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH v2] irq: add quirk for broken interrupt remapping on 55XX
 chipsets
Message-ID: <20130404175117.GC3403@neilslaptop.think-freely.org>
References: <1362158276-4901-1-git-send-email-nhorman@tuxdriver.com>
 <1362423859-18516-1-git-send-email-nhorman@tuxdriver.com>
 <CAErSpo4=L9q+q5hqP2Avw6uceQwZiPuOzadhsqGpu6aP53PMbQ@mail.gmail.com>
 <1365085649.28127.66.camel@i7.infradead.org>
 <20130404145012.GA3403@neilslaptop.think-freely.org>
 <CAErSpo6x5rokg8np7xEKO6y6Qke5X7=r7J7VB2LVrAGGzDC1sA@mail.gmail.com>
 <20130404153905.GB3403@neilslaptop.think-freely.org>
 <CAErSpo7Mup+k7UmZsH1ZidCM1dJw-rNfdtCC6dSF+cZe1d+aBg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo7Mup+k7UmZsH1ZidCM1dJw-rNfdtCC6dSF+cZe1d+aBg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 04, 2013 at 11:14:30AM -0600, Bjorn Helgaas wrote:
> On Thu, Apr 4, 2013 at 9:39 AM, Neil Horman <nhorman@tuxdriver.com> wrote:
> > On Thu, Apr 04, 2013 at 08:57:06AM -0600, Bjorn Helgaas wrote:
> >> On Thu, Apr 4, 2013 at 8:50 AM, Neil Horman <nhorman@tuxdriver.com> wrote:
> >> > On Thu, Apr 04, 2013 at 03:27:29PM +0100, David Woodhouse wrote:
> >> >> On Wed, 2013-04-03 at 17:53 -0600, Bjorn Helgaas wrote:
> >> >> > );
> >> >> > > +
> >> >> > > +       if ((revision == 0x13) && irq_remapping_enabled) {
> >> >> > > +                pr_warn(HW_ERR "This system BIOS has enabled interrupt remapping\n"
> >> >> > > +                        "on a chipset that contains an errata making that\n"
> >> >> > > +                        "feature unstable.  Please reboot with nointremap\n"
> >> >> > > +                        "added to the kernel command line and contact\n"
> >> >> > > +                        "your BIOS vendor for an update");
> >> >>
> >> >> This should be WARN_TAINT(TAINT_FIRMWARE_WORKAROUND). And 'an erratum'.
> >> >>
> >> > Ok, copy that. I'll repost shortly
> >>
> >> When you do, please include URLs for any problem reports or bugzillas you have.
> >>
> > Well, those are going to be vendor specific, so I'm not sure we can really do
> > that, at least not in any meaningful way.
> 
> Sorry, I don't understand your point.  It's useful to know who
> reported it (e.g., for future testers) and what happened and what
> bugzillas it solved.  Of course it applies only to machines with this
> chipset and certain BIOS revisions.
> 
Oh, you want the bug report that I'm fixing this against?  Sure, I can do that.
I thought you wanted me to include a url in the WARN_TAINT, with which user
could report occurances of this bug.  Yeah, the bug that this is reported in is:
https://bugzilla.redhat.com/show_bug.cgi?id=887006

Its standing in for about a dozen or so variants of this issue we've seen

> >> I assume Windows "just works" in this situation?
> > No more or less than linux does in this case.  The Intel provided errata
> > indicates that the only acceptable workaround is to disable remapping in the
> > BIOS, so I would presume that if a windows system has a BIOS that doesn't
> > implement this fix, its just as exposed as we are.
> 
> It sounds like the effect of this bug is that on Linux, devices may
> not work at all because of lost interrupts.  Either Windows must never
> enable remapping (so it never sees the bug), or it must be designed in
> a way that tolerates the problem.  I can't believe these machines
> shipped with Windows certification if devices didn't work correctly.
> 
I don't know what to tell you here.  We explicitly asked intel about this, and
there was an effort to recode the interrupt migration code to properly manage
this situation, and intels response was "No, just disable it in BIOS", so we're
telling people to disable it in BIOS.  You'd have to ask somebody at Microsoft
what Windows did or did not do about this problem.

> Either way, I don't understand why we can't make the quirk just fix
> this.  Booting with "nointremap" only sets disable_irq_remap, which is
> only used by irq_remapping_supported().  Early quirks are run before
> irq_remapping_supported () is ever called, so an early quirk ought to
> be just as effective as the command line option.  Here's the relevant
> call tree I see:
> 
>   start_kernel
>     setup_arch
>       parse_early_param
>       early_quirks
>     rest_init
>       ...
>         <first use of disable_irq_remap>
> 
> The x86 setup_arch() does call generic_apic_probe(), but as far as I
> can tell, none of the APIC .probe() methods reference
> disable_irq_remap, so that doesn't look like a problem.
> 
Well, I can give it a try, but I'm sure something went wrong last time I did.
Regardless, theres also the security issue to consider here - namely that
disabling irq remapping opens up users of virt to a possible security bug
(potential irq injection).  Some users may wish to live with the remapping
error, given that error typically leads to devices that need to be
restarted/reset to start working again, rather than live with the security hole.
I rather like the warning, that gives users a choice, but I'll spin up a version
that just disables it if you would rather.

Neil

