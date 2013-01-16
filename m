Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103Ab3APHko (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 02:40:44 -0500
Received: from mail-da0-f53.google.com ([209.85.210.53]:60860 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676Ab3APHkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 02:40:42 -0500
Message-ID: <50F65972.9030605@gmail.com>
Date: Wed, 16 Jan 2013 15:40:34 +0800
From: "yanyg02@gmail.com" <yanyg02@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysfs: sysfs_update_group always fails and generates
 a WARNING CALL-trace
References: <20130116070425.GA3972@yvit> <20130116071509.GA865@kroah.com>
In-Reply-To: <20130116071509.GA865@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry. I'm a fresh. This is my first patch commit. And still now *mutt* 
does not configured properly.

I will study howto and commit patch again. Sorry.

-------------------
> On Wed, Jan 16, 2013 at 03:04:25PM +0800, yanyg wrote:
>> @sysfs_update_group@ always fails and borns a WARNING CALL-trace
>> if the group exists. BUT still now, no *reference* of this routine at all.
> I don't understand.
OK, sysfs routine @sysfs_update_group@ *never* works properly
>
>> >From fe40df7d716658a1fbdab79768628c81d4363428 Mon Sep 17 00:00:00 2001
>> From: yanyg <yanyg02@gmail.com>
>> Date: Wed, 16 Jan 2013 11:25:15 +0800
>> Subject: [PATCH] sysfs-fixes:
>>
>> @sysfs_update_group@ always fail and generates WARNING CALL trace.
>> fix @internal_create_group@ to avoid it.
> Why did you embed the patch here, with the words above it?  I would have
> to edit it to apply it :(
>
> It's also not in a format I can apply (no signed-off-by: line.)
So sorry.
>
>> ---
>>   fs/sysfs/group.c |   14 ++++++++++----
>>   1 files changed, 10 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/sysfs/group.c b/fs/sysfs/group.c
>> index 2df555c..51fcf62 100644
>> --- a/fs/sysfs/group.c
>> +++ b/fs/sysfs/group.c
>> @@ -60,7 +60,7 @@ static int internal_create_group(struct kobject *kobj, int update,
>>   				 const struct attribute_group *grp)
>>   {
>>   	struct sysfs_dirent *sd;
>> -	int error;
>> +	int error, do_put = 0;
>>   
>>   	BUG_ON(!kobj || (!update && !kobj->sd));
>>   
>> @@ -73,9 +73,14 @@ static int internal_create_group(struct kobject *kobj, int update,
>>   		return -EINVAL;
>>   	}
>>   	if (grp->name) {
>> -		error = sysfs_create_subdir(kobj, grp->name, &sd);
>> -		if (error)
>> -			return error;
>> +		sd = sysfs_get_dirent(kobj->sd, NULL, grp->name);
>> +		if (sd) {
>> +			do_put = 1;
>> +		} else {
>> +			error = sysfs_create_subdir(kobj, grp->name, &sd);
>> +			if (error)
>> +				return error;
>> +		}
>>   	} else
>>   		sd = kobj->sd;
>>   	sysfs_get(sd);
>> @@ -85,6 +90,7 @@ static int internal_create_group(struct kobject *kobj, int update,
>>   			sysfs_remove_subdir(sd);
>>   	}
>>   	sysfs_put(sd);
>> +	if (do_put) sysfs_put(sd);
> Always run your patches through scripts/checkpatch.pl and fix the
> problems it tells you about.
>
> What code in the kernel is hitting this today?
I write a simply virtual block device driver which calls 
@sysfs_update_group@ to updates attributes and modes, it fails.
YOU can reproduce the bug by append @sysfs_update_group@ at below any of 
@sysfs_create_group@ call.
>
> thanks,
>
> greg k-h
>

So too sorry for my silly.

yanyg02
