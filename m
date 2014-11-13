Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933727AbaKMSCa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 13:02:30 -0500
Received: from mail-bl2on0141.outbound.protection.outlook.com ([65.55.169.141]:63840
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933296AbaKMSC3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 13:02:29 -0500
X-Greylist: delayed 851 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Nov 2014 13:02:28 EST
From: "J. German Rivera" <German.Rivera@freescale.com>
To: <gregkh@linuxfoundation.org>, <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>
CC: <stuart.yoder@freescale.com>, <Kim.Phillips@freescale.com>,
        <scottwood@freescale.com>, <agraf@suse.de>, <bhamciu1@freescale.com>,
        <R89243@freescale.com>, <Geoff.Thorpe@freescale.com>,
        <bhupesh.sharma@freescale.com>, <nir.erez@freescale.com>,
        <richard.schmitt@freescale.com>
Subject: [PATCH 0/3] drivers/bus: Freescale Management Complex bus driver patch series
Date: Thu, 13 Nov 2014 11:46:50 -0600
Message-ID: <1415900813-16334-1-git-send-email-German.Rivera@freescale.com>
X-Mailer: git-send-email 2.1.2
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(31966008)(106466001)(4396001)(50226001)(46102003)(102836001)(120916001)(104016003)(21056001)(99396003)(62966003)(20776003)(47776003)(107046002)(95666004)(36756003)(105606002)(77156002)(64706001)(229853001)(15975445006)(88136002)(50466002)(84676001)(87936001)(6806004)(89996001)(2201001)(19580395003)(92726001)(92566001)(44976005)(68736004)(50986999)(87286001)(104166001)(15202345003)(86362001)(93916002)(48376002)(97736003);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB1307;H:tx30smr01.am.freescale.net;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1307;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(7)(6);SRVR:CY1PR0301MB1307;
X-Forefront-PRVS: 0394259C80
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=German.Rivera@freescale.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1307;
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
resources are available, such as queues, buffer pools, I/O
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

Changes in v4:
- Addressed comments from Alex Graf. Details in each patch.
- Upgraded MC flibs to version 0.5
- Fixed bug related to setting fsl_mc_bus_type.dev_root too late

Changes in v3:
- Addressed pending issues not resolved in v2:
  * Removed Doxygen comments as requested by Greg Kroah-Hartman
  * Moved newly added FSL-specific header files from include/linux to
    include/linux/fsl
  * Changed wording of licenses in MC flib source files
  * Fixed sparse warning about context imbalance in 'mc_send_command'

- Addressed additional comments from Kim Phillips, Scott Wood and
  Timur Tabi. Details in each patch.

Issues pending resolution not addressed by v3:
- Checkpatch warnings:
  * WARNING: DT compatible string "fsl,qoriq-mc" appears un-documented
    This warning will go away once the prerequisite patch series is
    accepted upstream.
  * WARNING: added, moved or deleted file(s), does MAINTAINERS need updating?
    This warning still happens even after adding MAINTAINERS file entries in
    the same patch where new files were added

Changes in v2:
- Added reference to the patch series this patch is dependent on for
  device tree and device tree bindings changes. (See above).
- Removed patch 4 (update to the MAINTAINERS file), as this is done
  now in patch 1
- Addressed comments from Joe Perches, Kim Phillips, Alex Graf
  and Scott Wood. Details in each patch.

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
