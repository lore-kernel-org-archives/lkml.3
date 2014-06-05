Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855AbaFEPXS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 11:23:18 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:47392 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbaFEPXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 11:23:15 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.6+dev
To: Dan Williams <dan.j.williams@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: linux-next crash in xhci_add_ep_to_interval
From: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1401981749_1971P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 05 Jun 2014 11:22:29 -0400
Message-ID: <18529.1401981749@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1401981749_1971P
Content-Type: text/plain; charset=us-ascii

Dell Latitude E6530, BIOS A11, seeing a crash in xhci_add_ep_to_interval
when it's docked in a newer dock that has USB3.

It's very possible that the BIOS is buggy - it isn't like I haven't found
BIOS bugs in every single Dell laptop I've had. :)  But that shouldn't
make the kernel crash....

lsusb reports:

Bus 002 Device 004: ID 0a5c:5801 Broadcom Corp. BCM5880 Secure Applications Processor with fingerprint swipe sensor
Bus 002 Device 003: ID 413c:2513 Dell Computer Corp. internal USB Hub of E-Port Replicator
Bus 002 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 001 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 004 Device 002: ID 413c:5534 Dell Computer Corp.
Bus 004 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
Bus 003 Device 003: ID 0e8f:0020 GreenAsia Inc. USB to PS/2 Adapter
Bus 003 Device 002: ID 413c:2134 Dell Computer Corp.
Bus 003 Device 004: ID 045e:0023 Microsoft Corp. Trackball Optical
Bus 003 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub


Git bisect comes down to this:

commit d8521afe35862f4fbe3ccd6ca37897c0a304edf3
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Tue May 20 18:08:28 2014 -0700

    usb: assign default peer ports for root hubs

    Assume that the peer of a superspeed port is the port with the same id
    on the shared_hcd root hub.  This identification scheme is required of
    external hubs by the USB3 spec [1].  However, for root hubs, tier mismatch
    may be in effect [2].  Tier mismatch can only be enumerated via platform
    firmware.  For now, simply perform the nominal association.

Thanks to pstore, we have the explosion:

