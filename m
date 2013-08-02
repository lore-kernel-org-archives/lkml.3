Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050Ab3HBPQb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 11:16:31 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:50323 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296Ab3HBPQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 11:16:28 -0400
MIME-Version: 1.0
In-Reply-To: <2560973.EJVuxm6PHt@vostro.rjw.lan>
References: <1888947.F5IBMfDKlY@vostro.rjw.lan>
	<CAOLK0pxJM6ip-dzcEfswULnJR-qb=X_EXnBbdeSNMRKExPxq3Q@mail.gmail.com>
	<2560973.EJVuxm6PHt@vostro.rjw.lan>
Date: Fri, 2 Aug 2013 23:16:27 +0800
Message-ID: <CAOLK0pw_VipEwfPTOP_bKCT8yH9ZH0XAz9-40SM7ZTO-evsExQ@mail.gmail.com>
Subject: Re: [PATCH] ACPI: Do not fail acpi_bind_one() if device is already
 bound correctly
From: Lan Tianyu <lantianyu1986@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Toshi Kani <toshi.kani@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/8/2 Rafael J. Wysocki <rjw@sisk.pl>:
> On Friday, August 02, 2013 10:48:49 AM Lan Tianyu wrote:
>> 2013/8/2 Rafael J. Wysocki <rjw@sisk.pl>:
>> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>> >
>> > Modify acpi_bind_one() so that it doesn't fail if the device
>> > represented by its first argument has already been bound to the
>> > given ACPI handle (second argument), because that is not a good
>> > enough reason for returning an error code.
>> >
>> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>> > ---
>> >  drivers/acpi/glue.c |   15 +++++++++++----
>> >  1 file changed, 11 insertions(+), 4 deletions(-)
>> >
>> > Index: linux-pm/drivers/acpi/glue.c
>> > ===================================================================
>> > --- linux-pm.orig/drivers/acpi/glue.c
>> > +++ linux-pm/drivers/acpi/glue.c
>> > @@ -143,7 +143,10 @@ int acpi_bind_one(struct device *dev, ac
>> >         list_for_each_entry(pn, &acpi_dev->physical_node_list, node)
>> >                 if (pn->dev == dev) {
>> >                         dev_warn(dev, "Already associated with ACPI node\n");
>> > -                       goto err_free;
>> > +                       if (ACPI_HANDLE(dev) == handle)
>> > +                               retval = 0;
>> > +
>> > +                       goto out_free;
>> >                 }
>> >
>> >         /* allocate physical node id according to physical_node_id_bitmap */
>> > @@ -152,7 +155,7 @@ int acpi_bind_one(struct device *dev, ac
>> >                 ACPI_MAX_PHYSICAL_NODE);
>> >         if (physical_node->node_id >= ACPI_MAX_PHYSICAL_NODE) {
>> >                 retval = -ENOSPC;
>> > -               goto err_free;
>> > +               goto out_free;
>> >         }
>> >
>> >         set_bit(physical_node->node_id, acpi_dev->physical_node_id_bitmap);
>> > @@ -185,10 +188,14 @@ int acpi_bind_one(struct device *dev, ac
>> >         put_device(dev);
>> >         return retval;
>> >
>> > - err_free:
>> > + out_free:
>> >         mutex_unlock(&acpi_dev->physical_node_lock);
>> >         kfree(physical_node);
>> > -       goto err;
>> > +       if (retval)
>> > +               goto err;
>> > +
>> > +       put_device(dev);
>> > +       return 0;
>> >  }
>> >  EXPORT_SYMBOL_GPL(acpi_bind_one);
>>
>> Hi Rafael:
>>             How about the following change?
>
> It is incorrect, because the "problem" it attempts to "fix" is actually
> intentional behavior.  [And you could ask if it was intentional in the first
> place instead of assuming that it was a mistake.  It wasn't.]
>

Ok.

> Do you have any problems with my $subject patch?

No, I have no problem now.

Reviewed-by: Lan Tianyu <tianyu.lan@intel.com>

>
> Rafael
>
>
>>
>> diff --git a/drivers/acpi/glue.c b/drivers/acpi/glue.c
>> index f70cc45..35f375e 100644
>> --- a/drivers/acpi/glue.c
>> +++ b/drivers/acpi/glue.c
>> @@ -183,19 +183,15 @@ int acpi_bind_one(struct device *dev, acpi_handle handle)
>>
>>         return 0;
>>
>> - err:
>> -       ACPI_HANDLE_SET(dev, NULL);
>> -       put_device(dev);
>> -       return retval;
>> -
>>   out_free:
>>         mutex_unlock(&acpi_dev->physical_node_lock);
>>         kfree(physical_node);
>> -       if (retval)
>> -               goto err;
>>
>> + err:
>> +       if (retval)
>> +               ACPI_HANDLE_SET(dev, NULL);
>>         put_device(dev);
>> -       return 0;
>> +       return retval;
>>  }
>>  EXPORT_SYMBOL_GPL(acpi_bind_one);
>> ---------------
>>
>> When I reviewed this patch, found the dev's acpi handle always
>> is set  to NULL if there is error. This seems make no sense for
>> the case that the handle has been set to dev before binding.
>>
>> For this case, the acpi handle has been found before binding.
>> Actually, the device driver could control any resources under ACPI
>> node even if the binding failed. So adding one flag to differentiate
>> it.
>>
>> diff --git a/drivers/acpi/glue.c b/drivers/acpi/glue.c
>> index 35f375e..c868e51 100644
>> --- a/drivers/acpi/glue.c
>> +++ b/drivers/acpi/glue.c
>> @@ -113,6 +113,7 @@ int acpi_bind_one(struct device *dev, acpi_handle handle)
>>         acpi_status status;
>>         struct acpi_device_physical_node *physical_node, *pn;
>>         char physical_node_name[sizeof(PHYSICAL_NODE_STRING) + 2];
>> +       bool has_handle = false;
>>         int retval = -EINVAL;
>>
>>         if (ACPI_HANDLE(dev)) {
>> @@ -121,6 +122,7 @@ int acpi_bind_one(struct device *dev, acpi_handle handle)
>>                         return -EINVAL;
>>                 } else {
>>                         handle = ACPI_HANDLE(dev);
>> +                       has_handle = true;
>>                 }
>>         }
>>         if (!handle)
>> @@ -188,7 +190,7 @@ int acpi_bind_one(struct device *dev, acpi_handle handle)
>>         kfree(physical_node);
>>
>>   err:
>> -       if (retval)
>> +       if (retval && !has_handle)
>>                 ACPI_HANDLE_SET(dev, NULL);
>>         put_device(dev);
>>         return retval;
>>
>>
>>
>> >
>> >
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>>
>>
> --
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.



-- 
Best regards
Tianyu Lan
