Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132AbaE0UcI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 16:32:08 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:42728 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbaE0UcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 16:32:06 -0400
Message-ID: <5384F60C.5020608@ahsoftware.de>
Date: Tue, 27 May 2014 22:31:08 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@linaro.org>,
        Tomasz Figa <tomasz.figa@gmail.com>, linux-kernel@vger.kernel.org
CC: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>, Jon Loeliger <jdl@jdl.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [RFC PATCH 1/9] dt: deps: dtc: Automatically add new property
 'dependencies' which contains a list of referenced phandles
References: <1399913280-6915-1-git-send-email-holler@ahsoftware.de>	<1399913280-6915-2-git-send-email-holler@ahsoftware.de>	<53775334.3030704@gmail.com> <5379FAA5.10404@ahsoftware.de> <20140527200225.F12C4C40B4B@trevor.secretlab.ca>
In-Reply-To: <20140527200225.F12C4C40B4B@trevor.secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 27.05.2014 22:02, schrieb Grant Likely:
> On Mon, 19 May 2014 14:35:49 +0200, Alexander Holler <holler@ahsoftware.de> wrote:

>> What's still questionable about the patches for dtc is if dependencies 
>> to devices and not just drivers should be included in the new property 
>> dependencies too. My current assumption is that all devices belonging to 
>> one and the same driver don't have dependencies between each other. In 
>> other words the order in which devices will be attached to one and the 
>> same driver isn't important. If that assumption is correct it would be 
>> possible to just attach all devices belonging to a driver after the 
>> driver was loaded (also I haven't that done in my patches).
> 
> There aren't really any guarantees here. It is perfectly valid to have
> two of the same device depending on the other, or even a device with a
> different driver between the two.
> 
> There's always going to be corner cases on the dependency chain. The
> question is whether or not it is worth trying to solve every concievable
> order, or if a partway solution is good enough.

Solving dependencies always happens automatically, with or without
dependencies inbetween devices. I just ignored dependencies between pure
devices (instead changed them into dependencies between drivers) because
I'm still not sure how to handle devices at all. Below is a diff ontop
my dtc-patches to include dependencies between devices too. As said, the
changes to do so are minimal. Of course, the graphs are a bit more
complex, because they then include devices too, but that isn't any
problem for the solving algorithm at all.


diff --git a/scripts/dtc/dependencies.c b/scripts/dtc/dependencies.c
index 06f447b..602ec01 100644
--- a/scripts/dtc/dependencies.c
+++ b/scripts/dtc/dependencies.c
@@ -66,8 +66,10 @@ static void add_deps(struct node *dt, struct node
*node, struct property *prop)
 			continue;
 		}

-		source = find_compatible_not_disabled(node);
-		target = find_compatible_not_disabled(refnode);
+		//source = find_compatible_not_disabled(node);
+		//target = find_compatible_not_disabled(refnode);
+		source = node;
+		target = refnode;
 		if (!source || !target || source == target ||
 				is_parent_of(source, target) ||
 				is_parent_of(target, source))
@@ -385,9 +387,9 @@ static int __init add_deps_lnx(struct device_node
*parent,

 	if (!__of_device_is_available(node))
 		return 0;
-	if (__of_get_property(node, "compatible", NULL)) {
+//	if (__of_get_property(node, "compatible", NULL)) {
 		if (!parent->phandle) {
-			if (__of_get_property(parent, "compatible", NULL))
+//			if (__of_get_property(parent, "compatible", NULL))
 				parent->phandle = 1 + order.max_phandle++;
 		}
 		if (!node->phandle)
@@ -425,7 +427,7 @@ static int __init add_deps_lnx(struct device_node
*parent,
 		if (unlikely(rc))
 			return rc;
 		parent = node; /* change the parent only if node is a driver */
-	}
+//	}
 	for_each_child_of_node(node, child) {
 		rc = add_deps_lnx(parent, child, print_dot);
 		if (unlikely(rc))
-- 
1.8.3.2



To make it easier to see devices in the produced order, here is another
patch on top:



@@ -464,6 +467,8 @@ void __init of_init_print_order(const char *name)
                if (order.order[i]->full_name)
                        pr_cont(" (%s)", order.order[i]->full_name);
                prop = get_property(order.order[i], "compatible");
+               if (!prop)
+                       pr_cont(" -");
                for (cp = of_prop_next_string(prop, NULL); cp;
                     cp = of_prop_next_string(prop, cp))
                        pr_cont(" %s", cp);



With that patch one can do e.g. dtc -t |  grep ' - ' to see which device
nodes are included which don't have a compatible property. For the
omap3-beagle this produces the following 21 additional entries in the
init-order:

aholler@laptopahbt ~/Source/aholler/dtc.git $ dts/make_dtb.sh
dts/omap3-beagle.dts -t | grep ' - '
init 4 0xe4 pinmux_twl4030_pins
(/ocp/pinmux@48002030/pinmux_twl4030_pins) - (parent 0x14b)
init 10 0x107 clocks (/ocp/cm@48004000/clocks) - (parent 0x106)
init 17 0x101 clocks (/ocp/prm@48306000/clocks) - (parent 0x100)
init 226 0x143 clocks (/ocp/scrm@48002000/clocks) - (parent 0x142)
init 237 0xe1 pinmux_hsusb2_pins
(/ocp/pinmux@48002030/pinmux_hsusb2_pins) - (parent 0x14b)
init 239 0xe2 pinmux_gpio1_pins (/ocp/pinmux@48002a00/pinmux_gpio1_pins)
- (parent 0x14d)
init 251 0xec pinmux_hsusb2_2_pins
(/ocp/pinmux@480025d8/pinmux_hsusb2_2_pins) - (parent 0x18e)
init 255 0xf4 chosen (/chosen) - (parent 0xf3)
init 256 0xf5 aliases (/aliases) - (parent 0xf3)
init 257 0xf6 memory (/memory) - (parent 0xf3)
init 258 0xf7 cpus (/cpus) - (parent 0xf3)
init 269 0x105 clockdomains (/ocp/prm@48306000/clockdomains) - (parent
0x100)
init 311 0x131 clockdomains (/ocp/cm@48004000/clockdomains) - (parent 0x106)
init 333 0x149 clockdomains (/ocp/scrm@48002000/clockdomains) - (parent
0x142)
init 335 0x14c pinmux_uart3_pins
(/ocp/pinmux@48002030/pinmux_uart3_pins) - (parent 0x14b)
init 343 0x157 codec (/ocp/i2c@48070000/twl@48/audio/codec) - (parent 0xf1)
init 398 0x18f choosen (/choosen) - (parent 0xf3)
init 400 0x191 pmu_stat (/leds/pmu_stat) - (parent 0x190)
init 401 0x192 heartbeat (/leds/heartbeat) - (parent 0x190)
init 402 0x193 mmc (/leds/mmc) - (parent 0x190)
init 405 0x196 user (/gpio_keys/user) - (parent 0x195)


Regards,

Alexander Holler
