Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479Ab3C2Oro (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 10:47:44 -0400
Received: from smtp.citrix.com ([66.165.176.89]:21574 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753040Ab3C2Orm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 10:47:42 -0400
X-IronPort-AV: E=Sophos;i="4.87,373,1363132800"; 
   d="scan'208";a="16382960"
Date: Fri, 29 Mar 2013 14:47:36 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Rob Herring <robherring2@gmail.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "arnd@arndb.de" <arnd@arndb.de>, Marc Zyngier <Marc.Zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3] [RFC] arm: use PSCI if available
In-Reply-To: <51559D01.9070607@gmail.com>
Message-ID: <alpine.DEB.2.02.1303291430220.4430@kaball.uk.xensource.com>
References: <1364388639-11210-1-git-send-email-stefano.stabellini@eu.citrix.com> <20130327133811.GE18429@mudshark.cambridge.arm.com> <alpine.DEB.2.02.1303271610430.4430@kaball.uk.xensource.com> <20130327172306.GB20990@mudshark.cambridge.arm.com>
 <alpine.DEB.2.02.1303281225050.4430@kaball.uk.xensource.com> <alpine.LFD.2.03.1303281048060.1372@syhkavp.arg> <51545BE4.9050206@gmail.com> <alpine.LFD.2.03.1303281135320.1372@syhkavp.arg> <51548E1C.4070508@gmail.com> <alpine.DEB.2.02.1303291257060.4430@kaball.uk.xensource.com>
 <51559D01.9070607@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Mar 2013, Rob Herring wrote:
> On 03/29/2013 08:22 AM, Stefano Stabellini wrote:
> > On Thu, 28 Mar 2013, Rob Herring wrote:
> >> On 03/28/2013 10:39 AM, Nicolas Pitre wrote:
> >>> On Thu, 28 Mar 2013, Rob Herring wrote:
> >>>
> >>>> On 03/28/2013 09:51 AM, Nicolas Pitre wrote:
> >>>>> On Thu, 28 Mar 2013, Stefano Stabellini wrote:
> >>>>>
> >>>>>> - the interface to bring up secondary cpus is different and based on
> >>>>>> PSCI, in fact Xen is going to add a PSCI node to the device tree so that
> >>>>>> Dom0 can use it.
> >>>>>>
> >>>>>> Oh wait, Dom0 is not going to use the PSCI interface even if the node is
> >>>>>> present on device tree because it's going to prefer the platform smp_ops
> >>>>>> instead.
> >>>>>
> >>>>> Waitaminute...  I must have missed this part.
> >>>>>
> >>>>> Who said platform specific methods must be used in preference to PSCI?
> >>>>
> >>>> I did. Specifically, I said the platform should be allowed to provide
> >>>> its own smp_ops. A platform may need to do addtional things on top of
> >>>> PSCI for example.
> >>>
> >>> Then the platform should have its special hook that would override the 
> >>> default PSCI methods.  But, by *default* the PSCI methods should be used 
> >>> if the related DT information is present.
> >>
> >> Agreed. The special hook to override is setting mach desc smp_ops, right?
> > 
> > If you consider the mach smp_ops a platform specific override, then
> > again PSCI and providing a PSCI node on DT doesn't solve the Xen problem
> > at all.
> > 
> > See above: Xen adds a PSCI node to DT, and Linux still does not use it.
> 
> Okay, I see. I wasn't distinguishing Dom0 vs DomU cases. Is this really
> the only issue with having a platform run in Dom0? We expect all
> platforms to work without any modifications? I would think for more
> complex platforms there would be some other work needed.

No, I think that's all we need. At least I fail to see the need for
something else at the moment :-)


> How is Xen going to really do physical cpu power management if a
> platform does not provide PSCI firmware? Are you going to pull all the
> platform specific code we have in the kernel now into Xen? If you make
> PSCI firmware a requirement for Xen, then you would only be modifying
> existing PSCI data to the DTB and the platform would be converted to use
> PSCI already.

That is a good question. Realistically there are only few platforms that
support ARMv7 virtualization extensions today, so we could have those
platform specific functions in Xen. I am hopeful that in the future the
new platforms that will support ARMv7 virtualization extensions and the
coming ARMv8 platforms will also support PSCI.
Otherwise yes, Xen will have to know about platform specific power
management.


> >>>>> If DT does provide PSCI description, then PSCI should be used.  Doing 
> >>>>> otherwise is senseless.  If PSCI is not to be used, then it should not 
> >>>>> be present in DT.
> >>>>
> >>>> You can't assume the DT and kernel are in-sync. For example, I've added
> >>>> PSCI in the firmware and DTB (part of the firmware), but the highbank
> >>>> kernel may or may not use it depending if I convert it.
> >>>
> >>> If the kernel does not understand PSCI bindings in the DT, it naturally 
> >>> won't use PSCI, right?  Conversely, if the firmware and therefore 
> >>> provided DT don't have PSCI, then the PSCI enabled kernel won't use PSCI 
> >>> either. So what is the problem?
> >>
> >> I'm distinguishing the kernel in general is enabled for PSCI and a
> >> platform is enabled. The kernel may have PSCI smp_ops and the DTB may
> >> have PSCI data, but that alone should not make a platform use the
> >> default PSCI smp_ops. The platform has to make the decision and it
> >> cannot be just based on the platform's dtb having PSCI data.
> > 
> > I can see how this would give greater flexibility to firmware
> > developers, but on the other hand it would limit the flexibility of the
> > kernel.
> 
> It limits the flexibility of the kernel too. If PSCI is present in the
> DTB, then the kernel must use it and the platform has no say? That's not
> flexible.

I am OK with having an override, but the override can't be hardcoded in
the kernel sources. We could have a kernel command line parameter to
disable PSCI for example. Something like no_psci.


> > In fact, unfortunately, it is diametrically the opposite of what Xen
> > needs.
> > 
> > I would kindly ask the maintainers to let me know what direction I
> > should take to move forward.
> 
> My argument is somewhat academic. I fully expect to convert highbank
> over to PSCI for 3.10 assuming this patch gets sorted out in time. So it
> is not really an issue for me. Adding Nico's smp_init function could
> give the platform flexibility later if needed.
> 
> We're only talking about the behavior of a small portion of the patch,
> so I would go ahead with implementing the rest of the feedback.

OK, I'll do that.
But I have to highlight that without those two lines in setup_arch we'll
have broken SMP in Dom0.
