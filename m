Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758129AbaISWtu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 18:49:50 -0400
Received: from mail-by2on0136.outbound.protection.outlook.com ([207.46.100.136]:8157
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757949AbaISWtt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 18:49:49 -0400
From: "J. German Rivera" <German.Rivera@freescale.com>
To: <gregkh@linuxfoundation.org>, <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>
CC: <stuart.yoder@freescale.com>, <Kim.Phillips@freescale.com>,
        <scottwood@freescale.com>, <agraf@suse.de>,
        <linuxppc-release@linux.freescale.net>
Subject: [PATCH 0/3 v2] drivers/bus: Freescale Management Complex bus driver patch series
Date: Fri, 19 Sep 2014 17:49:38 -0500
Message-ID: <1411166981-3610-1-git-send-email-German.Rivera@freescale.com>
X-Mailer: git-send-email 1.7.9.7
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(64706001)(97736003)(90102001)(4396001)(50226001)(26826002)(99396002)(87936001)(50466002)(50986999)(102836001)(47776003)(20776003)(21056001)(81156004)(95666004)(87286001)(229853001)(31966008)(15202345003)(106466001)(62966002)(74662003)(88136002)(93916002)(104166001)(6806004)(105606002)(19580395003)(86362001)(79102003)(83322001)(92566001)(36756003)(44976005)(85306004)(107046002)(84676001)(77982003)(76482002)(89996001)(48376002)(104016003)(15975445006)(68736004)(2201001)(77156001)(92726001)(74502003)(83072002)(81342003)(80022003)(81542003)(85852003)(69596002)(46102003);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0721;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0721;
X-Forefront-PRVS: 0339F89554
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=German.Rivera@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series introduces Linux support for the Freescale
Management Complex (fsl-mc) hardware. This patch series is dependent
on the patch series "ARM64: Add support for FSL's LS2085A SoC"
(http://thread.gmane.org/gmane.linux.ports.arm.kernel/351829)

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

CHANGE HISTORY

Issues pending resolution not addressed by v2:
- What to do with Doxygen comments in patch 1
- Whether to move or not FSL-specific header files added in include/linux,
  by this patch series, to another location
- Whether to change or not the wording of the licenses used in some
  source files

- Checkpatch warnings:
  * WARNING: DT compatible string "fsl,qoriq-mc" appears un-documented
    This warning will go away once the prerequisite patch series is
    accepted upstream.
  * WARNING: added, moved or deleted file(s), does MAINTAINERS need updating?
    This warning still happens even after adding MAINTAINERS file entries in
    the same patch where new files were added
- Sparse warning:
  * drivers/bus/fsl-mc/fsl_mc_sys.c:193:9: warning: context imbalance in 'mc_send_command' - different lock contexts for basic block
    This warning is caused by conditionally acquiring/releasing a lock in function mc_send_command().
    Not clear how to solve this warning, as we need to be able to decide at
    run time based on a flag whether to acquire the lock or not.

Changes in v2:
- Added reference to the patch series this patch is dependent on for
  device tree and device tree bindings changes. (See above).
- Removed patch 4 (update to the MAINTAINERS file), as this is done
  now in patch 1
- Addressed comments from Joe Perches, Kim Phillips, Alex Graf
  and Scott Wood. Details in each patch.

Changes in v1:
- No changes since RFC v4

Changes in RFC v4:
- Fixed parameter mismatch for device_find_child() call in fsl_mc_dprc.c
- Added back the dma_mask field to struct fsl_mc_device as it is needed
  by some MC child device drivers. However, the default DMA mask now
  does not have the 32-bit limitation of the original patch series (v1).

Changes in RFC v3:
Rework to address comments from Arnd Bergmann:
- Removed per-bus list of children, and instead use device_for_each_child()
- Use the same structure (struct fsl_mc_device) to represent both
  bus devices and their children.
http://www.mail-archive.com/linux-kernel%40vger.kernel.org/msg711301.html

Changes in RFC v2:
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

