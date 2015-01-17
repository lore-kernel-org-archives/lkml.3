Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735AbbAQBwu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 20:52:50 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:55883 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbbAQBws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 20:52:48 -0500
Message-ID: <54B9C05E.1020309@roeck-us.net>
Date: Fri, 16 Jan 2015 17:52:30 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, kernel@savoirfairelinux.com
Subject: Re: [PATCH] sysfs: group: allow is_visible to drop permissions
References: <1547866090.421966.1421454145360.JavaMail.root@mail>
In-Reply-To: <1547866090.421966.1421454145360.JavaMail.root@mail>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020201.54B9C06F.015E,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 2
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2015 04:22 PM, Vivien Didelot wrote:
> Hi Greg,
>
>> On Fri, Jan 16, 2015 at 04:29:10PM -0500, Vivien Didelot wrote:
>>> Using the optional is_visible function, it is actually possible to
>>> either hide an attribute, or add a new permission, but not remove
>>> one.
>>
>> What code wants to remove attributes?
>
Actually, that can happen and is supported (if is_visible returns 0
when updating an attribute group).

> Sorry, I meant removing a permission. Actually, drivers hide attributes
> (if a feature isn't supported by a device) by returning 0 in is_visible.
>
> E.g, if we consider a read-only attribute, a driver can add the write
> permission by returning S_IWUSR, but removing S_IRUGO isn't possible.
>
>>> This commit uses all the UGO bits returned by is_visible instead of
>>> OR'ing them with the default attribute mode.
>>>
>>> Concretely, this allows a driver to use macros like DEVICE_ATTR_RW
>>> to
>>> set the attribute show and store functions and remove the S_IWUSR
>>> permission in is_visible if the implementation doesn't provide a
>>> setter.
>>
>> What bus wants to do this?
>
Every driver which has an attribute which is not always writable.
The scsi code fragment I copied below would be another example.

> Some high level frameworks such as DSA. My motivation behind this was to
> clarify how modes are set for temperature attributes in DSA. Optional
> functions can be provided by switch drivers to get temperatures or set
> limits. I hope the following patch helps clarifying this point:
> https://gist.github.com/vivien/72734ba0673ad0b79a6b
>
> (I Cc: Guenter as he is the author of NET_DSA_HWMON, see 51579c3).
>
>>> Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
>>> ---
>>>   fs/sysfs/group.c | 12 +++++++-----
>>>   1 file changed, 7 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/fs/sysfs/group.c b/fs/sysfs/group.c
>>> index 7d2a860..a8cfe03 100644
>>> --- a/fs/sysfs/group.c
>>> +++ b/fs/sysfs/group.c
>>> @@ -41,7 +41,7 @@ static int create_files(struct kernfs_node
>>> *parent, struct kobject *kobj,
>>>
>>>   	if (grp->attrs) {
>>>   		for (i = 0, attr = grp->attrs; *attr && !error; i++, attr++) {
>>> -			umode_t mode = 0;
>>> +			umode_t mode = (*attr)->mode;
>>>
>>>   			/*
>>>   			 * In update mode, we're changing the permissions or
>>> @@ -51,13 +51,15 @@ static int create_files(struct kernfs_node
>>> *parent, struct kobject *kobj,
>>>   			if (update)
>>>   				kernfs_remove_by_name(parent, (*attr)->name);
>>>   			if (grp->is_visible) {
>>> -				mode = grp->is_visible(kobj, *attr, i);
>>> -				if (!mode)
>>> +				umode_t ugo = grp->is_visible(kobj, *attr, i);
>>> +
>>> +				if (!(ugo & S_IRWXUGO))
>>>   					continue;
>>> +
>>> +				mode = (mode & ~S_IRWXUGO) | (ugo & S_IRWXUGO);
>>
>> Please document what you are doing here in the code, it's not obvious
>> at first glance.
>>
>>>   			}
>>>   			error = sysfs_add_file_mode_ns(parent, *attr, false,
>>> -						       (*attr)->mode | mode,
>>> -						       NULL);
>>> +						       mode, NULL);
>>
>> Any chance this is going to break existing code that isn't expecting
>> this type of change in functionality?
>
> Usually, drivers return 0 to hide the attribute, or the attr->mode to
> show it. This change should not break this expectation.
>

I am a bit concerned with 'Usually' and 'should not'. While you are correct,
the only way to know for sure would be to go through all is_visible functions
and make sure. And we don't really know why the original commit (0f4238958d)
chose to use "(*attr)->mode | mode" instead of just mode.

In this context, it is interesting that the scsi code, for which is_visible
was changed to return umode_t, appears to use it in a way that doesn't work.
The following code fragment is from drivers/scsi/scsi_sysfs.c.

static DEVICE_ATTR(queue_depth, S_IRUGO | S_IWUSR, sdev_show_queue_depth,
                    sdev_store_queue_depth);
...
         if (attr == &dev_attr_queue_depth.attr &&
             !sdev->host->hostt->change_queue_depth)
                 return S_IRUGO;

Oops ...

Given that, one could argue that the change to just use the return value
of is_visible may cause some trouble with lost permissions here or there,
but that it is already used in a wrong way and therefore _should_ be
changed.

> In the meantime, as the returned value is OR'ed with the actual mode,
> I'm wondering if a driver can break anything by returning, let's say ~0?
>
> That's why I kept the eventual extra bits from the attribute mode and OR
> them with only the UGO bits from the return of is_visible, similar to
> what sysfs_chmod_file() does.
>
Are there mode flags which have bits other than S_IRWXUGO set, or is that
another assumption ? If there are, why would or should is_visible be limited
to the S_IRWXUGO bits ?

So ultimately you have two semantic changes: One to limit the scope of
is_valid to S_IRWXUGO, and one to only use the bits from is_visible
within that scope, but keep using the other bits from the original mode.
Plus, returning ~S_IRWXUGO from asn in_visible function now results in
the file not being visible at all. Wonder if that should be more than
one patch, and if the changes should be discussed separately.

Thanks,
Guenter

