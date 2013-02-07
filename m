Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757558Ab3BGKZP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 05:25:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45134 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755579Ab3BGKZM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 05:25:12 -0500
Date: Thu, 7 Feb 2013 08:24:35 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Jiang Liu <jiang.liu@huawei.com>,
        Tony Luck <tony.luck@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 00/22] PCI: Iterate pci host bridge instead of pci
 root bus
Message-ID: <20130207082435.21d897a3@redhat.com>
In-Reply-To: <CAErSpo4jtrp4ashHsfZP580_qdCXBEqmdd=SBfQrgQTV4uM4EA@mail.gmail.com>
References: <CAE9FiQXHG01NjnYNDbC-KEpbcvY-q4pBe97CxTOGS7W4vZQBYQ@mail.gmail.com>
	<1359314629-18651-1-git-send-email-yinghai@kernel.org>
	<CAErSpo6r_LNEtYB3j5ELb8NdHu0a6_YOVj8S32CmByGFUpSsbg@mail.gmail.com>
	<CAE9FiQXg1YcPPJLCgPbKOKXHk-LRQv4bbBGH9jyuATQa2ANLkg@mail.gmail.com>
	<CAE9FiQX2DbTO0qCzGO4iMTkU_mPM2oZL+R5UoZ5dj=as6MUAsw@mail.gmail.com>
	<CAErSpo7-dULYwWQ=f5CBCxOULKJE9=n6Ha4jkVKd8enspuYjTA@mail.gmail.com>
	<CAE9FiQWvmK7N2z19B9ZiMyc_T6cJdpWoWr3mExpuwUA4ogBc3w@mail.gmail.com>
	<20130206065340.416a708b@redhat.com>
	<CAErSpo4jtrp4ashHsfZP580_qdCXBEqmdd=SBfQrgQTV4uM4EA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, 6 Feb 2013 10:45:16 -0700
Bjorn Helgaas <bhelgaas@google.com> escreveu:

