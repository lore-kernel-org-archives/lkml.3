Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208Ab3AWAC4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 19:02:56 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:50903 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755841Ab3AWACy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 19:02:54 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Kristen C. Accardi" <kristen.c.accardi@intel.com>,
        Len Brown <lenb@kernel.org>
Subject: Re: [PATCH 4/4] ACPI / PM: Expose lists of device power resources to user space
Date: Wed, 23 Jan 2013 01:08:54 +0100
Message-ID: <4110339.gOkm8VAsyn@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc4; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130122235624.GF694@kroah.com>
References: <3307415.pdOY6ovZLa@vostro.rjw.lan> <1477263.uvKKInuF7l@vostro.rjw.lan> <20130122235624.GF694@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 22, 2013 03:56:24 PM Greg Kroah-Hartman wrote:
> On Tue, Jan 22, 2013 at 03:28:23AM +0100, Rafael J. Wysocki wrote:
> > +static struct attribute *attrs[] = {
> > +	NULL,
> > +};
> 
> That's "odd"...

Well, I don't really need file attributes here (at least at the moment),
but sysfs_create_group() will complain if I just pass NULL in there.

> > +static void acpi_power_hide_list(struct acpi_device *adev,
> > +				 struct acpi_device_power_state *ps,
> > +				 const char *group_name)
> >  {
> > -	if (adev->power.flags.power_resources) {
> > -		struct acpi_device_power_state *ps;
> > -		struct acpi_power_resource_entry *entry;
> > -
> > -		ps = &adev->power.states[ACPI_STATE_D0];
> > -		list_for_each_entry(entry, &ps->resources, node) {
> > -			struct acpi_power_resource *resource = entry->resource;
> > -
> > -			if (add)
> > -				acpi_power_add_dependent(resource, adev);
> > -			else
> > -				acpi_power_remove_dependent(resource, adev);
> > +	struct attribute_group attr_group = {
> > +		.name	= group_name,
> > +		.attrs	= attrs,
> > +	};
> 
> This is on the stack, which seems like it would not be good...
> 
> > +	struct acpi_power_resource_entry *entry;
> > +
> > +	list_for_each_entry_reverse(entry, &ps->resources, node) {
> > +		struct acpi_device *res_dev = &entry->resource->device;
> > +
> > +		sysfs_remove_link_from_group(&adev->dev.kobj, group_name,
> > +					     dev_name(&res_dev->dev));
> > +	}
> > +	sysfs_remove_group(&adev->dev.kobj, &attr_group);
> 
> You aren't removing the same group that you created.  Well, kind of, but
> that's strange, it really works?

Yes, it does, as far as I can say.

> > +static void acpi_power_expose_list(struct acpi_device *adev,
> > +				   struct acpi_device_power_state *ps,
> > +				   const char *group_name)
> > +{
> > +	struct attribute_group attr_group = {
> > +		.name	= group_name,
> > +		.attrs	= attrs,
> > +	};
> 
> again a structure on the stack.
> 
> Why not just create the attribute groups as static, instead of
> "pseudo-dynamically" like you are doing here?

Basically because I'm lazy. :-)

They can be static if that's better.

> I have no idea if sysfs
> can properly cope with an attribute group pointer that disappears after
> it has been registered with the sysfs core.  That seems ripe for
> problems, don't you agree?

I don't think so having looked at the code, but I very well might overlook
something.  I'll change that.

> Oh, and same question about racing userspace, you will have problems
> here in that the symlinks will be showing up after the device is
> created.  Perhaps, to make the whole thing easier, you just change the
> acpi core code to hold off on the notification until you get all of
> these links and files set up and then tell userspace.  That's probably
> an easier fix.

I suppose so.

How can I do that?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
