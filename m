Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617AbaILUHF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 16:07:05 -0400
Received: from services.gouders.net ([141.101.32.176]:53858 "EHLO
	services.gouders.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbaILUHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 16:07:01 -0400
From: Dirk Gouders <dirk@gouders.net>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andreas Noever <andreas.noever@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-pci\@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [BUG] Bisected Problem with LSI PCI FC Adapter
In-Reply-To: <ghzje5f5zt.fsf@lena.gouders.net> (Dirk Gouders's message of
	"Fri, 12 Sep 2014 13:11:34 +0200")
References: <ghiol53r9u.fsf@lena.gouders.net>
	<CAMxnaaXiEZeJOsgQ6ZSbiqy5Z1zNoXonwNSQNRyRhV0t5jveYQ@mail.gmail.com>
	<ghwq9k3m6z.fsf@lena.gouders.net>
	<CAMxnaaUqTMf1uEQUqrAGjym8ZrQaBf2QbE4Jqxh2t6a2JgJkOQ@mail.gmail.com>
	<ghioku5l29.fsf@lena.gouders.net>
	<CAErSpo7j=a3y2MVsvEQGQ4B63_mNCyZSRNXNEZa-2++xs88NmQ@mail.gmail.com>
	<CAE9FiQUXvuZo2bQSRg0vpuDVYrnkcXDu7KZBNp-YgXbKa2LQhw@mail.gmail.com>
	<ghppf15236.fsf@quad.gouders.net>
	<CAErSpo5SVUOz+qa_x5JTC+-Y5ewTyYzA0N=jyPtK9LaguRrt=w@mail.gmail.com>
	<ghd2b1svdw.fsf@quad.gouders.net>
	<CAErSpo5e0GOdVbZdQYriP+aWziKELpb9BWTgJ4ERPia354CM5w@mail.gmail.com>
	<ghvbotd8es.fsf@quad.gouders.net> <ghzje5f5zt.fsf@lena.gouders.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
Date: Fri, 12 Sep 2014 22:05:43 +0200
Message-ID: <ghbnqkeh9k.fsf@quad.gouders.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=

Dirk Gouders <dirk@gouders.net> writes:

> Dirk Gouders <dirk@gouders.net> writes:
>
>> Bjorn Helgaas <bhelgaas@google.com> writes:
>>
>>> On Thu, Sep 11, 2014 at 3:24 PM, Dirk Gouders <dirk@gouders.net> wrote:
>>>> Bjorn Helgaas <bhelgaas@google.com> writes:
>>>>
>>>>> On Thu, Sep 11, 2014 at 2:33 PM, Dirk Gouders <dirk@gouders.net> wrote:
>>>>>> What I was currently trying was to construct a test-environment so that
>>>>>> I do not need to do tests and diagnosis on a busy machine.
>>>>>>
>>>>>> I noticed that this problem seems to start with the narrow Root
>>>>>> Bridge window (00-07) but every other machine that I had a look at,
>>>>>> starts with (00-ff), so those will not trigger my problem.
>>>>>>
>>>>>> I thought I could perhaps try to shrink the window in
>>>>>> acpi_pci_root_add() to trigger the problem and that kind of works: it
>>>>>> triggers it but not exactly the same way, because it basically ends at
>>>>>> this code in pci_scan_bridge():
>>>>>>
>>>>>>         if (max >= bus->busn_res.end) {
>>>>>>                 dev_warn(&dev->dev, "can't allocate child bus %02x from %pR (pass %d)\n",
>>>>>>                          max, &bus->busn_res, pass);
>>>>>>                 goto out;
>>>>>>         }
>>>>>>
>>>>>> If this could work but I am just missing a small detail, I would be
>>>>>> glad to hear about it and do the first tests this way.  If it is
>>>>>> complete nonsense, I will just use the machine that triggers the problem
>>>>>> for the tests.
>>>>>
>>>>> I was about to suggest the same thing.  If the problem is related to
>>>>> the bus number change, we should be able to force that to happen on a
>>>>> different machine.  Your approach sounds good, so I'm guessing we just
>>>>> need a tweak.
>>>>>
>>>>> I would first double-check that the PCI adapters are identical,
>>>>> including the firmware on the card.  Can you also include your patch
>>>>> and the resulting dmesg (with debug enabled as before)?
>>>>
>>>> Currently I am at home doing just tests for understanding and that I can
>>>> hopefully use when I am back in the office.
>>>>
>>>> I already noticed the the backup FC Adapter on the test machine is not
>>>> exactly the same: it is Rev. 1 whereas the one on the failing machine is
>>>> Rev. 2.
>>>>
>>>> So, here at home my tests let a NIC disappear.  Different from the
>>>> original problem but I was just trying to reconstruct the szenario of a
>>>> misconfigured bridge causing a reconfiguration.
>>>>
>>>> What I was trying is:
>>>>
>>>> diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
>>>> index e6ae603..fd146b3 100644
>>>> --- a/drivers/acpi/pci_root.c
>>>> +++ b/drivers/acpi/pci_root.c
>>>> @@ -556,6 +556,7 @@ static int acpi_pci_root_add(struct acpi_device *device,
>>>>         strcpy(acpi_device_name(device), ACPI_PCI_ROOT_DEVICE_NAME);
>>>>         strcpy(acpi_device_class(device), ACPI_PCI_ROOT_CLASS);
>>>>         device->driver_data = root;
>>>> +       root->secondary.end = 0x02;
>>>>
>>>>         pr_info(PREFIX "%s [%s] (domain %04x %pR)\n",
>>>>                acpi_device_name(device), acpi_device_bid(device),
>>>>
>>>> The device that disappears is a NIC:
>>>>
>>>> 00:00.0 Host bridge: Intel Corporation Xeon E3-1200 v2/3rd Gen Core processor DRAM Controller (rev 09)
>>>> 00:02.0 VGA compatible controller: Intel Corporation Xeon E3-1200 v2/3rd Gen Core processor Graphics Controller (rev 09)
>>>> 00:14.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset Family USB xHCI Host Controller (rev 04)
>>>> 00:16.0 Communication controller: Intel Corporation 7 Series/C210 Series Chipset Family MEI Controller #1 (rev 04)
>>>> 00:1a.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset Family USB Enhanced Host Controller #2 (rev 04)
>>>> 00:1b.0 Audio device: Intel Corporation 7 Series/C210 Series Chipset Family High Definition Audio Controller (rev 04)
>>>> 00:1c.0 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 1 (rev c4)
>>>> 00:1c.4 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 5 (rev c4)
>>>> 00:1c.5 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 6 (rev c4)
>>>> 00:1d.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset Family USB Enhanced Host Controller #1 (rev 04)
>>>> 00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev a4)
>>>> 00:1f.0 ISA bridge: Intel Corporation B75 Express Chipset LPC Controller (rev 04)
>>>> 00:1f.2 SATA controller: Intel Corporation 7 Series/C210 Series Chipset Family 6-port SATA Controller [AHCI mode] (rev 04)
>>>> 00:1f.3 SMBus: Intel Corporation 7 Series/C210 Series Chipset Family SMBus Controller (rev 04)
>>>> 02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 06)
>>>>
>>>> This is the one that is missing with the above change:
>>>> 03:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 06)
>>>
>>> This situation is a little different, so I don't think you're
>>> reproducing the situation we want to test.  On this box, you have:
>>>
>>>     pci_bus 0000:00: root bus resource [bus 00-02]
>>>     pci 0000:00:1c.0: PCI bridge to [bus 01]
>>>     pci 0000:00:1c.4: PCI bridge to [bus 02]
>>>
>>> so we find all the devices on bus 00 and bus 02 (there's nothing on
>>> bus 01).  My guess is the 03:00.0 device is normally behind the
>>> 00:1c.5 bridge, but we don't even scan behind that bridge because we
>>> can't allocate a secondary bus number for it (we're not smart enough
>>> to take advantage of the empty bus 01).
>>>
>>> On the failing box, it's different because we *do* have unused bus
>>> number space, and we do actually reconfigure the bridge to use it.
>>> It's just that the FC adapter doesn't respond when we use the new bus
>>> number for it.
>>>
>>> You might be able to do something similar on the test box by:
>>>
>>>   - Keeping your root->secondary.end = 02 patch, so you still have [bus 00-02].
>>>   - Ignoring bridges 00:1c.0 and 00:1c.4.  I would just test for those
>>> devfns in pci_scan_device() and when you see them, return NULL instead
>>> of trying to read the vendor ID.
>>>
>>> Then 00:1c.5 is probably configured by the BIOS for [bus 03], but
>>> that's outside the root bridge range, so we should reconfigure it to
>>> use [bus 01].  Then we should scan behind it, and we'll probably
>>> discover the NIC that was previously at 03:00.0.  The device *should*
>>> just work at the new bus number, since it probably doesn't have the
>>> same bug the FC adapter does.
>>
>> Thanks for the explanation.  I tried to ignore the two bridges but the
>> machine stopped with the "reconfiguring" message.
>>
>> Anyway, if I understood you correctly with the backup FC adapter I have
>> good chances, because there is the needed unused bus number space and I
>> don't have to ignore bridges.  I will test in a few hours and report.
>
> It turned out that there is no unused bus number space on the test
> machine:
>
> -[0000:00]-+-01.0-[01-02]--+-0d.0-[02]--
>            |               +-0e.0  Broadcom BCM5785 [HT1000] SATA (PATA/IDE Mode)
>            |               \-0e.1  Broadcom BCM5785 [HT1000] SATA (PATA/IDE Mode)
>            +-02.0  Broadcom BCM5785 [HT1000] Legacy South Bridge
>            +-02.1  Broadcom BCM5785 [HT1000] IDE
>            +-02.2  Broadcom BCM5785 [HT1000] LPC
>            +-03.0  Broadcom BCM5785 [HT1000] USB
>            +-03.1  Broadcom BCM5785 [HT1000] USB
>            +-03.2  Broadcom BCM5785 [HT1000] USB
>            +-06.0-[03]--
>            +-07.0-[04]--+-04.0  Broadcom Corporation NetXtreme BCM5780 Gigabit Ethernet
>            |            \-04.1  Broadcom Corporation NetXtreme BCM5780 Gigabit Ethernet
>            +-08.0-[05]--
>            +-09.0-[06]--
>            +-0a.0-[07]----00.0  LSI Logic / Symbios Logic FC949ES Fibre Channel Adapter
>            +-0b.0-[08]--
>            +-0c.0  Advanced Micro Devices, Inc. [AMD/ATI] ES1000
>            +-18.0  Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
>            +-18.1  Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] Address Map
>            +-18.2  Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] DRAM Controller
>            +-18.3  Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
>            +-19.0  Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
>            +-19.1  Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] Address Map
>            +-19.2  Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] DRAM Controller
>            \-19.3  Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
>
> So, I used the following changes to create the space and limit the root
> bridge window:
>
> diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
> index e6ae603..a41066b 100644
> --- a/drivers/acpi/pci_root.c
> +++ b/drivers/acpi/pci_root.c
> @@ -556,6 +556,7 @@ static int acpi_pci_root_add(struct acpi_device *device,
>  	strcpy(acpi_device_name(device), ACPI_PCI_ROOT_DEVICE_NAME);
>  	strcpy(acpi_device_class(device), ACPI_PCI_ROOT_CLASS);
>  	device->driver_data = root;
> +	root->secondary.end = 0x06;
>  
>  	pr_info(PREFIX "%s [%s] (domain %04x %pR)\n",
>  	       acpi_device_name(device), acpi_device_bid(device),
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index e3cf8a2..d8dc02d 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -1323,6 +1323,9 @@ static struct pci_dev *pci_scan_device(struct pci_bus *bus, int devfn)
>  	struct pci_dev *dev;
>  	u32 l;
>  
> +	if (devfn == PCI_DEVFN(0x08, 0) || devfn == PCI_DEVFN(0x09,0))
> +		return NULL;
> +
>  	if (!pci_bus_read_dev_vendor_id(bus, devfn, &l, 60*1000))
>  		return NULL;
>  
> And to me it looks as if that is the situation, I need for testing
> Yinghai's patches; the FC Adapter disappeared similar to that on the
> other machine (find the dmesg output at the end):
>
> -[0000:00]-+-01.0-[01-02]--+-0d.0-[02]--
>            |               +-0e.0  Broadcom BCM5785 [HT1000] SATA (PATA/IDE Mode)
>            |               \-0e.1  Broadcom BCM5785 [HT1000] SATA (PATA/IDE Mode)
>            +-02.0  Broadcom BCM5785 [HT1000] Legacy South Bridge
>            +-02.1  Broadcom BCM5785 [HT1000] IDE
>            +-02.2  Broadcom BCM5785 [HT1000] LPC
>            +-03.0  Broadcom BCM5785 [HT1000] USB
>            +-03.1  Broadcom BCM5785 [HT1000] USB
>            +-03.2  Broadcom BCM5785 [HT1000] USB
>            +-06.0-[03]--
>            +-07.0-[04]--+-04.0  Broadcom Corporation NetXtreme BCM5780 Gigabit Ethernet
>            |            \-04.1  Broadcom Corporation NetXtreme BCM5780 Gigabit Ethernet
>            +-0a.0-[05]--
>            +-0b.0-[06]--
>            +-0c.0  Advanced Micro Devices, Inc. [AMD/ATI] ES1000
>            +-18.0  Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
>            +-18.1  Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] Address Map
>            +-18.2  Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] DRAM Controller
>            +-18.3  Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
>            +-19.0  Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
>            +-19.1  Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] Address Map
>            +-19.2  Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] DRAM Controller
>            \-19.3  Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
>
>
> So, I wanted to test the patches but unfortunately, the patches do not
> apply cleanly; git am refuses to take the files (unknown format) and git
> apply gives errors. I tried to apply them against Linus' current, v3.16,
> v3.15 and v3.14.  What am I probably doing wrong, Yinghai?

