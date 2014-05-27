Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771AbaE0R02 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 13:26:28 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:40212 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126AbaE0R00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 13:26:26 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.6+dev
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: next-20140529 - BUG: sleeping function called from invalid context at mm/slab.c:2946
From: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1401211549_1980P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 27 May 2014 13:25:49 -0400
Message-ID: <10314.1401211549@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1401211549_1980P
Content-Type: text/plain; charset=us-ascii

This seems to be a repeateable BUG in next-20140529 (have hit it in
2 boots out of 2).  Seeing it on a Dell Latitude E6530 while it's
enumerating the internal USB hubs.  Whatever trips it, it's new since
next-20140519.

% lsusb
Bus 002 Device 004: ID 0a5c:5801 Broadcom Corp. BCM5880 Secure Applications Processor with fingerprint swipe sensor
Bus 002 Device 003: ID 413c:2513 Dell Computer Corp. internal USB Hub of E-Port Replicator
Bus 002 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 001 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 004 Device 002: ID 413c:5534 Dell Computer Corp.
Bus 004 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
Bus 003 Device 004: ID 0e8f:0020 GreenAsia Inc. USB to PS/2 Adapter
Bus 003 Device 003: ID 413c:2134 Dell Computer Corp.
Bus 003 Device 002: ID 045e:0023 Microsoft Corp. Trackball Optical
Bus 003 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub

Anybody recognize this, before I go off to bisect land?

[    3.717306] usb 3-4: New USB device found, idVendor=413c, idProduct=2134
[    3.717316] usb 3-4: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    3.717322] usb 3-4: Product: USB2134
[    3.717327] usb 3-4: Manufacturer: SMSC
[    3.718174] hub 3-4:1.0: USB hub found
[    3.718217] hub 3-4:1.0: 3 ports detected
[    3.720133] BUG: sleeping function called from invalid context at mm/slab.c:2946
[    3.720235] in_atomic(): 1, irqs_disabled(): 1, pid: 39, name: kworker/2:1
[    3.720308] 3 locks held by kworker/2:1/39:
[    3.720311]  #0:  ("pm"){.+.+.+}, at: [<ffffffff81056fac>] process_one_work+0x1fa/0x4be
[    3.720330]  #1:  ((&dev->power.work)){+.+.+.}, at: [<ffffffff81056fac>] process_one_work+0x1fa/0x4be
[    3.720346]  #2:  (&(&xhci->lock)->rlock){-.-...}, at: [<ffffffff813ce13f>] xhci_stop_device.constprop.7+0x61/0x14a
[    3.720363] irq event stamp: 7490
[    3.720366] hardirqs last  enabled at (7489): [<ffffffff81081c7c>] debug_check_no_locks_freed+0x123/0x131
[    3.720374] hardirqs last disabled at (7490): [<ffffffff81687c36>] _raw_spin_lock_irqsave+0x17/0x4e
[    3.720382] softirqs last  enabled at (7426): [<ffffffff81041ae4>] __do_softirq+0x2ab/0x403
[    3.720388] softirqs last disabled at (7413): [<ffffffff81041edf>] irq_exit+0x4c/0xbb
[    3.720396] CPU: 2 PID: 39 Comm: kworker/2:1 Not tainted 3.15.0-rc7-next-20140526-dirty #215
[    3.720400] Hardware name: Dell Inc. Latitude E6530/07Y85M, BIOS A11 03/12/2013
[    3.720406] ^AdWorkqueue: pm pm_runtime_work
[    3.720411]  0000000000000000 ffff880128edb768 ffffffff8167d3af 0000000000000027
[    3.720423]  ffff880128ee0a50 ffff880128edb790 ffffffff81065fe4 0000000000008010
[    3.720435]  ffff88012d000280 ffff88012d000280 ffff880128edb7a0 ffffffff8112fe1e
[    3.720446] Call Trace:
[    3.720453]  [<ffffffff8167d3af>] dump_stack+0x51/0xaa
[    3.720462]  [<ffffffff81065fe4>] __might_sleep+0x1b7/0x1be
[    3.720470]  [<ffffffff8112fe1e>] cache_alloc_debugcheck_before.isra.45+0x1d/0x1f
[    3.720477]  [<ffffffff811311b0>] __kmalloc+0x62/0x10d
[    3.720485]  [<ffffffff813c71e9>] ? kzalloc+0xf/0x11
[    3.720492]  [<ffffffff813c71e9>] kzalloc+0xf/0x11
[    3.720499]  [<ffffffff813c876a>] xhci_alloc_command+0x25/0xac
[    3.720506]  [<ffffffff813ce164>] xhci_stop_device.constprop.7+0x86/0x14a
[    3.720513]  [<ffffffff813cece8>] xhci_hub_control+0x9ca/0xdb6
[    3.720521]  [<ffffffff810819c3>] ? trace_hardirqs_on_caller+0x18f/0x1ab
[    3.720529]  [<ffffffff813a0501>] usb_hcd_submit_urb+0x598/0x7cf
[    3.720536]  [<ffffffff8108181d>] ? mark_held_locks+0x5d/0x74
[    3.720543]  [<ffffffff81081c7c>] ? debug_check_no_locks_freed+0x123/0x131
[    3.720550]  [<ffffffff810819c3>] ? trace_hardirqs_on_caller+0x18f/0x1ab
[    3.720556]  [<ffffffff810819ec>] ? trace_hardirqs_on+0xd/0xf
[    3.720563]  [<ffffffff813a1443>] usb_submit_urb+0x448/0x481
[    3.720570]  [<ffffffff813a2174>] usb_start_wait_urb+0x72/0x119
[    3.720577]  [<ffffffff813a22e8>] usb_control_msg+0xcd/0xf2
[    3.720585]  [<ffffffff81686b67>] ? __mutex_unlock_slowpath+0x19d/0x1af
[    3.720592]  [<ffffffff81398455>] set_port_feature+0x30/0x32
[    3.720599]  [<ffffffff8139ab47>] usb_port_suspend+0x167/0x24a
[    3.720605]  [<ffffffff813abf2c>] generic_suspend+0x21/0x27
[    3.720612]  [<ffffffff813a449e>] usb_suspend_both+0xe9/0x190
[    3.720619]  [<ffffffff813a5311>] usb_runtime_suspend+0x2e/0x69
[    3.720626]  [<ffffffff813a52e3>] ? usb_probe_interface+0x1db/0x1db
[    3.720633]  [<ffffffff8132b579>] __rpm_callback+0x34/0x5b
[    3.720640]  [<ffffffff8132b60f>] rpm_callback+0x6f/0x85
[    3.720646]  [<ffffffff8132bce9>] rpm_suspend+0x26e/0x405
[    3.720654]  [<ffffffff8108596f>] ? do_raw_spin_lock+0xdf/0x19f
[    3.720661]  [<ffffffff8132ca76>] __pm_runtime_suspend+0x56/0x80
[    3.720668]  [<ffffffff813a5363>] ? usb_runtime_resume+0x17/0x17
[    3.720674]  [<ffffffff813a5388>] usb_runtime_idle+0x25/0x2d
[    3.720681]  [<ffffffff8132b579>] __rpm_callback+0x34/0x5b
[    3.720687]  [<ffffffff8132c0ae>] rpm_idle+0x17d/0x22e
[    3.720695]  [<ffffffff8132cb68>] pm_runtime_work+0x59/0x8f
[    3.720702]  [<ffffffff8105704e>] process_one_work+0x29c/0x4be
[    3.720710]  [<ffffffff81057a68>] worker_thread+0x40d/0x561
[    3.720717]  [<ffffffff8105765b>] ? cancel_delayed_work+0xb7/0xb7
[    3.720724]  [<ffffffff8105d71d>] kthread+0xd6/0xde
[    3.720732]  [<ffffffff8105d647>] ? __kthread_parkme+0x62/0x62
[    3.720738]  [<ffffffff8168896c>] ret_from_fork+0x7c/0xb0
[    3.720745]  [<ffffffff8105d647>] ? __kthread_parkme+0x62/0x62
[    3.782223] usb 2-1.7: new high-speed USB device number 3 using ehci-pci
[    3.856396] systemd-udevd[238]: starting version 212
[    3.867694] usb 2-1.7: New USB device found, idVendor=413c, idProduct=2513
[    3.867713] usb 2-1.7: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    3.870885] hub 2-1.7:1.0: USB hub found


