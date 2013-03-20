Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932898Ab3CTSlo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 14:41:44 -0400
Received: from fold.natur.cuni.cz ([195.113.57.32]:36123 "HELO
	fold.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754263Ab3CTSlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 14:41:42 -0400
Message-ID: <514A02E2.9030700@fold.natur.cuni.cz>
Date: Wed, 20 Mar 2013 19:41:38 +0100
From: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20100101 Firefox/19.0 SeaMonkey/2.16
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>, Bjorn Helgaas <bhelgaas@google.com>
CC: Oliver Neukum <oneukum@suse.de>, Michal Marek <mmarek@suse.cz>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pciehp: Add pciehp_surprise module option
References: <s5h38vqjhk6.wl%tiwai@suse.de>
In-Reply-To: <s5h38vqjhk6.wl%tiwai@suse.de>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Takashi,
  would you please describe your test system in more detail? How
about 'lspci -tv'? And 'lsusb -v' of the broken device?

1. For me on Dell Vostro 3550 with a SandyBridge chip doing all SATA+USB2+ExpressCardSlot:

00:00.0 Host bridge: Intel Corporation 2nd Generation Core Processor Family DRAM Controller (rev 09)
00:02.0 VGA compatible controller: Intel Corporation 2nd Generation Core Processor Family Integrated Graphics Controller (rev 09) (prog-if 00 [VGA controller])
00:16.0 Communication controller: Intel Corporation 6 Series/C200 Series Chipset Family MEI Controller #1 (rev 04)
00:1a.0 USB controller: Intel Corporation 6 Series/C200 Series Chipset Family USB Enhanced Host Controller #2 (rev 05) (prog-if 20 [EHCI])
00:1b.0 Audio device: Intel Corporation 6 Series/C200 Series Chipset Family High Definition Audio Controller (rev 05)
00:1c.0 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 1 (rev b5) (prog-if 00 [Normal decode])
00:1c.1 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 2 (rev b5) (prog-if 00 [Normal decode])
00:1c.3 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 4 (rev b5) (prog-if 00 [Normal decode])
00:1c.4 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 5 (rev b5) (prog-if 00 [Normal decode])
00:1c.7 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 8 (rev b5) (prog-if 00 [Normal decode])
00:1d.0 USB controller: Intel Corporation 6 Series/C200 Series Chipset Family USB Enhanced Host Controller #1 (rev 05) (prog-if 20 [EHCI])
00:1f.0 ISA bridge: Intel Corporation HM67 Express Chipset Family LPC Controller (rev 05)
00:1f.2 SATA controller: Intel Corporation 6 Series/C200 Series Chipset Family 6 port SATA AHCI Controller (rev 05) (prog-if 01 [AHCI 1.0])
00:1f.3 SMBus: Intel Corporation 6 Series/C200 Series Chipset Family SMBus Controller (rev 05)
05:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168 PCI Express Gigabit Ethernet controller (rev 06)
09:00.0 Network controller: Intel Corporation Centrino Wireless-N 1030 [Rainbow Peak] (rev 34)
0b:00.0 USB controller: Texas Instruments TUSB73x0 SuperSpeed USB 3.0 xHCI Host Controller (rev 02) (prog-if 30 [XHCI])
11:00.0 Mass storage controller: Silicon Image, Inc. SiI 3132 Serial ATA Raid II Controller (rev 01)
#

If I have Realtek MediaCardReader enabled in BIOS, no card in it, coldboot, and hot
insert an ExpressCard into the slot, the Realtek MediaCardReader pops up in dmesg as
a new PCI device. How about you?

My card does NOT show in lspci (maybe because I never plugged in a data card into it) but does show in lsusb:

Bus 002 Device 005: ID 0bda:0138 Realtek Semiconductor Corp. RTS5138 Card Reader Controller
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  idVendor           0x0bda Realtek Semiconductor Corp.
  idProduct          0x0138 RTS5138 Card Reader Controller
  bcdDevice           38.82
  iManufacturer           1 Generic
  iProduct                2 USB2.0-CRW
  iSerial                 3 20090516388200000


Can you try coldboot without a media card inserted before power up without
your patch and check whether the CardReader pops up after you plugin some
ExpressCard into an ExpressCardSlot (not the CardReader)? I presume it is
a laptop. ;-)

2. Is the hotplug broken also under acpiphp? And again, does it get detected
once you plugin some card into an ExpressCard slot?

3. Does the device appear under lsusb also in addition to lspci?

4. How does the 'lack of the hotplug surprise (PCI_EXP_SLTCAP_HPS) capability bit'
manifest in 'lspci -vvv' output? A diff before and after the patch?

5. Where is the *real* bug in the code that "linux" ignores the fact that one of
the PCIe Root Ports (or the whole PCI Bridge?) does not support 'hotplug surprise'?
Or is this about the hooked up "third-party" PCI devices? Why does it affect
other PCIe ports of the bridge?


Would be nice if you look into any of my previous emails to linux-pci and
with your current knowledge comment whether here or there I faced a same
problem. Looks like. Disabling the hotplug is a no go for me, I need hotplug
for my ExpressCards. So far am rather having disabled the MediaCardReader in
BIOS. But thank you, I did not know that inserting a data card into a CardReader
is supposed to give me a lspci entry for it. So far I saw only the one in lsusb.

Thank you,
Martin


Takashi Iwai wrote:
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
> 