[    3.974159] usb 3-4.1: New USB device found, idVendor=0e8f, idProduct=0020
[    3.974173] usb 3-4.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    3.974247] usb 3-4.1: Product: PS2toUSB Adapter
[    3.974259] usb 3-4.1: Manufacturer: GASIA
[    3.975475] BUG: unable to handle kernel NULL pointer dereference at 0000000000000080
[    3.975643] IP: [<ffffffff8139abd4>] xhci_add_ep_to_interval_table+0xc8/0x172
[    3.975795] PGD 0
[    3.975849] Oops: 0002 [#1] PREEMPT SMP
[    3.975954] Modules linked in:
[    3.976029] CPU: 0 PID: 37 Comm: khubd Not tainted 3.15.0-rc5-00299-g7e73be2 #234
[    3.976169] Hardware name: Dell Inc. Latitude E6530/07Y85M, BIOS A11 03/12/2013
[    3.976304] task: ffff880128e809d0 ti: ffff880128e84000 task.ti: ffff880128e84000
[    3.976441] RIP: 0010:[<ffffffff8139abd4>]  [<ffffffff8139abd4>] xhci_add_ep_to_interval_table+0xc8/0x172
[    3.976631] RSP: 0018:ffff880128e85608  EFLAGS: 00010006
[    3.976732] RAX: 0000000000000003 RBX: 0000000000000000 RCX: ffff8800c5861800
[    3.976863] RDX: 0000000000000001 RSI: 0000000000000078 RDI: 0000000000000005
[    3.976997] RBP: ffff880128e85640 R08: ffff8801288f2228 R09: 0000000000000000
[    3.977125] R10: ffff880128e85968 R11: 0000000000000004 R12: ffff8801288f22fc
[    3.977255] R13: ffff8800c5861800 R14: ffff88003f878000 R15: 0000000000000007
[    3.977353] FS:  0000000000000000(0000) GS:ffff88012dc00000(0000) knlGS:0000000000000000
[    3.977440] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    3.977503] CR2: 0000000000000080 CR3: 00000000c5eb4000 CR4: 00000000001407f0
[    3.977578] Stack:
[    3.977606]  ffff8801288f2228 0000000000000000 ffff8801288f2000 ffff8801288f22fc
[    3.977708]  ffff88003f878000 ffff8800c5d8b000 0000000000000003 ffff880128e85990
[    3.977808]  ffffffff8139c76d ffff880128e85700 ffff880128e85680 0000000100000007
[    3.977910] Call Trace:
[    3.977948]  [<ffffffff8139c76d>] xhci_reserve_bandwidth+0x158/0x534
[    3.978022]  [<ffffffff8107d810>] ? mark_held_locks+0x5d/0x74
[    3.978086]  [<ffffffff8107d5da>] ? mark_lock+0x2a/0x203
[    3.978148]  [<ffffffff8107e313>] ? __lock_acquire+0x696/0xedf
[    3.978215]  [<ffffffff8112256b>] ? dma_pool_alloc+0x188/0x225
[    3.978281]  [<ffffffff8107d5da>] ? mark_lock+0x2a/0x203
[    3.980065]  [<ffffffff8107d5da>] ? mark_lock+0x2a/0x203
[    3.981976]  [<ffffffff8107d810>] ? mark_held_locks+0x5d/0x74
[    3.984302]  [<ffffffff8107d5da>] ? mark_lock+0x2a/0x203
[    3.986919]  [<ffffffff8107e313>] ? __lock_acquire+0x696/0xedf
[    3.989317]  [<ffffffff8139cb84>] ? xhci_configure_endpoint+0x3b/0x4b0
[    3.991817]  [<ffffffff8107d5da>] ? mark_lock+0x2a/0x203
[    3.994396]  [<ffffffff8107d810>] ? mark_held_locks+0x5d/0x74
[    3.996896]  [<ffffffff8107eebf>] ? lock_acquire+0xc1/0x14e
[    3.998795]  [<ffffffff8139cb84>] ? xhci_configure_endpoint+0x3b/0x4b0
[    4.000407]  [<ffffffff813a84b0>] ? xhci_dbg_trace+0x3f/0x47
[    4.002724]  [<ffffffff8139cc88>] xhci_configure_endpoint+0x13f/0x4b0
[    4.005076]  [<ffffffff8139d706>] xhci_check_bandwidth+0x11e/0x231
[    4.007457]  [<ffffffff813791ce>] usb_hcd_alloc_bandwidth+0x21d/0x2bd
[    4.009787]  [<ffffffff8137be1b>] usb_set_configuration+0x282/0x6f9
[    4.012008]  [<ffffffff81371927>] ? usb_hub_to_struct_hub+0x30/0x32
[    4.014085]  [<ffffffff813847ec>] generic_probe+0x40/0x72
[    4.015894]  [<ffffffff8137d7e9>] usb_probe_device+0x28/0x3b
[    4.017332]  [<ffffffff81302f4d>] driver_probe_device+0xda/0x202
[    4.019226]  [<ffffffff81303075>] ? driver_probe_device+0x202/0x202
[    4.021241]  [<ffffffff8130309a>] __device_attach+0x25/0x38
[    4.023357]  [<ffffffff81301636>] bus_for_each_drv+0x80/0x85
[    4.025480]  [<ffffffff81302e36>] device_attach+0x66/0x87
[    4.027587]  [<ffffffff81302456>] bus_probe_device+0x34/0xe1
[    4.029659]  [<ffffffff8130099f>] device_add+0x325/0x531
[    4.031661]  [<ffffffff813744ca>] usb_new_device+0x450/0x66a
[    4.033502]  [<ffffffff8107d9df>] ? trace_hardirqs_on+0xd/0xf
[    4.035347]  [<ffffffff81565f03>] ? __mutex_unlock_slowpath+0x19d/0x1af
[    4.037082]  [<ffffffff81374ff2>] hub_port_connect+0x4be/0x700
[    4.038873]  [<ffffffff8137586a>] hub_events+0x636/0x7ba
[    4.040210]  [<ffffffff81375a23>] hub_thread+0x35/0x16b
[    4.041518]  [<ffffffff81075c8c>] ? prepare_to_wait_exclusive+0x6c/0x6c
[    4.043361]  [<ffffffff813759ee>] ? hub_events+0x7ba/0x7ba
[    4.045170]  [<ffffffff81059cb3>] kthread+0xd6/0xde
[    4.046884]  [<ffffffff81059bdd>] ? __kthread_parkme+0x62/0x62
[    4.048760]  [<ffffffff8156e0fc>] ret_from_fork+0x7c/0xb0
[    4.050117]  [<ffffffff81059bdd>] ? __kthread_parkme+0x62/0x62
[    4.051467] Code: 00 e9 c2 00 00 00 83 f8 03 41 8b 04 24 74 03 83 e8 03 85 c0 75 07 41 8b 54 24 10 01 13 48 98 41 8b 54 24 08 48 6b f0 28 48 01 de <01> 56 08 41 83 7d 1c 05 77 27 41 8b 55 1c ff 24 d5 80 cb 68 81
[    4.057974] RIP  [<ffffffff8139abd4>] xhci_add_ep_to_interval_table+0xc8/0x172
[    4.059737]  RSP <ffff880128e85608>
[    4.061767] CR2: 0000000000000080
[    4.063775] ---[ end trace 581dd718db50beb0 ]---

