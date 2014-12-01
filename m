Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065AbaLARlH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 12:41:07 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:52418 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753213AbaLARlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 12:41:04 -0500
Date: Mon, 1 Dec 2014 17:41:00 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Stefan Agner <stefan@agner.ch>
Cc: "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "arnd@arndb.de" <arnd@arndb.de>, "sre@kernel.org" <sre@kernel.org>,
        "fkan@apm.com" <fkan@apm.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "dbaryshkov@gmail.com" <dbaryshkov@gmail.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] power: reset: read priority from device tree
Message-ID: <20141201174100.GC22708@leverpostej>
References: <1417453389-1588-1-git-send-email-stefan@agner.ch>
 <1417453389-1588-2-git-send-email-stefan@agner.ch>
 <20141201171126.GB22708@leverpostej>
 <e5c5a44c84b95c4e48ed01c4dcffd35a@agner.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e5c5a44c84b95c4e48ed01c4dcffd35a@agner.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2014 at 05:24:37PM +0000, Stefan Agner wrote:
> On 2014-12-01 18:11, Mark Rutland wrote:
> > On Mon, Dec 01, 2014 at 05:03:07PM +0000, Stefan Agner wrote:
> >> This patch adds an optional property which allows to specify the
> >> reset source priority. This priority is used by the kernel restart
> >> handler call chain to sort out the proper reset/restart method.
> >> Depending on the power design of a board or other machine/board
> >> specific peculiarity, it is not possible to pick a generic priority.
> >>
> >> Signed-off-by: Stefan Agner <stefan@agner.ch>
> >> ---
> >>  Documentation/devicetree/bindings/power/reset/syscon-reboot.txt | 3 +++
> >>  drivers/power/reset/syscon-reboot.c                             | 5 ++++-
> >>  2 files changed, 7 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/Documentation/devicetree/bindings/power/reset/syscon-reboot.txt b/Documentation/devicetree/bindings/power/reset/syscon-reboot.txt
> >> index 1190631..ee41d9c 100644
> >> --- a/Documentation/devicetree/bindings/power/reset/syscon-reboot.txt
> >> +++ b/Documentation/devicetree/bindings/power/reset/syscon-reboot.txt
> >> @@ -11,6 +11,9 @@ Required properties:
> >>  - offset: offset in the register map for the reboot register (in bytes)
> >>  - mask: the reset value written to the reboot register (32 bit access)
> >>
> >> +Optional properties:
> >> +- priority: define the priority of the reset (0-255, defaults to 128)
> >> +
> > 
> > NAK. This is a leak of Linux-internal details.
> > 
> > What is this necessary for?
> > 
> > Mark.
> 
> Hi Mark,
> 
> In my case, it is necessary to be called ahead of the watchdog, which
> has a priority of 128. This syscon-reboot driver currently has a default
> priority of 128 too. I could live with a higher default priority for the
> syscon-reboot driver, in fact I proposed that in the discussion of v1 of
> that patch:
> https://lkml.org/lkml/2014/11/28/484

Thanks for the link.

> IMHO, this priority might make sense for most cases, I guess that
> dedicated "syscon" capabilities are usually better suited as a reboot
> source than watchdog.

I would think likewise.

> If dt, then the question which arises: If there are different
> capabilities to reset/reboot a whole system, how do we reflect which is
> the best suited one in dt?

I'm not sure, but I don't think that exposing a priority variable in
this way is the best, because it implicitly relies on what the kernel
may have selected for other devices and/or FW interfaces, which may not
have been described in DT.

So if we can get away with a fixed priority for now, then I would prefer
that.

Otherwise, I would imagine that most systems have a single preferred
mechanism with some possible fallback(s), for which a single
preferred-poweroff property might suffice, and has better interaction
w.r.t. priority (in that it should _always_ be tried first). Even that's
difficult to reconcile with FW bindings though, especially EFI (which we
sometimes must use in preference for variable storage and capsule
updates).

Thanks,
Mark.
