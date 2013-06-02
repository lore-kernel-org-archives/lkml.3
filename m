Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393Ab3FBVpq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 17:45:46 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:56961 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753315Ab3FBVpl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 17:45:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Kevin Hilman <khilman@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 2/2] PM / Runtime: Update .runtime_idle() callback documentation
Date: Sun, 02 Jun 2013 23:53:27 +0200
Message-ID: <5059437.HIXCbxAemz@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <2033252.LiVeuYIhnT@vostro.rjw.lan>
References: <Pine.LNX.4.44L0.1305301247370.1137-100000@iolanthe.rowland.org> <2033252.LiVeuYIhnT@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

Runtime PM documentation needs to be updated after the previous
change of the rpm_idle() behavior, so modify it as appropriate.

[rjw: Subject and changelog]
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

Index: usb-3.10/Documentation/power/runtime_pm.txt
===================================================================
--- usb-3.10.orig/Documentation/power/runtime_pm.txt
+++ usb-3.10/Documentation/power/runtime_pm.txt
@@ -144,8 +144,12 @@ The action performed by the idle callbac
 (or driver) in question, but the expected and recommended action is to check
 if the device can be suspended (i.e. if all of the conditions necessary for
 suspending the device are satisfied) and to queue up a suspend request for the
-device in that case.  The value returned by this callback is ignored by the PM
-core.
+device in that case.  If there is no idle callback, or if the callback returns
+0, then the PM core will attempt to carry out a runtime suspend of the device;
+in essence, it will call pm_runtime_suspend() directly.  To prevent this (for
+example, if the callback routine has started a delayed suspend), the routine
+should return a non-zero value.  Negative error return codes are ignored by the
+PM core.
 
 The helper functions provided by the PM core, described in Section 4, guarantee
 that the following constraints are met with respect to runtime PM callbacks for
@@ -301,9 +305,10 @@ drivers/base/power/runtime.c and include
       removing the device from device hierarchy
 
   int pm_runtime_idle(struct device *dev);
-    - execute the subsystem-level idle callback for the device; returns 0 on
-      success or error code on failure, where -EINPROGRESS means that
-      ->runtime_idle() is already being executed
+    - execute the subsystem-level idle callback for the device; returns an
+      error code on failure, where -EINPROGRESS means that ->runtime_idle() is
+      already being executed; if there is no callback or the callback returns 0
+      then run pm_runtime_suspend(dev) and return its result
 
   int pm_runtime_suspend(struct device *dev);
     - execute the subsystem-level suspend callback for the device; returns 0 on

