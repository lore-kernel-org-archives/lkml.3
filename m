Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751535AbaK0Nm1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 08:42:27 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:43593 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750781AbaK0Nm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 08:42:26 -0500
Date: Thu, 27 Nov 2014 13:41:37 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Leif Lindholm <leif.lindholm@linaro.org>
Cc: Andrew Lunn <andrew@lunn.ch>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ian Campbell <ijc@debian.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>
Subject: Re: [PATCH v2 2/2] of: support passing console options with
 stdout-path
Message-ID: <20141127134137.GI857@leverpostej>
References: <1417023640-23464-1-git-send-email-leif.lindholm@linaro.org>
 <1417023640-23464-3-git-send-email-leif.lindholm@linaro.org>
 <20141126183052.GH3443@lunn.ch>
 <CACxGe6tYZ8aE_TKw1cYMY5DDjpSXPSnhhAam-rG5NgdjpKJe+A@mail.gmail.com>
 <20141126214847.GJ3443@lunn.ch>
 <20141127121543.GG857@leverpostej>
 <20141127131635.GJ2361@bivouac.eciton.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141127131635.GJ2361@bivouac.eciton.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2014 at 01:16:36PM +0000, Leif Lindholm wrote:
> On Thu, Nov 27, 2014 at 12:15:43PM +0000, Mark Rutland wrote:
> > On Wed, Nov 26, 2014 at 09:48:47PM +0000, Andrew Lunn wrote:
> > > On Wed, Nov 26, 2014 at 09:07:33PM +0000, Grant Likely wrote:
> > > > On Wed, Nov 26, 2014 at 6:30 PM, Andrew Lunn <andrew@lunn.ch> wrote:
> > > > > On Wed, Nov 26, 2014 at 05:40:40PM +0000, Leif Lindholm wrote:
> > > > >> Support specifying console options (like with console=ttyXN,<options>)
> > > > >> by appending them to the stdout-path property after a separating ':'.
> > > > >>
> > > > >> Example:
> > > > >>         stdout-path = "uart0:115200";
> > > > >
> > > > > Hi Leif
> > > > >
> > > > > This should be documented somewhere under
> > > > > Documentation/devicetree/bindings/
> > > > >
> > > > > Not sure where thought. Maybe a top level chosen.txt?
> > > > 
> > > > Actually, this one doesn't. It is already documented in ePAPR
> > > 
> > > Hi Grant
> > > 
> > > Humm, do i have an old version of ePAPR?
> > > 
> > > All i see is that in Table 3-4 It says:
> > > 
> > > stdout-path O <string> A string that specifies the full path to the
> > > 	      	       node representing the device to be used for
> > > 	      	       boot console output. If the character ":" is
> > > 	      	       present in the value it terminates the
> > > 	      	       path. The value may be an alias.
> > > 
> > > 		       If the stdin-path property is not specified,
> > > 		       stdout-path should be assumed to define the input device.
> > > 
> > > So what is before the : is defined. What comes afterwards,
> > > baudrate/parity/bits/flow control does not appear to the defined in
> > > ePAPR. Should we not document the extension being added here?
> > 
> > I believe that we should, and it should be relatively trivial to add a
> > document stating that the format and meaning of the parts after the ':'
> > are device-specific. 
> 
> Device-specific is a bit broad though?

If we have a generic set of properties, then I'm happy to have that.
Otherwise I assumed that the portion after the ':' would be interpreted
w.r.t. the binding for the device being pointed to.

> > So how about Documentation/devicetree/bindings/serial/stdout-path.txt,
> > with something like the following:
> 
> There is, however, nothing serial-specific about this functionality -
> it console-specific.
> 
> Could it be bindings/console/stdout-path.txt?

I am in no way attached to the path. But to bikeshed a little, I would
expect (or at least I would hope) not to have an awful lot under
bindings/console, given that consoles are a SW construct. So we could
just drop this right under bindings/stdout-path.txt for now until we
find a better taxonomy.

>  
> > ---->8----
> > Device trees may specify the device to be used for boot console output
> > with a stdout-path property under /chosen, as described in ePAPR, e.g.
> > 
> > / {
> > 	chosen {
> > 		stdout-path = "/serial@f00:115200";
> > 	};
> > 
> > 	serial@f00 {
> > 		compatible = "vendor,some-uart";
> > 		reg = <0xf00 0x10>;
> > 	};
> > };
> > 
> > If the character ":" is present in the value, this terminates the path.
> > The meaning of any cahracters following the ":" is device-specific, and
> > must be specified in the relevant binding documentation.
> > ---->8----
> > 
> > The more difficult part is documenting those (and I'm still uneasy about
> > conflating the Linux driver command line options with the DT binding for
> > that reason).
> 
> For the current situation, which _is_ serial-specific, could we then
> add a serial/stdout-path.txt describing the mapping to
> uart_parse_options - making that interface an implicit requirement for
> the use of stdout-path?

That would depend on what you mean by "the mapping to
uart_parse_options". The binding should _not_ refer to Linux internals,
just the parts visible to an arbitrary DT author/parseer.

So we'd need to document which strings you can have after the ':' and
what they mean -- I don't want to see that defined by reference to
Linux-specific command line options because people will change that
without thinking.

Mark.
