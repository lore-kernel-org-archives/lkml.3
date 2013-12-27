Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967Ab3L0AT7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 19:19:59 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:54526 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751229Ab3L0AT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 19:19:58 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Toshi Kani <toshi.kani@hp.com>,
        Yinghai Lu <yinghai@kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH 1/2][Untested] ACPI / hotplug: Add demand_offline hotplug profile flag
Date: Fri, 27 Dec 2013 01:33:30 +0100
Message-ID: <2270511.t53XC5JBYQ@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <52BB9E0C.8020102@jp.fujitsu.com>
References: <1421028.Rsfpmhnym3@vostro.rjw.lan> <2003756.4bDvk8cJ93@vostro.rjw.lan> <52BB9E0C.8020102@jp.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, December 26, 2013 12:10:04 PM Yasuaki Ishimatsu wrote:
> (2013/12/23 23:00), Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >
> > Add a new ACPI hotplug profile flag, demand_offline, such that if
> > set for the given ACPI device object's scan handler, it will cause
> > acpi_scan_hot_remove() to check if that device object's physical
> > companions are offline upfront and fail the hot removal if that
> > is not the case.
> >
> > That flag will be useful to overcome a problem with containers on
> > some system where they can only be hot-removed after some cleanup
> > operations carried out by user space, which needs to be notified
> > of the container hot-removal before the kernel attempts to offline
> > devices in the container.  In those cases the current implementation
> > of acpi_scan_hot_remove() is not sufficient, because it first tries
> > to offline the devices in the container and only if that is
> > suffcessful it tries to offline the container itself.  As a result,
> > the container hot-removal notification is not delivered to user space
> > at the right time.
> >
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > ---
> >   drivers/acpi/scan.c     |   41 +++++++++++++++++++++++++++++++++++++----
> >   include/acpi/acpi_bus.h |    3 ++-
> >   2 files changed, 39 insertions(+), 5 deletions(-)
> >
> > Index: linux-pm/drivers/acpi/scan.c
> > ===================================================================
> > --- linux-pm.orig/drivers/acpi/scan.c
> > +++ linux-pm/drivers/acpi/scan.c
> > @@ -126,6 +126,24 @@ acpi_device_modalias_show(struct device
> >   }
> >   static DEVICE_ATTR(modalias, 0444, acpi_device_modalias_show, NULL);
> >
> > +static bool acpi_scan_is_offline(struct acpi_device *adev)
> > +{
> > +	struct acpi_device_physical_node *pn;
> > +	bool offline = true;
> > +
> > +	mutex_lock(&adev->physical_node_lock);
> > +
> > +	list_for_each_entry(pn, &adev->physical_node_list, node)
> 
> > +		if (!pn->dev->offline) {
> 
> Please check pn->dev->bus and pn->dev->bus->offline too as follow:
> 
> 		if (pn->dev->bus && pn->dev->bus->offline &&
> 		    !pn->dev->offline) {
> 
> My container has CPU and Memory and PCI root bridge. PCI root bridge
> does not has offline function (pn->dev->bus->offline). So I cannot offline
> the device and pn->dev->offline of the device is always 0. Therefore,
> following operation always returns -EBUSY even if I offline CPUs and
> all memory sections on a container device.
> 
> echo 0 > /sys/bus/container/devices/ACPI0004:01/online

I see.  We simply can do

	if (device_supports_offline(pn->dev) && !pn->dev->offline) {

there I think.

Thanks,
Rafael

