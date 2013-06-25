Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751756Ab3FYVbP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 17:31:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49453 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751102Ab3FYVbO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 17:31:14 -0400
Date: Tue, 25 Jun 2013 22:50:05 +0200
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Myron Stowe <myron.stowe@redhat.com>,
        Joe Lawrence <Joe.Lawrence@stratus.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Isaku Yamahata <yamahata@valinux.co.jp>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH] PCI: avoid NULL deref in alloc_pcie_link_state
Message-ID: <20130625205005.GA1716@hpx.cz>
References: <1371668174-32115-1-git-send-email-rkrcmar@redhat.com>
 <CAErSpo7O2YUUq-Ninu+BdmnrDGcU_h5=h=v1MBCoLorSDZW=Ow@mail.gmail.com>
 <20130625112348.GA13722@redhat.com>
 <CAErSpo7sH_TsN73LZWRFgO+RqAhzgdiTXR86xJ7Ojmno6QTY5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAErSpo7sH_TsN73LZWRFgO+RqAhzgdiTXR86xJ7Ojmno6QTY5w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013-06-25 11:17-0600, Bjorn Helgaas:
> On Tue, Jun 25, 2013 at 5:23 AM, Michael S. Tsirkin <mst@redhat.com> wrote:
> > On Mon, Jun 24, 2013 at 07:38:45PM -0600, Bjorn Helgaas wrote:
> >> [+cc Michael, Alex, Isaku]
> >>
> >> On Wed, Jun 19, 2013 at 12:56 PM, Radim Krčmář <rkrcmar@redhat.com> wrote:
> >> > PCIe switch upstream port can be connected directly to the PCIe root bus
> >> > in QEMU; ASPM does not expect this topology and dereferences NULL pointer
> >> > when initializing.
> >> >
> >> > I have not confirmed this can happen on real hardware, but it is presented
> >> > as a feature in QEMU, so there is no reason to panic if we can recover.
> >>
> >> This doesn't seem like a valid hardware topology to me.  If this *can*
> >> occur on real hardware, we should fix it in Linux.  If not, maybe QEMU
> >> should be changed to disallow it.
> >
> > I don't think it's a spec compliant topology either.
> >
> > Anything connected to an RC is either an integrated endpoint
> > or a root port.
> > There's no way to have an upstream port that is also
> > an integrated endpoint or a root port - these are distinct
> > device types.
> >
> > So I don't think Linux needs to support it.
> >
> > Having said that, there's all kind of broken hardware
> > out there - crashing is not a friendly way to tell users
> > that their hardware is not spec compliant.
> > Maybe linux can print a friendly warning and ignore
> > this port?
> 
> Indeed, that would be nicer.  I booted Win7 on the same config, and it
> came up fine.  It did complain that it couldn't start the PCI-to-PCI
> bridge driver on 00:03.0, the upstream port.

True, would something like

  printk(KERN_WARNING "pcie: %s connected directly to root bus[complex?]:"
                      " aspm disabled\n", dev_name(pdev));

be enough?

> I'd like it if Linux could similarly tolerate that.  But since this is
> a relatively low-priority issue, I'm going to hold out for a more
> straightforward solution.  Checking for a null
> "pdev->bus->parent->self" pointer is not very obvious.  I think we can
> probably come up with a more direct check that reads better and
> possibly even detects the issue at the upstream port, not the
> downstream port.

The check could be in pcie_aspm_init_link_state, where a "strange" VIA
chipset is already being detected and using "pci_is_root_bus()" instead
of "->self" is probably clearer as well.

  	/* QEMU can connect upstream port directly to the root complex */
  	if (pci_pcie_type(pdev) == PCI_EXP_TYPE_DOWNSTREAM &&
  	    !pci_is_root_bus(pdev->bus->parent))
  		return;

If we were to check for the, even worse, downstream<->root complex,
it would be "!pci_is_root_bus(pdev->bus)".

Upstream port is a bit neglected in our aspm implementation, so
refactoring might be required to get detection in it.

> I opened a bugzilla for this issue:
> https://bugzilla.kernel.org/show_bug.cgi?id=60111
> 
> Radim, can you please attach a complete dmesg log showing the oops,
> i.e., console output with "ignore_loglevel" and lspci -vv output (have
> to use your patch so it boots, I guess)?  I tried to reproduce it and
> I know the problem is there, but I haven't quite found the right
> recipe yet.

Sorry, I have not mentioned that device must be connected to the switch,
so "pci_scan_slot" does not end with "nr == 0", skipping the link setup.
I connected the root disk; whole command for qemu-kvm 1.5:

  qemu-kvm -m 2048 -M q35 -serial stdio -vnc :0 \
  	-device x3130-upstream,bus=pcie.0,id=upstream \
  	-device xio3130-downstream,bus=upstream,id=downstream,chassis=1 \
  	-drive file=fc19.img,id=disk1,if=none,format=raw,media=disk,cache=none \
  	-device virtio-blk-pci,bus=downstream,id=virtio-disk1,drive=disk1

"pcie_aspm=off" should do exactly the same as patch.

Both logs attached in bugzilla.