--==_Exmh_1401211549_1980P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBU4TKnQdmEQWDXROgAQLjKxAAspqtGizdaZWrDNAW+iPXo0RdcsgTctvq
HNuQbY/HpuSJ5ZcARGyP6OoYGgGAFlZmgOs9ygnSM+X+1owONhAEFtk47RP0K/j7
TYbZGovQ08vLDTt1KpL/Bccggn6MjRREhy5ivn5+RFtAWUnu/tuDeFSkWxVlEUYz
NyHq57TPQ2hnuXzQmIzRhXkuSp9SM2YNd57iwIItU9fuTqnVB1jI2I6JOAPMPorC
6oW+k12z2sf7M+5gN8A8pwstDCmFuAOsXXoVm9AJiL5gDVn1MV7mGkYjSDFwl8QT
Mt5omOG6zS4OYQrNzTCqGZFt9IX7Ulug5umOadnyAR447BteanWBBULNdH+dEjuv
zwDf+E8k/ZaGcpa1JDBUb2FOzgHeJOEOw0phWreKhzaPT50USSYKm9pNIN93FV6S
jCKfqGzqKspcopjVyVUOxsXn7qKR8d+Wbt+K9UBCR6Q3FCvU45N1gC6y9PyEblnc
p2Kuw4PBOSo1BcQKRVQ0wLQ1CUyQ8bKWjk8vPH7d4vna34hFCQGN7aekbtpZZVvQ
EQTyYi5seyF7xsVRUKYGl1HEyaTG9dZLLHZduRjMLVoGJj06t5izoll08l8psti+
zKuKQDmjutbPujrL+zQivwdw/v2JZTN559cZrjF+s5W0FLG56a9f9edXWj/FY+7E
TbUKKDT/unE=
=UV+Y
-----END PGP SIGNATURE-----

--==_Exmh_1401211549_1980P--
