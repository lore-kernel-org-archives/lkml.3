Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048AbaFXLyy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 07:54:54 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:45537 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752392AbaFXLyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 07:54:51 -0400
Message-ID: <1403610880.26821.10.camel@hornet>
Subject: Re: [PATCH v7 1/2] video: ARM CLCD: Add DT support
From: Pawel Moll <pawel.moll@arm.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Mark Rutland <Mark.Rutland@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Tue, 24 Jun 2014 12:54:40 +0100
In-Reply-To: <CAL_JsqLQTT5N8D_GTDd5YVgr2SSCXtC6EcRQxW2=_-J8Wmsf0g@mail.gmail.com>
References: <1403018494-10264-1-git-send-email-pawel.moll@arm.com>
	 <20140620170901.GA12059@leverpostej> <1403532837.3804.29.camel@hornet>
	 <CAL_Jsq+6SveWhzWPrtziTJ-tDOFaJV4sXO+r_CEhAZf=tQE6FA@mail.gmail.com>
	 <1403539186.3804.46.camel@hornet>
	 <CAL_JsqLQTT5N8D_GTDd5YVgr2SSCXtC6EcRQxW2=_-J8Wmsf0g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-23 at 18:56 +0100, Rob Herring wrote:
> On Mon, Jun 23, 2014 at 10:59 AM, Pawel Moll <pawel.moll@arm.com> wrote:
> > On Mon, 2014-06-23 at 16:43 +0100, Rob Herring wrote:
> >> On Mon, Jun 23, 2014 at 9:13 AM, Pawel Moll <pawel.moll@arm.com> wrote:
> >> > On Fri, 2014-06-20 at 18:09 +0100, Mark Rutland wrote:
> 
> >> >> > +- max-memory-bandwidth: maximum bandwidth in bytes per second that the
> >> >> > +   cell's memory interface can handle
> >> >>
> >> >> When should I set this, given it is optional?
> >> >
> >> > When there is a (significant) limitation of the bandwidth available for
> >> > the cell's memory interface. One will either be told by the soc guys or
> >> > will figure it out in the hard way, as we did :-(
> >>
> >> What are you going to do with this information? b/w is a function of
> >> screen size and pixel depth. Are you going to refuse certain configs
> >> based on that? Seems like someone doing their own modes should know
> >> what they are doing and the limitations.
> >>
> >> Again, drop it until there is a defined need for this.
> >
> > Yes, there is. Use case: PL111 is wired up to a HDMI formatter, which
> > will take everything up to 1080p. This is what a DRM driver (what/if
> > it's ready) will get from the encoder driver (and rightly so). But the
> > chip interconnect limitations is make the chip being able to get 480p at
> > 60Hz tops.
> >
> > Or do you want me to add a subnode with timings for all achievable modes
> > instead?
> 
> I want this solved in a generic way and not something pl111 specific.
> If this is already defined then use it. If not, I would drop this for
> now and get a pl111 binding in place finally.

Hardware limitation on bandwidth available to a memory interface is
definitely not a PL111 specific phenomenon, and I don't know how can be
it described in a more generic way than a number of bytes per second.
Grepping through existing bindings, it turned out that it's not the
first time the problem is being solved. "ti,am33x-tilcdc" defines this:

 - max-bandwidth: The maximum pixels per second that the memory
   interface / lcd controller combination can sustain
 
Don't know that hardware, but in my case "pixels" doesn't cut. On
V2P-CA9 I have a choice of 640x480 32bpp or 1024x768 16bpp, 1024x768
32bpp won't work. The driver must know this somehow and you can't work
out the memory color model from display timings. So, to summarize - this
property is here to stay, or the binding is useless from my perspective.

I'll post v9 in a second, replacing the pl11x-specific framebuffer
property with the "memory-region" phandle (I don't see how "dma-regions"
would fit here), especially as the "reserved-memory" examples cites a
use case identical to mine. Fortunately all I had to do code-wise was
reverting a single function to a version from September 2013 and
changing a compatible string.

Pawel