> On Wed, Feb 6, 2013 at 1:53 AM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
> > Em Tue, 5 Feb 2013 16:47:10 -0800
> > Yinghai Lu <yinghai@kernel.org> escreveu:
> >
> >> On Tue, Feb 5, 2013 at 4:19 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> >> >
> >> > Maybe.  I'd rather not introduce for_each_pci_host_bridge() at all, if
> >> > we can avoid it.  Every place it's used is a place we have to audit to
> >> > make sure it's safe.  I think your audit above is correct and
> >> > complete, but it relies on way too much architecture knowledge.  It's
> >> > better if we can deduce correctness without knowing which arches
> >> > support hotplug and which CPUs support EDAC.
> >> >
> >> > As soon as for_each_pci_host_bridge() is in the tree, those uses can
> >> > be copied to even more places.  It's a macro, so it's usable by any
> >> > module, even out-of-tree ones that we'll never see and can't fix.  So
> >> > we won't really have a good way to deprecate and remove it.
> >>
> >> Now we only have two references in modules.
> >>
> >> drivers/edac/i7core_edac.c:     for_each_pci_host_bridge(host_bridge) {
> >> drivers/pci/hotplug/sgi_hotplug.c:      for_each_pci_host_bridge(host_bridge) {
> >>
> >> for the sgi_hotplug.c, it should be same problem that have for acpiphp
> >> and pciehp.
> >> need to make it support pci host bridge hotplug anyway.
> >>
> >> for edac, we need to check Mauro about their plan.
> >
> > The i7core_pci_lastbus() code at i7core_edac is there to make it work
> > with some Nehalem/Nehalem-EP machines that hide the memory controller's
> > PCI ID by using an artificially low last bus.
> 
> I don't really understand how this helps.  An example would probably
> make it clearer.
> 
> i7core_edac.c has some very creative use of PCI infrastructure.
> Normally a driver has a pci_device_id table that identifies the
> vendor/device IDs of the devices it cares about, and the driver's
> .probe() method is called for every matching device.
> 
> But i7core_edac only has two entries in its id_table.  When we find a
> device that matches one of those two entries, we call i7core_probe(),
> which then gropes around for all the *other* devices related to that
> original one.  This is a bit messy.
> 
> I'd like it a lot better if the device IDs in
> pci_dev_descr_i7core_nehalem[], pci_dev_descr_lynnfield[], etc., were
> just in the pci_device_id table directly.  Then i7core_probe() would
> be called directly for every device you care about, and you could sort
> them out there.  That should work without any need for
> pci_get_device(), i7core_pci_lastbus(), etc.


Bjorn,

On almost all Intel memory controllers since 2002, the memory controller
handling function were split into several different PCI devices and
PCI functions. So, for example, even if you look on old driver like 
i5000_edac.c, you'll see 5 different PCI IDs that are required to
control a single device:

#ifndef PCI_DEVICE_ID_INTEL_FBD_0
#define PCI_DEVICE_ID_INTEL_FBD_0	0x25F5
#endif
#ifndef PCI_DEVICE_ID_INTEL_FBD_1
#define PCI_DEVICE_ID_INTEL_FBD_1	0x25F6
#endif

/* Device 16,
 * Function 0: System Address
 * Function 1: Memory Branch Map, Control, Errors Register
 * Function 2: FSB Error Registers
 *
 * All 3 functions of Device 16 (0,1,2) share the SAME DID
 */
#define	PCI_DEVICE_ID_INTEL_I5000_DEV16	0x25F0

/* OFFSETS for Function 1 */

(a long list of registers there)

/*
 * Device 21,
 * Function 0: Memory Map Branch 0
 *
 * Device 22,
 * Function 0: Memory Map Branch 1
 */
#define PCI_DEVICE_ID_I5000_BRANCH_0	0x25F5
#define PCI_DEVICE_ID_I5000_BRANCH_1	0x25F6

(another long list or registers there)

I've no idea why the hardware engineers there decided on that way, 
but the number of different PCI devices required for the functionality 
to work has been increased on their newer chipsets. At the Sandy
Bridge driver (sb_edac.c), all those PCI devices need to be opened
at the same time, in order to allow controlling a single memory
controller (and one system have one memory controller per socket):

#define PCI_DEVICE_ID_INTEL_SBRIDGE_SAD0	0x3cf4	/* 12.6 */
#define PCI_DEVICE_ID_INTEL_SBRIDGE_SAD1	0x3cf6	/* 12.7 */
#define PCI_DEVICE_ID_INTEL_SBRIDGE_BR		0x3cf5	/* 13.6 */
#define PCI_DEVICE_ID_INTEL_SBRIDGE_IMC_HA0	0x3ca0	/* 14.0 */
#define PCI_DEVICE_ID_INTEL_SBRIDGE_IMC_TA	0x3ca8	/* 15.0 */
#define PCI_DEVICE_ID_INTEL_SBRIDGE_IMC_RAS	0x3c71	/* 15.1 */
#define PCI_DEVICE_ID_INTEL_SBRIDGE_IMC_TAD0	0x3caa	/* 15.2 */
#define PCI_DEVICE_ID_INTEL_SBRIDGE_IMC_TAD1	0x3cab	/* 15.3 */
#define PCI_DEVICE_ID_INTEL_SBRIDGE_IMC_TAD2	0x3cac	/* 15.4 */
#define PCI_DEVICE_ID_INTEL_SBRIDGE_IMC_TAD3	0x3cad	/* 15.5 */
#define PCI_DEVICE_ID_INTEL_SBRIDGE_IMC_DDRIO	0x3cb8	/* 17.0 */

The first thing that any EDAC driver needs to do is to get the memory
configuration (number of DIMMs, channels filled, DIMM size, etc).
In the case of sb_edac, the logic is at get_dimm_config(). It needs
to read data on _several_ of the above PCI IDs:

static int get_dimm_config(struct mem_ctl_info *mci)
{
...
	pci_read_config_dword(pvt->pci_br, SAD_TARGET, &reg);		// reads from PCI_DEVICE_ID_INTEL_SBRIDGE_BR
...
	pci_read_config_dword(pvt->pci_br, SAD_CONTROL, &reg);		// reads from PCI_DEVICE_ID_INTEL_SBRIDGE_BR
...
	pci_read_config_dword(pvt->pci_ras, RASENABLES, &reg);		// reads from PCI_DEVICE_ID_INTEL_SBRIDGE_IMC_RAS
...
	pci_read_config_dword(pvt->pci_ta, MCMTR, &pvt->info.mcmtr);	// reads from PCI_DEVICE_ID_INTEL_SBRIDGE_IMC_TA
...
	pci_read_config_dword(pvt->pci_ddrio, RANK_CFG_A, &reg);	// reads from PCI_DEVICE_ID_INTEL_SBRIDGE_IMC_DDRIO
...
	for (i = 0; i < NUM_CHANNELS; i++) {
...
		for (j = 0; j < ARRAY_SIZE(mtr_regs); j++) {
...
			pci_read_config_dword(pvt->pci_tad[i],
					      mtr_regs[j], &mtr);	// PCI_DEVICE_ID_INTEL_SBRIDGE_IMC_TAD0 to PCI_DEVICE_ID_INTEL_SBRIDGE_IMC_TAD3

So, while the usual design of having one PCI ID entry for each device
works for the vast majority of drivers, as each different PCI ID/function
are typically independent and pci_driver.probe() can be called for every
entry inside the PCI ID table, that's not the case of EDAC.

On EDAC drivers, the probing routine can be called only after calling
pci_get_device() for the entire set of PCI devices that belongs to the
memory controller. 

To make things worse, the PCI IDs for the memory controllers are sometimes
after PCI lastbus.

So, the logic used on almost all drivers there is to use one PCI ID "detect"
device at the table, used to discover if the system has a supported memory
controller chipset. If it matches, the pci_driver.probe() will seek for the
actual PCI devices that are required for it to work, with may or may not be
the same as the "detect" device.

Also, the highest bus corresponds to the first memory controller. So,
bus=255 matches the memory controller for the CPU socket 0,
bus=254 matches the one for CPU socket 1 and so on. That forced the driver
to probe all devices at the same time, on all CPU sockets, in order to reverse
the order when initializing the memory controller EDAC structures.

There are some other odd details there... In the case of i7core_edac, it 
supports 3 different versions of memory controllers; each version has its 
own set of PCI ID's. So, its "real" PCI ID table set has 3 entries:

static const struct pci_id_table pci_dev_table[] = {
	PCI_ID_TABLE_ENTRY(pci_dev_descr_i7core_nehalem),
	PCI_ID_TABLE_ENTRY(pci_dev_descr_lynnfield),
	PCI_ID_TABLE_ENTRY(pci_dev_descr_i7core_westmere),
	{0,}			/* 0 terminated list. */
};

while its PCI ID "detect" table has only two, as the PCI device 8086:342e
(PCI_DEVICE_ID_INTEL_X58_HUB_MGMT) is found on both Nehalem and Westmere:

static DEFINE_PCI_DEVICE_TABLE(i7core_pci_tbl) = {
	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_X58_HUB_MGMT)},
	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_LYNNFIELD_QPI_LINK0)},
	{0,}			/* 0 terminated list. */

-- 

Cheers,
Mauro
