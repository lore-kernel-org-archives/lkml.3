Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331Ab3AVLIO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 06:08:14 -0500
Received: from li42-95.members.linode.com ([209.123.162.95]:54435 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752314Ab3AVLIN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 06:08:13 -0500
Subject: Re: [PATCH 6/6] OF: Introduce DT overlay support.
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <20130122035056.GF23500@truffula.fritz.box>
Date: Tue, 22 Jan 2013 13:08:04 +0200
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Jon Loeliger <jdl@jdl.com>, Tony Lindgren <tony@atomide.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Benoit Cousson <b-cousson@ti.com>, Mitch Bradley <wmb@firmworks.com>,
        Alan Tull <atull@altera.com>, linux-omap@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matt Porter <mporter@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, Koen Kooi <koen@dominion.thruhere.net>,
        Joel A Fernandes <agnel.joel@gmail.com>,
        Rob Clark <robdclark@gmail.com>,
        Jason Kridner <jkridner@beagleboard.org>,
        Matt Ranostay <mranostay@gmail.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <9768253B-92ED-4298-8BE4-6FAB091DF062@antoniou-consulting.com>
References: <1357327870-13615-1-git-send-email-panto@antoniou-consulting.com> <1357327870-13615-7-git-send-email-panto@antoniou-consulting.com> <20130122035056.GF23500@truffula.fritz.box>
To: David Gibson <david@gibson.dropbear.id.au>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Jan 22, 2013, at 5:50 AM, David Gibson wrote:

> On Fri, Jan 04, 2013 at 09:31:10PM +0200, Pantelis Antoniou wrote:
>> Introduce DT overlay support.
>> Using this functionality it is possible to dynamically overlay a part of
>> the kernel's tree with another tree that's been dynamically loaded.
>> It is also possible to remove node and properties.
>> 
>> Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
>> ---
>> Documentation/devicetree/overlay-notes.txt | 179 +++++++
>> drivers/of/Kconfig                         |  10 +
>> drivers/of/Makefile                        |   1 +
>> drivers/of/overlay.c                       | 831 +++++++++++++++++++++++++++++
>> include/linux/of.h                         | 107 ++++
>> 5 files changed, 1128 insertions(+)
>> create mode 100644 Documentation/devicetree/overlay-notes.txt
>> create mode 100644 drivers/of/overlay.c
>> 
>> diff --git a/Documentation/devicetree/overlay-notes.txt b/Documentation/devicetree/overlay-notes.txt
>> new file mode 100644
>> index 0000000..5289cbb
>> --- /dev/null
>> +++ b/Documentation/devicetree/overlay-notes.txt
>> @@ -0,0 +1,179 @@
>> +Device Tree Overlay Notes
>> +-------------------------
>> +
>> +This document describes the implementation of the in-kernel
>> +device tree overlay functionality residing in drivers/of/overlay.c and is a
>> +companion document to Documentation/devicetree/dt-object-internal.txt[1] &
>> +Documentation/devicetree/dynamic-resolution-notes.txt[2]
>> +
>> +How overlays work
>> +-----------------
>> +
>> +A Device Tree's overlay purpose is to modify the kernel's live tree, and
>> +have the modification affecting the state of the the kernel in a way that
>> +is reflecting the changes.
> 
> Um.. I'm having a great deal of trouble parsing that sentence.
> 
>> +Since the kernel mainly deals with devices, any new device node that result
>> +in an active device should have it created while if the device node is either
>> +disabled or removed all together, the affected device should be deregistered.
>> +
>> +Lets take an example where we have a foo board with the following base tree
>> +which is taken from [1].
>> +
>> +---- foo.dts -----------------------------------------------------------------
>> +	/* FOO platform */
>> +	/ {
>> +		compatible = "corp,foo";
>> +
>> +		/* shared resources */
>> +		res: res {
>> +		};
>> +
>> +		/* On chip peripherals */
>> +		ocp: ocp {
>> +			/* peripherals that are always instantiated */
>> +			peripheral1 { ... };
>> +		}
>> +	};
>> +---- foo.dts -----------------------------------------------------------------
>> +
>> +The overlay bar.dts, when loaded (and resolved as described in [2]) should
>> +
>> +---- bar.dts -----------------------------------------------------------------
>> +/plugin/;	/* allow undefined label references and record them */
>> +/ {
>> +	....	/* various properties for loader use; i.e. part id etc. */
>> +	fragment@0 {
>> +		target = <&ocp>;
>> +		__overlay__ {
>> +			/* bar peripheral */
>> +			bar {
>> +				compatible = "corp,bar";
>> +				... /* various properties and child nodes */
>> +			}
>> +		};
>> +	};
>> +};
>> +---- bar.dts -----------------------------------------------------------------
>> +
>> +result in foo+bar.dts
>> +
>> +---- foo+bar.dts -------------------------------------------------------------
>> +	/* FOO platform + bar peripheral */
>> +	/ {
>> +		compatible = "corp,foo";
>> +
>> +		/* shared resources */
>> +		res: res {
>> +		};
>> +
>> +		/* On chip peripherals */
>> +		ocp: ocp {
>> +			/* peripherals that are always instantiated */
>> +			peripheral1 { ... };
>> +
>> +			/* bar peripheral */
>> +			bar {
>> +				compatible = "corp,bar";
>> +				... /* various properties and child nodes */
>> +			}
>> +		}
>> +	};
>> +---- foo+bar.dts -------------------------------------------------------------
>> +
>> +As a result of the the overlay, a new device node (bar) has been created
>> +so a bar platform device will be registered and if a matching device driver
>> +is loaded the device will be created as expected.
> 
> Hrm.  This all seems rather complicated.  Maybe it needs to be, but
> I'm not entirely convinced yet.
> 
> One other point - both of these patches are assuming that the overlay
> is in the "live tree" format, but it still needs a bunch of extra
> mangling.  Would it simplify things to just go straight from the
> overlay in flat tree form to modifications to the system-wide live
> tree.

Sorry, I can't parse this. You mean apply the overlay without converting
to live tree format?

> 
> -- 
> David Gibson			| I'll have my music baroque, and my code
> david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
> 				| _way_ _around_!
> http://www.ozlabs.org/~dgibson

