Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970Ab3BCMvO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 07:51:14 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:54688 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752151Ab3BCMvL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 07:51:11 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        e1000-devel@lists.sourceforge.net, linux-pci@vger.kernel.org,
        Dave Airlie <airlied@redhat.com>
Subject: Re: [PATCH 3/5] PCI: revert preparing for wakeup in runtime-suspend finalization
Date: Sun, 03 Feb 2013 13:57:25 +0100
Message-ID: <1628839.R4n9fVjxNH@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc6; KDE/4.9.5; x86_64; ; )
In-Reply-To: <510E3896.9060401@openvz.org>
References: <20130118113019.6698.25941.stgit@zurg> <5674023.p1MahTPJ11@vostro.rjw.lan> <510E3896.9060401@openvz.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, February 03, 2013 02:14:46 PM Konstantin Khlebnikov wrote:
> Rafael J. Wysocki wrote:
> > On Saturday, February 02, 2013 09:58:45 PM Rafael J. Wysocki wrote:
> >> On Saturday, February 02, 2013 04:12:03 PM Konstantin Khlebnikov wrote:
> >>> Rafael J. Wysocki wrote:
> >>>> On Tuesday, January 29, 2013 12:55:15 PM Rafael J. Wysocki wrote:
> >>>>> On Tuesday, January 29, 2013 11:04:57 AM Konstantin Khlebnikov wrote:
> >>>>>> Rafael J. Wysocki wrote:
> >>>>>>> On Monday, January 28, 2013 04:17:42 PM Bjorn Helgaas wrote:
> >>>>>>>> [+cc Rafael]
> >>>>>>>>
> >>>>>>>> On Fri, Jan 18, 2013 at 4:42 AM, Konstantin Khlebnikov
> >>>>>>>> <khlebnikov@openvz.org>    wrote:
> >>>>>>>>> This patch effectively reverts commit 42eca2302146fed51335b95128e949ee6f54478f
> >>>>>>>>> ("PCI: Don't touch card regs after runtime suspend D3")
> >>>>>>>>>
> >>>>>>>>> | This patch checks whether the pci state is saved and doesn't attempt to hit
> >>>>>>>>> | any registers after that point if it is.
> >>>>>>>>>
> >>>>>>>>> This seems completely wrong. Yes, PCI configuration space has been saved by
> >>>>>>>>> driver, but this doesn't means that all job is done and device has been
> >>>>>>>>> suspended and ready for waking up in the future.
> >>>>>>>>>
> >>>>>>>>> For example driver e1000e for ethernet in my thinkpad x220 saves pci-state
> >>>>>>>>> but device cannot wakeup after that, because it needs some ACPI callbacks
> >>>>>>>>> which usually called from pci_finish_runtime_suspend().
> >>>>>>>>>
> >>>>>>>>> | Optimus (dual-gpu) laptops seem to have their own form of D3cold, but
> >>>>>>>>> | unfortunately enter it on normal D3 transitions via the ACPI callback.
> >>>>>>>>>
> >>>>>>>>> Hardware which disappears from the bus unexpectedly is exception, so let's
> >>>>>>>>> handle it as an exception. Its driver should set device state to D3cold and
> >>>>>>>>> the rest code will handle it properly.
> >>>>>>>>
> >>>>>>>> Functions in D3cold don't have power, so it's completely expected that
> >>>>>>>> they would disappear from the bus and not respond to config accesses.
> >>>>>>>> Maybe Dave was referring to D3hot, where functions *should* respond to
> >>>>>>>> config accesses.  I dunno.
> >>>>>>>>
> >>>>>>>> Just to be clear, it sounds like 42eca230 caused a regression on your
> >>>>>>>> e1000e device?  If so, I guess we should revert it unless you and Dave
> >>>>>>>> can figure out a better patch that fixes both your e1000e device and
> >>>>>>>> the Optimus issue.
> >>>>>>>
> >>>>>>> Yes, if there's a regression, let's revert it, but I'd like the regression
> >>>>>>> to be described clearly.
> >>>>>>
> >>>>>> Yep, this is regression.
> >>>>>>
> >>>>>> commit 42eca2302146fed51335b95128e949ee6f54478f ("PCI: Don't touch
> >>>>>> card regs after runtime suspend D3") changes state convention during
> >>>>>> runtime-suspend transaction too much. If PCI configuration space
> >>>>>> has been saved by driver that does not means that all job is done
> >>>>>> and device has been suspended and ready for waking up in the future.
> >>>>>>
> >>>>>> e1000e saves pci-config space itself, but it requires operations which
> >>>>>> pci_finish_runtime_suspend() does: preparing for wake (calling particular
> >>>>>> platform pm-callbacks) and switching to proper sleep state.
> >>>>>
> >>>>> Well, I'd argue this is a bug in e1000e.  Why does it need to save the PCI
> >>>>> config space even though pci_pm_runtime_suspend() will do that anyway?
> >>>>
> >>>> I honestly don't think we should revert 42eca2302146 because of this.
> >>>>
> >>>> Yes, there is a requirement that drivers not save the PCI config space by
> >>>> themselves unless they want to do the whole power management by themselves too
> >>>> and e1000e is not following that.  So either we need to drop the
> >>>> pci_save_state() from __e1000_shutdown() which I would prefer (I'm not really
> >>>> sure why it is there), or e1000_runtime_suspend() needs to call
> >>>> pci_finish_runtime_suspend() by itself.
> >>>
> >>> Yet another problem: some drivers calls pci_save_state() from ->probe() callback
> >>> to use this saved state in pci_error_handlers->slot_reset().
> >>> As result pdev->state_saved is true mostly all time.
> >>> At least e1000e and drivers/pci/pcie/portdrv_pci.c are doing this.
> >>>
> >>> I think it will be safer to revert 42eca2302146 in v3.8
> >>
> >> Well, I wonder if we can just do something like the appended patch instead and
> >> address the e1000e runtime suspend by calling pci_finish_runtime_suspend()
> >> directly from e1000_runtime_suspend().
> >>
> >> While we can revert commit 42eca2302146, that hardly would be progress,
> >> because then the issue it was supposed to address would still need to be
> >> addressed somehow.
> >>
> >> ---
> >>   drivers/pci/pci-driver.c |    4 ++++
> >>   1 file changed, 4 insertions(+)
> >>
> >> Index: linux-pm/drivers/pci/pci-driver.c
> >> ===================================================================
> >> --- linux-pm.orig/drivers/pci/pci-driver.c
> >> +++ linux-pm/drivers/pci/pci-driver.c
> >> @@ -628,6 +628,7 @@ static int pci_pm_suspend(struct device
> >>   		goto Fixup;
> >>   	}
> >>
> >> +	pci_dev->state_saved = false;
> >>   	if (pm->suspend) {
> >>   		pci_power_t prev = pci_dev->current_state;
> >>   		int error;
> >> @@ -774,6 +775,7 @@ static int pci_pm_freeze(struct device *
> >>   		return 0;
> >>   	}
> >>
> >> +	pci_dev->state_saved = false;
> >>   	if (pm->freeze) {
> >>   		int error;
> >>
> >> @@ -862,6 +864,7 @@ static int pci_pm_poweroff(struct device
> >>   		goto Fixup;
> >>   	}
> >>
> >> +	pci_dev->state_saved = false;
> >>   	if (pm->poweroff) {
> >>   		int error;
> >>
> >> @@ -987,6 +990,7 @@ static int pci_pm_runtime_suspend(struct
> >>   	if (!pm || !pm->runtime_suspend)
> >>   		return -ENOSYS;
> >>
> >> +	pci_dev->state_saved = false;
> >>   	pci_dev->no_d3cold = false;
> >>   	error = pm->runtime_suspend(dev);
> >>   	suspend_report_result(pm->runtime_suspend, error);
> >
> > For completness, on top of the above one.
> 
> I would prefer to remove pci_save_state() from e1000e_runtime_suspend().
> 
> --- a/drivers/net/ethernet/intel/e1000e/netdev.c
> +++ b/drivers/net/ethernet/intel/e1000e/netdev.c
> @@ -5429,9 +5429,11 @@ static int __e1000_shutdown(struct pci_dev *pdev, bool *enable_wake,
>          }
>          e1000e_reset_interrupt_capability(adapter);
> 
> -       retval = pci_save_state(pdev);
> -       if (retval)
> -               return retval;
> +       if (!runtime) {
> +               retval = pci_save_state(pdev);
> +               if (retval)
> +                       return retval;
> +       }
> 
>          status = er32(STATUS);
>          if (status & E1000_STATUS_LU)

Well, I'm not sure if it's necessary to do the pci_save_state() for !runtime
here (i.e. why don't we remove it entirely?), but I'm fine with this change. :-)

> I found another problem in e1000e: it does not calls pci_enable_master()
> in 'resume' functions, but it disables 'bus-mastering' on suspending.
> Thus if pci_save_state() is called after clearing that bit whole device
> wouldn't work after resuming.
> 
> --- a/drivers/net/ethernet/intel/e1000e/netdev.c
> +++ b/drivers/net/ethernet/intel/e1000e/netdev.c
> @@ -5598,6 +5598,7 @@ static int __e1000_resume(struct pci_dev *pdev)
> 
>          pci_set_power_state(pdev, PCI_D0);
>          pci_restore_state(pdev);
> +       pci_set_master(pdev);
>          pci_save_state(pdev);
> 
>          err = pci_enable_device_mem(pdev);
> 

Yeah.  Perhaps you can fold this change into your [2/5]?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
