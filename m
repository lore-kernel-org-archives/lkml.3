Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757523AbaGWI1E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 04:27:04 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:34231 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757367AbaGWI06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 04:26:58 -0400
MIME-Version: 1.0
In-Reply-To: <6018343.yi13pxNXUP@vostro.rjw.lan>
References: <1406056419-3047-1-git-send-email-arjun024@gmail.com> <6018343.yi13pxNXUP@vostro.rjw.lan>
From: Arjun <arjun024@gmail.com>
Date: Wed, 23 Jul 2014 13:56:36 +0530
Message-ID: <CAJFMrCH1yeZfEo=z6Vj-qaK=Qpiu9KoqJOLsUo-p1yYcxr+L-g@mail.gmail.com>
Subject: Re: [PATCH] PNPACPI: check return value of pnpacpi_parse_allocated_resource()
 and pnpacpi_parse_resource_option_data()
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACPI 5.0 resource types like FixedDMA will fail pnpacpi_allocated_resource().
pnpacpi_add_device() has to return error in that case.

On 23 July 2014 03:42, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> On Wednesday, July 23, 2014 12:43:39 AM Arjun Sreedharan wrote:
>> Handle error condition since pnpacpi_parse_allocated_resource() and pnpacpi_parse_resource_option_data() could return -EPERM.
>>
>> Signed-off-by: Arjun Sreedharan <arjun024@gmail.com>
>
> I wonder if this fixes any functional issue you've seen or someone has
> reported to you or it's just an "Oh, we probably should handle the return
> values here" kind of thing?
>
>> ---
>>  drivers/pnp/pnpacpi/core.c | 8 ++++++--
>>  1 file changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/pnp/pnpacpi/core.c b/drivers/pnp/pnpacpi/core.c
>> index b81448b..c3214e9 100644
>> --- a/drivers/pnp/pnpacpi/core.c
>> +++ b/drivers/pnp/pnpacpi/core.c
>> @@ -272,10 +272,14 @@ static int __init pnpacpi_add_device(struct acpi_device *device)
>>               strncpy(dev->name, acpi_device_bid(device), sizeof(dev->name));
>>
>>       if (dev->active)
>> -             pnpacpi_parse_allocated_resource(dev);
>> +             error = pnpacpi_parse_allocated_resource(dev);
>> +             if (error)
>> +                     return error;
>>
>>       if (dev->capabilities & PNP_CONFIGURABLE)
>> -             pnpacpi_parse_resource_option_data(dev);
>> +             error = pnpacpi_parse_resource_option_data(dev);
>> +             if (error)
>> +                     return error;
>>
>>       list_for_each_entry(id, &device->pnp.ids, list) {
>>               if (!strcmp(id->id, pnpid))
>>
>
> --
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.
