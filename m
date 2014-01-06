Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536AbaAFIpa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 03:45:30 -0500
Received: from mail-bk0-f43.google.com ([209.85.214.43]:43106 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864AbaAFIpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 03:45:23 -0500
Message-ID: <52CA6D14.4040300@profitbricks.com>
Date: Mon, 06 Jan 2014 09:45:08 +0100
From: Jack Wang <jinpu.wang@profitbricks.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: linux-fsdevel@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [BUG]NULL pointer dereference at 0000000000000008 __blkdev_put+0x17f/0x1d0
References: <52C19767.60000@profitbricks.com> <52C5331E.3050304@profitbricks.com> <20140104060925.GF10323@ZenIV.linux.org.uk>
In-Reply-To: <20140104060925.GF10323@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2014 07:09 AM, Al Viro wrote:
> On Thu, Jan 02, 2014 at 10:36:30AM +0100, Jack Wang wrote:
> 
>>> Bug happened at line 1486, looks disk->fops is NULL here for some
>>> reason, is it reasonable to add a check like:
>>>
>>> if (disk->fops)
>>> 	if (disk->fops->release)
>>> 		ret = disk->fops->release(disk, mode);
>>>
>>>
>>> Happy New Year and Best regards:)
>>> Jack
>>>
>>
>> Ping, could you share opnions on this, attached with patch I proposaled.
> 
> Sorry, had been sick since mid-December ;-/  The patch is not a good idea -
> in the best case it's papering over a bug (and insufficiently so, at that,
> since there are other places where disk->fops->some_method is checked).
> 
> gendisk->fops should never be assigned NULL; it starts life with NULL
> ->fops, but that should be assigned a non-NULL value (and never modified
> afterwards) before anyone can see it.  Moreover, even if some driver has
> fscked up and forgot to initialize the damn thing, get_gendisk() would've
> refused to return such a thing to any callers (including __blkdev_get()).
> Note that __blkdev_get() would oops on such a thing if get_gendisk()
> somehow returned it.
> 
> Looks like something is shitting over bdev->bd_disk or bdev->bd_disk->fops.
> The offsets in the disassembled code are all wrong (including that from
> beginning of function to oopsing instruction), but the code match is good,
> so I agree that we are hitting bdev->bd_disk->fops == NULL here.  The
> question is how it has happened - that's where the real bug is...
> 
> How reproducible it is?  And which kernel, while we are at it?  This area
> didn't get a lot of changes lately, but still...
> 
Thanks Al for reply, and look into this.
We're using 3.4.71, and this happened in production, we can not
reproduce it yet. What I could see is: before this happened, we saw scsi
devices offlined, and multipath failed path, raid1 failed member device.

Possible the bug lies in drivers md-raid1, dm-multipath or sd? How could
I narrow it down? Could you teach me?

Thanks, wish you happy and healthy!

Jack
