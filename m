Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810AbaG3RsK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 13:48:10 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:45265 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755670AbaG3RsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 13:48:07 -0400
Date: Wed, 30 Jul 2014 18:48:03 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Robert Richter <rric@kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Radha Mohan Chintakuntla <rchintakuntla@cavium.com>,
        Robert Richter <rrichter@cavium.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 2/5] arm64, thunder: Add initial dts for Cavium Thunder
 SoC
Message-ID: <20140730174803.GF20162@leverpostej>
References: <1406732794-20920-1-git-send-email-rric@kernel.org>
 <1406732794-20920-3-git-send-email-rric@kernel.org>
 <20140730154626.GD20162@leverpostej>
 <CAL_JsqLJ_W34XTF2aMOW9z+Gq4oxbrX1RztyJN8Mi0OFPeNxfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_JsqLJ_W34XTF2aMOW9z+Gq4oxbrX1RztyJN8Mi0OFPeNxfg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[...]

> >> +     gic0: interrupt-controller@801000000000 {
> >
> > To make this easier to read, please place a comma between 32-bit
> > portions of the unit address (e.g. here have 8010,00000000).
> 
> Mark, perhaps a dtc or checkpatch.pl check for this?

Sure. Dodgy first atttempt at checkpatch below.

---->8----
diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 182be0f..8aee3f5 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2136,6 +2136,14 @@ sub process {
                        }
                }
 
+# check for difficult-to-read unit-addresses
+               if (defined $root &&
+                       ($realfile =~ /\.dtsi?$/ && $line =~ /([a-z0-9._\-+]++@([0-9a-f]+))\s*{/gi) &&
+                       (length($2) > 8)) {
+                               WARN("LONG_DT_UNIT_ADDRESS",
+                                    "Consider splitting long unit address \"$2\" with a comma between cells\n" . $herecurr);
+               }
+
 # check we are in a valid source file if not then ignore this hunk
                next if ($realfile !~ /\.(h|c|s|S|pl|sh)$/);
----8<----

It would also be nice to check matching unit-address and reg, but doing
that correctly requires knowing #address-cells, which sounds a little
painful.

I'm not sure where I picked up the comma convention, as it doesn't seem
to be in ePAPR.  It does seem common though, and is my personal
preference:

[mark@leverpostej:~/src/linux]% git grep '@[a-z0-9]\+,[a-b0-9]\+' \                          
	-- arch/arm/boot/dts | wc -l
254
[mark@leverpostej:~/src/linux]% git grep '@[a-z0-9]\+,[a-b0-9]\+' \
	-- arch/powerpc/boot/dts | wc -l
370
[mark@leverpostej:~/src/linux]% git grep '@[a-z0-9]\+,[a-b0-9]\+' \
        -- arch/*/boot/dts | wc -l
631

[...]

> >> +             uaa0: serial@87e024000000 {
> >> +                     compatible = "arm,pl011", "arm,primecell";
> >> +                     reg = <0x87e0 0x24000000 0x0 0x1000>;
> >> +                     interrupts = <1 21 4>;
> >> +                     clocks = <&refclk50mhz>;
> >> +                     clock-names = "apb_pclk";
> >
> > Is this actually the apb_pclk, or is the the uartclk? I assume it's the
> > latter.
> 
> Shouldn't new bindings have both clocks here? A single clock was a
> mistake I think (mine in fact).

I don't think we fixed it up in the end. It made drivers look a bit messy and
it dropped off my priority queue.

Cheers,
Mark.
