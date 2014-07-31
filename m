Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932376AbaGaKLt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 06:11:49 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:44201 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932343AbaGaKLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 06:11:46 -0400
Message-ID: <53DA165E.8040601@gmail.com>
Date: Thu, 31 Jul 2014 13:11:42 +0300
From: Boaz Harrosh <openosd@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Matthew Wilcox <willy@linux.intel.com>
CC: Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 04/22] Change direct_access calling convention
References: <cover.1406058387.git.matthew.r.wilcox@intel.com> <b78b33d94b669a5fbd02e06f2493b43dd5d77698.1406058387.git.matthew.r.wilcox@intel.com> <53D9174C.7040906@gmail.com> <20140730194503.GQ6754@linux.intel.com>
In-Reply-To: <20140730194503.GQ6754@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2014 10:45 PM, Matthew Wilcox wrote:
<>
>> + 	if (sector & (PAGE_SECTORS-1))
>> + 		return -EINVAL;
> 
> Mmm.  PAGE_SECTORS is private to brd (and also private to bcache!) at
> this point.  We've got a real mess of defines of SECTOR_SIZE, SECTORSIZE,
> SECTOR_SHIFT and so on, dotted throughout various random include files.
> I am not the river to flush those Augean stables today.
> 
> I'll go with this, from the dcssblk driver:
> 
>         if (sector % (PAGE_SIZE / 512))
>                 return -EINVAL;
> 

Sigh, right, sure I did not mean to make that fight. Works as well

<>
>> Style: Need a space between declaration and code (have you check-patch)
> 
> That's a bullshit check.  I don't know why it's in checkpatch.
> 

I did not invent the rules. But I do respect them. I think the merit
of sticking to some common style is much higher then any particular
style choice. Though this particular one I do like, because of the
C rule that forces all declarations before code, so it makes it easier
on the maintenance. In any way Maintainers are suppose to run checkpatch
before submission, some do ;-)

<>
>>> +	if (size < 0)
>>
>> 	if(size < PAGE_SIZE), No?
> 
> No, absolutely not.  PAGE_SIZE is unsigned long, which (if I understand
> my C integer promotions correctly) means that 'size' gets promoted to
> an unsigned long, and we compare them unsigned, so errors will never be
> caught by this check.

Good point I agree that you need a cast ie.

 	if(size < (long)PAGE_SIZE)

The reason I'm saying this is because of a bug I actually hit when
playing with partitioning and fdisk, it came out that the last partition's
size was not page aligned, and code that checked for (< 0) crashed because
prd returned the last two sectors of the partition, since your API is sector
based this can happen for you here, before you are memseting a PAGE_SIZE
you need to test there is space, No? 

> 
> 

Thanks
Boaz

