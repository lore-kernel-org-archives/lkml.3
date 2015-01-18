Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016AbbARBpf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 20:45:35 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:47306 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbbARBpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 20:45:33 -0500
Message-ID: <54BB102B.1060606@roeck-us.net>
Date: Sat, 17 Jan 2015 17:45:15 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, kernel@savoirfairelinux.com
Subject: Re: [PATCH] sysfs: group: allow is_visible to drop permissions
References: <526250410.74266.1421532551922.JavaMail.root@mail>
In-Reply-To: <526250410.74266.1421532551922.JavaMail.root@mail>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020204.54BB103D.002B,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
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

On 01/17/2015 02:09 PM, Vivien Didelot wrote:
> Hi Guenter, Greg,
>
[ .. ]

>
> BTW Guenter, does this patch make sense to you?
>

It does make sense to me to only use the return value from is_visible
for the mode.

As for which bits to use, I am not entirely sure. I think it would be
more important to first decide which bits should be acceptable to start with.

Then I would _always_ only use the bits from mode, masked against the
valid bits, whatever they are.

	umode_t mode = (*attr)->mode;
	...
	if (grp->is_visible) {
		mode = grp->is_visible(kobj, *attr, i);
		if (!mode)
			continue;
	}

	WARN(mode & ~(S_IRUGO | S_IWUGO | SYSFS_PREALLOC),	/* optional */
	     "Attribute %s: Invalid permission 0x%x\n", (*attr)->name, mode);

	mode &= S_IRUGO | S_IWUGO | SYSFS_PREALLOC;
	error = sysfs_add_file_mode_ns(parent, *attr, false, mode, NULL);
	...

>
> My assumption here was that the attribute group is_visible function
> should just be able to adjust the UGO bits. Am I correct?
>
I would think so.

> I'm not even sure about the execute permission though. Only one driver
> uses it for an attribute and it seems wrong, in drivers/hid/hid-lg4ff.c:
>
> static DEVICE_ATTR(range, S_IRWXU | S_IRWXG | S_IROTH, lg4ff_range_show, lg4ff_range_store);
>
That seems wrong.

>
> The actual behavior seems wrong to me. Again, what happens is you return
> SYSFS_PREALLOC, that the underlying sysfs_add_file_mode_ns() function is
> actually checking?
>
Ultimately, the implementor asked for it.

> IMHO, if we want an attribute group to only be able to "hide or show" an
> attribute, then is_visible (as the name suggests) should return a
> boolean. If we want it be able to adjust permissions (as it seems
> correct, given the examples), we should identify which permissions are
> OK to change, deprecate is_visible function (to avoid code break) in
> favor of a new one which limits the bits to that scope.
>

Up to Greg to decide. From my perspective, we have lived with is_visible
for several years and overall it seems to work. Sure, it lacks a clear
API, but that can be fixed without changing a lot of code just to replace
the function name.

Guenter