Yinghai,

I now applied your patches and tested them:

echo 1 > /sys/bus/pci/devices/0000\:00\:0a.0/pcie_link_disable
echo 0 > /sys/bus/pci/devices/0000\:00\:0a.0/pcie_link_disable

The FC Adapter did not show up, this is the dmesg output (I also tested
with 0b.0):

[  143.294168] pcieport 0000:00:0a.0: pcie_link_disable_set: lnk_ctrl = 18
[  148.284456] pcieport 0000:00:0a.0: pcie_link_disable_set: lnk_ctrl = 8
[  304.065942] pcieport 0000:00:0b.0: pcie_link_disable_set: lnk_ctrl = 18
[  309.035278] pcieport 0000:00:0b.0: pcie_link_disable_set: lnk_ctrl = 8

So, probably my test environment does not work as expected and I have to
test it on the failing machine.

I hope I applied the patches correctly, I attach them to this mail.

Dirk


--=-=-=
Content-Disposition: inline;
 filename=0001-PCI-Add-generic-pcie_link_disable.patch
Content-Description: patch1

>From b57b339bf10237e234c491c58f6dd0a1f575c34e Mon Sep 17 00:00:00 2001
From: Dirk Gouders <dirk@gouders.net>
Date: Fri, 12 Sep 2014 21:16:06 +0200
Subject: [PATCH 1/4] PCI: Add generic pcie_link_disable

