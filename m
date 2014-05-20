Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521AbaETH4h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 03:56:37 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:58733 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366AbaETH4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 03:56:36 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Murali Karicheri <m-karicheri2@ti.com>,
        "Strashko, Grygorii" <grygorii.strashko@ti.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Jingoo Han <jg1.han@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        Mohit Kumar <mohit.kumar@st.com>, Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH v1 5/5] pci: keystone: add pcie driver based on designware core driver
Date: Tue, 20 May 2014 09:55:57 +0200
Message-ID: <4769015.Y4xoyoQxYb@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <537A735A.9070607@ti.com>
References: <1400169692-9677-1-git-send-email-m-karicheri2@ti.com> <5671513.YgJm44AVLV@wuerfel> <537A735A.9070607@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:VpxwbKwFxfyhXs5+nVgaIMbnYdgtcLbqWCCn+3iAU6Z
 fkEH5UEZVRTxyFDj09Er6rTcA3fCKBPlDJIptXjfuhX9LUPILr
 PpSmG2q09BYiX3MEbTU3TM/t3qjGj2papyn1mUuqe8V9pPrcGL
 USHdpnBOFdnquUjWKuygZtbZtX5bZV9TH/KWu3Zgz9EKjYa9UR
 LQ0SbrKUriv3yi4rpy+fd7tcoIGq0slxluUehe7m3zSbB+l6OB
 +J4xkl0qQWU4e0U8HSgnC+AgShhkodTU5orIGU/YdiDhPoqEby
 fgh3szbLIwmIw6A3fOOo14kE7IOjwLUXJt0SUsEl4nVjoepM74
 ILXqmZKXOYf83uwq30P4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 May 2014 17:10:50 Murali Karicheri wrote:
> On 5/19/2014 8:06 AM, Arnd Bergmann wrote:
> > On Friday 16 May 2014 16:26:51 Murali Karicheri wrote:
> >> On 5/15/2014 2:20 PM, Arnd Bergmann wrote:
> >>> On Thursday 15 May 2014 13:45:08 Murali Karicheri wrote:
> >>>>>> +#ifdef CONFIG_PCI_KEYSTONE
> >>>>>> +/*
> >>>>>> + * The KeyStone PCIe controller has maximum read request size of 256 bytes.
> >>>>>> + */
> >>>>>> +static void quirk_limit_readrequest(struct pci_dev *dev)
> >>>>>> +{
> >>>>>> +    int readrq = pcie_get_readrq(dev);
> >>>>>> +
> >>>>>> +    if (readrq > 256)
> >>>>>> +            pcie_set_readrq(dev, 256);
> >>>>>> +}
> >>>>>> +DECLARE_PCI_FIXUP_FINAL(PCI_ANY_ID, PCI_ANY_ID, quirk_limit_readrequest);
> >>>>>> +#endif /* CONFIG_PCI_KEYSTONE */
> >>>>> This doesn't work: you can't just limit do this for all devices just based
> >>>>> on PCI_KEYSTONE being enabled, you have to check if you are actually using
> >>>>> this controller.
> >>>>>
> >>>>>         Arnd
> >>>>     I assume, I need to check if PCI controller's vendor ID/ device ID
> >>>> match with the keystone
> >>>>     PCI controller's ID and call pcie_set_readrq() for all of the slave
> >>>> PCI devices and do this fixup.
> >>>> Is this correct understanding?  If you can point me to an example code
> >>>> for this that will be
> >>>> really helpful so that I can avoid re-inventing the wheel.
> >>> I think it would be best to move the quirk into the keystone pci driver
> >>> and compare compare the dev->driver pointer of the PCI controller device.
> >>>
> >>>        Arnd
> >> Arnd,
> >>
> >> I will move this quirk to keystone pci driver. So in that case, I guess
> >> your original comment
> >> is not applicable as  this quirk gets enabled only with PCI keystone
> >> driver enabled. Right?
> > Of course you still have to fix the bug, not just move the code into
> > the driver. Otherwise it's still broken for every machine after the keystone
> > driver is enabled.
> 
> Agree. I have tried following to get this work so that the quirk gets 
> applied only for
> keystone pci controller.
> 
> #define KS_K2HK_PCI_DEVICE_ID    0xb008
> #define KS_K2E_PCI_DEVICE_ID    0xb009
> #define KS_K2L_PCI_DEVICE_ID    0xb00a
> 
> static u16 root_pci_ids[] =
>      {KS_K2HK_PCI_DEVICE_ID, KS_K2E_PCI_DEVICE_ID, KS_K2L_PCI_DEVICE_ID, 
> 0 };
> /*
>   * The KeyStone PCIe controller has maximum read request size of 256 bytes.
>   */
> static void quirk_limit_readrequest(struct pci_dev *dev)
> {
>      struct pci_dev *root_dev;
>      int i = 0;
> 
>      /* Apply quirk only if this bridge device is keystone */
>      while (root_pci_ids[i]) {
>          root_dev = pci_get_device(PCI_VENDOR_ID_TI, root_pci_ids[i], NULL);
>          if ((root_dev->class >> 8) == PCI_CLASS_BRIDGE_PCI) {
>              int readrq;
> 
>              readrq = pcie_get_readrq(dev);
>              if (pcie_get_readrq(dev) > 256) {
>                  pcie_set_readrq(dev, 256);
>                  printk("Applied quirk\n");
>              }
>              break;
>          };
>      }
> }
> DECLARE_PCI_FIXUP_FINAL(PCI_ANY_ID, PCI_ANY_ID, quirk_limit_readrequest);

