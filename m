Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550AbbATPoG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 10:44:06 -0500
Received: from mail.savoirfairelinux.com ([209.172.62.77]:58958 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239AbbATPoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 10:44:02 -0500
Date: Tue, 20 Jan 2015 10:44:01 -0500 (EST)
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, kernel <kernel@savoirfairelinux.com>
Message-ID: <1272429736.105015.1421768641283.JavaMail.root@mail>
In-Reply-To: <54BDC087.4010906@roeck-us.net>
Subject: Re: [PATCH 2/3] sysfs: Only accept read/write permissions for file
 attributes
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Mailer: Zimbra 7.1.4_GA_2555 (ZimbraWebClient - FF3.0 (Linux)/7.1.4_GA_2555)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

>>> @@ -55,6 +55,12 @@ static int create_files(struct kernfs_node *parent, struct kobject *kobj,
>>>                                   if (!mode)
>>>                                           continue;
>>>                           }
>>> +
>>> +                        WARN(mode & ~(S_IRUGO | S_IWUGO | SYSFS_PREALLOC),
>>> +                             "Attribute %s: Invalid permission 0x%x\n",
>>> +                             (*attr)->name, mode);
>>
>> To print permissions, I would suggest unsigned octal ("0%o").
>
> Fine with me.
>
>>> +
>>> +                        mode &= S_IRUGO | S_IWUGO | SYSFS_PREALLOC;
>>
>> As readable attributes are created with S_IRUGO and writable attributes are
>> created with S_IWUSR, I would limit the scope of is_visible to only:
>> S_IRUGO | S_IWUSR. Write permission for group and others feels wrong.
>
> That seems to be too restrictive to me. There are several attributes
> (I count 32) which permit group writes (search for "DEVICE_ATTR.*IWGRP").
>
>>
>> Then, I think we may want to keep the extra bits (all mode bits > 0777) from
>> the default attribute mode. Can they be used for sysfs attributes?
>>
>
> I have not seen it anywhere, except for execute permissions in
> drivers/hid/hid-lg4ff.c (which should be fixed).

Fixed and merged ;)

> Of course, I may have missed some.

>> My suggestion is something like this:
>>
>>          /* Limit the scope to S_IRUGO | S_IWUSR */
>>          if (mode & ~(S_IRUGO | S_IWUSR))
>>                  pr_warn("Attribute %s: Invalid permissions 0%o\n",
>>                          (*attr)->name, mode);
>>
> The reason for WARN() was to give the implementer a strong incentive to fix it,
> and to show the calling path. Only displaying the attribute name makes it
> difficult to identify the culprit, at least for widely used attribute names.

No objection with WARN(), I just decreased it to pr_warn() for testing.

>>          mode &= S_IRUGO | S_IWUSR;
>>
>>          /* Use only returned bits and defaults > 0777 */
>>          mode |= (*attr)->mode & ~S_IRWXUGO;
>>
>>>                           error = sysfs_add_file_mode_ns(parent, *attr, false,
>>>                                                          mode, NULL);
>>>                           if (unlikely(error))
>>
>> The code hitting this warning actually is drivers/pci/pci-sysfs.c, which
>> declares write-only attributes with S_IWUSR|S_IWGRP (0220). Is that correct to
>> have write access for group for these attributes?

> Why not ? Not our call to make.

I was concerned about attributes with group write permission, but you are
right, this is another discussion.

> Anyway, my goal was to keep things simple. Taking some bits from the default
> and others from the return value of the is_visible function isn't simple,
> even more so since your code would require the is_visible function to mask
> out SYSFS_PREALLOC to avoid the warning.

While I'm still not sure about the consequences of flipping this SYSFS_PREALLOC
bit at runtime, I do agree with your goal.

Then to keep it simple, the scope of is_visible could be limited to any bit
allowed at attribute declaration (using *_ATTR* macros). The compile-time check
macro VERIFY_OCTAL_PERMISSIONS() allows any bit but S_IWOTH. The scope can be
SYSFS_PREALLOC | 0775. (or 0664 if we want to avoid executables as well.)

[ This will prevent some follow-up patches "avoid world-writable sysfs files".
In the future, we may want a runtime equivalent of VERIFY_OCTAL_PERMISSIONS. ]

Thanks,
-v
