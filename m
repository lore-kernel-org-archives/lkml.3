Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183Ab3BBW6d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 17:58:33 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:49878 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751611Ab3BBW6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 17:58:31 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Borislav Petkov <bp@suse.de>
Cc: Jiri Slaby <jslaby@suse.cz>, Borislav Petkov <bp@alien8.de>,
        Bjorn Helgaas <bhelgaas@google.com>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: Re: Uhhuh. NMI received for unknown reason 2c on CPU 0.
Date: Sun, 03 Feb 2013 00:04:46 +0100
Message-ID: <2293454.v8QRHr8txR@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc6; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130131131034.GF4926@pd.tnic>
References: <20130129202848.GE25415@pd.tnic> <3066730.6MVSAfNyye@vostro.rjw.lan> <20130131131034.GF4926@pd.tnic>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart12599168.djPLoo6RXv"
Content-Transfer-Encoding: 7Bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--nextPart12599168.djPLoo6RXv
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"

On Thursday, January 31, 2013 02:10:34 PM Borislav Petkov wrote:
> On Thu, Jan 31, 2013 at 02:12:58PM +0100, Rafael J. Wysocki wrote:
> > Yes, there are two bugs in e1000e, it appears. Konstantin's
> > patch [2/5] fixes one of them, but the other one has to be fixed
> > differently.
> >
> > Boris, would you be able to test a couple of e1000e patches for me?
> 
> Sure, send them on. You can add 2/5 in the mix too.

There you go.

The [2/5] is at: https://patchwork.kernel.org/patch/2001211/

The other two are attached.  I suppose the ordering doesn't matter.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
--nextPart12599168.djPLoo6RXv
Content-Disposition: attachment; filename="pci-pm-fix-e1000e-runtime-suspend.patch"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="UTF-8"; name="pci-pm-fix-e1000e-runtime-suspend.patch"

---
 drivers/net/ethernet/intel/e1000e/netdev.c |    1 +
 drivers/pci/pci.c                          |    1 +
 drivers/pci/pci.h                          |    1 -
 include/linux/pci.h                        |    1 +
 4 files changed, 3 insertions(+), 1 deletion(-)

Index: linux-pm/drivers/pci/pci.c
===================================================================
--- linux-pm.orig/drivers/pci/pci.c
+++ linux-pm/drivers/pci/pci.c
@@ -1840,6 +1840,7 @@ int pci_finish_runtime_suspend(struct pc
 
 	return error;
 }
+EXPORT_SYMBOL_GPL(pci_finish_runtime_suspend);
 
 /**
  * pci_dev_run_wake - Check if device can generate run-time wake-up events.
Index: linux-pm/drivers/pci/pci.h
===================================================================
--- linux-pm.orig/drivers/pci/pci.h
+++ linux-pm/drivers/pci/pci.h
@@ -64,7 +64,6 @@ extern int pci_set_platform_pm(struct pc
 extern void pci_update_current_state(struct pci_dev *dev, pci_power_t state);
 extern void pci_power_up(struct pci_dev *dev);
 extern void pci_disable_enabled_device(struct pci_dev *dev);
-extern int pci_finish_runtime_suspend(struct pci_dev *dev);
 extern int __pci_pme_wakeup(struct pci_dev *dev, void *ign);
 extern void pci_wakeup_bus(struct pci_bus *bus);
 extern void pci_config_pm_runtime_get(struct pci_dev *dev);
Index: linux-pm/include/linux/pci.h
===================================================================
--- linux-pm.orig/include/linux/pci.h
+++ linux-pm/include/linux/pci.h
@@ -936,6 +936,7 @@ int pci_back_from_sleep(struct pci_dev *
 bool pci_dev_run_wake(struct pci_dev *dev);
 bool pci_check_pme_status(struct pci_dev *dev);
 void pci_pme_wakeup_bus(struct pci_bus *bus);
+int pci_finish_runtime_suspend(struct pci_dev *dev);
 
 static inline int pci_enable_wake(struct pci_dev *dev, pci_power_t state,
 				  bool enable)
Index: linux-pm/drivers/net/ethernet/intel/e1000e/netdev.c
===================================================================
--- linux-pm.orig/drivers/net/ethernet/intel/e1000e/netdev.c
+++ linux-pm/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -5696,6 +5696,7 @@ static int e1000_runtime_suspend(struct
 		bool wake;
 
 		__e1000_shutdown(pdev, &wake, true);
+		pci_finish_runtime_suspend(pdev);
 	}
 
 	return 0;

--nextPart12599168.djPLoo6RXv
Content-Disposition: attachment; filename="pci-pm-clear-state_saved-during-suspend.patch"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="UTF-8"; name="pci-pm-clear-state_saved-during-suspend.patch"

---
 drivers/pci/pci-driver.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-pm/drivers/pci/pci-driver.c
===================================================================
--- linux-pm.orig/drivers/pci/pci-driver.c
+++ linux-pm/drivers/pci/pci-driver.c
@@ -628,6 +628,7 @@ static int pci_pm_suspend(struct device
 		goto Fixup;
 	}
 
+	pci_dev->state_saved = false;
 	if (pm->suspend) {
 		pci_power_t prev = pci_dev->current_state;
 		int error;
@@ -774,6 +775,7 @@ static int pci_pm_freeze(struct device *
 		return 0;
 	}
 
+	pci_dev->state_saved = false;
 	if (pm->freeze) {
 		int error;
 
@@ -862,6 +864,7 @@ static int pci_pm_poweroff(struct device
 		goto Fixup;
 	}
 
+	pci_dev->state_saved = false;
 	if (pm->poweroff) {
 		int error;
 
@@ -987,6 +990,7 @@ static int pci_pm_runtime_suspend(struct
 	if (!pm || !pm->runtime_suspend)
 		return -ENOSYS;
 
+	pci_dev->state_saved = false;
 	pci_dev->no_d3cold = false;
 	error = pm->runtime_suspend(dev);
 	suspend_report_result(pm->runtime_suspend, error);

--nextPart12599168.djPLoo6RXv--

