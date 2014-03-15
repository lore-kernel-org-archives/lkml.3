Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755627AbaCOBM3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 21:12:29 -0400
Received: from mga11.intel.com ([192.55.52.93]:18088 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754752AbaCOBM2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 21:12:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,658,1389772800"; 
   d="scan'208";a="492397643"
From: "Zhang, Rui" <rui.zhang@intel.com>
To: "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>
CC: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "matthew.garrett@nebula.com" <matthew.garrett@nebula.com>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>
Subject: RE: [PATCH V2 06/13] ACPI: introduce enumerable_id flag
Thread-Topic: [PATCH V2 06/13] ACPI: introduce enumerable_id flag
Thread-Index: AQHPPte7KYuqmVAkrkSVvMKZtDwLWZrg0OuAgACG8FA=
Date: Sat, 15 Mar 2014 01:12:09 +0000
Message-ID: <744357E9AAD1214791ACBA4B0B90926301207EF6@SHSMSX103.ccr.corp.intel.com>
References: <1394727413-3587-1-git-send-email-rui.zhang@intel.com>
 <1394727413-3587-7-git-send-email-rui.zhang@intel.com>
 <5323A6D9.5070005@intel.com>
In-Reply-To: <5323A6D9.5070005@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Wysocki, Rafael J
> Sent: Saturday, March 15, 2014 9:03 AM
> To: Zhang, Rui
> Cc: linux-acpi@vger.kernel.org; linux-kernel@vger.kernel.org;
> bhelgaas@google.com; matthew.garrett@nebula.com;
> dmitry.torokhov@gmail.com
> Subject: Re: [PATCH V2 06/13] ACPI: introduce enumerable_id flag
> Importance: High
> 
> On 3/13/2014 5:16 PM, Zhang Rui wrote:
> > Only certain kind of ACPI device objects can be enumerated via ACPI.
> > These ACPI device objects include
> > 1. ACPI device objects that have _HID control method.
> > 2. some ACPI device objects that have Linux specified HID strings.
> >
> > In order to distinguish those device objects from the others, a new
> > flag enumerable_id and a new function acpi_add_eid() are introduced
> in this patch.
> 
> I don't really like the name of the new flag.  What about calling it
> platform_id (it is supposed to indicate that the core should create a
> platform device for it)?
>
I concerned about the same problem, but could not get a better name.
Yes, platform_id sounds much better.

> > Currently, only devices with _HID method have this flag set.
> > And in the future, if a device that has Linux specified HID strings
> > wants to be enumerated to platform bus, acpi_add_eid() should be used
> 
> And what about calling the new function acpi_add_platform_id()
> accordingly?
>
Agreed.
 
> > instead of acpi_add_id() when adding its Linux specified HID string.
> 
> And I don't quite understand the last paragraph as a whole.  Is it
> supposed to mean "if you want platform devices to be created for device
> objects without _HID, use acpi_add_platform_id() when adding artificial
> Linux-specific ID strings to them"?
> 
Yes.
Currently, we use acpi_add_id() for devices like video, thermal, etc,
If we want to see them in platform bus, we just a one line change to
replace acpi_add_id() with acpi_add_platform_id().

Thanks,
rui

> > Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> > ---
> >   drivers/acpi/scan.c     |    8 +++++++-
> >   include/acpi/acpi_bus.h |    3 ++-
> >   2 files changed, 9 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c index
> > 399257e..768f81d 100644
> > --- a/drivers/acpi/scan.c
> > +++ b/drivers/acpi/scan.c
> > @@ -1679,6 +1679,12 @@ static void acpi_add_id(struct acpi_device_pnp
> *pnp, const char *dev_id)
> >   	pnp->type.hardware_id = 1;
> >   }
> >
> > +static void acpi_add_eid(struct acpi_device_pnp *pnp, const char
> > +*dev_id) {
> > +	acpi_add_id(pnp, dev_id);
> > +	pnp->type.enumerable_id = 1;
> > +}
> > +
> >   /*
> >    * Old IBM workstations have a DSDT bug wherein the SMBus object
> >    * lacks the SMBUS01 HID and the methods do not have the necessary
> "_"
> > @@ -1729,7 +1735,7 @@ static void acpi_set_pnp_ids(acpi_handle handle,
> struct acpi_device_pnp *pnp,
> >   		}
> >
> >   		if (info->valid & ACPI_VALID_HID)
> > -			acpi_add_id(pnp, info->hardware_id.string);
> > +			acpi_add_eid(pnp, info->hardware_id.string);
> >   		if (info->valid & ACPI_VALID_CID) {
> >   			cid_list = &info->compatible_id_list;
> >   			for (i = 0; i < cid_list->count; i++) diff --git
> > a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h index
> > 8c5e235..688ca44 100644
> > --- a/include/acpi/acpi_bus.h
> > +++ b/include/acpi/acpi_bus.h
> > @@ -217,7 +217,8 @@ struct acpi_hardware_id {
> >   struct acpi_pnp_type {
> >   	u32 hardware_id:1;
> >   	u32 bus_address:1;
> > -	u32 reserved:30;
> > +	u32 enumerable_id:1;
> > +	u32 reserved:29;
> >   };
> >
> >   struct acpi_device_pnp {