On a working boot, it progresses:

[    3.823139] usb 3-4.1: New USB device found, idVendor=0e8f, idProduct=0020
[    3.823160] usb 3-4.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    3.823174] usb 3-4.1: Product: PS2toUSB Adapter
[    3.823187] usb 3-4.1: Manufacturer: GASIA
[    3.842836] input: GASIA PS2toUSB Adapter as /devices/pci0000:00/0000:00:14.0/usb3/3-4/3-4.1/3-4.1:1.0/0003:0E8F:0020.0001/input/input14
[    3.848598] hid-generic 0003:0E8F:0020.0001: input,hidraw0: USB HID v1.10 Keyboard [GASIA PS2toUSB Adapter] on usb-0000:00:14.0-4.1/input0
[    3.863592] input: GASIA PS2toUSB Adapter as /devices/pci0000:00/0000:00:14.0/usb3/3-4/3-4.1/3-4.1:1.1/0003:0E8F:0020.0002/input/input15
[    3.878608] hid-generic 0003:0E8F:0020.0002: input,hidraw1: USB HID v1.10 Mouse [GASIA PS2toUSB Adapter] on usb-0000:00:14.0-4.1/input1

So something about the PS2 adapter plugged into the dock gives it indigestion.

ANy ideas?

--==_Exmh_1401981749_1971P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBU5CLNQdmEQWDXROgAQKzCRAAmTrXnlKPJzPuJXKu0BgqWYKt+R3vZcqJ
Ovp4v8holQlF/0jMrz/Afie0ewJAB5LfsbH4peVy/REhitMz0fr0tWLYCs8n6uUk
/+lqEHzU/8im6n0TOgHyvK7BItm48C0lySIx3djEsv49w+tGN4BU8V2V8lkjvpR9
Jlu25aKENPVDjPQOvHi3/llgSMXhdTB8Je5aBOd4wuqrp4gDdIq9+H8ZTPsc22mO
DxCk0CJG1T/ay2DlvrirKgGLWTIT60U3cKybzGFS4gMA4BqtY7MjTuJtD4HmCwAa
tq371x861dXfc11KhrVY/Xp0IYpwU5cClHcDKgAwqlEpIrLNsH8bdDoLszMgac4C
hMbWEjqjwHwl3uxthNbYkfzliecEJbrhLTzwQcPrSf9DY9koHMwcGnvzHWpoEHTU
MJf6IPya0YlZgMMcr4fkyq7Hb2X3Re8q7H8ATEBBtXeQqbq41m3mgyBcCxRJ4YBy
NdOw5nmTWgWZEFeDLIZvOA79ii3W0B+Qem1H9tEMcHjnDvzjbcuslPYzwZ0wTtRL
5AGd7JwFD5tXODUz+6Yea6yTbP/ytL1XMuJvBmfNV31++LEwdnqS8SlJ9Y2iY9fg
yjI9X+Qq23mt5goh55WQToUQ6/74VoqbKekGEHCzLBvdRGIB6LUUMfch2Sy1/oAQ
UuHWhBN8Y0w=
=N2r2
-----END PGP SIGNATURE-----

--==_Exmh_1401981749_1971P--
