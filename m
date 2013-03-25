Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932485Ab3CYQ7E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 12:59:04 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:59807 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932231Ab3CYQ7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 12:59:02 -0400
MIME-Version: 1.0
In-Reply-To: <s5h38vqjhk6.wl%tiwai@suse.de>
References: <s5h38vqjhk6.wl%tiwai@suse.de>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 25 Mar 2013 10:58:40 -0600
Message-ID: <CAErSpo57ObGbTwLV+ji4bAtGBfT4=Y3wK1mFQdQGAx9oBcRZww@mail.gmail.com>
Subject: Re: [PATCH] pciehp: Add pciehp_surprise module option
To: Takashi Iwai <tiwai@suse.de>
Cc: Oliver Neukum <oneukum@suse.de>, Michal Marek <mmarek@suse.cz>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 8:02 AM, Takashi Iwai <tiwai@suse.de> wrote:
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

Can you point us at these bug reports, e.g., with URLs?  Hopefully
they will contain complete dmesg logs and "lspci -vv" outputs so we
can debug this a bit more.

I'm strongly opposed to adding a module option to work around this
issue because the user experience is unacceptable.  We can't expect
users to debug the problem and discover the option.

I'm also opposed to a DMI quirk system because I think it's very
likely that this device works correctly under Windows, and I doubt
very much that Windows has to include the equivalent of DMI quirks.
So we should, at least in principle, be able to figure out how to make
it work, too.

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
>  #define dbg(format, arg...)                                            \
>  do {                                                                   \
> @@ -122,7 +123,7 @@ struct controller {
>  #define MRL_SENS(ctrl)         ((ctrl)->slot_cap & PCI_EXP_SLTCAP_MRLSP)
>  #define ATTN_LED(ctrl)         ((ctrl)->slot_cap & PCI_EXP_SLTCAP_AIP)
>  #define PWR_LED(ctrl)          ((ctrl)->slot_cap & PCI_EXP_SLTCAP_PIP)
> -#define HP_SUPR_RM(ctrl)       ((ctrl)->slot_cap & PCI_EXP_SLTCAP_HPS)
> +#define HP_SUPR_RM(ctrl)       (pciehp_surprise || ((ctrl)->slot_cap & PCI_EXP_SLTCAP_HPS))
>  #define EMI(ctrl)              ((ctrl)->slot_cap & PCI_EXP_SLTCAP_EIP)
>  #define NO_CMD_CMPL(ctrl)      ((ctrl)->slot_cap & PCI_EXP_SLTCAP_NCCS)
>  #define PSN(ctrl)              ((ctrl)->slot_cap >> 19)
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
>  #define DRIVER_VERSION "0.4"
>  #define DRIVER_AUTHOR  "Dan Zink <dan.zink@compaq.com>, Greg Kroah-Hartman <greg@kroah.com>, Dely Sy <dely.l.sy@intel.com>"
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
> --
> 1.8.2
>
