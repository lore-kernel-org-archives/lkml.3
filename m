Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811AbaEPAcg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 20:32:36 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:59192 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751345AbaEPAby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 20:31:54 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 2/3] PM / sleep: Update device PM documentation to cover direct_complete
Date: Fri, 16 May 2014 02:47:37 +0200
Message-ID: <4534834.OsNKUUZo0i@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1596386.YnYCCm2UQG@vostro.rjw.lan>
References: <Pine.LNX.4.44L0.1405141041360.1432-100000@iolanthe.rowland.org> <1495375.YeObBhD5SE@vostro.rjw.lan> <1596386.YnYCCm2UQG@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Update the device PM documentation in devices.txt and runtime_pm.txt
to reflect the changes in the system suspend and resume handling
related to the introduction of the new power.direct_complete flag.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 Documentation/power/devices.txt    |   34 ++++++++++++++++++++++++++++++----
 Documentation/power/runtime_pm.txt |   17 +++++++++++++++++
 2 files changed, 47 insertions(+), 4 deletions(-)

Index: linux-pm/Documentation/power/devices.txt
===================================================================
--- linux-pm.orig/Documentation/power/devices.txt
+++ linux-pm/Documentation/power/devices.txt
@@ -2,6 +2,7 @@ Device Power Management
 
 Copyright (c) 2010-2011 Rafael J. Wysocki <rjw@sisk.pl>, Novell Inc.
 Copyright (c) 2010 Alan Stern <stern@rowland.harvard.edu>
+Copyright (c) 2014 Intel Corp., Rafael J. Wysocki <rafael.j.wysocki@intel.com>
 
 
 Most of the code in Linux is device drivers, so most of the Linux power
@@ -326,6 +327,20 @@ the phases are:
 	driver in some way for the upcoming system power transition, but it
 	should not put the device into a low-power state.
 
+	For devices supporting runtime power management, the return value of the
+	prepare callback can be used to indicate to the PM core that it may
+	safely leave the device in runtime suspend (if runtime-suspended
+	already), provided that all of the device's descendants are also left in
+	runtime suspend.  Namely, if the prepare callback returns a positive
+	number and that happens for all of the descendants of the device too,
+	and all of them (including the device itself) are runtime-suspended, the
+	PM core will skip the suspend, suspend_late and	suspend_noirq suspend
+	phases as well as the resume_noirq, resume_early and resume phases of
+	the following system resume for all of these devices.	In that case,
+	the complete callback will be called directly after the prepare callback
+	and is entirely responsible for bringing the device back to the
+	functional state as appropriate.
+
     2.	The suspend methods should quiesce the device to stop it from performing
 	I/O.  They also may save the device registers and put it into the
 	appropriate low-power state, depending on the bus type the device is on,
@@ -400,12 +415,23 @@ When resuming from freeze, standby or me
 	the resume callbacks occur; it's not necessary to wait until the
 	complete phase.
 
+	Moreover, if the preceding prepare callback returned a positive number,
+	the device may have been left in runtime suspend throughout the whole
+	system suspend and resume (the suspend, suspend_late, suspend_noirq
+	phases of system suspend and the resume_noirq, resume_early, resume
+	phases of system resume may have been skipped for it).  In that case,
+	the complete callback is entirely responsible for bringing the device
+	back to the functional state after system suspend if necessary.  [For
+	example, it may need to queue up a runtime resume request for the device
+	for this purpose.]  To check if that is the case, the complete callback
+	can consult the device's power.direct_complete flag.  Namely, if that
+	flag is set when the complete callback is being run, it has been called
+	directly after the preceding prepare and special action may be required
+	to make the device work correctly afterward.
+
 At the end of these phases, drivers should be as functional as they were before
 suspending: I/O can be performed using DMA and IRQs, and the relevant clocks are
-gated on.  Even if the device was in a low-power state before the system sleep
-because of runtime power management, afterwards it should be back in its
-full-power state.  There are multiple reasons why it's best to do this; they are
-discussed in more detail in Documentation/power/runtime_pm.txt.
+gated on.
 
 However, the details here may again be platform-specific.  For example,
 some systems support multiple "run" states, and the mode in effect at
Index: linux-pm/Documentation/power/runtime_pm.txt
===================================================================
--- linux-pm.orig/Documentation/power/runtime_pm.txt
+++ linux-pm/Documentation/power/runtime_pm.txt
@@ -2,6 +2,7 @@ Runtime Power Management Framework for I
 
 (C) 2009-2011 Rafael J. Wysocki <rjw@sisk.pl>, Novell Inc.
 (C) 2010 Alan Stern <stern@rowland.harvard.edu>
+(C) 2014 Intel Corp., Rafael J. Wysocki <rafael.j.wysocki@intel.com>
 
 1. Introduction
 
@@ -444,6 +445,10 @@ drivers/base/power/runtime.c and include
   bool pm_runtime_status_suspended(struct device *dev);
     - return true if the device's runtime PM status is 'suspended'
 
+  bool pm_runtime_suspended_if_enabled(struct device *dev);
+    - return true if the device's runtime PM status is 'suspended' and its
+      'power.disable_depth' field is equal to 1
+
   void pm_runtime_allow(struct device *dev);
     - set the power.runtime_auto flag for the device and decrease its usage
       counter (used by the /sys/devices/.../power/control interface to
@@ -644,6 +649,18 @@ place (in particular, if the system is n
 be more efficient to leave the devices that had been suspended before the system
 suspend began in the suspended state.
 
+To this end, the PM core provides a mechanism allowing some coordination between
+different levels of device hierarchy.  Namely, if a system suspend .prepare()
+callback returns a positive number for a device, that indicates to the PM core
+that the device appears to be runtime-suspended and its state is fine, so it
+may be left in runtime suspend provided that all of its descendants are also
+left in runtime suspend.  If that happens, the PM core will not execute any
+system suspend and resume callbacks for all of those devices, except for the
+complete callback, which is then entirely responsible for handling the device
+as appropriate.  This only applies to system suspend transitions that are not
+related to hibernation (see Documentation/power/devices.txt for more
+information).
+
 The PM core does its best to reduce the probability of race conditions between
 the runtime PM and system suspend/resume (and hibernation) callbacks by carrying
 out the following operations:

