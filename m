Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751120Ab3HSQFc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 12:05:32 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:34938 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860Ab3HSQFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 12:05:31 -0400
Message-ID: <52124248.3040802@wwwdotorg.org>
Date: Mon, 19 Aug 2013 10:05:28 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Caizhiyong <caizhiyong@huawei.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Karel Zak <kzak@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wanglin (Albert)" <albert.wanglin@huawei.com>,
        Quyaxin <quyaxin@huawei.com>
Subject: Re: [PATCH] block: support embedded device command line partition
References: <C3050A4DBA34F345975765E43127F10F1C061D75@szxeml512-mbs.china.huawei.com> <520CF92A.90909@wwwdotorg.org> <C3050A4DBA34F345975765E43127F10F1C0643F8@szxeml512-mbx.china.huawei.com> <520E4D1F.3000509@wwwdotorg.org> <C3050A4DBA34F345975765E43127F10F1C06666F@szxeml512-mbs.china.huawei.com>
In-Reply-To: <C3050A4DBA34F345975765E43127F10F1C06666F@szxeml512-mbs.china.huawei.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/2013 02:36 AM, Caizhiyong wrote:
>> On 08/15/2013 08:54 PM, Caizhiyong wrote:
>>>>> +blkdevparts=<blkdev-def>[;<blkdev-def>]
>>>>> +  <blkdev-def> := <blkdev-id>:<partdef>[,<partdef>]
>>>>> +    <partdef> := <size>[@<offset>](part-name)
>>>>> +
>>>>> +<blkdev-id>
>>>>> +    block device disk name, embedded device used fixed block device,
>>>>> +    it's disk name also fixed. such as: mmcblk0, mmcblk1, mmcblk0boot0.
>>>>
>>>> The device-name isn't always fixed.
>>>>
>>>> For example, what if there are multiple SDHCI controllers, one hosting a
>>>> fixed eMMC device and the other an SD card? It's quite typical for the
>>>> eMMC's device name (which is likely what should be affected by this
>>>> feature) to be mmcblk0 when no SD card is present, yet be mmcblk1 when
>>>> an SD card is present. Is there a more precise/stable way to define
>>>> which device the command-line option applies to?
>>>
>>> Yes. Fixed is for single controller.
>>> For multiple controllers, currently, there is not a simple way.
>>> I tend to do something in the eMMC driver, such as initialize order,
>>> but I have not tried.
>>
>> There have been proposals before to try and create a fixed naming for
>> the controllers (or rather the block devices they generate...) but
>> they've been rejected. I don't think we should rely on being able to do
>> that.
>>
>>>>> +
>>>>> +<offset>
>>>>> +    partition start address, in bytes.
>>>>> +
>>>>> +(part-name)
>>>>> +    partition name, kernel send uevent with "PARTNAME". application can create
>>>>> +    a link to block device partition with the name "PARTNAME".
>>>>> +    user space application can access partition by partition name.
>>>>
>>>> Do partitions usually have a PARTNAME attribute when probed through
>>>> normal mechanisms like MBR? If so, I guess this is fine.
>>>>
>>>> Perhaps we can just use , as the delimiter for all fields, rather than
>>>> special-casing part-name to use (), so:
>>>>
>>>> size,offset,partname,size,offset,partname,...
>>>>
>>>> The partname field could easily be empty if not needed.
>>>
>>> If no need partname, your bootargs are mmcblk0:1G,1G,1G,...
>>
>> Well, you always need the offset too. I don't think there's any harm in
>> forcing all fields to be specified in all cases; it makes the whole
>> system much more regular and less error-prone.
>>
>> Alternatively, use a different separator between fields for a given
>> partition, and between partitions, e.g.:
>>
>> size,offset,partname;size,offset,partname
>>
>> That way, you know that if you see a ; you're looking at a new
>> partition, and hence the partname field need not always be specified.
>> Although, if you want to specify a partname but not an offset you'd
>> still need empty fields, so just requiring all fields to always be
>> present still seems safest to me.
> 
> I just follow MTD cmdline partition format.(reference drivers/mtd/cmdlinepart.c)

Ah OK, consistency with an existing format used for similar purposes
probably does override any other concerns.

> There are many pitfalls in using this partition format, the designer is more
> consideration its ease of use, rather than safe.
> There is an other conversation: https://lkml.org/lkml/2013/8/3/16

