Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584Ab3LBCvQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 21:51:16 -0500
Received: from mail-oa0-f43.google.com ([209.85.219.43]:34025 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552Ab3LBCvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 21:51:14 -0500
MIME-Version: 1.0
X-Originating-IP: [121.6.203.106]
In-Reply-To: <CAMVG2svSYPDEhs2vUMDi0jZ8vR9P9O5MmSnsd_ziDGcCe8aURg@mail.gmail.com>
References: <CAMVG2svSYPDEhs2vUMDi0jZ8vR9P9O5MmSnsd_ziDGcCe8aURg@mail.gmail.com>
Date: Mon, 2 Dec 2013 10:51:13 +0800
Message-ID: <CAMVG2ssN34fqjwmDezQVBeTOdt42tYQh92uS914pLbphqhk_EA@mail.gmail.com>
Subject: Re: [PATCH 00/12] Thunderbolt hotplug support for Apple hardware
 (testers needed)
From: Daniel J Blueman <daniel@quora.org>
To: Andreas Noever <andreas.noever@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 29 November 2013 09:40:02 UTC+8, Andreas Noever  wrote:
> Thunderbolt hotplug is supposed to be implemented by the firmware. But Apple's
> firmeware only initializes devices during boot and ignores hotplugged devices.
> This patch series adds a driver for the Intel Cactus Ridge Thunderbolt
> controller. The driver supports hotplug operations of simple (one PCI device,
> no chaining) thunderbolt devices.
[...]
> (1) and (2) should be solveable given some time. I also have a pretty good idea
> on how chaining should work. The main problem is that I have yet to see any
> Thunderbolt device besides the Apple ethernet adapter. If someone with a
> MacBook and access to more complicated TB hardware is willing to run some
> tests: Please contact me.
>
> I will try to debug (4) further and write a seperate bug report for the issue.

Booting with 3.12.2, your patch series, with acpi_osi=Darwin and no
thunderbolt devices plugged, I run into this oops:

dsl3510 0000:07:00.0: dma_pool_free dls3510 cfg,
0000000080000000/ee2429b8 (bad data)
kernel BUG at mm/slub.c:3338!
invalid opcode: 0000 [#1] SMP
tb_ctl_free_packet.isra.0+0x21/0x30
tb_cfg_rx_callback+0xbc/0x300
ring_drain_and_free+0x2c2/0x360
tb_cfg_free+0x1b/0x80
thunderbolt_shutdown_and_free
thunderbolt_alloc_and_start
dsl3510_probe
pci_device_probe
driver_probe_device
__driver_attach
? __device_attach
bus_for_each_dev
driver_attach
bus_add_driver
? extcon_class_init
driver_register
? extcon_class_init
__pci_register_driver
dsl3510_init
do_one_initcall

(gdb) list *(tb_ctl_free_packet+0x21)
0xffffffff815bb221 is in tb_ctl_free_packet (drivers/thunderbolt/tb_cfg.c:243).
238
239    static void tb_ctl_free_packet(struct tb_cfg *cfg, struct
ring_packet *pkg)
240    {
241        dma_pool_free(cfg->packet_pool, pkg->buffer, pkg->buffer_phy);
242        kfree(pkg);
243    }
244
245    /**
246     * tb_ctl_alloc_packets() - allocate multiple packets safely
247     *

Later, I'll add debug to see which path is being taken in
thunderbolt_alloc_and_start, as I guess that wasn't expected to fail,
though it looks like there's this teardown issue.

Thanks,
  Daniel
-- 
Daniel J Blueman
