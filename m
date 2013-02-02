Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382Ab3BBWxZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 17:53:25 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:49827 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601Ab3BBWxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 17:53:13 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        e1000-devel@lists.sourceforge.net, linux-pci@vger.kernel.org,
        Dave Airlie <airlied@redhat.com>
Subject: Re: [PATCH 3/5] PCI: revert preparing for wakeup in runtime-suspend finalization
Date: Sat, 02 Feb 2013 23:59:27 +0100
Message-ID: <5674023.p1MahTPJ11@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc6; KDE/4.9.5; x86_64; ; )
In-Reply-To: <4112994.zQU2CRiGj6@vostro.rjw.lan>
References: <20130118113019.6698.25941.stgit@zurg> <510D0293.8030509@openvz.org> <4112994.zQU2CRiGj6@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, February 02, 2013 09:58:45 PM Rafael J. Wysocki wrote:
> On Saturday, February 02, 2013 04:12:03 PM Konstantin Khlebnikov wrote:
> > Rafael J. Wysocki wrote:
> > > On Tuesday, January 29, 2013 12:55:15 PM Rafael J. Wysocki wrote:
> > >> On Tuesday, January 29, 2013 11:04:57 AM Konstantin Khlebnikov wrote:
> > >>> Rafael J. Wysocki wrote:
> > >>>> On Monday, January 28, 2013 04:17:42 PM Bjorn Helgaas wrote:
> > >>>>> [+cc Rafael]
> > >>>>>
> > >>>>> On Fri, Jan 18, 2013 at 4:42 AM, Konstantin Khlebnikov
> > >>>>> <khlebnikov@openvz.org>   wrote:
> > >>>>>> This patch effectively reverts commit 42eca2302146fed51335b95128e949ee6f54478f
> > >>>>>> ("PCI: Don't touch card regs after runtime suspend D3")
> > >>>>>>
> > >>>>>> | This patch checks whether the pci state is saved and doesn't attempt to hit
> > >>>>>> | any registers after that point if it is.
> > >>>>>>
> > >>>>>> This seems completely wrong. Yes, PCI configuration space has been saved by
> > >>>>>> driver, but this doesn't means that all job is done and device has been
> > >>>>>> suspended and ready for waking up in the future.
> > >>>>>>
> > >>>>>> For example driver e1000e for ethernet in my thinkpad x220 saves pci-state
> > >>>>>> but device cannot wakeup after that, because it needs some ACPI callbacks
> > >>>>>> which usually called from pci_finish_runtime_suspend().
> > >>>>>>
> > >>>>>> | Optimus (dual-gpu) laptops seem to have their own form of D3cold, but
> > >>>>>> | unfortunately enter it on normal D3 transitions via the ACPI callback.
> > >>>>>>
> > >>>>>> Hardware which disappears from the bus unexpectedly is exception, so let's
> > >>>>>> handle it as an exception. Its driver should set device state to D3cold and
> > >>>>>> the rest code will handle it properly.
> > >>>>>
> > >>>>> Functions in D3cold don't have power, so it's completely expected that
> > >>>>> they would disappear from the bus and not respond to config accesses.
> > >>>>> Maybe Dave was referring to D3hot, where functions *should* respond to
> > >>>>> config accesses.  I dunno.
> > >>>>>
> > >>>>> Just to be clear, it sounds like 42eca230 caused a regression on your
> > >>>>> e1000e device?  If so, I guess we should revert it unless you and Dave
> > >>>>> can figure out a better patch that fixes both your e1000e device and
> > >>>>> the Optimus issue.
> > >>>>
> > >>>> Yes, if there's a regression, let's revert it, but I'd like the regression
> > >>>> to be described clearly.
> > >>>
> > >>> Yep, this is regression.
> > >>>
> > >>> commit 42eca2302146fed51335b95128e949ee6f54478f ("PCI: Don't touch
> > >>> card regs after runtime suspend D3") changes state convention during
> > >>> runtime-suspend transaction too much. If PCI configuration space
> > >>> has been saved by driver that does not means that all job is done
> > >>> and device has been suspended and ready for waking up in the future.
> > >>>
> > >>> e1000e saves pci-config space itself, but it requires operations which
> > >>> pci_finish_runtime_suspend() does: preparing for wake (calling particular
> > >>> platform pm-callbacks) and switching to proper sleep state.
> > >>
> > >> Well, I'd argue this is a bug in e1000e.  Why does it need to save the PCI
> > >> config space even though pci_pm_runtime_suspend() will do that anyway?
> > >
> > > I honestly don't think we should revert 42eca2302146 because of this.
> > >
> > > Yes, there is a requirement that drivers not save the PCI config space by
> > > themselves unless they want to do the whole power management by themselves too
> > > and e1000e is not following that.  So either we need to drop the
> > > pci_save_state() from __e1000_shutdown() which I would prefer (I'm not really
> > > sure why it is there), or e1000_runtime_suspend() needs to call
> > > pci_finish_runtime_suspend() by itself.
> > 
> > Yet another problem: some drivers calls pci_save_state() from ->probe() callback
> > to use this saved state in pci_error_handlers->slot_reset().
> > As result pdev->state_saved is true mostly all time.
> > At least e1000e and drivers/pci/pcie/portdrv_pci.c are doing this.
> > 
> > I think it will be safer to revert 42eca2302146 in v3.8
> 
> Well, I wonder if we can just do something like the appended patch instead and
> address the e1000e runtime suspend by calling pci_finish_runtime_suspend()
> directly from e1000_runtime_suspend().
> 
> While we can revert commit 42eca2302146, that hardly would be progress,
> because then the issue it was supposed to address would still need to be
> addressed somehow.
> 
> ---
>  drivers/pci/pci-driver.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> Index: linux-pm/drivers/pci/pci-driver.c
> ===================================================================
> --- linux-pm.orig/drivers/pci/pci-driver.c
> +++ linux-pm/drivers/pci/pci-driver.c
> @@ -628,6 +628,7 @@ static int pci_pm_suspend(struct device
>  		goto Fixup;
>  	}
>  
> +	pci_dev->state_saved = false;
>  	if (pm->suspend) {
>  		pci_power_t prev = pci_dev->current_state;
>  		int error;
> @@ -774,6 +775,7 @@ static int pci_pm_freeze(struct device *
>  		return 0;
>  	}
>  
> +	pci_dev->state_saved = false;
>  	if (pm->freeze) {
>  		int error;
>  
> @@ -862,6 +864,7 @@ static int pci_pm_poweroff(struct device
>  		goto Fixup;
>  	}
>  
> +	pci_dev->state_saved = false;
>  	if (pm->poweroff) {
>  		int error;
>  
> @@ -987,6 +990,7 @@ static int pci_pm_runtime_suspend(struct
>  	if (!pm || !pm->runtime_suspend)
>  		return -ENOSYS;
>  
> +	pci_dev->state_saved = false;
>  	pci_dev->no_d3cold = false;
>  	error = pm->runtime_suspend(dev);
>  	suspend_report_result(pm->runtime_suspend, error);

For completness, on top of the above one.

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



-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
