Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933744Ab3D3V2E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 17:28:04 -0400
Received: from mxout1.idt.com ([157.165.5.25]:60660 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933058Ab3D3V2B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 17:28:01 -0400
From: Alexandre Bounine <alexandre.bounine@idt.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc: Alexandre Bounine <alexandre.bounine@idt.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>, Kumar Gala <galak@kernel.crashing.org>,
        Andre van Herk <andre.van.herk@Prodrive.nl>,
        Micha Nelissen <micha.nelissen@Prodrive.nl>
Subject: [PATCH v2 3/3] rapidio: documentation update for enumeration changes
Date: Tue, 30 Apr 2013 17:25:55 -0400
Message-Id: <1367357155-11586-4-git-send-email-alexandre.bounine@idt.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1367357155-11586-1-git-send-email-alexandre.bounine@idt.com>
References: <1367357155-11586-1-git-send-email-alexandre.bounine@idt.com>
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
 Documentation/rapidio/rapidio.txt |  128 +++++++++++++++++++++++++++++++++---
 Documentation/rapidio/sysfs.txt   |   17 +++++
 2 files changed, 134 insertions(+), 11 deletions(-)

diff --git a/Documentation/rapidio/rapidio.txt b/Documentation/rapidio/rapidio.txt
index c75694b..a9c16c9 100644
--- a/Documentation/rapidio/rapidio.txt
+++ b/Documentation/rapidio/rapidio.txt
@@ -79,20 +79,63 @@ master port that is used to communicate with devices within the network.
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
+discovery methods as statically linked components or loadable modules.
+An enumeration/discovery method implementation and available input parameters
+define how any given method can be attached to available RapidIO mports:
+simply to all available mports OR individually to the specified mport device.
+
+Depending on selected enumeration/discovery build configuration, there are
+several methods to initiate an enumeration and/or discovery process:
+
+  (a) Statically linked enumeration and discovery process can be started
+  automatically during kernel initialization time using corresponding module
+  parameters. This was the original method used since introduction of RapidIO
+  subsystem. Now this method relies on enumerator module parameter which is
+  'rio-scan.scan' for existing basic enumeration/discovery method.
+  When automatic start of enumeration/discovery is used a user has to ensure
+  that all discovering endpoints are started before the enumerating endpoint
+  and are waiting for enumeration to be completed.
+  Configuration option CONFIG_RAPIDIO_DISC_TIMEOUT defines time that discovering
+  endpoint waits for enumeration to be completed. If the specified timeout
+  expires the discovery process is terminated without obtaining RapidIO network
+  information. NOTE: a timed out discovery process may be restarted later using
+  a user-space command as it is described later if the given endpoint was
+  enumerated successfully.
+
+  (b) Statically linked enumeration and discovery process can be started by
+  a command from user space. This initiation method provides more flexibility
+  for a system startup compared to the option (a) above. After all participating
+  endpoints have been successfully booted, an enumeration process shall be
+  started first by issuing a user-space command, after an enumeration is
+  completed a discovery process can be started on all remaining endpoints.
+
+  (c) Modular enumeration and discovery process can be started by a command from
+  user space. After an enumeration/discovery module is loaded, a network scan
+  process can be started by issuing a user-space command.
+  Similar to the option (b) above, an enumerator has to be started first.
+
+  (d) Modular enumeration and discovery process can be started by a module
+  initialization routine. In this case an enumerating module shall be loaded
+  first.
+
+When a network scan process is started it calls an enumeration or discovery
+routine depending on the configured role of a master port: host or agent.
 
 Enumeration is performed by a master port if it is configured as a host port by
 assigning a host device ID greater than or equal to zero. A host device ID is
@@ -104,8 +147,58 @@ for it.
 The enumeration and discovery routines use RapidIO maintenance transactions
 to access the configuration space of devices.
 
-The enumeration process is implemented according to the enumeration algorithm
-outlined in the RapidIO Interconnect Specification: Annex I [1].
+4.2 Automatic Start of Enumeration and Discovery
+------------------------------------------------
+
+Automatic enumeration/discovery start method is applicable only to built-in
+enumeration/discovery RapidIO configuration selection. To enable automatic
+enumeration/discovery start by existing basic enumerator method set use boot
+command line parameter "rio-scan.scan=1".
+
+This configuration requires synchronized start of all RapidIO endpoints that
+form a network which will be enumerated/discovered. Discovering endpoints have
+to be started before an enumeration starts to ensure that all RapidIO
+controllers have been initialized and are ready to be discovered. Configuration
+parameter CONFIG_RAPIDIO_DISC_TIMEOUT defines time (in seconds) which
+a discovering endpoint will wait for enumeration to be completed.
+
+When automatic enumeration/discovery start is selected, basic method's
+initialization routine calls rio_init_mports() to perform enumeration or
+discovery for all known mport devices.
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
+This method can be configured as statically linked or loadable module.
+The method's single parameter "scan" allows to trigger the enumeration/discovery
+process from module initialization routine.
+
+This enumeration/discovery method can be started only once and does not support
+unloading if it is built as a module.
 
 The enumeration process traverses the network using a recursive depth-first
 algorithm. When a new device is found, the enumerator takes ownership of that
@@ -160,6 +253,19 @@ time period. If this wait time period expires before enumeration is completed,
 an agent skips RapidIO discovery and continues with remaining kernel
 initialization.
 
+4.5 Adding New Enumeration/Discovery Method
+-------------------------------------------
+
+RapidIO subsystem code organization allows addition of new enumeration/discovery
+methods as new configuration options without significant impact to to the core
+RapidIO code.
+
+A new enumeration/discovery method has to be attached to one or more mport
+devices before an enumeration/discovery process can be started. Normally,
+method's module initialization routine calls rio_register_scan() to attach
+an enumerator to a specified mport device (or devices). The basic enumerator
+implementation demonstrates this process.
+
 5. References
 -------------
 
diff --git a/Documentation/rapidio/sysfs.txt b/Documentation/rapidio/sysfs.txt
index 97f71ce..1987817 100644
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
+	 is a write-only attribute. To initiate an enumeration or discovery
+	 process on specific mport device, a user needs to write mport_ID (not
+	 RapidIO destination ID) into this file. The mport_ID is a sequential
+	 number (0 ... RIO_MAX_MPORTS) assigned to the mport device.
+	 For example, for a machine with a single RapidIO controller, mport_ID
+	 for that controller always will be 0.
+	 To initiate RapidIO enumeration/discovery on all available mports
+	 a user must write '-1' (or RIO_MPORT_ANY) into this attribute file.
-- 
1.7.8.4

