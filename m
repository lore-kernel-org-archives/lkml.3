Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755721Ab3IYOZI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 10:25:08 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:58394 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754886Ab3IYOZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 10:25:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: Toshi Kani <toshi.kani@hp.com>, Tang Chen <tangchen@cn.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Subject: Re: [Bug report] Warning when hot-add an ACPI0004 device.
Date: Wed, 25 Sep 2013 16:36:22 +0200
Message-ID: <1885947.mO0H2ES2Cp@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <5242BB6D.3060504@cn.fujitsu.com>
References: <52314A89.2060809@cn.fujitsu.com> <1378998712.12538.18.camel@misato.fc.hp.com> <5242BB6D.3060504@cn.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 25, 2013 06:31:09 PM Gu Zheng wrote:
> Hi Toshi,
> 
> On 09/12/2013 11:11 PM, Toshi Kani wrote:
> 
> > On Thu, 2013-09-12 at 13:00 +0800, Tang Chen wrote:
> >> Hi Rafael, Toshi,
> >>
> >> When we hot-add an ACPI0004 device, we got the following warning:
> >>
> >> 	acpi ACPI0004:01: Attempt to re-insert
> >>
> >> The ACPI0004 device is a System Board in Fujitsu server, which has two
> >> numa nodes (processors and memory).
> >>
> >> It seems that we reserved the ACPI_NOTIFY_DEVICE_CHECK event twice in
> >> acpi_hotplug_notify_cb().
> >>
> >>
> >> According to bisect, this happens after the following commit:
> >>
> >>  From 68a67f6c78b80525d9b3c6672e7782de95e56a83 Mon Sep 17 00:00:00 2001
> >> From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
> >> Date: Sun, 3 Mar 2013 23:05:55 +0100
> >> Subject: [PATCH 1/1] ACPI / container: Use common hotplug code
> >>
> >> Switch the ACPI container driver to using common device hotplug code
> >> introduced previously.  This reduces the driver down to a trivial
> >> definition and registration of a struct acpi_scan_handler object.
> >>
> >> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >> Acked-by: Toshi Kani <toshi.kani@hp.com>
> >> Tested-by: Toshi Kani <toshi.kani@hp.com>
> >> ---
> >>   drivers/acpi/container.c | 146 
> >> ++++-------------------------------------------
> >>   1 file changed, 10 insertions(+), 136 deletions(-)
> >>
> >>
> >> I'm now investigating this problem. If you have any idea about why this
> >> happens, please let me know.
> > 
> > With the above change, container devices use the common notify handler,
> > which logs the warning message in question when it receives device check
> > twice on a same device.  Before the change, the container-specific
> > notify handler did not log this message in the same case (but considered
> > it as an eject request).
> > 
> > So, I suspect that you are getting device check twice regardless of the
> > kernel change.  Can you check KERN_DEBUG messages to see if that is the
> > case?  The notify handler logs all events with KERN_DEBUG.
> 
> Follow your suggestion, we confirm that it really received ACPI_NOTIFY_
> DEVICE_CHECK event*twice*, but the original ACPI container driver only
> received once, does the common device hotplug code introduce another device
> check? any idea?

Well, we couldn't possibly make the BIOS generate the event twice unless
there's an _OST response missing somewhere or similar.

In any case the second event should be harmless.

> Container uses common device hotplug code:
> [  142.937724] IPv6: ADDRCONF(NETDEV_CHANGE): eth8: link becomes ready
> [  674.975575] ACPI: \_SB_.LSB1: ACPI_NOTIFY_DEVICE_CHECK event          <<<<
> [  674.991604] ACPI: \_SB_.LSB1: ACPI_NOTIFY_DEVICE_CHECK event		 <<<<	

Where exactly did you put that printk()?

> [  675.613990] ACPI: PCI Root Bridge [UNC2] (domain 0000 [bus fd])
> [  675.684970] acpi PNP0A03:01: ACPI _OSC support notification failed, disabling PCIe ASPM
> [  675.780957] acpi PNP0A03:01: Unable to request _OSC control (_OSC support mask: 0x08)
> [  675.874806] ACPI _OSC control for PCIe not granted, disabling ASPM
> [  675.949005] pci_bus 0000:fd: Allocating resources
> [  675.960145] ACPI: PCI Root Bridge [UNC3] (domain 0000 [bus fc])
> [  676.031176] acpi PNP0A03:02: ACPI _OSC support notification failed, disabling PCIe ASPM
> [  676.127129] acpi PNP0A03:02: Unable to request _OSC control (_OSC support mask: 0x08)
> [  676.220943] ACPI _OSC control for PCIe not granted, disabling ASPM
> [  676.295019] pci_bus 0000:fc: Allocating resources
> 
> Original ACPI container driver:
> [ 1526.122933] Container driver received ACPI_NOTIFY_DEVICE_CHECK event <<<<

And that?

> [ 1526.800646] ACPI: PCI Root Bridge [UNC2] (domain 0000 [bus fd])
> [ 1526.871682] acpi PNP0A03:01: ACPI _OSC support notification failed, disabling PCIe ASPM
> [ 1526.967878] acpi PNP0A03:01: Unable to request _OSC control (_OSC support mask: 0x08)
> [ 1527.061891] ACPI _OSC control for PCIe not granted, disabling ASPM
> [ 1527.136036] pci_bus 0000:fd: Allocating resources
> [ 1527.150747] ACPI: PCI Root Bridge [UNC3] (domain 0000 [bus fc])
> [ 1527.221821] acpi PNP0A03:02: ACPI _OSC support notification failed, disabling PCIe ASPM
> [ 1527.317738] acpi PNP0A03:02: Unable to request _OSC control (_OSC support mask: 0x08)
> [ 1527.411795] ACPI _OSC control for PCIe not granted, disabling ASPM
> [ 1527.485917] pci_bus 0000:fc: Allocating resources

Thanks,
Rafael

