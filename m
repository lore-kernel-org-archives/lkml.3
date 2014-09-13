Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045AbaIMJcU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 05:32:20 -0400
Received: from services.gouders.net ([141.101.32.176]:54103 "EHLO
	services.gouders.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763AbaIMJcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 05:32:18 -0400
From: Dirk Gouders <dirk@gouders.net>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Yinghai Lu <yinghai@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andreas Noever <andreas.noever@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-pci\@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [BUG] Bisected Problem with LSI PCI FC Adapter
In-Reply-To: <20140913040716.GA28080@google.com> (Bjorn Helgaas's message of
	"Fri, 12 Sep 2014 22:07:16 -0600")
References: <ghvbotd8es.fsf@quad.gouders.net>
	<ghzje5f5zt.fsf@lena.gouders.net> <ghbnqkeh9k.fsf@quad.gouders.net>
	<CAE9FiQXQesrDMqf1b6ZhHdmY_wEEUrOEvNO4N_d6WtaNMGNLww@mail.gmail.com>
	<gh4mwcef0r.fsf@quad.gouders.net>
	<CAE9FiQWgioBeVmfWCaE38BrkjbWKaS+_FYYdmdd+7X8fpeEgnQ@mail.gmail.com>
	<ghoaukcx6b.fsf@quad.gouders.net>
	<CAE9FiQUk-sAHnjfBvNeHQWibJRqbPE1V0UtDtARtwxmS=7aQrw@mail.gmail.com>
	<ghk358crbe.fsf@quad.gouders.net>
	<CAE9FiQUeP84585-4b+Y6WBVD3zqOi7ch_OXytsTmKEz9AyZ3Vg@mail.gmail.com>
	<20140913040716.GA28080@google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
Date: Sat, 13 Sep 2014 11:30:55 +0200
Message-ID: <gh8ulnn9yo.fsf@quad.gouders.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas <bhelgaas@google.com> writes:

> I want to fix this regression before v3.17.  Dirk, can you test the
> following patch on top of v3.17-rc2?  I'm hoping you can try this on your
> test machine in conjunction with your acpi_pci_root_add() and
> pci_scan_device() patches.  If I understand correctly,  you were able to
> reproduce the FC adapter not showing up, and if you can verify that it does
> show with those patches + this revert, I think that's good enough for now.

I tried this patch on the test machine but after rebooting I lost remote
access -- details will have to wait until tonight.

Independent of the result of this test I planned to go to the office,
this evening to also do this test on the VX50 and to also try Yinghai's
suggestion to reset the PCIe link on it.  I'd like to see if the
behavior of the VX50 differs from that of the test machine.

Probably obvious but did I undestand correctly that Yinghai's patches + 

echo 1 > /sys/bus/.../pcie_link_disable
echo 0 > /sys/bus/.../pcie_link_disable

is exactly identical to this?

setpci -s ... 0xc0.b=0x18
setpci -s ... 0xc0.b=0x08

Please let me know if there is anything else you want me to test on the
VX50.

Dirk

> I'm not committed to applying this yet, but I'd like to have a working fix
> in my back pocket in case we don't come up with a better solution soon.
>
> Bjorn
>
>
> commit 5945a8d28c416fc390a94c8e7fb8fd0a76f5d710
> Author: Bjorn Helgaas <bhelgaas@google.com>
> Date:   Fri Sep 12 21:58:19 2014 -0600
>
>     Revert "PCI: Make sure bus number resources stay within their parents bounds"
>     
>     This reverts commit 1820ffdccb9b ("PCI: Make sure bus number resources stay
>     within their parents bounds") because it breaks some systems with LSI Logic
>     FC949ES Fibre Channel Adapters, apparently by exposing a defect in those
>     adapters.
>     
>     Dirk tested a Tyan VX50 (B4985) with this device that worked like this
>     prior to 1820ffdccb9b:
>     
>         bus: [bus 00-7f] on node 0 link 1
>         ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-07])
>         pci 0000:00:0e.0: PCI bridge to [bus 0a]
>         pci_bus 0000:0a: busn_res: can not insert [bus 0a] under [bus 00-07] (conflicts with (null) [bus 00-07])
>         pci 0000:0a:00.0: [1000:0646] type 00 class 0x0c0400 (FC adapter)
>     
>     Note that the root bridge [bus 00-07] aperture is wrong; this is a BIOS
>     defect in the PCI0 _CRS method.  But prior to 1820ffdccb9b, we didn't
>     enforce that aperture, and the FC adapter worked fine at 0a:00.0.
>     
>     After 1820ffdccb9b, we notice that 00:0e.0's aperture is not contained in
>     the root bridge's aperture, so we reconfigure it so it *is* contained:
>     
>         pci 0000:00:0e.0: bridge configuration invalid ([bus 0a-0a]), reconfiguring
>         pci 0000:00:0e.0: PCI bridge to [bus 06-07]
>     
>     This effectively moves the FC device from 0a:00.0 to 07:00.0, which should
>     be legal.  But when we enumerate bus 06, the FC device doesn't respond, so
>     we don't find anything.  This is probably a defect in the FC device.
>     
>     Possible fixes (due to Yinghai):
>     
>         1) Add a quirk to fix the _CRS information based on what amd_bus.c read
>            from the hardware
>     
>         2) Reset the FC device after we change its bus number
>     
>         3) Revert 1820ffdccb9b
>     
>     Fix 1 would be relatively easy, but it does sweep the LSI FC issue under
>     the rug.  We might want to reconfigure bus numbers in the future for some
>     other reason, e.g., hotplug, and then we could trip over this again.
>     
>     For that reason, I like fix 2, but we don't know whether it actually works,
>     and we don't have a patch for it yet.
>     
>     This revert is fix 3, which also sweeps the LSI FC issue under the rug.
>     
>     Link: https://bugzilla.kernel.org/show_bug.cgi?id=84281
>     Reported-by: Dirk Gouders <dirk@gouders.net>
>     Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
>     CC: stable@vger.kernel.org	# v3.15+
>     CC: Yinghai Lu <yinghai@kernel.org>
>
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index e3cf8a2e6292..f0badff77cff 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -775,7 +775,7 @@ int pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max, int pass)
>  	/* Check if setup is sensible at all */
>  	if (!pass &&
>  	    (primary != bus->number || secondary <= bus->number ||
> -	     secondary > subordinate || subordinate > bus->busn_res.end)) {
> +	     secondary > subordinate)) {
>  		dev_info(&dev->dev, "bridge configuration invalid ([bus %02x-%02x]), reconfiguring\n",
>  			 secondary, subordinate);
>  		broken = 1;
> @@ -853,8 +853,7 @@ int pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max, int pass)
>  			child = pci_add_new_bus(bus, dev, max+1);
>  			if (!child)
>  				goto out;
> -			pci_bus_insert_busn_res(child, max+1,
> -						bus->busn_res.end);
> +			pci_bus_insert_busn_res(child, max+1, 0xff);
>  		}
>  		max++;
>  		buses = (buses & 0xff000000)
> @@ -913,11 +912,6 @@ int pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max, int pass)
>  		/*
>  		 * Set the subordinate bus number to its real value.
>  		 */
> -		if (max > bus->busn_res.end) {
> -			dev_warn(&dev->dev, "max busn %02x is outside %pR\n",
> -				 max, &bus->busn_res);
> -			max = bus->busn_res.end;
> -		}
>  		pci_bus_update_busn_res_end(child, max);
>  		pci_write_config_byte(dev, PCI_SUBORDINATE_BUS, max);
>  	}
