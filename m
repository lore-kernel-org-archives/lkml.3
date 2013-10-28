Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932093Ab3J1Q45 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 12:56:57 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:35354 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756103Ab3J1Q4z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 12:56:55 -0400
MIME-Version: 1.0
In-Reply-To: <1382964295.992.122.camel@kjgkr>
References: <1382716919-23345-1-git-send-email-huajun.li.lee@gmail.com>
	<1382716919-23345-6-git-send-email-huajun.li.lee@gmail.com>
	<1382964295.992.122.camel@kjgkr>
Date: Tue, 29 Oct 2013 00:56:55 +0800
Message-ID: <CA+v9cxYUJ20_N5Zbo1W4WbTDB_SgXsbngZ0fEJx0dk+sxTS_1g@mail.gmail.com>
Subject: Re: [f2fs-dev 5/5] f2fs: Handle inline data operations
From: Huajun Li <huajun.li.lee@gmail.com>
To: "jaegeuk.kim" <jaegeuk.kim@samsung.com>
Cc: linux-f2fs-devel <linux-f2fs-devel@lists.sourceforge.net>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Huajun Li <huajun.li@intel.com>,
        Haicheng Li <haicheng.li@linux.intel.com>,
        Weihong Xu <weihong.xu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 28, 2013 at 8:44 PM, Jaegeuk Kim <jaegeuk.kim@samsung.com> wrote:
> Hi,
>
> 2013-10-26 (토), 00:01 +0800, Huajun Li:
>> From: Huajun Li <huajun.li@intel.com>
>>
>
> [snip]
>
>>
>> @@ -538,7 +553,7 @@ static int f2fs_write_data_page(struct page *page,
>>       loff_t i_size = i_size_read(inode);
>>       const pgoff_t end_index = ((unsigned long long) i_size)
>>                                                       >> PAGE_CACHE_SHIFT;
>> -     unsigned offset;
>> +     unsigned offset = 0;
>>       bool need_balance_fs = false;
>>       int err = 0;
>>
>> @@ -572,7 +587,14 @@ write:
>>               err = do_write_data_page(page);
>>       } else {
>>               f2fs_lock_op(sbi);
>> -             err = do_write_data_page(page);
>> +             if (test_opt(sbi, INLINE_DATA) && (i_size <= MAX_INLINE_DATA)) {
>> +                     err = f2fs_write_inline_data(inode, page, offset);
>> +                     ClearPageDirty(page);
>
> Don't need to call ClearPageDirty(page).
>

Yes. I will remove it in next version, thanks.

>> +                     f2fs_unlock_op(sbi);
>> +                     goto out;
>> +             } else {
>> +                     err = do_write_data_page(page);
>> +             }
>>               f2fs_unlock_op(sbi);
>>               need_balance_fs = true;
>>
> --
> Jaegeuk Kim
> Samsung
>
