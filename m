Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803Ab3C2DWG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 23:22:06 -0400
Received: from mail-ia0-f182.google.com ([209.85.210.182]:52998 "EHLO
	mail-ia0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754628Ab3C2DWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 23:22:03 -0400
Date: Thu, 28 Mar 2013 21:22:00 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Roman Yepishev <roman.yepishev@gmail.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        e1000-devel@lists.sourceforge.net
Subject: Re: [PATCH] PCI: Remove not needed check in disable aspm link
Message-ID: <20130329032200.GA11990@google.com>
References: <CAE9FiQXmeb66dc8fET0y99BjqpUXp11c7utiQ5keR1Wf+N9xaA@mail.gmail.com>
 <1363628226-6679-1-git-send-email-yinghai@kernel.org>
 <CAErSpo6v0mj9=Q13d=G4hho0mb9XTcsmefzke9fROYmZ7oBWxQ@mail.gmail.com>
 <CAE9FiQU7cDzJdHxmqhJNgc9UCsRLgvCFQpv8+fLxD79pLEUC5A@mail.gmail.com>
 <CAErSpo4ncW8rkcpDiccORZedj30m7jRmpXK+amfDGn_wjwt7EA@mail.gmail.com>
 <CAE9FiQVqKag2TGah7x_1MAJ+c0UWgywgM_jKUoOnh+rq3bwBhg@mail.gmail.com>
 <CAE9FiQVMgdj5edbR4qZny29fV9-bW_We_G4Wpn_yruDLQZiQiQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQVMgdj5edbR4qZny29fV9-bW_We_G4Wpn_yruDLQZiQiQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Matthew]
[+cc e1000-devel@lists.sourceforge.net for suspected 82575/82598 regression]

On Thu, Mar 28, 2013 at 01:24:55PM -0700, Yinghai Lu wrote:
> patch for Roman
> 
> On Thu, Mar 28, 2013 at 1:24 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> > resending with adding To Roman.
> >
> > On Thu, Mar 28, 2013 at 5:46 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> >> This patch might be *safe*, but it (and the changelog) are completely
> >> unintelligible.
> >>
> >> The problem with applying an unintelligible stop-gap patch is that it
> >> becomes forever part of the changelog, and it's a huge waste of time
> >> to everybody who tries to understand the history later.  That's why I
> >> think it's worth spending some time to make a good patch now.
> >
> > Please check if attached patch is doing what you want.

Patch inlined below for convenience.

> Subject: [PATCH] PCI: Remove not needed check in disable aspm link
> 
> Roman reported ath5k does not work anymore on 3.8.
> Bisected to
> | commit 8c33f51df406e1a1f7fa4e9b244845b7ebd61fa6
> | Author: Taku Izumi <izumi.taku@jp.fujitsu.com>
> | Date:   Tue Oct 30 15:27:13 2012 +0900
> |
> |    PCI/ACPI: Request _OSC control before scanning PCI root bus
> |
> |    This patch moves up the code block to request _OSC control in order to
> |    separate ACPI work and PCI work in acpi_pci_root_add().
> 
> It make pci_disable_link_state does not work anymore as acpi_disabled
> is set before pci root bus scanning.
> It will skip that in quirks and pcie_aspm_sanity_check.

I think this regression has nothing to do with pci_disable_link_state().

When aspm_disabled is set, pci_disable_link_state() doesn't do anything.

In both 3.7 and 3.8, aspm_disabled is set in acpi_pci_root_add() before
any driver probe routines are run, so it looks like calling
pci_disable_link_state() from a driver had no effect even in 3.7.  This
is a problem, of course, but not the one Roman is seeing, because ath5k
calls pci_disable_link_state() from the driver probe routine.

There are also PCI_FIXUP_FINAL quirks for 82575 and 82598 NICs that call
pci_disable_link_state().  In 3.7, these quirks are run before
aspm_disabled is set, but 8c33f51d moved the pcie_no_aspm() call up
before we start scanning the bus, so in 3.8, aspm_disabled is set
*before* we run them.  I think that means 8c33f51d broke all these
quirks.  That's also a problem, of course, but this isn't the one Roman
is seeing either.

