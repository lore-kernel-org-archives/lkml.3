Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751382AbaEWRvO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 13:51:14 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:56039 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168AbaEWRvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 13:51:11 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Alan <gnomes@lxorguk.ukuu.org.uk>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nikhil P Rao <nikhil.rao@intel.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Jason Cooper <jason@lakedaemon.net>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] pci: Allow very large resource windows
References: <20140519130255.15364.49358.stgit@alan.etchedpixels.co.uk>
	<20140519202853.GA1371@google.com>
Date: Fri, 23 May 2014 10:51:08 -0700
In-Reply-To: <20140519202853.GA1371@google.com> (Bjorn Helgaas's message of
	"Mon, 19 May 2014 14:28:53 -0600")
Message-ID: <7h38g0e643.fsf@paris.lan>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bjorn,

Bjorn Helgaas <bhelgaas@google.com> writes:

> On Mon, May 19, 2014 at 02:03:14PM +0100, Alan wrote:
>> From: Alan <alan@linux.intel.com>
>> 
>> This is needed for some of the Xeon Phi type systems.
>> 
>> Signed-off-by: Alan Cox <alan@linux.intel.com>
>
> I applied this to my pci/resource branch for v3.16.  Nikhil
> posted essentially the same patch a couple years ago, so I added
> his signed-off-by and adopted his use of ARRAY_SIZE() to connect the
> "order > 13" test with the aligns[] declaration.

This patch (with the ARRAY_SIZE changes) has hit next-20140253 (in the
form of commit 272c5a886c57) and according to my bisect, is the cause of
a new boot failure on a 32-bit ARM platform (Marvell Armada 370,
Mirabox, boot log excerpt down below[2].)

While debugging, I found that Alan's original patch (without the
ARRAY_SIZE change) booted just fine so I started looking closely at the
ARRAY_SIZE() change.  After some high-tech printk debugging, I noticed
that order was negative when doing the compare, and found that this hack
got things booting again:

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 47482b27fa12..792db3477fd5 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -966,7 +966,7 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
 			/* For bridges size != alignment */
 			align = pci_resource_alignment(dev, r);
 			order = __ffs(align) - 20;
