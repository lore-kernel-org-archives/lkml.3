Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130Ab3BRODr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 09:03:47 -0500
Received: from mail-oa0-f51.google.com ([209.85.219.51]:33913 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755859Ab3BRODp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 09:03:45 -0500
MIME-Version: 1.0
In-Reply-To: <87fw0t3mq0.fsf@devron.myhome.or.jp>
References: <1360422145-12280-1-git-send-email-linkinjeon@gmail.com>
	<87fw0t3mq0.fsf@devron.myhome.or.jp>
Date: Mon, 18 Feb 2013 23:03:45 +0900
Message-ID: <CAKYAXd9cxUJwObHUfh0Rf9jVLzmvpfnYx4AKw6tsSAX-jzDusA@mail.gmail.com>
Subject: Re: [PATCH v6 4/7] fat: restructure export_operations
From: Namjae Jeon <linkinjeon@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/18 OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> Namjae Jeon <linkinjeon@gmail.com> writes:
>
>> +     if (MSDOS_SB(inode->i_sb)->options.nfs == FAT_NFS_NOSTALE_RO) {
>> +             if (inode->i_ino == MSDOS_ROOT_INO)
>> +                     stat->ino = MSDOS_ROOT_INO;
>
> Can we simply set i_pos = MSDOS_ROOT_INO in fat_read_root()? If so, I
> think we can avoid this check.
Yes,  we can. I will change it.

>
>> +             else
>> +                     /* Use i_pos for ino. This is used as fileid of nfs. */
>> +                     stat->ino = fat_i_pos_read(MSDOS_SB(inode->i_sb),
>> +                                                inode);
>> +     }
>>       return 0;
>>  }
>>  EXPORT_SYMBOL_GPL(fat_getattr);
>
>
>> +struct fat_fid {
>> +     u32 i_gen;
>> +     u32 i_pos_low;
>> +     u16 i_pos_hi;
>> +     u16 parent_i_pos_hi;
>> +     u32 parent_i_pos_low;
>> +     u32 parent_i_gen;
>> +} __packed;
>
> Do we need to use __packed? Unnecessary __packed can generate slower
> code for alignment check on arch has unaligned fault.
Actually, I referenced other filesystem's exportfs code like btrfs and xfs.
they are packing their fids.
your opinion is reasonable, so I can fix it as your opinion.
>
>> +     if (parent && (len < FAT_FID_SIZE_WITH_PARENT)) {
>> +             *lenp = FAT_FID_SIZE_WITH_PARENT;
>> +             return 255;
>> +     } else if (len < FAT_FID_SIZE_WITHOUT_PARENT) {
>> +             *lenp = FAT_FID_SIZE_WITHOUT_PARENT;
>> +             return 255;
>> +     }
>
> This check strange. "parent && len == FAT_FID_SIZE_WITHOUT_PARENT" will
> overwrite over limit of fh size?
I need to check more. because I followed the logic in
export_encode_fh() function.

Thanks for review!
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