Remove not needed return value checking that Linus pointed out before.

Will use it from /sys/.../pcie/link_disable

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/Makefile    |  2 +-
 drivers/pci/pcie-link.c | 42 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/pci.h     |  2 ++
 3 files changed, 45 insertions(+), 1 deletion(-)
 create mode 100644 drivers/pci/pcie-link.c

diff --git a/drivers/pci/Makefile b/drivers/pci/Makefile
index e04fe2d..eab9feb 100644
--- a/drivers/pci/Makefile
+++ b/drivers/pci/Makefile
@@ -4,7 +4,7 @@
 
 obj-y		+= access.o bus.o probe.o host-bridge.o remove.o pci.o \
 			pci-driver.o search.o pci-sysfs.o rom.o setup-res.o \
-			irq.o vpd.o setup-bus.o vc.o
+			irq.o vpd.o setup-bus.o pcie-link.o vc.o
 obj-$(CONFIG_PROC_FS) += proc.o
 obj-$(CONFIG_SYSFS) += slot.o
 
diff --git a/drivers/pci/pcie-link.c b/drivers/pci/pcie-link.c
new file mode 100644
index 0000000..e10d0ba
--- /dev/null
+++ b/drivers/pci/pcie-link.c
@@ -0,0 +1,42 @@
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/errno.h>
+#include <linux/jiffies.h>
+#include <linux/delay.h>
+
+int pcie_link_disable_get(struct pci_dev *dev)
+{
+	u16 lnk_ctrl;
+	if (!pci_is_pcie(dev))
+		return 0;
+
+	pcie_capability_read_word(dev, PCI_EXP_LNKCTL, &lnk_ctrl);
+
+	return !!(lnk_ctrl & PCI_EXP_LNKCTL_LD);
+}
+
+void pcie_link_disable_set(struct pci_dev *dev, int bit)
+{
+	u16 lnk_ctrl, old_lnk_ctrl;
+
+	if (!pci_is_pcie(dev))
+		return;
+
+	pcie_capability_read_word(dev, PCI_EXP_LNKCTL, &lnk_ctrl);
+	old_lnk_ctrl = lnk_ctrl;
+
+	if (!bit)
+		lnk_ctrl &= ~PCI_EXP_LNKCTL_LD;
+	else
+		lnk_ctrl |= PCI_EXP_LNKCTL_LD;
+
+	if (old_lnk_ctrl == lnk_ctrl)
+		return;
+
+	pcie_capability_write_word(dev, PCI_EXP_LNKCTL, lnk_ctrl);
+
+	dev_printk(KERN_DEBUG, &dev->dev, "%s: lnk_ctrl = %x\n", __func__,
+			 lnk_ctrl);
+}
+EXPORT_SYMBOL(pcie_link_disable_set);
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 61978a4..926fcb4 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -778,6 +778,8 @@ struct pci_bus *pci_scan_root_bus(struct device *parent, int bus,
 struct pci_bus *pci_add_new_bus(struct pci_bus *parent, struct pci_dev *dev,
 				int busnr);
 void pcie_update_link_speed(struct pci_bus *bus, u16 link_status);
+void pcie_link_disable_set(struct pci_dev *dev, int bit);
+int pcie_link_disable_get(struct pci_dev *dev);
 struct pci_slot *pci_create_slot(struct pci_bus *parent, int slot_nr,
 				 const char *name,
 				 struct hotplug_slot *hotplug);
-- 
2.1.0


--=-=-=
Content-Type: text/x-diff
Content-Disposition: inline;
 filename=0002-PCI-pciehp-Use-generic-pcie_link_disable.patch
Content-Description: patch2

>From b504067748a1c0e4c4847fbb569c149b43d02904 Mon Sep 17 00:00:00 2001
From: Dirk Gouders <dirk@gouders.net>
Date: Fri, 12 Sep 2014 21:20:38 +0200
Subject: [PATCH 2/4] PCI, pciehp: Use generic pcie_link_disable

Also remove old version with not needed return check.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/hotplug/pciehp_hpc.c | 30 +++---------------------------
 1 file changed, 3 insertions(+), 27 deletions(-)

diff --git a/drivers/pci/hotplug/pciehp_hpc.c b/drivers/pci/hotplug/pciehp_hpc.c
index 9da84b8..e8caa18 100644
--- a/drivers/pci/hotplug/pciehp_hpc.c
+++ b/drivers/pci/hotplug/pciehp_hpc.c
@@ -303,28 +303,6 @@ int pciehp_check_link_status(struct controller *ctrl)
 	return 0;
 }
 
