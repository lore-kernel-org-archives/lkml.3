Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938AbaKNJjM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 04:39:12 -0500
Received: from mail-ig0-f175.google.com ([209.85.213.175]:58289 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754751AbaKNJjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 04:39:08 -0500
MIME-Version: 1.0
In-Reply-To: <20141104185702.GR1618@lahna.fi.intel.com>
References: <20141031184509.GA2224@psi-dev26.jf.intel.com>
	<20141103092402.GA1304@lahna.fi.intel.com>
	<20141103150048.GB27425@saruman>
	<20141103152743.GB1618@lahna.fi.intel.com>
	<20141103154207.GC1618@lahna.fi.intel.com>
	<20141103155011.GH27425@saruman>
	<20141103184247.GD1618@lahna.fi.intel.com>
	<20141103221903.GA20305@psi-dev26.jf.intel.com>
	<20141104075936.GF1618@lahna.fi.intel.com>
	<20141104180526.GB2224@psi-dev26.jf.intel.com>
	<20141104185702.GR1618@lahna.fi.intel.com>
Date: Fri, 14 Nov 2014 10:39:07 +0100
Message-ID: <CACRpkdZg9-h+SVEe1mDHWm2kCfR3wc6uCvaLJsXpJm7xNL=r-w@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: baytrail: show output gpio state correctly on
 Intel Baytrail
From: Linus Walleij <linus.walleij@linaro.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Greg Kroah-Hartman <greg@kroah.com>
Cc: David Cohen <david.a.cohen@linux.intel.com>, Felipe Balbi <balbi@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 4, 2014 at 7:57 PM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:
> On Tue, Nov 04, 2014 at 10:05:26AM -0800, David Cohen wrote:

>> It looks we have an implicit dependency to GPIO driver in Bay Trail, and
>> having this window until load the module is not acceptable to fulfill
>> this implicit dependency.
>
> It is not implicit at all.
>
> The user of the GPIO in ACPI DSDT table says something like:
>
>         Name (_DEP, Package () { \_SB.GPO2 })
>
> or similar. That is *explicit* dependency. Here \_SB.GPO2 is one of the
> GPIO banks.

That's very nice for ACPI. But what do you expect the Linux kernel to
do with that?

Basically that is just like getting an -EPROBE_DEFER from the
gpiochip when the gpiod_get() call is issued, and you have to wait
because the gpiochip is not probed yet. We can solve that at runtime
right?

I had a discussion with Greg the other day that we have no way of
expressing inside the kernel that a resource such as a GPIO, a pin,
a clk or a regulator is used by some module. It's just a synchronous
gpiod_get() or whatever call, then there is a warning if you remove
a gpiochip with gpios still in use.

What is needed to make use of such a dependency mechanism is
a way to graph the dependencies between kernel drivers and
the resources (gpios, clocks, regulators...) they provide to other
drivers, so this information can be used when probing, removing,
powering up/down the cluster.

That problem needs to be solved in the device core, until then there
is not way to actually use that ACPI _DEP property for what I can
tell.

(On a side note: whoever came up with the idea that ACPI props
be 4 characters wide and start with an underscore and this
backslash obfuscation needs to... think differently.)

Yours,
Linus Walleij
