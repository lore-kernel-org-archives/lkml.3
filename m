Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758942Ab3GZRPj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 13:15:39 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:33658 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756961Ab3GZRPg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 13:15:36 -0400
Date: Fri, 26 Jul 2013 11:15:24 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Richard Cochran <richardcochran@gmail.com>
Cc: Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>, Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Domenico Andreoli <cavokz@gmail.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>, Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ian Campbell <ian.campbell@citrix.com>
Subject: Re: DT bindings as ABI [was: Do we have people interested in device
 tree janitoring / cleanup?]
Message-ID: <20130726171524.GB28895@obsidianresearch.com>
References: <CAOesGMhJ+je8FZqeFxhAcYwU0CHYer+aGP6DA_8x3azrzfA2sw@mail.gmail.com>
 <20130725175702.GC22291@e106331-lin.cambridge.arm.com>
 <51F168FC.9070906@wwwdotorg.org>
 <20130725182920.GA24955@e106331-lin.cambridge.arm.com>
 <20130725184834.GA8296@netboy>
 <20130725213753.GC17616@obsidianresearch.com>
 <20130726045433.GB4100@netboy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130726045433.GB4100@netboy>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.195
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 26, 2013 at 06:54:33AM +0200, Richard Cochran wrote:
> On Thu, Jul 25, 2013 at 03:37:53PM -0600, Jason Gunthorpe wrote:
> 
> > We use DT has a kernel configuration input. Our environment is
> > designed to guarantee 100% that the kernel and DT match exactly. DT
> > very deliberately isn't an ABI boundary in our systems.
> 
> It is nice that you use DT in that way, but that is not how DT is
> supposed to work. If you must keep your DT in sync with the kernel,
> then there is no advantage over the old platfrom device method. At
> least that had the virtue of being a C language interface (ABI), and
> some mistakes were be caught by the compiler.

Over the years we have done it both ways, the platform device/open
coded method was not very flexible and it was hard to get changes into
the kernel. Even something as simple as pre-declaring I2C devices was
(back then) impossible/PITA.

Further, every other kernel release tended to break the board.c files,
just due to the usual kernel churn.

DT is much better, the stuff that can be described in DT is broader
and more thought tends to have been put into DT bindings than was put
into the old C methods. It has less churn, and what churn there is
seems simpler to follow.

Further, I've observed our usages tend to converge on something stable
after a few releases. I think our PPC platform went from 2.6.2x to 3.7
with only very minor DT changes, for instance.

Of course all this could have been done in C, but it wasn't/hasn't been..

> > We've been doing this for years and have a proven in the field track
> > record of upgrades from pre-2.6.16 to 3.7 and beyond with multiple
> > SOCs. The same bootloader that was shipped to support non-DT 2.6.16
> > boots DT 3.7 just fine.
> 
> Try that with Freescale PowerPCs.  Good luck.

Why would Freescale PPC be any different from the IBM PPC we use? We'd
use exactly the same techniques we use on ARM and PPC today and the
churn to the DT wouldn't be an operational problem in the field.

Hint: We don't use uboot on any production systems.

> I too work on commercial embedded systems, and DT has proven to be
> one gigantic *PITA*.

Why do you think our experiences are so different? I have now four
boards on two architectures that have run at least 8 different kernel
versions over 5-6 years (DT and non-DT) and DT has never once been a
problem for my systems. It all just works, and frankly, it works
really well.

[...]

>> We use DT has a kernel configuration input. Our environment is
>> designed to guarantee 100% that the kernel and DT match exactly. DT
>> very deliberately isn't an ABI boundary in our systems.

> Think about what you just said.

*shrug* For embedded I am being *very pragmatic*. I don't need/want an
ABI boundary between the DT and the kernel. I don't need the DT to
statically describe the hardware.

What I need, fundamentally, is a way to describe my board to the
kernel. IMHO, DT is doing that job today better than the old board.c
method.

> The DT describes the *hardware* not the kernel. Why should you ever
> need to update your DT at all?

Well, you know why. The DT schema used by the kernel changes over
time. Kirkwood just went through a massive change in schema in the
past few releases, and the same was true on our PPC platforms when
that was new.

Even if the mainline kernel was perfect, we'd still need to change the
DT schema in our products. Using kirkwood as an example - we have
various parts of the new schemas, and some variations of the
now-mainlined schemas as local patches in our tree to get the
functionality we need. This was all done about 8 months ago - final
upstream versions might ultimately land in 3.12..

I can't delay shipping while upstream sorts this out - so I know
*absolutely* that the DT schema will change. This has been planned for
and designed into the boot system and won't be a problem.

Why would anyone do embedded any other way?

Jason