-static int __pciehp_link_set(struct controller *ctrl, bool enable)
-{
-	struct pci_dev *pdev = ctrl_dev(ctrl);
-	u16 lnk_ctrl;
-
-	pcie_capability_read_word(pdev, PCI_EXP_LNKCTL, &lnk_ctrl);
-
-	if (enable)
-		lnk_ctrl &= ~PCI_EXP_LNKCTL_LD;
-	else
-		lnk_ctrl |= PCI_EXP_LNKCTL_LD;
-
-	pcie_capability_write_word(pdev, PCI_EXP_LNKCTL, lnk_ctrl);
-	ctrl_dbg(ctrl, "%s: lnk_ctrl = %x\n", __func__, lnk_ctrl);
-	return 0;
-}
-
-static int pciehp_link_enable(struct controller *ctrl)
-{
-	return __pciehp_link_set(ctrl, true);
-}
-
 void pciehp_get_attention_status(struct slot *slot, u8 *status)
 {
 	struct controller *ctrl = slot->ctrl;
@@ -471,7 +449,6 @@ int pciehp_power_on_slot(struct slot *slot)
 	struct controller *ctrl = slot->ctrl;
 	struct pci_dev *pdev = ctrl_dev(ctrl);
 	u16 slot_status;
-	int retval;
 
 	/* Clear sticky power-fault bit from previous power failures */
 	pcie_capability_read_word(pdev, PCI_EXP_SLTSTA, &slot_status);
@@ -485,11 +462,10 @@ int pciehp_power_on_slot(struct slot *slot)
 		 pci_pcie_cap(ctrl->pcie->port) + PCI_EXP_SLTCTL,
 		 PCI_EXP_SLTCTL_PWR_ON);
 
