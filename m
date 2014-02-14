Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918AbaBNVgN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 16:36:13 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:34031 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354AbaBNVgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 16:36:11 -0500
MIME-Version: 1.0
In-Reply-To: <52FE89FF.4020700@gmail.com>
References: <52FE89FF.4020700@gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 14 Feb 2014 14:35:51 -0700
Message-ID: <CAErSpo4YwCaS+zc50L8PMO5nx9XscEua7nHXqM3eR3XzG4TtJQ@mail.gmail.com>
Subject: Re: [PATCH] pciehp: Display the link state change reporting capability
To: Rajat Jain <rajatxjain@gmail.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rajat Jain <rajatjain@juniper.net>, Guenter Roeck <groeck@juniper.net>,
        Alex Williamson <alex.williamson@redhat.com>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 2:26 PM, Rajat Jain <rajatxjain@gmail.com> wrote:
> With recent addition of Link state change based hot-plug, it makes
> sense to display this capability in dbg_ctrl() addition to others.
>
> (Also move the call to dbg_ctrl() further down untill after the value
> is populated in ctrl->link_active_reporting)
>
> Signed-off-by: Rajat Jain <rajatxjain@gmail.com>
> Signed-off-by: Rajat Jain <rajatjain@juniper.net>
> Signed-off-by: Guenter Roeck <groeck@juniper.net>

This is fine as it is, but I'd like to get rid of dbg_ctrl()
altogether someday.  I made pcie_init() more verbose with afe2478f2e3f
("PCI: pciehp: Announce slot capabilities (slot #, button, LEDs,
etc)"), and it does include the PCI_EXP_LNKCAP_DLLLARC info.

Is there anything important left in dbg_ctrl() that we don't already
print elsewhere?  The PCI core prints the vendor/device and BAR info.
Of course, we don't print the entire capabilities/status/control words
anywhere else.  Is that important?

> ---
>  drivers/pci/hotplug/pciehp_hpc.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/pci/hotplug/pciehp_hpc.c b/drivers/pci/hotplug/pciehp_hpc.c
> index da4b020..cbe8e924 100644
> --- a/drivers/pci/hotplug/pciehp_hpc.c
> +++ b/drivers/pci/hotplug/pciehp_hpc.c
> @@ -747,6 +747,8 @@ static inline void dbg_ctrl(struct controller *ctrl)
>                   EMI(ctrl)        ? "yes" : "no");
>         ctrl_info(ctrl, "  Command Completed    : %3s\n",
>                   NO_CMD_CMPL(ctrl) ? "no" : "yes");
> +       ctrl_info(ctrl, "  Link Change Reporting: %3s\n",
> +                 ctrl->link_active_reporting ? "yes" : "no");
>         pcie_capability_read_word(pdev, PCI_EXP_SLTSTA, &reg16);
>         ctrl_info(ctrl, "Slot Status            : 0x%04x\n", reg16);
>         pcie_capability_read_word(pdev, PCI_EXP_SLTCTL, &reg16);
> @@ -771,7 +773,6 @@ struct controller *pcie_init(struct pcie_device *dev)
>         ctrl->slot_cap = slot_cap;
>         mutex_init(&ctrl->ctrl_lock);
>         init_waitqueue_head(&ctrl->queue);
> -       dbg_ctrl(ctrl);
>         /*
>          * Controller doesn't notify of command completion if the "No
>          * Command Completed Support" bit is set in Slot Capability
> @@ -784,10 +785,9 @@ struct controller *pcie_init(struct pcie_device *dev)
>
>          /* Check if Data Link Layer Link Active Reporting is implemented */
>          pcie_capability_read_dword(pdev, PCI_EXP_LNKCAP, &link_cap);
> -        if (link_cap & PCI_EXP_LNKCAP_DLLLARC) {
> -                ctrl_dbg(ctrl, "Link Active Reporting supported\n");
> +       if (link_cap & PCI_EXP_LNKCAP_DLLLARC)
>                  ctrl->link_active_reporting = 1;
> -        }
> +       dbg_ctrl(ctrl);
>
>         /* Clear all remaining event bits in Slot Status register */
>         pcie_capability_write_word(pdev, PCI_EXP_SLTSTA,
> --
> 1.7.9.5
>
