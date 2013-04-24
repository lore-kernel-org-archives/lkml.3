Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049Ab3DXOoD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 10:44:03 -0400
Received: from mxout1.idt.com ([157.165.5.25]:49864 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755906Ab3DXOn6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 10:43:58 -0400
X-Greylist: delayed 571 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Apr 2013 10:43:53 EDT
From: Alexandre Bounine <alexandre.bounine@idt.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc: Alexandre Bounine <alexandre.bounine@idt.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>, Kumar Gala <galak@kernel.crashing.org>,
        Andre van Herk <andre.van.herk@Prodrive.nl>,
        Micha Nelissen <micha.nelissen@Prodrive.nl>
Subject: [PATCH 3/3] rapidio: documentation update for enumeration changes
Date: Wed, 24 Apr 2013 10:31:59 -0400
Message-Id: <1366813919-13766-4-git-send-email-alexandre.bounine@idt.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1366813919-13766-1-git-send-email-alexandre.bounine@idt.com>
References: <1366813919-13766-1-git-send-email-alexandre.bounine@idt.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update RapidIO documentation to reflect changes made to enumeration/discovery
build configuration and user space triggering mechanism.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Andre van Herk <andre.van.herk@Prodrive.nl>
Cc: Micha Nelissen <micha.nelissen@Prodrive.nl>
---
 Documentation/rapidio/rapidio.txt |  137 ++++++++++++++++++++++++++++++++++---
 Documentation/rapidio/sysfs.txt   |   17 +++++
 2 files changed, 143 insertions(+), 11 deletions(-)

diff --git a/Documentation/rapidio/rapidio.txt b/Documentation/rapidio/rapidio.txt
index c75694b..d97576f 100644
--- a/Documentation/rapidio/rapidio.txt
+++ b/Documentation/rapidio/rapidio.txt
@@ -79,20 +79,64 @@ master port that is used to communicate with devices within the network.
 In order to initialize the RapidIO subsystem, a platform must initialize and
 register at least one master port within the RapidIO network. To register mport
 within the subsystem controller driver initialization code calls function
-rio_register_mport() for each available master port. After all active master
-ports are registered with a RapidIO subsystem, the rio_init_mports() routine
-is called to perform enumeration and discovery.
+rio_register_mport() for each available master port.
 
-In the current PowerPC-based implementation a subsys_initcall() is specified to
-perform controller initialization and mport registration. At the end it directly
-calls rio_init_mports() to execute RapidIO enumeration and discovery.
+RapidIO subsystem uses subsys_initcall() or device_initcall() to perform
+controller initialization (depending on controller device type).
+
+After all active master ports are registered with a RapidIO subsystem,
+an enumeration and/or discovery routine may be called automatically or
+by user-space command.
 
 4. Enumeration and Discovery
 ----------------------------
 
-When rio_init_mports() is called it scans a list of registered master ports and
-calls an enumeration or discovery routine depending on the configured role of a
-master port: host or agent.
+4.1 Overview
+------------
+
+RapidIO subsystem configuration options allow users to specify enumeration and
+discovery methods as built-in components or loadable modules.
+For built-in options only one method can be selected for all mports in a system.
+Selecting a modular build option for enumeration/discovery allows to use
+different enumerators attached to available mport device individually.
+
+Depending on selected enumeration/discovery build configuration, there are
+several methods to initiate enumeration and/or discovery process:
+
+  (a) Built-in enumeration and discovery process can be started automatically
+  during kernel initialization time. This is the original method used since
+  introduction of RapidIO subsystem. This method relies	on kernel initcall that
+  calls rio_init_mports() routine after all available mports have been
+  registered. When automatic start of enumeration/discovery is used a user has
+  to ensure that all discovering endpoints are started before the enumerating
+  endpoint and are waiting for enumeration to be completed.
+  Configuration option CONFIG_RAPIDIO_DISC_TIMEOUT defines time that discovering
+  endpoint waits for enumeration to be completed. If the specified timeout
+  expires the discovery process is terminated without obtaining RapidIO network
+  information. NOTE: a timed out discovery process may be restarted later using
+  a user-space command as it is described later if the given endpoint was
+  enumerated successfully.
+
+  (b) Built-in enumeration and discovery process can be started by a command
+  from user space. This initiation method provides more freedom for system
+  startup compared to the option (a) above. After all participating endpoints
+  have been successfully booted, an enumeration process shall be started first
+  by issuing a user-space command, as soon as enumeration is completed
+  a discovery process can be started on all remaining endpoints.
+  Configuration option CONFIG_RAPIDIO_ENUM_AUTO defines which method will be
+  used to start a built-in enumeration and discovery process.
+
+  (c) Modular enumeration and discovery process can be started by a command from
+  user space. After an enumeration/discovery module is loaded, a network scan
+  process can be started by issuing a user-space command.
+  Similar to the option (b) above, an enumerator has to be started first.
+
+  (d) Modular enumeration and discovery process can be started by a module
+  initialization routine. As in the cases above an enumerating module shall be
+  loaded first.
+
+When a network scan process is started it calls an enumeration or discovery
+routine depending on the configured role of a master port: host or agent.
 
 Enumeration is performed by a master port if it is configured as a host port by
 assigning a host device ID greater than or equal to zero. A host device ID is
@@ -104,8 +148,57 @@ for it.
 The enumeration and discovery routines use RapidIO maintenance transactions
 to access the configuration space of devices.
 
-The enumeration process is implemented according to the enumeration algorithm
-outlined in the RapidIO Interconnect Specification: Annex I [1].
+4.2 Automatic Start of Enumeration and Discovery
+------------------------------------------------
+
+Automatic enumeration/discovery start method is applicable only to built-in
+enumeration/discovery RapidIO configuration selection. To enable automatic
+enumeration/discovery start set CONFIG_RAPIDIO_ENUM_AUTO=y.
+
+This configuration requires synchronized start of all RapidIO endpoints that
+form a network which will be enumerated/discovered. Discovering endpoints have
+to be started before an enumeration starts to ensure that all RapidIO
+controllers have been initialized and are ready to be discovered. Configuration
+parameter CONFIG_RAPIDIO_DISC_TIMEOUT defines time (in seconds) which
+a discovering endpoint will wait for enumeration to be completed.
+
+When automatic enumeration/discovery start method is selected RapidIO subsystem
+core uses device_initcall_sync() to invoke rio_init_mports() routine to perform
+enumeration or discovery for all known mport devices.
+
+Depending on RapidIO network size and configuration this automatic
+enumeration/discovery start method may be difficult to use due to the
+requirement for synchronized start of all endpoints.
+
+4.3 User-space Start of Enumeration and Discovery
+-------------------------------------------------
+
+User-space start of enumeration and discovery can be used with built-in and
+modular build configurations. For user-space controlled start RapidIO subsystem
+creates the sysfs write-only attribute file '/sys/bus/rapidio/scan'. To initiate
+an enumeration or discovery process on specific mport device, a user needs to
+write mport_ID (not RapidIO destination ID) into that file. The mport_ID is a
+sequential number (0 ... RIO_MAX_MPORTS) assigned during mport device
+registration. For example for machine with single RapidIO controller, mport_ID
+for that controller always will be 0.
+
+To initiate RapidIO enumeration/discovery on all available mports a user may
+write '-1' (or RIO_MPORT_ANY) into the scan attribute file.
+
+4.4 Basic Enumeration Method
+----------------------------
+
+This is an original enumeration/discovery method which is available since
+first release of RapidIO subsystem code. The enumeration process is
+implemented according to the enumeration algorithm outlined in the RapidIO
+Interconnect Specification: Annex I [1].
+
+This method can be configured as built-in or loadable module. When used as a
+kernel module this method offers parameter "scan" witch allows to trigger the
+enumeration/discovery process from module initialization routine.
+
+This enumeration/discovery method can be started only once and does not support
+unloading if it is built as a module.
 
 The enumeration process traverses the network using a recursive depth-first
 algorithm. When a new device is found, the enumerator takes ownership of that
@@ -160,6 +253,28 @@ time period. If this wait time period expires before enumeration is completed,
 an agent skips RapidIO discovery and continues with remaining kernel
 initialization.
 
+4.5 Adding New Enumeration/Discovery Method
+-------------------------------------------
+
+RapidIO subsystem code organization allows addition of new enumeration/discovery
+methods as new configuration options without significant impact to to the core
+RapidIO code.
+
+RapidIO developers can add new enumeration/discovery methods as built-in code or
+loadable kernel modules. In case of built-in methods only one method may be
+configured in, having multiple built-in enumeration/discovery methods is not
+supported by mport role assignment mechanism.
+
+To be registered with RapidIO subsystem a new built-in method must provide
+global data structure named "rio_scan_ops" (see definition of 'struct rio_scan'
+in include/linux/rio.h file). Example of this structure is available in the
+existing implementation of basic RapidIO enumeration method (see rio-scan.c).
+
+If a new enumeration/discovery method is implemented as a module, its module
+initialization routine has to call rio_register_scan() routine to attach
+a loadable enumerator to a specified mport device. The basic enumerator
+implementation demonstrates this process as well.
+
 5. References
 -------------
 
diff --git a/Documentation/rapidio/sysfs.txt b/Documentation/rapidio/sysfs.txt
index 97f71ce..c3b7d18 100644
--- a/Documentation/rapidio/sysfs.txt
+++ b/Documentation/rapidio/sysfs.txt
@@ -88,3 +88,20 @@ that exports additional attributes.
 
 IDT_GEN2:
  errlog - reads contents of device error log until it is empty.
+
+
+5. RapidIO Bus Attributes
+-------------------------
+
+RapidIO bus subdirectory /sys/bus/rapidio implements the following bus-specific
+attribute:
+
+  scan - allows to trigger enumeration discovery process from user space. This
+	 is write-only attribute. To initiate an enumeration or discovery
+	 process on specific mport device, a user needs to write mport_ID (not
+	 RapidIO destination ID) into this file. The mport_ID is a sequential
+	 number (0 ... RIO_MAX_MPORTS) assigned to mport device. For example for
+	 machine with single RapidIO controller, mport_ID for that controller
+	 always will be 0. To initiate RapidIO enumeration/discovery on all
+	 available mports a user must write '-1' (or RIO_MPORT_ANY) into this
+	 attribute file.
-- 
1.7.8.4