-	retval = pciehp_link_enable(ctrl);
-	if (retval)
-		ctrl_err(ctrl, "%s: Can not enable the link!\n", __func__);
+        /* Enable the link */
+        pcie_link_disable_set(ctrl->pcie->port, 0);
 
-	return retval;
+	return 0;
 }
 
 void pciehp_power_off_slot(struct slot *slot)
-- 
2.1.0


--=-=-=
Content-Disposition: inline;
 filename=0003-PCI-sysfs-Add-pcie-attrs-for-pcie-device-under-pci-d.patch
Content-Description: patch3

>From 4435354e0d99e409d0140256d8162c0046139843 Mon Sep 17 00:00:00 2001
From: Dirk Gouders <dirk@gouders.net>
Date: Fri, 12 Sep 2014 21:25:18 +0200
Subject: [PATCH 3/4] PCI, sysfs: Add pcie attrs for pcie device under pci dev
 dir.

Will put link_disable and link_retrain

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/Makefile     |  2 +-
 drivers/pci/pci-sysfs.c  |  1 +
 drivers/pci/pci.h        |  1 +
 drivers/pci/pcie-sysfs.c | 23 +++++++++++++++++++++++
 4 files changed, 26 insertions(+), 1 deletion(-)
 create mode 100644 drivers/pci/pcie-sysfs.c

