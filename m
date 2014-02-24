Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121AbaBXPJh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 10:09:37 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:35405 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752708AbaBXPJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 10:09:35 -0500
Date: Mon, 24 Feb 2014 15:09:31 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Sebastian Reichel <sre@debian.org>
Cc: Sebastian Reichel <sre@ring0.de>, Linus Walleij <linus.walleij@linaro.org>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Carlos Chinea <cch.devel@gmail.com>, Tony Lindgren <tony@atomide.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>,
        Joni Lapilainen <joni.lapilainen@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: Re: [PATCHv1 1/6] HSI: add Device Tree support for HSI clients
Message-ID: <20140224150930.GI28555@e106331-lin.cambridge.arm.com>
References: <1393199401-27197-1-git-send-email-sre@debian.org>
 <1393199401-27197-2-git-send-email-sre@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393199401-27197-2-git-send-email-sre@debian.org>
Thread-Topic: [PATCHv1 1/6] HSI: add Device Tree support for HSI clients
Accept-Language: en-GB, en-US
Content-Language: en-US
acceptlanguage: en-GB, en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 23, 2014 at 11:49:56PM +0000, Sebastian Reichel wrote:
> Add new method hsi_add_clients_from_dt, which can be used
> to initialize HSI clients from a device tree node.
> 
> The patch also documents the DT binding for trivial HSI
> clients.
> 
> Signed-off-by: Sebastian Reichel <sre@debian.org>
> ---
>  .../devicetree/bindings/hsi/trivial-devices.txt    | 36 +++++++++++
>  drivers/hsi/hsi.c                                  | 70 +++++++++++++++++++++-
>  include/dt-bindings/hsi/hsi.h                      | 17 ++++++
>  include/linux/hsi/hsi.h                            |  2 +
>  4 files changed, 124 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/devicetree/bindings/hsi/trivial-devices.txt
>  create mode 100644 include/dt-bindings/hsi/hsi.h

It would be nice if we had a general HSI binding document that explains
what HSI is and how HSI bus devices and clients are expected too look.

Does HSI have an addressing scheme, or does each port have a single
device?

> 
> diff --git a/Documentation/devicetree/bindings/hsi/trivial-devices.txt b/Documentation/devicetree/bindings/hsi/trivial-devices.txt
> new file mode 100644
> index 0000000..1ace14a
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/hsi/trivial-devices.txt
> @@ -0,0 +1,36 @@
> +This is a list of trivial hsi client devices that have simple
> +device tree bindings, consisting only of a compatible field
> +and the optional hsi configuration.
> +
> +If a device needs more specific bindings, such as properties to
> +describe some aspect of it, there needs to be a specific binding
> +document for it just like any other devices.

Might this make more sense as a hsi-clients binding doc? I assume these
properties could be applied to non-trivial devices?

> +
> +Optional HSI configuration properties:
> +
> +- hsi,mode		Bit transmission mode (STREAM or FRAME)
> +			The first value is used for RX and the second one for
> +			TX configuration. If only one value is provided it will
> +			be used for RX and TX.
> +			The assignments may be found in header file
> +			<dt-bindings/hsi/hsi.h>.

Why not have hsi,rx-mode and hsi,tx-mode? I'll certainly get confused as
to which cell is tx and which is rx with the current binding.

Having separate tx-* and rx-* versions of the remaining properties would
be good too.

I note that the defines are called HSI_MODE_STREAM and HSI_MODE_FRAME,
not STREAM and FRAME as the binding document implies. Please refer to
exact names.

It may make more sense to use a string here and for the other
properties. They're easier for humans to read, and they survive
decompilation (so you get _much_ better error messages).

> +- hsi,channels		Number of channels to use [1..16]
> +			The first value is used for RX and the second one for
> +			TX configuration. If only one value is provided it will
> +			be used for RX and TX.
> +- hsi,speed		Max bit transmission speed (Kbit/s)
> +			The first value is used for RX and the second one for
> +			TX configuration. If only one value is provided it will
> +			be used for RX and TX.
> +- hsi,flow		RX flow type (SYNCHRONIZED or PIPELINE)
> +			The assignments may be found in header file
> +			<dt-bindings/hsi/hsi.h>.
> +- hsi,arb_mode		Arbitration mode for TX frame (Round robin, priority)
> +			The assignments may be found in header file
> +			<dt-bindings/hsi/hsi.h>.

s/_/-/ in property names please.

> +
> +This is the list of trivial client devices:
> +
> +Compatible		Description
> +==========		=============
> +hsi-char		HSI character device

What exactly is a HSI character device?

This seems more like a Linux abstraction than a real class of device.

Cheers,
Mark.
