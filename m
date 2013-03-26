Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760087Ab3CZSdp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 14:33:45 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:46038 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754251Ab3CZSdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 14:33:42 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 2/5] capemgr: Add beaglebone's cape driver bindings
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Jon Loeliger <jdl@jdl.com>, Tony Lindgren <tony@atomide.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Benoit Cousson <b-cousson@ti.com>, Mitch Bradley <wmb@firmworks.com>,
        Alan Tull <atull@altera.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-omap@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Porter <mporter@ti.com>, Russ Dill <Russ.Dill@ti.com>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Joel A Fernandes <agnel.joel@gmail.com>,
        Rob Clark <robdclark@gmail.com>,
        Jason Kridner <jkridner@beagleboard.org>,
        Matt Ranostay <mranostay@gmail.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <1357584666-17374-3-git-send-email-panto@antoniou-consulting.com>
References: <1357584666-17374-1-git-send-email-panto@antoniou-consulting.com> <1357584666-17374-3-git-send-email-panto@antoniou-consulting.com>
Date: Tue, 26 Mar 2013 17:36:19 +0000
Message-Id: <20130326173619.E6F483E2585@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  7 Jan 2013 20:51:03 +0200, Pantelis Antoniou <panto@antoniou-consulting.com> wrote:
> Document the beaglebone's cape driver bindings.
> 
> Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>

Hi Pantelis,

I'll go back and review the driver in a minute, but I'll start here
since this is the data model that we'll be using for a long time.
Overall this looks pretty sane. It's pretty well contained too which I
like. Long term I do want to try and create some common patterns for
overlay connections, but it's really hard to do that when this is the
first serious attempt at implementing one.  :-) This is nicely contained
to only the beaglebone use case which makes it easy to try out without
forcing this exact data model on all users. If it works in other places,
then fantastic! we've got our generic model. If not, then we can refine
the interface for new boards without breaking beaglebone.

Comments below...

> ---
>  .../devicetree/bindings/misc/capes-beaglebone.txt  | 110 +++++++++++++++++++++
>  1 file changed, 110 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/misc/capes-beaglebone.txt
> 
> diff --git a/Documentation/devicetree/bindings/misc/capes-beaglebone.txt b/Documentation/devicetree/bindings/misc/capes-beaglebone.txt
> new file mode 100644
> index 0000000..f73cab5
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/misc/capes-beaglebone.txt
> @@ -0,0 +1,110 @@
> +* TI Beaglebone DT Overlay Cape Driver
> +
> +Required properties:
> +
> +- compatible: "ti,bone-capemgr"

"capemgr" sounds like a software construct. Can you rename this to
something that sounds more like describing concrete hardware? From that
perspective, "ti,bone-capebus" would be appropriate here, regardless of
where the driver actually lives in the kernel tree.

It would be better to be more specific here with the compatible
property also. Put the actual board name into the compatible string.
Following the lead of the board level compatible property, call it
'ti,am335x-bone-capebus". Newer boards can claim compatibilty with the
older where appropriate.

> +
> +- eeprom: Contains the phandle beaglebone's baseboard i2c eeprom.
> +
> +- baseboardmaps - node containing a list of supported
> +	beaglebone revisions; each node in should have the
> +	following properties:
> +	- board-name: The board name stored in the baseboard
> +		eeprom.

If it is stored in the baseboard eeprom, then why does it need to appear
in the .dtb?

> +	- compatible-name: The name which will be used for
> +		matching compatible capes.

What is the matching logic for this compatible capes? How does it get
used?

> +
> +- slots: node containing a list of slot nodes (which in the beaglebone
> +	case correspond to I2C addresses for dynamically probed capes,
> +	or an override slot definition for hardcoded capes.
> +	- eeprom: Contains the phandle beaglebone's cape i2c eeprom.
> +
> +	It is possible to define override slots that will be activated
> +	when the baseboard matches, and/or if supplied on the kernel command
> +	line and/or when dynamically requested on runtime.
> +	In that case the slot is marked with
> +	- ti,cape-override: Marks a slot override.
> +	- compatible: any of the "runtime", "kernel", or any compatible-name
> +	  on a matching baseboardmap node.
> +	- Any of the eeprom-format-revision, board-name, version, manufacturer,
> +	  part-number, number-of-pins, serial-number, pin-usage, vdd-3v3exp,
> +	  vdd-5v, sys-5v, dc-supplied properties which fill in the simulated
> +	  cape's EEPROM fields. The part-number field is required, the rest
> +	  are optional taking into default values.

I could use some help understanding the use-case for the override slots.
It isn't clear to me how the override is intended to work. Can you
describe exactly what happens when an override slot is defined? Do
override slots replace detected slots, or are they separate?

> +
> +- capemaps: node contains list of cape mappings, which allow converting
> +	from a part-number & version tuple to the filename of the dtbo file.
> +	- part-number: part number contained in the EEPROM
> +	- version node containing a
> +		- version: specific version to map to
> +		- dtbo: name of the dtbo file 

I think you'd be better off here defining a direct 1:1 mapping from
board name + revision to dtb filename. Maintaining a list of mappings in
the dtb file means it needs to be updated when new capes are created. It
would be nicer to drop the new overlay in the root filesystem (or initrd
if that is more convenient) and have the kernel know when to pick it up.

> +
> +Example:
> +bone_capemgr {
> +	compatible = "ti,bone-capemgr";
> +	status = "okay";
> +
> +	eeprom = <&baseboard_eeprom>;
> +
> +	baseboardmaps {
> +		baseboard_beaglebone: board@0 {
> +			board-name = "A335BONE";
> +			compatible-name = "ti,beaglebone";
> +		};
> +	};
> +
> +	slots {
> +		slot@0 {
> +			eeprom = <&cape_eeprom0>;
> +		};
> +
> +		slot@1 {
> +			eeprom = <&cape_eeprom1>;
> +		};
> +
> +		slot@2 {
> +			eeprom = <&cape_eeprom2>;
> +		};
> +
> +		slot@3 {
> +			eeprom = <&cape_eeprom3>;
> +		};
> +	};
> +
> +	/* mapping between board names and dtb objects */
> +	capemaps {
> +		/* Weather cape */
> +		cape@0 {
> +			part-number = "BB-BONE-WTHR-01";
> +			version@00A0 {
> +				version = "00A0";
> +				dtbo = "cape-bone-weather-00A0.dtbo";
> +			};
> +		};
> +	};
> +};
> +
> +Example of the override syntax when used on a bone compatible foo board.
> +
> +{
> +	...
> +
> +	baseboardmaps {
> +		...
> +		baseboard_beaglebone: board@0 {
> +			board-name = "A335FOO";
> +			compatible-name = "ti,foo";
> +		};
> +
> +		slot@6 {
> +			ti,cape-override;
> +			compatible = "ti,foo";
> +			board-name = "FOO-hardcoded";
> +			version = "00A0";
> +			manufacturer = "Texas Instruments";
> +			part-number = "BB-BONE-FOO-01";
> +		};
> +	};
> +
> +};
> +	
> -- 
> 1.7.12
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
