Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374AbbATCme (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 21:42:34 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:35763 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbbATCmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 21:42:32 -0500
Message-ID: <54BDC087.4010906@roeck-us.net>
Date: Mon, 19 Jan 2015 18:42:15 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, kernel <kernel@savoirfairelinux.com>
Subject: Re: [PATCH 2/3] sysfs: Only accept read/write permissions for file
 attributes
References: <643183939.413796.1421712438502.JavaMail.root@mail>
In-Reply-To: <643183939.413796.1421712438502.JavaMail.root@mail>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020203.54BDC098.004E,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
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

On 01/19/2015 04:07 PM, Vivien Didelot wrote:
> Hi Guenter,
>
>> For sysfs file attributes, only read and write permisssions make sense.
>
> Minor typo, there's an extra 's' to permissions.
>
>> Mask provided attribute permissions accordingly and send a warning
>> to the console if invalid permission bits are set.
>>
>> Cc: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
>> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
>> ---
>>   fs/sysfs/group.c | 6 ++++++
>>   1 file changed, 6 insertions(+)
>>
>> diff --git a/fs/sysfs/group.c b/fs/sysfs/group.c
>> index 305eccb..0de6473 100644
>> --- a/fs/sysfs/group.c
>> +++ b/fs/sysfs/group.c
>> @@ -55,6 +55,12 @@ static int create_files(struct kernfs_node *parent, struct kobject *kobj,
>>                                   if (!mode)
>>                                           continue;
>>                           }
>> +
>> +                        WARN(mode & ~(S_IRUGO | S_IWUGO | SYSFS_PREALLOC),
>> +                             "Attribute %s: Invalid permission 0x%x\n",
>> +                             (*attr)->name, mode);
>
> To print permissions, I would suggest unsigned octal ("0%o").
>
Fine with me.

>> +
>> +                        mode &= S_IRUGO | S_IWUGO | SYSFS_PREALLOC;
>
> As readable attributes are created with S_IRUGO and writable attributes are
> created with S_IWUSR, I would limit the scope of is_visible to only:
> S_IRUGO | S_IWUSR. Write permission for group and others feels wrong.

That seems to be too restrictive to me. There are several attributes
(I count 32) which permit group writes (search for "DEVICE_ATTR.*IWGRP").

>
> Then, I think we may want to keep the extra bits (all mode bits > 0777) from
> the default attribute mode. Can they be used for sysfs attributes?
>

I have not seen it anywhere, except for execute permissions in
drivers/hid/hid-lg4ff.c (which should be fixed).

Of course, I may have missed some.

> My suggestion is something like this:
>
>          /* Limit the scope to S_IRUGO | S_IWUSR */
>          if (mode & ~(S_IRUGO | S_IWUSR))
>                  pr_warn("Attribute %s: Invalid permissions 0%o\n",
>                          (*attr)->name, mode);
>
The reason for WARN() was to give the implementer a strong incentive to fix it,
and to show the calling path. Only displaying the attribute name makes it
difficult to identify the culprit, at least for widely used attribute names.

>          mode &= S_IRUGO | S_IWUSR;
>
>          /* Use only returned bits and defaults > 0777 */
>          mode |= (*attr)->mode & ~S_IRWXUGO;
>
>>                           error = sysfs_add_file_mode_ns(parent, *attr, false,
>>                                                          mode, NULL);
>>                           if (unlikely(error))
>
> The code hitting this warning actually is drivers/pci/pci-sysfs.c, which
> declares write-only attributes with S_IWUSR|S_IWGRP (0220). Is that correct to
> have write access for group for these attributes?

Why not ? Not our call to make.

Anyway, my goal was to keep things simple. Taking some bits from the default
and others from the return value of the is_visible function isn't simple,
even more so since your code would require the is_visible function to mask
out SYSFS_PREALLOC to avoid the warning.

[ Note that I don't like SYSFS_PREALLOC to start with; it overloads
   mode and, worse, is identical to S_IFIFO and part of the S_IFMT mask.
   But that is a different issue. ]

Thanks,
Guenter
