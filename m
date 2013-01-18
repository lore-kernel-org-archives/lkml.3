Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585Ab3ARVFr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 16:05:47 -0500
Received: from mail-ob0-f179.google.com ([209.85.214.179]:44392 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128Ab3ARVFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 16:05:45 -0500
MIME-Version: 1.0
In-Reply-To: <20121211012112.GA11273@local>
References: <1354210800-27230-1-git-send-email-dinggnu@gmail.com>
	<20121211012112.GA11273@local>
Date: Fri, 18 Jan 2013 22:05:45 +0100
X-Google-Sender-Auth: ZgHJlu6U1NhiEa6c45xnxL6KxmE
Message-ID: <CAM3j68oNeb5HVYVHTSnQoiBHa7T4krkiDLy0dQkBZUd5BQgo2w@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] uio.c: solve memory leak
From: Cong Ding <dinggnu@gmail.com>
To: "Hans J. Koch" <hjk@hansjkoch.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2012 at 2:21 AM, Hans J. Koch <hjk@hansjkoch.de> wrote:
> On Thu, Nov 29, 2012 at 05:40:00PM +0000, Cong Ding wrote:
>> In version 1, I forgot to modify the same bug in the first loop.
>>
>> we have to call kobject_put() to clean up the kobject after function
>> kobject_init(), kobject_add(), or kobject_uevent() is called.
>>
>> Signed-off-by: Cong Ding <dinggnu@gmail.com>
>
> Signed-off-by: "Hans J. Koch" <hjk@hansjkoch.de>

Hi Greg, is this patch stil in the queue?

- cong

>> ---
>>  drivers/uio/uio.c |   16 ++++++++++------
>>  1 files changed, 10 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
>> index 5110f36..79774d3 100644
>> --- a/drivers/uio/uio.c
>> +++ b/drivers/uio/uio.c
>> @@ -291,10 +291,10 @@ static int uio_dev_add_attributes(struct uio_device *idev)
>>               mem->map = map;
>>               ret = kobject_add(&map->kobj, idev->map_dir, "map%d", mi);
>>               if (ret)
>> -                     goto err_map;
>> +                     goto err_map_kobj;
>>               ret = kobject_uevent(&map->kobj, KOBJ_ADD);
>>               if (ret)
>> -                     goto err_map;
>> +                     goto err_map_kobj;
>>       }
>>
>>       for (pi = 0; pi < MAX_UIO_PORT_REGIONS; pi++) {
>> @@ -317,23 +317,27 @@ static int uio_dev_add_attributes(struct uio_device *idev)
>>               ret = kobject_add(&portio->kobj, idev->portio_dir,
>>                                                       "port%d", pi);
>>               if (ret)
>> -                     goto err_portio;
>> +                     goto err_portio_kobj;
>>               ret = kobject_uevent(&portio->kobj, KOBJ_ADD);
>>               if (ret)
>> -                     goto err_portio;
>> +                     goto err_portio_kobj;
>>       }
>>
>>       return 0;
>>
>>  err_portio:
>> -     for (pi--; pi >= 0; pi--) {
>> +     pi--;
>> +err_portio_kobj:
>> +     for (; pi >= 0; pi--) {
>>               port = &idev->info->port[pi];
>>               portio = port->portio;
>>               kobject_put(&portio->kobj);
>>       }
>>       kobject_put(idev->portio_dir);
>>  err_map:
>> -     for (mi--; mi>=0; mi--) {
>> +     mi--;
>> +err_map_kobj:
>> +     for (; mi >= 0; mi--) {
>>               mem = &idev->info->mem[mi];
>>               map = mem->map;
>>               kobject_put(&map->kobj);
>> --
>> 1.7.4.5
>>
>>
