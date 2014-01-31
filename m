Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932460AbaAaQCA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 11:02:00 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:50124 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932363AbaAaQBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 11:01:40 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Aaron Lu <aaron.lu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>
Subject: Re: [Update][PATCH 4/5][RFT] ACPI / hotplug / PCI: Simplify acpi_install_hotplug_notify_handler()
Date: Fri, 31 Jan 2014 17:16:03 +0100
Message-ID: <6209942.qBRV2jHzWd@vostro.rjw.lan>
User-Agent: KMail/4.11.4 (Linux/3.13.0+; KDE/4.11.4; x86_64; ; )
In-Reply-To: <20140131160157.GL18029@intel.com>
References: <2217793.001RY6hKlo@vostro.rjw.lan> <20140131154011.GK18029@intel.com> <20140131160157.GL18029@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, January 31, 2014 06:01:57 PM Mika Westerberg wrote:
> On Fri, Jan 31, 2014 at 05:40:11PM +0200, Mika Westerberg wrote:
> > On Fri, Jan 31, 2014 at 04:42:21PM +0100, Rafael J. Wysocki wrote:
> > > On Friday, January 31, 2014 05:28:36 PM Mika Westerberg wrote:
> > > > On Wed, Jan 29, 2014 at 01:00:57AM +0100, Rafael J. Wysocki wrote:
> > > > > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > > > 
> > > > > Use the observation that the ACPI scan handler of the device object
> > > > > in acpi_hotplug_notify_cb() can be obtained from that device object's
> > > > > handler pointer and do not pass it as data to
> > > > > acpi_install_hotplug_notify_handler() in acpi_scan_init_hotplug().
> > > > > 
> > > > > That allows the second argument of acpi_install_hotplug_notify_handler()
> > > > > to be dropped, so do it and update its callers accordingly.
> > > > > 
> > > > > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > > > ---
> > > > >  drivers/acpi/scan.c                |   31 ++++++++++++++++++-------------
> > > > >  drivers/pci/hotplug/acpiphp_glue.c |    2 +-
> > > > >  include/acpi/acpi_bus.h            |    2 +-
> > > > >  3 files changed, 20 insertions(+), 15 deletions(-)
> > > > > 
> > > > > Index: linux-pm/drivers/acpi/scan.c
> > > > > ===================================================================
> > > > > --- linux-pm.orig/drivers/acpi/scan.c
> > > > > +++ linux-pm/drivers/acpi/scan.c
> > > > > @@ -487,7 +487,6 @@ static void acpi_device_hotplug(void *da
> > > > >  
> > > > >  static void acpi_hotplug_notify_cb(acpi_handle handle, u32 type, void *data)
> > > > >  {
> > > > > -	struct acpi_scan_handler *handler = data;
> > > > >  	u32 ost_code = ACPI_OST_SC_SUCCESS;
> > > > >  	struct acpi_device *adev;
> > > > >  	acpi_status status;
> > > > > @@ -503,13 +502,6 @@ static void acpi_hotplug_notify_cb(acpi_
> > > > >  
> > > > >  	case ACPI_NOTIFY_EJECT_REQUEST:
> > > > >  		acpi_handle_debug(handle, "ACPI_NOTIFY_EJECT_REQUEST event\n");
> > > > > -		if (handler && !handler->hotplug.enabled) {
> > > > > -			acpi_handle_err(handle, "Eject disabled\n");
> > > > > -			ost_code = ACPI_OST_SC_EJECT_NOT_SUPPORTED;
> > > > > -			goto out;
> > > > > -		}
> > > > > -		acpi_evaluate_hotplug_ost(handle, ACPI_NOTIFY_EJECT_REQUEST,
> > > > > -					  ACPI_OST_SC_EJECT_IN_PROGRESS, NULL);
> > > > >  		break;
> > > > >  
> > > > >  	case ACPI_NOTIFY_DEVICE_WAKE:
> > > > > @@ -535,11 +527,24 @@ static void acpi_hotplug_notify_cb(acpi_
> > > > >  		goto out;
> > > > >  	}
> > > > >  
> > > > > +	mutex_lock(&acpi_scan_lock);
> > > > 
> > > > This is weird. I'm testing against your test-next branch which has this
> > > > patch included. If I remove locking here, TBT hotplug works fine. Otherwise
> > > > I can see the first hotplug/unplug works but after that I cannot get any
> > > > events anymore.
> > > 
> > > Weird indeed.  I don't seem to be able to reproduce that on my Aspire S5.
> > > 
> > > What system are you testing on?
> > 
> > This is Intel NUC. Let me see if I can reproduce this on S5 with longer
> > chain of devices.
> 
> OK, so on S5 this works even with longer chain. However, exactly the same
> kernel image on NUC fails after first hotplug/unplug cycle.

Well, we need to figure out what happens there.

Please add printks (1) before mutex_lock(), (2) before the if (type == ...)
instruction, (3) before the acpi_evaluate_hotplug_ost() under the if () and (4)
before the get_device() in acpi_notify_hotplug_cb() and check if they are all
printed (on NUC).

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
