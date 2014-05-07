Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997AbaEGBcv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 21:32:51 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:33815 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791AbaEGBct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 21:32:49 -0400
MIME-Version: 1.0
In-Reply-To: <536982E3.10303@gmail.com>
References: <536982E3.10303@gmail.com>
Date: Tue, 6 May 2014 20:32:48 -0500
Message-ID: <CAL_JsqL6+i_ED+s6kODsadszefaZUcA7VHCfZ4k4yj62iXsarQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] devicetree, qcomm PMIC: fix node name conflict
From: Rob Herring <robherring2@gmail.com>
To: Frank Rowand <frowand.list@gmail.com>
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Josh Cartwright <joshc@codeaurora.org>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 6, 2014 at 7:48 PM, Frank Rowand <frowand.list@gmail.com> wrote:
> An issue with the path of SPMI nodes under /sys/bus/... was reported in
> https://lkml.org/lkml/2014/4/23/312.  The symptom is that two different
> grandchild nodes of the spmi with the same node-name@unit-address will
> result in attempting to create duplicate links at
> /sys/bus/platform/devices/unit-address.node-name.  It turns out that the
> specific example provided might not be an expected configuration for
> current hardware, but the reported trap remains an issue.
>
> I have been poking at the problem, trying to figure out how to cleanly
> fix the issue without breaking devicetree device creation.
>
> The first patch in the series is the one that may be a very bad idea.  Or
> it may help show the way forward to deal with what I think is the major
> underlying problem.  I have not finished investigating the possible negative
> side effects.  And I am still thinking whether this is a conceptually good
> approach, or whether it is simply an expediant hack that hides the underlying
> problem.  But I am throwing this out prematurely because I have mentioned
> it to several people, and I want to make it visible to everyone involved.
>
> The underlying architectural problem (in my opinion) is that a lot of devices
> are created by the device tree infrastructure as platform devices, when they
> truly should not be platform devices.  They should not be platform devices
> because they are not physically on a platform bus, they are instead somewhere
> below some other bus.  The first patch in this series is a hack which
> results in the devices still being represented by "struct platform_device"
> objects, but with a link to their parent's "struct bus_type" instead of
> to &platform_bus_type.
>
> The second patch does not require the first patch.  The second patch provides
> a mechanism to allow subsystems to provide a method of naming devices to
> avoid name collisions.
>
> The third patch provides an example of a subsystem using the new feature
> provided by the second patch.
>

I think the primary question to ask is there any added benefit to
having the additional hierarchy of devices. I don't think there is
much support to have more hierarchy from what I have seen of past
discussions.

Another approach could be to support having multiple platform bus
instances. Then drivers can easily create a new instance for each set
of sub-devices.

This can be solved in a much less invasive way just in the DT naming
algorithm. This is slightly different from what I had suggested of
just dropping the unit address. It keeps the unit address, but adds
the unique index on untranslate-able addresses. The diff is bigger due
to refactoring to reduce the indentation levels. It is untested and
whitespace corrupted:

diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index 404d1da..c77dd7a 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -105,23 +105,33 @@ void of_device_make_bus_id(struct device *dev)
         * For MMIO, get the physical address
         */
        reg = of_get_property(node, "reg", NULL);
-       if (reg) {
-               if (of_can_translate_address(node)) {
-                       addr = of_translate_address(node, reg);
-               } else {
-                       addrp = of_get_address(node, 0, NULL, NULL);
-                       if (addrp)
-                               addr = of_read_number(addrp, 1);
-                       else
-                               addr = OF_BAD_ADDR;
-               }
-               if (addr != OF_BAD_ADDR) {
-                       dev_set_name(dev, "%llx.%s",
-                                    (unsigned long long)addr, node->name);
-                       return;
-               }
+       if (!reg)
+               goto no_bus_id;
+
+       if (of_can_translate_address(node)) {
+               addr = of_translate_address(node, reg);
+               if (addr == OF_BAD_ADDR)
+                       goto no_bus_id;
+
+               dev_set_name(dev, "%llx.%s",
+                            (unsigned long long)addr, node->name);
+               return;
        }

+       addrp = of_get_address(node, 0, NULL, NULL);
+       if (!addrp)
+               goto no_bus_id;
+
+       addr = of_read_number(addrp, 1);
+       if (addr == OF_BAD_ADDR)
+               goto no_bus_id;
+
+       magic = atomic_add_return(1, &bus_no_reg_magic);
+       dev_set_name(dev, "%llx.%s.%d", (unsigned long long)addr,
+                    node->name, magic - 1);
+       return;
+
+no_bus_id:
        /*
         * No BusID, use the node name and add a globally incremented
         * counter (and pray...)