I think the problem Roman is seeing happens when
pcie_aspm_init_link_state() calls pcie_aspm_sanity_check() during device
enumeration.  In 3.8, the fact that aspm_disabled is already set by the
time we get here means we skip the check for pre-1.1 PCIe devices, and
I think *this* is what Roman is seeing.

I suspect the following hunk of your patch is enough to fix things for
Roman:

> --- linux-2.6.orig/drivers/pci/pcie/aspm.c
> +++ linux-2.6/drivers/pci/pcie/aspm.c
> @@ -493,15 +492,6 @@ static int pcie_aspm_sanity_check(struct
>  			return -EINVAL;
>  
>  		/*
> -		 * If ASPM is disabled then we're not going to change
> -		 * the BIOS state. It's safe to continue even if it's a
> -		 * pre-1.1 device
> -		 */
> -
> -		if (aspm_disabled)
> -			continue;
> -
> -		/*
>  		 * Disable ASPM for pre-1.1 PCIe device, we follow MS to use
>  		 * RBER bit to determine if a function is 1.1 version device
>  		 */

However, this test was added by Matthew in c9651e70, and I can't remove
it unless we have an explanation of why removing it will not reintroduce
the bug he was fixing.

This code is such a terrible mess that it's not surprising at all that
we have all these issues.  But there's too much to untangle in v3.9; all
we can hope for is to fix the regressions in v3.9 and clean it up later.

> We could revert to old logic, but that will make booting path and hotplug
> path with different aspm_disabled again.
> 
> Acctually we don't need to check aspm_disabled in disable link, as
> we already have protection about link state following.
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=55211
> http://article.gmane.org/gmane.linux.kernel.pci/20640
> 
> Need it for 3.8 stable.
> 
> -v2: more cleanup
> 	1. remove aspm_support_enabled, as if it compiled in, support is there
> 		so even user pass aspm=off, link_state still get allocated,
> 		then we will have chance to disable aspm on devices from
> 		buggy setting of BIOS.
> 	2. move pcie_no_aspm() calling for fadt disabling before scanning
> 		requested by Bjorn.
> 
> Reported-by: Roman Yepishev <roman.yepishev@gmail.com>
> Bisected-by: Roman Yepishev <roman.yepishev@gmail.com>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: Taku Izumi <izumi.taku@jp.fujitsu.com>
> Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
> 
> ---
>  drivers/acpi/pci_root.c  |   25 +++++++++---------------
>  drivers/pci/pcie/aspm.c  |   48 ++---------------------------------------------
>  include/linux/pci-aspm.h |    4 ---
>  include/linux/pci.h      |    2 -
>  4 files changed, 14 insertions(+), 65 deletions(-)
> 
> Index: linux-2.6/drivers/acpi/pci_root.c
> ===================================================================
> --- linux-2.6.orig/drivers/acpi/pci_root.c
> +++ linux-2.6/drivers/acpi/pci_root.c
> @@ -415,7 +415,6 @@ static int acpi_pci_root_add(struct acpi
>  	struct acpi_pci_root *root;
>  	struct acpi_pci_driver *driver;
>  	u32 flags, base_flags;
> -	bool is_osc_granted = false;
>  
>  	root = kzalloc(sizeof(struct acpi_pci_root), GFP_KERNEL);
>  	if (!root)
> @@ -494,6 +493,11 @@ static int acpi_pci_root_add(struct acpi
>  			flags = base_flags;
>  		}
>  	}
> +
> +	/* ASPM setting */
> +	if (acpi_gbl_FADT.boot_flags & ACPI_FADT_NO_ASPM)
> +		pcie_no_aspm();
> +
>  	if (!pcie_ports_disabled
>  	    && (flags & ACPI_PCIE_REQ_SUPPORT) == ACPI_PCIE_REQ_SUPPORT) {
>  		flags = OSC_PCI_EXPRESS_CAP_STRUCTURE_CONTROL
> @@ -513,16 +517,17 @@ static int acpi_pci_root_add(struct acpi
>  
>  		status = acpi_pci_osc_control_set(device->handle, &flags,
>  				       OSC_PCI_EXPRESS_CAP_STRUCTURE_CONTROL);
> -		if (ACPI_SUCCESS(status)) {
> -			is_osc_granted = true;
> +		if (ACPI_SUCCESS(status))
>  			dev_info(&device->dev,
>  				"ACPI _OSC control (0x%02x) granted\n", flags);
> -		} else {
> -			is_osc_granted = false;
> +		else {
>  			dev_info(&device->dev,
>  				"ACPI _OSC request failed (%s), "
>  				"returned control mask: 0x%02x\n",
>  				acpi_format_exception(status), flags);
> +			pr_info("ACPI _OSC control for PCIe not granted, "
> +				"disabling ASPM\n");
> +			pcie_no_aspm();
>  		}
>  	} else {
>  		dev_info(&device->dev,
> @@ -554,16 +559,6 @@ static int acpi_pci_root_add(struct acpi
>  		goto out_del_root;
>  	}
>  
> -	/* ASPM setting */
> -	if (is_osc_granted) {
> -		if (acpi_gbl_FADT.boot_flags & ACPI_FADT_NO_ASPM)
> -			pcie_clear_aspm(root->bus);
> -	} else {
> -		pr_info("ACPI _OSC control for PCIe not granted, "
> -			"disabling ASPM\n");
> -		pcie_no_aspm();
> -	}
> -
>  	pci_acpi_add_bus_pm_notifier(device, root->bus);
>  	if (device->wakeup.flags.run_wake)
>  		device_set_run_wake(root->bus->bridge, true);
> Index: linux-2.6/drivers/pci/pcie/aspm.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/pcie/aspm.c
> +++ linux-2.6/drivers/pci/pcie/aspm.c
> @@ -69,7 +69,6 @@ struct pcie_link_state {
>  };
>  
>  static int aspm_disabled, aspm_force;
> -static bool aspm_support_enabled = true;
>  static DEFINE_MUTEX(aspm_lock);
>  static LIST_HEAD(link_list);
>  
> @@ -493,15 +492,6 @@ static int pcie_aspm_sanity_check(struct
>  			return -EINVAL;
>  
>  		/*
> -		 * If ASPM is disabled then we're not going to change
> -		 * the BIOS state. It's safe to continue even if it's a
> -		 * pre-1.1 device
> -		 */
> -
> -		if (aspm_disabled)
> -			continue;
> -
> -		/*
>  		 * Disable ASPM for pre-1.1 PCIe device, we follow MS to use
>  		 * RBER bit to determine if a function is 1.1 version device
>  		 */
> @@ -556,9 +546,6 @@ void pcie_aspm_init_link_state(struct pc
>  	struct pcie_link_state *link;
>  	int blacklist = !!pcie_aspm_sanity_check(pdev);
>  
> -	if (!aspm_support_enabled)
> -		return;
> -
>  	if (!pci_is_pcie(pdev) || pdev->link_state)
>  		return;
>  	if (pci_pcie_type(pdev) != PCI_EXP_TYPE_ROOT_PORT &&
> @@ -718,15 +705,11 @@ void pcie_aspm_powersave_config_link(str
>   * pci_disable_link_state - disable pci device's link state, so the link will
>   * never enter specific states
>   */
> -static void __pci_disable_link_state(struct pci_dev *pdev, int state, bool sem,
> -				     bool force)
> +static void __pci_disable_link_state(struct pci_dev *pdev, int state, bool sem)
>  {
>  	struct pci_dev *parent = pdev->bus->self;
>  	struct pcie_link_state *link;
>  
> -	if (aspm_disabled && !force)
> -		return;
> -
>  	if (!pci_is_pcie(pdev))
>  		return;
>  
> @@ -757,34 +740,16 @@ static void __pci_disable_link_state(str
>  
>  void pci_disable_link_state_locked(struct pci_dev *pdev, int state)
>  {
> -	__pci_disable_link_state(pdev, state, false, false);
> +	__pci_disable_link_state(pdev, state, false);
>  }
>  EXPORT_SYMBOL(pci_disable_link_state_locked);
>  
>  void pci_disable_link_state(struct pci_dev *pdev, int state)
>  {
> -	__pci_disable_link_state(pdev, state, true, false);
> +	__pci_disable_link_state(pdev, state, true);
>  }
>  EXPORT_SYMBOL(pci_disable_link_state);
>  
> -void pcie_clear_aspm(struct pci_bus *bus)
> -{
> -	struct pci_dev *child;
> -
> -	if (aspm_force)
> -		return;
> -
> -	/*
> -	 * Clear any ASPM setup that the firmware has carried out on this bus
> -	 */
> -	list_for_each_entry(child, &bus->devices, bus_list) {
> -		__pci_disable_link_state(child, PCIE_LINK_STATE_L0S |
> -					 PCIE_LINK_STATE_L1 |
> -					 PCIE_LINK_STATE_CLKPM,
> -					 false, true);
> -	}
> -}
> -
>  static int pcie_aspm_set_policy(const char *val, struct kernel_param *kp)
>  {
>  	int i;
> @@ -944,7 +909,6 @@ static int __init pcie_aspm_disable(char
>  	if (!strcmp(str, "off")) {
>  		aspm_policy = POLICY_DEFAULT;
>  		aspm_disabled = 1;
> -		aspm_support_enabled = false;
>  		printk(KERN_INFO "PCIe ASPM is disabled\n");
>  	} else if (!strcmp(str, "force")) {
>  		aspm_force = 1;
> @@ -980,9 +944,3 @@ int pcie_aspm_enabled(void)
>         return !aspm_disabled;
>  }
>  EXPORT_SYMBOL(pcie_aspm_enabled);
> -
> -bool pcie_aspm_support_enabled(void)
> -{
> -	return aspm_support_enabled;
> -}
> -EXPORT_SYMBOL(pcie_aspm_support_enabled);
> Index: linux-2.6/include/linux/pci-aspm.h
> ===================================================================
> --- linux-2.6.orig/include/linux/pci-aspm.h
> +++ linux-2.6/include/linux/pci-aspm.h
> @@ -29,7 +29,6 @@ extern void pcie_aspm_pm_state_change(st
>  extern void pcie_aspm_powersave_config_link(struct pci_dev *pdev);
>  extern void pci_disable_link_state(struct pci_dev *pdev, int state);
>  extern void pci_disable_link_state_locked(struct pci_dev *pdev, int state);
> -extern void pcie_clear_aspm(struct pci_bus *bus);
>  extern void pcie_no_aspm(void);
>  #else
>  static inline void pcie_aspm_init_link_state(struct pci_dev *pdev)
> @@ -47,9 +46,6 @@ static inline void pcie_aspm_powersave_c
>  static inline void pci_disable_link_state(struct pci_dev *pdev, int state)
>  {
>  }
> -static inline void pcie_clear_aspm(struct pci_bus *bus)
> -{
> -}
>  static inline void pcie_no_aspm(void)
>  {
>  }
> Index: linux-2.6/include/linux/pci.h
> ===================================================================
> --- linux-2.6.orig/include/linux/pci.h
> +++ linux-2.6/include/linux/pci.h
> @@ -1168,7 +1168,7 @@ static inline int pcie_aspm_enabled(void
>  static inline bool pcie_aspm_support_enabled(void) { return false; }
>  #else
>  extern int pcie_aspm_enabled(void);
> -extern bool pcie_aspm_support_enabled(void);
> +static inline bool pcie_aspm_support_enabled(void) { return true; }
>  #endif
>  
>  #ifdef CONFIG_PCIEAER
