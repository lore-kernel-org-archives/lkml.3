Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159AbaJWNXZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 09:23:25 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34787 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbaJWNXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 09:23:20 -0400
Date: Thu, 23 Oct 2014 15:23:05 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [RFC] pinctrl: Provide a generic device tree binding for per-pin pin
 controllers
Message-ID: <20141023132305.GG14443@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most iomux controllers allow a configuration per pin. These currently
have no common device tree binding. There are many different SoC
specific bindings for this class of iomux controllers. Some controllers
artificially group pins together where in hardware no groups exist (for
example lantiq). Other controllers just put each pin into a separate
group which explodes to many many strings to parse (Tegra30).


A pin controller has n pins, each muxable to m different positions.
There exists a logical numbering for all pins, for most SoCs this will
be defined by the register ordering so that the pin number can directly
be translated to a register offset without the need of tables in the
driver. The register usually takes m different numbers to specify the
function the pin should have. Both the pin and its function can be
described as a single 32bit number:

#define PINMUX_PIN(no, fn) (((no) & 0xffffff) << 8) | (fn) & 0xff)

This allows to put multiple pins into a single device tree property
which is very efficiently parsable by the driver (or the pinmux core).
We suggest to name this property 'pins' and to put it next to the
generic pinconf binding.  This allows to describe multiple pins with the
same pinconf settings in a single device tree node. Multiple of these
nodes can be grouped under a pinctrl state node. This allows to put pins
with different pinconf settings to a single state.

Example:

	uart2 {
		uart2_default_mode: uart2_default {
			pins1 {
				pins = <PINMUX_PIN(127, 3), PINMUX_PIN(128, 3)>;
				drive-push-pull;
			};
			pins2 {
				pins = <PINMUX_PIN(129, 2), PINMUX_PIN(130, 2)>;
				drive-strength = <20>;
			};
		};
	};

This binding is efficient to write and to parse and covers all (per-)pin
controllers we are aware of. Further convenience can be added using
defines which specify the pin and function names. A SoC might want to
use defines for pin numbers, or even for a combination of pin number and
function:

#define PIN_W23				127
#define PIN_W23__UART2_RXD		PINMUX_PIN(PIN_W23, 3)

Defines like this make it a straight forward task to write down all
possible combinations of pins and functions, thus creating a full
documentation without writing documentation. Looking at current binding
documentation this is indeed a problem since often the different mux
groups and the different function names are described, but not which
combinations are valid in hardware. Sometimes the documentation does not
even describe which pins and functions exist (Allwinner, Renesas), so
strings like "mmc0_data8_0" have to be made up from the driver source.

So from our view we see the following advantages of such a binding:

- Easy to transfer schematics or the output of a vendor iomux tool or
  excel sheet to a valid device tree. These are often the base for porting
  to a new board.
- The simple case when all pins of a state have the same pinconf setting
  requires only a single device tree node.
- No string matching required. String matching is expensive in terms of
  CPU cycles, device tree binary size and kernel binary size.
- Less creativity needed for writing drivers. Many drivers and bindings
  look very different, although all implement the same muxing pattern.
- makes a common device tree parser possible.
- No artificial limitations in the binding, do not force groups when there
  are none in hardware. Grouping pins in the driver means that the original
  author must get it right, splitting up groups later and using pins
  individually is difficult.


Sascha Hauer, Lucas Stach

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