diff --git a/drivers/pci/Makefile b/drivers/pci/Makefile
index eab9feb..43523dd 100644
--- a/drivers/pci/Makefile
+++ b/drivers/pci/Makefile
@@ -4,7 +4,7 @@
 
 obj-y		+= access.o bus.o probe.o host-bridge.o remove.o pci.o \
 			pci-driver.o search.o pci-sysfs.o rom.o setup-res.o \
-			irq.o vpd.o setup-bus.o pcie-link.o vc.o
+			irq.o vpd.o setup-bus.o pcie-link.o pcie-sysfs.o vc.o
 obj-$(CONFIG_PROC_FS) += proc.o
 obj-$(CONFIG_SYSFS) += slot.o
 
diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 9ff0a90..6f20e5d 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -1566,6 +1566,7 @@ static struct attribute_group pci_dev_attr_group = {
 
 static const struct attribute_group *pci_dev_attr_groups[] = {
 	&pci_dev_attr_group,
+	&pci_dev_pcie_attr_group,
 	&pci_dev_hp_attr_group,
 #ifdef CONFIG_PCI_IOV
 	&sriov_dev_attr_group,
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 0601890..cc2977c 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -152,6 +152,7 @@ static inline int pci_no_d1d2(struct pci_dev *dev)
 extern const struct attribute_group *pci_dev_groups[];
 extern const struct attribute_group *pcibus_groups[];
 extern struct device_type pci_dev_type;
+extern struct attribute_group pci_dev_pcie_attr_group;
 extern const struct attribute_group *pci_bus_groups[];
 
 
diff --git a/drivers/pci/pcie-sysfs.c b/drivers/pci/pcie-sysfs.c
new file mode 100644
index 0000000..b65e065
--- /dev/null
+++ b/drivers/pci/pcie-sysfs.c
@@ -0,0 +1,23 @@
+#include <linux/kernel.h>
+#include <linux/pci.h>
+
+static struct attribute *pci_dev_pcie_dev_attrs[] = {
+       NULL,
+};
+
+static umode_t pci_dev_pcie_attrs_are_visible(struct kobject *kobj,
+                                               struct attribute *a, int n)
+{
+       struct device *dev = container_of(kobj, struct device, kobj);
+       struct pci_dev *pdev = to_pci_dev(dev);
+
+       if (!pci_is_pcie(pdev))
+               return 0;
+
+       return a->mode;
+}
+
+struct attribute_group pci_dev_pcie_attr_group = {
+       .is_visible = pci_dev_pcie_attrs_are_visible,
+       .attrs      = pci_dev_pcie_dev_attrs,
+};
-- 
2.1.0


--=-=-=
Content-Disposition: inline;
 filename=0004-PCI-Add-link_disable-in-sysfs-for-pcie-device.patch
Content-Description: patch4

>From 8cd5b6a3b380b730893cf67e7d611fe256baeaed Mon Sep 17 00:00:00 2001
From: Dirk Gouders <dirk@gouders.net>
Date: Fri, 12 Sep 2014 21:31:53 +0200
Subject: [PATCH 4/4] PCI: Add link_disable in /sysfs for pcie device

Found PCIe cards from one vendor, will not respond to scan from bridge,
if we change bus number setting in bridge device.

Have to do link disable/enable on the pcie root port.

So try to expose link disable bit of pcie link control register. We can use
 echo 1 > /sys/..../link_disable
 echo 0 > /sys/..../link_disable
to bring the pcie device back to respond to scan.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/pcie-sysfs.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/drivers/pci/pcie-sysfs.c b/drivers/pci/pcie-sysfs.c
index b65e065..d4f6d4f 100644
--- a/drivers/pci/pcie-sysfs.c
+++ b/drivers/pci/pcie-sysfs.c
@@ -1,7 +1,35 @@
 #include <linux/kernel.h>
 #include <linux/pci.h>
 
+static ssize_t
+pcie_link_disable_show(struct device *dev, struct device_attribute *attr,
+                       char *buf)
+{
+       struct pci_dev *pdev = to_pci_dev(dev);
+
+       return sprintf(buf, "%u\n", pcie_link_disable_get(pdev));
+}
+static ssize_t
+pcie_link_disable_store(struct device *dev, struct device_attribute *attr,
+                       const char *buf, size_t count)
+{
+       struct pci_dev *pdev = to_pci_dev(dev);
+       unsigned long val;
+
+       if (kstrtoul(buf, 0, &val) < 0)
+               return -EINVAL;
+
+       pcie_link_disable_set(pdev, val);
+
+       return count;
+}
+
+static struct device_attribute pcie_link_disable_attr =
+               __ATTR(pcie_link_disable, 0644,
+                      pcie_link_disable_show, pcie_link_disable_store);
+
 static struct attribute *pci_dev_pcie_dev_attrs[] = {
+       &pcie_link_disable_attr.attr,
        NULL,
 };
 
@@ -14,6 +42,11 @@ static umode_t pci_dev_pcie_attrs_are_visible(struct kobject *kobj,
        if (!pci_is_pcie(pdev))
                return 0;
 
+       if (a == &pcie_link_disable_attr.attr)
+               if ((pci_pcie_type(pdev) != PCI_EXP_TYPE_ROOT_PORT) &&
+                   (pci_pcie_type(pdev) != PCI_EXP_TYPE_DOWNSTREAM))
+                       return 0;
+
        return a->mode;
 }
 
-- 
2.1.0


--=-=-=--
