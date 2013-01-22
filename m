Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756296Ab3AVX4b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 18:56:31 -0500
Received: from mail-da0-f52.google.com ([209.85.210.52]:60065 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805Ab3AVX42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 18:56:28 -0500
Date: Tue, 22 Jan 2013 15:56:24 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Kristen C. Accardi" <kristen.c.accardi@intel.com>,
        Len Brown <lenb@kernel.org>
Subject: Re: [PATCH 4/4] ACPI / PM: Expose lists of device power resources to
 user space
Message-ID: <20130122235624.GF694@kroah.com>
References: <3307415.pdOY6ovZLa@vostro.rjw.lan>
 <4247313.2G7Z3nCgM0@vostro.rjw.lan>
 <2760421.6nE3tkh92K@vostro.rjw.lan>
 <1477263.uvKKInuF7l@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1477263.uvKKInuF7l@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 03:28:23AM +0100, Rafael J. Wysocki wrote:
> +static struct attribute *attrs[] = {
> +	NULL,
> +};

That's "odd"...

> +static void acpi_power_hide_list(struct acpi_device *adev,
> +				 struct acpi_device_power_state *ps,
> +				 const char *group_name)
>  {
> -	if (adev->power.flags.power_resources) {
> -		struct acpi_device_power_state *ps;
> -		struct acpi_power_resource_entry *entry;
> -
> -		ps = &adev->power.states[ACPI_STATE_D0];
> -		list_for_each_entry(entry, &ps->resources, node) {
> -			struct acpi_power_resource *resource = entry->resource;
> -
> -			if (add)
> -				acpi_power_add_dependent(resource, adev);
> -			else
> -				acpi_power_remove_dependent(resource, adev);
> +	struct attribute_group attr_group = {
> +		.name	= group_name,
> +		.attrs	= attrs,
> +	};

This is on the stack, which seems like it would not be good...

> +	struct acpi_power_resource_entry *entry;
> +
> +	list_for_each_entry_reverse(entry, &ps->resources, node) {
> +		struct acpi_device *res_dev = &entry->resource->device;
> +
> +		sysfs_remove_link_from_group(&adev->dev.kobj, group_name,
> +					     dev_name(&res_dev->dev));
> +	}
> +	sysfs_remove_group(&adev->dev.kobj, &attr_group);

You aren't removing the same group that you created.  Well, kind of, but
that's strange, it really works?

> +static void acpi_power_expose_list(struct acpi_device *adev,
> +				   struct acpi_device_power_state *ps,
> +				   const char *group_name)
> +{
> +	struct attribute_group attr_group = {
> +		.name	= group_name,
> +		.attrs	= attrs,
> +	};

again a structure on the stack.

Why not just create the attribute groups as static, instead of
"pseudo-dynamically" like you are doing here?  I have no idea if sysfs
can properly cope with an attribute group pointer that disappears after
it has been registered with the sysfs core.  That seems ripe for
problems, don't you agree?

Oh, and same question about racing userspace, you will have problems
here in that the symlinks will be showing up after the device is
created.  Perhaps, to make the whole thing easier, you just change the
acpi core code to hold off on the notification until you get all of
these links and files set up and then tell userspace.  That's probably
an easier fix.

thanks,

greg k-h
