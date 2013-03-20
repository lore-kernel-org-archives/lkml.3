Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932356Ab3CTSKA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 14:10:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40141 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752636Ab3CTSJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 14:09:58 -0400
Message-ID: <1363802953.24132.513.camel@bling.home>
Subject: Re: [PATCH] pciehp: Add pciehp_surprise module option
From: Alex Williamson <alex.williamson@redhat.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Oliver Neukum <oneukum@suse.de>,
        Michal Marek <mmarek@suse.cz>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 20 Mar 2013 12:09:13 -0600
In-Reply-To: <s5h38vqjhk6.wl%tiwai@suse.de>
References: <s5h38vqjhk6.wl%tiwai@suse.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-20 at 15:02 +0100, Takashi Iwai wrote:
> We encountered a problem that on some HP machines the Realtek PCI-e
> card reader device appears only when you inserted a card before the
> cold boot.  While debugging, it turned out that the device is actually
> handled via PCI-e hotplug in some level.  The device sends a presence
> change notification, and pciehp receives it, but it's ignored because
> of lack of the hotplug surprise (PCI_EXP_SLTCAP_HPS) capability bit.
> Once when this check passes, everything starts working -- the device
> appears upon plugging the card properly.
> 
> There are a few other bug reports indicating the similar problems
> (e.g. on recent Dell laptops), and I guess the culprit is same.
> 
> This patch adds a new module option, pciehp_surprise, to pciehp as a
> workaround.  When pciehp_surprise=1 is given, pciehp handles the
> presence change as the device on/off as if PCI_EXP_SLTCAP_HPS is set.
> Unless it's set explicitly, there is no impact on the existing
> behavior.
> 
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> ---
>  drivers/pci/hotplug/pciehp.h      | 3 ++-
>  drivers/pci/hotplug/pciehp_core.c | 3 +++
>  2 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/pci/hotplug/pciehp.h b/drivers/pci/hotplug/pciehp.h
> index 2c113de..314f3be 100644
> --- a/drivers/pci/hotplug/pciehp.h
> +++ b/drivers/pci/hotplug/pciehp.h
> @@ -44,6 +44,7 @@ extern bool pciehp_poll_mode;
>  extern int pciehp_poll_time;
>  extern bool pciehp_debug;
>  extern bool pciehp_force;
> +extern bool pciehp_surprise;
>  
>  #define dbg(format, arg...)						\
>  do {									\
> @@ -122,7 +123,7 @@ struct controller {
>  #define MRL_SENS(ctrl)		((ctrl)->slot_cap & PCI_EXP_SLTCAP_MRLSP)
>  #define ATTN_LED(ctrl)		((ctrl)->slot_cap & PCI_EXP_SLTCAP_AIP)
>  #define PWR_LED(ctrl)		((ctrl)->slot_cap & PCI_EXP_SLTCAP_PIP)
> -#define HP_SUPR_RM(ctrl)	((ctrl)->slot_cap & PCI_EXP_SLTCAP_HPS)
> +#define HP_SUPR_RM(ctrl)	(pciehp_surprise || ((ctrl)->slot_cap & PCI_EXP_SLTCAP_HPS))
>  #define EMI(ctrl)		((ctrl)->slot_cap & PCI_EXP_SLTCAP_EIP)
>  #define NO_CMD_CMPL(ctrl)	((ctrl)->slot_cap & PCI_EXP_SLTCAP_NCCS)
>  #define PSN(ctrl)		((ctrl)->slot_cap >> 19)
> diff --git a/drivers/pci/hotplug/pciehp_core.c b/drivers/pci/hotplug/pciehp_core.c
> index 7d72c5e..c3a574e 100644
> --- a/drivers/pci/hotplug/pciehp_core.c
> +++ b/drivers/pci/hotplug/pciehp_core.c
> @@ -42,6 +42,7 @@ bool pciehp_debug;
>  bool pciehp_poll_mode;
>  int pciehp_poll_time;
>  bool pciehp_force;
> +bool pciehp_surprise;
>  
>  #define DRIVER_VERSION	"0.4"
>  #define DRIVER_AUTHOR	"Dan Zink <dan.zink@compaq.com>, Greg Kroah-Hartman <greg@kroah.com>, Dely Sy <dely.l.sy@intel.com>"
> @@ -55,10 +56,12 @@ module_param(pciehp_debug, bool, 0644);
>  module_param(pciehp_poll_mode, bool, 0644);
>  module_param(pciehp_poll_time, int, 0644);
>  module_param(pciehp_force, bool, 0644);
> +module_param(pciehp_surprise, bool, 0644);
>  MODULE_PARM_DESC(pciehp_debug, "Debugging mode enabled or not");
>  MODULE_PARM_DESC(pciehp_poll_mode, "Using polling mechanism for hot-plug events or not");
>  MODULE_PARM_DESC(pciehp_poll_time, "Polling mechanism frequency, in seconds");
>  MODULE_PARM_DESC(pciehp_force, "Force pciehp, even if OSHP is missing");
> +MODULE_PARM_DESC(pciehp_surprise, "Force to set hotplug-surprise capability");
>  
>  #define PCIE_MODULE_NAME "pciehp"
>  

Please no.  Can we quirk just the device with the problem?  My issue
with turning on surprise hotplug across the system is that secondary bus
resets will trigger a device hot unplug, hot re-plug.  I have a system
with an integrated broadcom NIC behind a root port that claims to
support surprise hotplug (even though this NIC is soldered to the
motherboard) and it's nearly impossible to use it with KVM device
assignment because the struct pci_dev goes away as we're trying to use
it.  This patch is only going to make that problem more widespread.
Thanks,

Alex

