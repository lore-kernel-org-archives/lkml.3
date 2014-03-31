Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751766AbaCaWVU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 18:21:20 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:39926 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739AbaCaWVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 18:21:18 -0400
MIME-Version: 1.0
In-Reply-To: <20140331151337.f6a46a8fcab6206f4d21be08@linux-foundation.org>
References: <1396120235-27844-1-git-send-email-cse.cem@gmail.com>
	<20140331151337.f6a46a8fcab6206f4d21be08@linux-foundation.org>
Date: Mon, 31 Mar 2014 15:21:17 -0700
Message-ID: <CAG6CVpV6sxOc2ZH_xWRGc28N6W+M9iK6QbX-4bx326FON8B9GA@mail.gmail.com>
Subject: Re: [PATCH v2] fs: FAT: Add support for DOS 1.x formatted volumes
From: Conrad Meyer <cse.cem@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Conrad Meyer <cemeyer@uw.edu>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark <markk@clara.co.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2014 at 3:13 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Sat, 29 Mar 2014 12:10:35 -0700 Conrad Meyer <cemeyer@uw.edu> wrote:
>
>> +     .nr_sectors = 360 * KB_IN_SECTORS,
>> +     .sec_per_clus = 2,
>> +     .dir_entries = 112,
>> +     .media = 0xFD,
>> +     .fat_length = 2,
>> +},
>> +{ 0 } };
>
> We don't really need this EOF element.

Ah, right, I forgot about ARRAY_SIZE. This is an old version of this
patch, see v3 here: https://lkml.org/lkml/2014/3/31/275

But the same criticism is valid there, too.

>> +     if (get_unaligned_le16(&b->sector_size) != 0 || b->sec_per_clus != 0 ||
>> +             b->reserved != 0 || b->fats != 0 ||
>> +             get_unaligned_le16(&b->dir_entries) != 0 ||
>> +             get_unaligned_le16(&b->sectors) != 0 || b->media != 0 ||
>> +             b->fat_length != 0 || b->secs_track != 0 || b->heads != 0 ||
>> +             b->secs_track != 0 || b->heads != 0)
>
> Impressive!

I aim to please. Not sure what would be better -- memcmp() part of the
struct to a zeroed array?

>
>> +             return;
>> +
>> +     bd_sects = part_nr_sects_read(sb->s_bdev->bd_part);
>> +     for (di = floppy_defaults; di->nr_sectors; di++) {
>
> Can do something like
>
>         for (di = floppy_defaults;
>                 di < floppy_defaults + ARRAY_SIZE(floppy_defaults); di++) {

Yep, I should revise and send a v4 patch. Thanks.

>
>> +             if (di->nr_sectors == bd_sects)
>> +                     break;
>> +     }
>> +     if (di->nr_sectors == 0) {
>> +             fat_msg(sb, KERN_WARNING,
>> +                     "DOS volume lacks BPB and isn't a recognized floppy size (%ld sectors)",
>> +                     (long)bd_sects);
>
> sector_t can be u64 on 32-bit so one should really use %Lu and cast to
> u64.

Thanks, will fix.

Conrad