Why not compare the driver pointer as I suggested?

> > I also agree with Jason that changing the PCI core to call
> > pcie_bus_configure_settings() would be a better way of dealing with this
> > if it solves the problem.
> 
> I tried following piece of code added to bios32.c
> 
> void pci_common_init_dev(struct device *parent, struct hw_pci *hw)
> {
>          struct pci_sys_data *sys;
>          LIST_HEAD(head);
> 
>          pci_add_flags(PCI_REASSIGN_ALL_RSRC);
>          if (hw->preinit)
>                  hw->preinit();
> 
>           ........
>           ....
> 
>           list_for_each_entry(sys, &head, node) {
>                  struct pci_bus *bus = sys->bus;
> 
>                  if (!pci_has_flag(PCI_PROBE_ONLY)) {
>                          /*
>                           * Size the bridge windows.
>                           */
>                          pci_bus_size_bridges(bus);
> 
>                          /*
>                           * Assign resources.
>                           */
>                          pci_bus_assign_resources(bus);
>                  }
>                  /*
>                   * Tell drivers about devices found.
>                   */
>                  pci_bus_add_devices(bus);
>          }
> 
> // New code starts here
>          list_for_each_entry(sys, &head, node) {
>                  struct pci_bus *bus = sys->bus;
> 
>                  /* Configure PCI Express settings */
>                  if (bus && !pci_has_flag(PCI_PROBE_ONLY)) {
>                          struct pci_bus *child;
> 
>                          list_for_each_entry(child, &bus->children, node)
>                          pcie_bus_configure_settings(child);
>                  }
>          }
> // New code ends.

This is the ARM specific part of the PCI code. I think it would be
better to do this independent of the architecture.

> This seems to do different things based on the pci bootargs. The key 
> requirement for Keystone PCI controller
> is that the MRRS can't be more than 256 bytes.  The only option that 
> works for keystone PCI controller
> is with pci=pcie_bus_perf.   I see following logs:-
> 
> [    3.382747] pcie_bus_configure_settings, config 2
> [    3.382753] pcie_bus_configure_set
> [    3.382781] pcieport 0000:00:00.0: Max Payload Size set to  256/ 256 
> (was  128), Max Read Rq  256
> [    3.382788] pcie_bus_configure_set
> [    3.382846] pci 0000:01:00.0: Max Payload Size set to  256/ 256 (was  
> 128), Max Read Rq  256
> [    3.382852] pcie_bus_configure_set
> [    3.382909] pci 0000:01:00.1: Max Payload Size set to  256/ 256 (was  
> 128), Max Read Rq  256
> 
> On ARM, by default pci_bus_config seems to be set to 0 
> (PCIE_BUS_TUNE_OFF). So the code doesn't get
> executed for this default. But for PCIE_BUS_SAFE, it doesn't change the 
> mrrs at the EP and is not
> good for our platform w.r.t mrrs settings. For PCIE_BUS_PERFORMANCE, it 
> seems to increase the payload
> size as well and Keystone Payload size is limited to 128 bytes. So it is 
> not safe to increase the payload
> size to 256 based on the log.
> 
> On other platforms, Why the PCI core try to set the payload size equal 
> to mrrs? Is this explained in any
> PCI spec?  Looks like this is done for performance? Let me know if you 
> want me to send a patch for
> review to add the pcie_bus_configure_settings() code to 
> arch/arm/kernel/bios32.c
> 
> For the Keystone PCI driver, I believe. it is safe to have the quirk so 
> that controller can handle the
> read requests properly. Let me know if the quirk code above looks good 
> to go.

I don't know enough about these to give you a definite answer, but
I'd still prefer to handle this in generic code. A quirk seems to
be the wrong answer here. If this isn't something we can do in generic
fashion, can you do it in the add_bus() callback perhaps?

Maybe Jason or Bjorn have a better idea.

	Arnd