-			if (order >= ARRAY_SIZE(aligns)) {
+			if (order >= (int)ARRAY_SIZE(aligns)) {
 				dev_warn(&dev->dev, "disabling BAR %d: %pR "
 					 "(bad alignment %#llx)\n", i, r,
 					 (unsigned long long) align);

which led me to realize that the ARRAY_SIZE() change converted the >=
into an unsigned compare where before it was a signed one, and as an
unsigned compare, it was always true, resulting in those BARs being
disabled.

Below is a patch[1] which fixes the problem for me, and attempts a more
detailed description of the problem in the changelog.

Kevin

[1]
>From 386d39a22e586fc1b060ad18c79247a50f2c0f8c Mon Sep 17 00:00:00 2001
From: Kevin Hilman <khilman@linaro.org>
Date: Fri, 23 May 2014 10:24:40 -0700
Subject: [PATCH] PCI: pbus_mem_size(): don't disable small BAR windows

Since commit 272c5a886c57 (PCI: Support BAR sizes up to 8GB), small
BAR windows get disabled.

For small BAR sizes, order (as computed by __ffs(align) - 20) may be
negative.  If order is negative, when checking if it's >=
ARRAY_SIZE(aligns) will always be true (since the result of
ARRAY_SIZE() is unsigned) and so those BARs will be disabled.

It doesn't make sense for order to be negative, and the code already
converts it to non-negative later on, so to fix this bug, ensure that
order is non-negative before comapring with ARRAY_SIZE().

NOTE: Before commit 272c5a886c57, this worked just fine because order
      wasn't compared with ARRAY_SIZE() but with a hard-coded int, so
      the resulting signed compare worked fine.

Signed-off-by: Kevin Hilman <khilman@linaro.org>
---
 drivers/pci/setup-bus.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 47482b27fa12..a4152566f531 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -966,6 +966,8 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
 			/* For bridges size != alignment */
 			align = pci_resource_alignment(dev, r);
 			order = __ffs(align) - 20;
+			if (order < 0)
+				order = 0;
 			if (order >= ARRAY_SIZE(aligns)) {
 				dev_warn(&dev->dev, "disabling BAR %d: %pR "
 					 "(bad alignment %#llx)\n", i, r,
@@ -974,8 +976,6 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
 				continue;
 			}
 			size += r_size;
-			if (order < 0)
-				order = 0;
 			/* Exclude ranges with size > align from
 			   calculation of the alignment. */
 			if (r_size == align)
-- 
1.9.2



[2]
[...]
mvebu-pcie pcie-controller.3: PCI host bridge to bus 0000:00
pci_bus 0000:00: root bus resource [io  0x1000-0xfffff]
pci_bus 0000:00: root bus resource [mem 0xf8000000-0xffdfffff]
pci_bus 0000:00: root bus resource [bus 00-ff]
pci 0000:00:01.0: [11ab:6710] type 01 class 0x060400
pci 0000:00:02.0: [11ab:6710] type 01 class 0x060400
PCI: bus0: Fast back to back transfers disabled
pci 0000:00:01.0: bridge configuration invalid ([bus 00-00]), reconfiguring
pci 0000:00:02.0: bridge configuration invalid ([bus 00-00]), reconfiguring
PCI: bus1: Fast back to back transfers enabled
pci_bus 0000:01: busn_res: [bus 01-ff] end is updated to 01
pci 0000:02:00.0: [1b73:1009] type 00 class 0x0c0330
pci 0000:02:00.0: reg 0x10: [mem 0x42000000-0x4200ffff 64bit]
pci 0000:02:00.0: reg 0x18: [mem 0x42010000-0x42010fff 64bit]
pci 0000:02:00.0: reg 0x20: [mem 0x42011000-0x42011fff 64bit]
pci 0000:02:00.0: supports D1
pci 0000:02:00.0: PME# supported from D0 D1 D3hot
PCI: bus2: Fast back to back transfers disabled
pci_bus 0000:02: busn_res: [bus 02-ff] end is updated to 02
pci 0000:02:00.0: disabling BAR 0: [mem 0x42000000-0x4200ffff 64bit] (bad alignment 0x10000)
pci 0000:02:00.0: disabling BAR 2: [mem 0x42010000-0x42010fff 64bit] (bad alignment 0x1000)
pci 0000:02:00.0: disabling BAR 4: [mem 0x42011000-0x42011fff 64bit] (bad alignment 0x1000)
pci 0000:00:01.0: PCI bridge to [bus 01]
pci 0000:00:02.0: PCI bridge to [bus 02]
Unhandled fault: external abort on non-linefetch (0x1008) at 0xf0080010
Internal error: : 1008 [#1] SMP ARM
Modules linked in:
CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.15.0-rc6-next-20140523-08540-gefd7e9bf5d99 #45
task: ee81ab80 ti: ee83a000 task.ti: ee83a000
PC is at quirk_usb_early_handoff+0x348/0x7dc
LR is at ioremap_page_range+0xfc/0x1b4
pc : [<c0297f54>]    lr : [<c01886d8>]    psr: a0000153
sp : ee83bd48  ip : c0019a20  fp : c0620964
r10: 00000100  r9 : ee83bdd0  r8 : 00010000
r7 : f0080000  r6 : c0607e20  r5 : eeb7a800  r4 : eeb7a800
r3 : 00000146  r2 : 00000000  r1 : f0090000  r0 : f0080000
Flags: NzCv  IRQs on  FIQs off  Mode SVC_32  ISA ARM  Segment kernel
Control: 10c5387d  Table: 00004019  DAC: 00000015
Process swapper/0 (pid: 1, stack limit = 0xee83a248)
Stack: (0xee83bd48 to 0xee83c000)
bd40:                   c04428d4 ee83bd80 c062ae30 c053ab4c eeb7a800 c0607e20
bd60: c053ab4c 0000ffff ee83bdd0 00000100 c0620964 c01bc3a0 00000000 c01eda18
bd80: eeb7a800 eeb78814 eeb78800 00000001 00010000 c01ab390 eeb7a800 c01ab534
bda0: eeb7ac00 eeb78e14 eeb78e00 c01ab57c eeb77f80 eeb78e00 ee83be28 c0012d98
bdc0: f0074000 c0007fc8 feef0000 00000000 eeb77f80 eeb77f80 ee8e3410 c0303450
bde0: c01be984 c01be9cc ee83be24 00010100 00000002 00000021 00000000 c01bfb68
be00: eea1a0b8 000007cb 00000065 00000000 eeff2cb4 ee8e3410 ee83be24 10624dd3
be20: 00000000 eea18210 c05e69c8 00000001 ee83be24 c01be9cc c01be984 00000000
be40: 00000000 00000000 c0303450 c01bf794 c01be818 00000000 00000000 ee8e3410
be60: c05e6984 00000000 c05e6984 00000000 00000000 ee83a000 00000000 c01f05b0
be80: c01f0598 ee8e3410 c062c548 c01ef280 ee8e3410 c05e6984 ee8e3444 00000000
bea0: c059f558 c01ef434 00000000 c05e6984 c01ef3a8 c01eda80 ee80965c ee8d47b4
bec0: c05e6984 eeb1a000 c05edcc8 c01eea48 c0505490 c05c6de8 c05e6984 c05e6984
bee0: c05d5198 eeb70f40 c0607e00 c01efa74 00000000 c05d5198 c05d5198 c0008984
bf00: c0610304 ee82bc00 c042e950 00000010 c0607e00 c0563398 00000000 c00f5a90
bf20: 00000000 c05d84a4 60000153 00000001 ef7fce1b c04403d0 000000a2 c00366c0
bf40: c0562978 00000006 ef7fce26 00000006 c05d8474 c05c6de8 00000006 c05b5f30
bf60: c0607e00 000000a2 c05b5f3c c058b5a4 00000000 c058bd14 00000006 00000006
bf80: c058b5a4 00000000 00000000 c0422ffc 00000000 00000000 00000000 00000000
bfa0: 00000000 c0423004 00000000 c000e5b8 00000000 00000000 00000000 00000000
bfc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
bfe0: 00000000 00000000 00000000 00000000 00000013 00000000 00000000 00000000
[<c0297f54>] (quirk_usb_early_handoff) from [<c01bc3a0>] (pci_fixup_device+0xd4/0x184)
[<c01bc3a0>] (pci_fixup_device) from [<c01ab390>] (pci_bus_add_device+0x14/0x64)
[<c01ab390>] (pci_bus_add_device) from [<c01ab534>] (pci_bus_add_devices+0x3c/0x9c)
[<c01ab534>] (pci_bus_add_devices) from [<c01ab57c>] (pci_bus_add_devices+0x84/0x9c)
[<c01ab57c>] (pci_bus_add_devices) from [<c0012d98>] (pci_common_init_dev+0x184/0x2dc)
[<c0012d98>] (pci_common_init_dev) from [<c01bfb68>] (mvebu_pcie_probe+0x3ac/0x604)
[<c01bfb68>] (mvebu_pcie_probe) from [<c01f05b0>] (platform_drv_probe+0x18/0x48)
[<c01f05b0>] (platform_drv_probe) from [<c01ef280>] (driver_probe_device+0x100/0x228)
[<c01ef280>] (driver_probe_device) from [<c01ef434>] (__driver_attach+0x8c/0x90)
[<c01ef434>] (__driver_attach) from [<c01eda80>] (bus_for_each_dev+0x54/0x88)
[<c01eda80>] (bus_for_each_dev) from [<c01eea48>] (bus_add_driver+0xd4/0x1d0)
[<c01eea48>] (bus_add_driver) from [<c01efa74>] (driver_register+0x78/0xf4)
[<c01efa74>] (driver_register) from [<c0008984>] (do_one_initcall+0x80/0x1b8)
[<c0008984>] (do_one_initcall) from [<c058bd14>] (kernel_init_freeable+0xfc/0x1c8)
[<c058bd14>] (kernel_init_freeable) from [<c0423004>] (kernel_init+0x8/0xec)
[<c0423004>] (kernel_init) from [<c000e5b8>] (ret_from_fork+0x14/0x3c)
Code: e3a02000 ebf5fd27 e2507000 0affff59 (e5973010) 
---[ end trace 20c08b6c6486c9b6 ]---
Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
