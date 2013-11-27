Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751593Ab3K0AFn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 19:05:43 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:34077 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab3K0AF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:05:28 -0500
Message-ID: <1385510442.1791.195.camel@misato.fc.hp.com>
Subject: Re: [PATCH 0/4] ACPI / bind: Simplify child devices lookup
From: Toshi Kani <toshi.kani@hp.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Aaron Lu <aaron.lu@intel.com>
Date: Tue, 26 Nov 2013 17:00:42 -0700
In-Reply-To: <2610478.KxPMyuOMok@vostro.rjw.lan>
References: <2610478.KxPMyuOMok@vostro.rjw.lan>
Content-Type: multipart/mixed; boundary="=-VHl82ZA3ZmN645SC2jpl"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-VHl82ZA3ZmN645SC2jpl
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Mon, 2013-11-25 at 01:09 +0100, Rafael J. Wysocki wrote:
> Hi,
> 
> The following series of four patches (on top of current linux-pm.git/bleeding-edge)
> rework child device lookup in drivers/acpi/glue.c and related things:
> 
> [1/4] ACPI / bind: Simplify child device lookup
> [2/4] PCI/ ACPI: Use acpi_find_child_device() for child device lookup
> [3/4] ACPI / bind: Redefine acpi_get_child()
> [4/4] ACPI / bind: Redefine acpi_preset_companion()

This patchset caused the attached panic during boot on a system.
acpi_pci_find_device() called acpi_find_child_device() with
ACPI_COMPANION(dev->parent) being a NULL pointer when scanning bus 0xf.

This bus 0xf seems to be a chipset internal bus, which is not intended
for the OS to use.  Therefore, ACPI does not list its PCI bridge device.

# lspci -tv
   :
 +-[0000:0f]-+-08.0  Intel Corporation Ivytown QPI Link 0
 |           +-08.2  Intel Corporation Ivytown QPI Link 0
   :

However, pcibios_fixup_peer_bridges(), called from pci_subsys_init(),
finds this bus as it scans all the buses from 0 to pcibios_last_bus.
Hence, this dev->parent does not have an associated ACPI device object. 

Thanks,
-Toshi


--=-VHl82ZA3ZmN645SC2jpl
Content-Disposition: attachment; filename="panic.log"
Content-Type: text/x-log; name="panic.log"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

 :
PCI: Discovered peer bus 0f
PCI host bridge to bus 0000:0f
pci_bus 0000:0f: root bus resource [io  0x0000-0xffff]
pci_bus 0000:0f: root bus resource [mem 0x00000000-0x3fffffffffff]
pci_bus 0000:0f: No busn resource found for root bus, will use [bus 0f-ff]
BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
IP: [<ffffffff812da078>] acpi_find_child_device+0x23/0xc3
PGD 0 
Oops: 0000 [#1] SMP 
Modules linked in:
CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.13.0-rc1+ #504
Hardware name: HP CB920s x1, BIOS Bundle: 005.028.018 SFW: 012.124.000 10/28/2013
task: ffff88085fa5d110 ti: ffff88085fa5e000 task.ti: ffff88085fa5e000
RIP: 0010:[<ffffffff812da078>]  [<ffffffff812da078>] acpi_find_child_device+0x23/0xc3
RSP: 0000:ffff88085fa5fbc0  EFLAGS: 00010286
RAX: ffff8a07de1c1800 RBX: ffff88085fa5fc28 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000080000 RDI: 0000000000000000
RBP: ffff88085fa5fbf8 R08: ffff88085ebb2578 R09: 0000000000000000
R10: 0000000000003c0a R11: 0000000000000006 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000080000
FS:  0000000000000000(0000) GS:ffff88087fa00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000018 CR3: 0000000001a0b000 CR4: 00000000001407f0
Stack:
 ffff88085fa5fc10 ffffffff812da3cb ffff88085fa5fc28 ffff88085ebb0098
 ffffffff81a7c860 ffff88085ebb0098 00000000ffffffff ffff88085fa5fc10
 ffffffff812affde ffff88085ebb00a8 ffff88085fa5fc40 ffffffff812da620
Call Trace:
 [<ffffffff812da3cb>] ? acpi_bind_one+0x65/0x280
 [<ffffffff812affde>] acpi_pci_find_device+0x3e/0x60
 [<ffffffff812da620>] acpi_platform_notify+0x3a/0x6c
 [<ffffffff8135eb4d>] device_add+0x13d/0x640
 [<ffffffff81292286>] ? pci_find_capability+0x26/0x50
 [<ffffffff8128eea4>] pci_device_add+0x114/0x150
 [<ffffffff8153ce41>] pci_scan_single_device+0x91/0xc0
 [<ffffffff8128ef2e>] pci_scan_slot+0x4e/0x150
 [<ffffffff8128fd7d>] pci_scan_child_bus+0x3d/0x150
 [<ffffffff81290090>] pci_scan_root_bus+0xa0/0xb0
 [<ffffffff8146551c>] pci_scan_bus_on_node+0x7c/0xd0
 [<ffffffff81463ea7>] pcibios_scan_specific_bus+0x97/0xa0
 [<ffffffff81b32e62>] ? pci_legacy_init+0x37/0x37
 [<ffffffff81b32e98>] pci_subsys_init+0x36/0x48
 [<ffffffff81000312>] do_one_initcall+0xf2/0x1a0
 [<ffffffff81067fcd>] ? parse_args+0x21d/0x3f0
 [<ffffffff81aee047>] kernel_init_freeable+0x18f/0x21a
 [<ffffffff81aed833>] ? do_early_param+0x88/0x88
 [<ffffffff81539fe0>] ? rest_init+0x80/0x80
 [<ffffffff81539fee>] kernel_init+0xe/0x130
 [<ffffffff815563ec>] ret_from_fork+0x7c/0xb0
 [<ffffffff81539fe0>] ? rest_init+0x80/0x80
Code: ff ff 5a 5b 41 5c 5d c3 0f 1f 44 00 00 55 48 89 e5 41 57 49 89 f7 41 56 45 31 f6 41 55 44 0f b6 ea 41 54 45 31 e4 53 48 83 ec 10 <48> 8b 47 18 48 8d 58 d8 48 8d 47 18 48 89 45 c8 48 8d 43 28 48 
RIP  [<ffffffff812da078>] acpi_find_child_device+0x23/0xc3
 RSP <ffff88085fa5fbc0>
CR2: 0000000000000018
---[ end trace 752051e71cfc0265 ]---
Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000009


--=-VHl82ZA3ZmN645SC2jpl--

