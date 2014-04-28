Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268AbaD1B5R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 21:57:17 -0400
Received: from mga03.intel.com ([143.182.124.21]:47726 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752458AbaD1B5O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 21:57:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,940,1389772800"; 
   d="scan'208";a="522121016"
Message-ID: <1398650223.2443.12.camel@rzhang1-mobl4>
Subject: Re: [PATCH V5 09/12] ACPI: introduce acpi platform exclude id list
From: Zhang Rui <rui.zhang@intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhelgaas@google.com, matthew.garrett@nebula.com,
        rafael.j.wysocki@intel.com, dmitry.torokhov@gmail.com
Date: Mon, 28 Apr 2014 09:57:03 +0800
In-Reply-To: <5562797.vTJauiAbJc@vostro.rjw.lan>
References: <1396886819-2637-1-git-send-email-rui.zhang@intel.com>
	 <1396886819-2637-10-git-send-email-rui.zhang@intel.com>
	 <5562797.vTJauiAbJc@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-04-28 at 00:21 +0200, Rafael J. Wysocki wrote:
> On Tuesday, April 08, 2014 12:06:56 AM Zhang Rui wrote:
> > For ACPI PIC (PNP0000) and Timer (PNP0100) device objects, although
> > they have _HID control method, but they should not be enumerated to
> > platform bus, because there will never be any platform drivers for them.
> > 
> > Thus an exclude id list is introduced in this patch to prevent
> > those platform device nodes from being created.
> > 
> > Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> 
> This should go into [6/12] as well.
> 
I think it is okay to keep them as separate patches because they do not
break bisect. And this patch is just a cleanup, it does not fix a real
BUG in patch 6/12.

thanks,
rui

> > ---
> >  drivers/acpi/acpi_platform.c |   14 ++++++++++++++
> >  1 file changed, 14 insertions(+)
> > 
> > diff --git a/drivers/acpi/acpi_platform.c b/drivers/acpi/acpi_platform.c
> > index 33376a9..91ed43a 100644
> > --- a/drivers/acpi/acpi_platform.c
> > +++ b/drivers/acpi/acpi_platform.c
> > @@ -22,6 +22,17 @@
> >  
> >  ACPI_MODULE_NAME("platform");
> >  
> > +static const struct acpi_device_id excluded_id_list[] = {
> > +	{"PNP0000", 0},	/* PIC */
> > +	{"PNP0100", 0},	/* Timer */
> > +	{"", 0},
> > +};
> > +
> > +static bool is_exclusive_device(struct acpi_device *dev)
> > +{
> > +	return !acpi_match_device_ids(dev, excluded_id_list);
> > +}
> > +
> >  /**
> >   * acpi_create_platform_device - Create platform device for ACPI device node
> >   * @adev: ACPI device node to create a platform device for.
> > @@ -48,6 +59,9 @@ int acpi_create_platform_device(struct acpi_device *adev,
> >  	if (adev->physical_node_count)
> >  		return 0;
> >  
> > +	if (is_exclusive_device(adev))
> > +		return 0;
> > +
> >  	INIT_LIST_HEAD(&resource_list);
> >  	count = acpi_dev_get_resources(adev, &resource_list, NULL, NULL);
> >  	if (count < 0) {
> > 
> 


