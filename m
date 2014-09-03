Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933915AbaICW1w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 18:27:52 -0400
Received: from [207.46.163.244] ([207.46.163.244]:54810 "EHLO
	na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S932209AbaICW1s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:27:48 -0400
From: "J. German Rivera" <German.Rivera@freescale.com>
To: <gregkh@linuxfoundation.org>, <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>
CC: <stuart.yoder@freescale.com>, <Kim.Phillips@freescale.com>,
        <scottwood@freescale.com>, <agraf@suse.de>,
        <linuxppc-release@linux.freescale.net>
Subject: [RFC PATCH 0/4 v4] drivers/bus: Freescale Management Complex bus driver patch series
Date: Wed, 3 Sep 2014 17:25:42 -0500
Message-ID: <1409783146-13418-1-git-send-email-German.Rivera@freescale.com>
X-Mailer: git-send-email 1.7.9.7
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199003)(189002)(81342001)(86362001)(62966002)(93916002)(99396002)(97736001)(87936001)(92726001)(80022001)(50986999)(102836001)(104166001)(81542001)(4396001)(26826002)(88136002)(2201001)(92566001)(90102001)(89996001)(36756003)(83072002)(50226001)(106466001)(87286001)(77982001)(105606002)(81156004)(79102001)(85306004)(6806004)(19580395003)(83322001)(44976005)(229853001)(15202345003)(68736004)(69596002)(50466002)(48376002)(104016003)(84676001)(77156001)(64706001)(95666004)(15975445006)(47776003)(74662001)(85852003)(31966008)(20776003)(74502001)(76482001)(46102001)(107046002)(21056001)(217873001);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR0301MB0707;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 032334F434
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=German.Rivera@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series introduces Linux support for the Freescale
Management Complex (fsl-mc) hardware.

The fsl-mc is a hardware resource manager that manages specialized
hardware objects used in network-oriented packet processing
applications.  After the fsl-mc block is enabled, pools of hardware
resources are available, such as queues, buffer poools, I/O
interfaces.  These resources are building blocks that can be
used to create functional hardware objects such as network
interfaces, crypto accelerator instances, or L2 switches.

All the fsl-mc managed hardware resources/objects are represented in
a physical grouping mechanism called a 'container' or DPRC (data
path resource container).

>From the point of view of an OS, a DPRC functions similar to a plug
and play bus.  Using fsl-mc commands software can enumerate the
contents of the DPRC discovering the hardware objects present
and binding them to drivers.  Hardware objects can be created
and removed dynamically, providing hot pluggability of the hardware
objects.

Software contexts interact with the fsl-mc by sending commands through
a memory mapped hardware interface called an "MC portal". Every
fsl-mc object type has a command set to manage the objects. Key
DPRC commands include:
   -create/destroy a DPRC
   -enumerate objects and resource pools in the DPRC, including
    identifying mappable regions and the number of IRQs an object
    may have
   -IRQ configuration
   -move objects/resources between DPRCs
   -connecting objects (e.g. connecting a network interface to
    an L2 switch port)
   -reset

Patch 1 contains a minimal set of low level functions to send an
d receive commands to the fsl-mc. It includes support for basic
management commands and commands to manipulate DPRC objects.

Patch 2 contains a platform device driver that sets up and registers
the basic bus infrastructure including support for adding/removing
devices, register/unregister of drivers, and bus match support
to bind devices to drivers.

Patch 3 contains an driver that manages DPRC objects (the
container that holds the hardware resources). This driver
functions as a bus controller and handles enumeration
of the objects in the container and hotplug events.

Patch 4 contains the update to the MAINTAINERS file.

Changes in v4:
- Fixed parameter mismatch for device_find_child() call in fsl_mc_dprc.c
- Added back the dma_mask field to struct fsl_mc_device as it is needed
  by some MC child device drivers. However, the default DMA mask now
  does not have the 32-bit limitation of the original patch series (v1).

Changes in v3:
Rework to address comments from Arnd Bergmann:
- Removed per-bus list of children, and instead use device_for_each_child()
- Use the same structure (struct fsl_mc_device) to represent both
  bus devices and their children.
http://www.mail-archive.com/linux-kernel%40vger.kernel.org/msg711301.html

Changes in v2:
Rework to address comments from Arnd Bergmann:
- Removed fsl_mc_bus structure and global variable
- Removed the 'magic' fields from all structs
- Removed NULL initializers
- Replaced all occurrences of EXPORT_SYMBOL() with EXPORT_SYMBOL_GPL()
- Removed function dprc_parse_dt_node(), and replaced its call by a
  direct call to of_address_to_resource()
- Removed struct fsl_mc_device_region and use standard 'struct resource'
  instead.
- Removed dma_mask field from 'struct fsl_mc_device' as it is not currently
  being used.
- Removed redundant 'driver' field from struct fsl_mc_device
- Removed the container field. We can get the parent DPRC of a given dev,
  from its dev.parent field.
http://www.mail-archive.com/linux-kernel%40vger.kernel.org/msg708858.html

