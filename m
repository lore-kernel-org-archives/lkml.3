Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933588Ab3CHENT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 23:13:19 -0500
Received: from mail-oa0-f54.google.com ([209.85.219.54]:44181 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760164Ab3CHENS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 23:13:18 -0500
MIME-Version: 1.0
In-Reply-To: <1362709985.14386.33.camel@kjgkr>
References: <1362195663-20751-1-git-send-email-linkinjeon@gmail.com>
	<1362285251.14386.10.camel@kjgkr>
	<CAKYAXd9DDoUyB-kvumojKJQ6kR2rn+Wx+8Z4WjM1tVs10f40zg@mail.gmail.com>
	<1362709985.14386.33.camel@kjgkr>
Date: Fri, 8 Mar 2013 13:13:17 +0900
Message-ID: <CAKYAXd9BQmXV0V_4q9s9zAbdKGki7oSfz5JZmuY6nxsQ=3YHkw@mail.gmail.com>
Subject: Re: [PATCH 3/5] f2fs: move f2fs_balance_fs to correct place in unlink
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/8, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> 2013-03-04 (월), 15:10 +0900, Namjae Jeon:
>> 2013/3/3, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
>> > 2013-03-02 (토), 12:41 +0900, Namjae Jeon:
>> >> From: Namjae Jeon <namjae.jeon@samsung.com>
>> >>
>> >> Actual dirty of pages will occur in f2fs_delete_entry so move the
>> >> f2fs_balance_fs just before deletion.
>> >>
>> >> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
>> >> Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
>> >> ---
>> >>  fs/f2fs/namei.c |    4 ++--
>> >>  1 file changed, 2 insertions(+), 2 deletions(-)
>> >>
>> >> diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
>> >> index 1a49b88..eaa86f5 100644
>> >> --- a/fs/f2fs/namei.c
>> >> +++ b/fs/f2fs/namei.c
>> >> @@ -223,8 +223,6 @@ static int f2fs_unlink(struct inode *dir, struct
>> >> dentry *dentry)
>> >>  	struct page *page;
>> >>  	int err = -ENOENT;
>> >>
>> >> -	f2fs_balance_fs(sbi);
>> >> -
>> >>  	de = f2fs_find_entry(dir, &dentry->d_name, &page);
>> >>  	if (!de)
>> >>  		goto fail;
>> >> @@ -236,6 +234,8 @@ static int f2fs_unlink(struct inode *dir, struct
>> >> dentry *dentry)
>> >>  		goto fail;
>> >>  	}
>> >>
>> >> +	f2fs_balance_fs(sbi);
>> >> +
>> >
>> > I think we don't need to do this because of no issues on performance
>> > and
>> > reliability.
>> > In addition, it would be better to call f2fs_balance_fs without any
>> > dentry page.
>> Regarding moving “f2fs_balance_fs” in unlink part– we considered one
>> scenario.
>> Suppose – when the disk is full and it really needed to trigger the
>> Garbage collection. But in this we considered one scenario. Let’s say
>> the ‘name’ being passed is for invalid file i.e., the file does not
>> exist. So, primarily in this case – I think it should return
>> immediately.
>> In such cases it actually results in wrong timing results for the
>> non-existence files.
>> For this observation we thought that f2fs_balance_fs be instead called
>> at a proper place i.e., after there is no lookup-failure.
>
> If so, could you check all the locations of f2fs_balance_fs and write
> one patch for whole things?
> I suspect that many directory operations are exposed to this issue.
> Thanks,
Sure, I will check all places to use f2fs_balance_fs. And will post
updated patch again.
Thanks Jaegeuk!
>
>>
>> Let me know your opinion.
>> Thanks.
>> >
>> >>  	f2fs_delete_entry(de, page, inode);
>> >>
>> >>  	/* In order to evict this inode,  we set it dirty */
>> >
>> > --
>> > Jaegeuk Kim
>> > Samsung
>> >
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel"
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
> --
> Jaegeuk Kim
> Samsung
>
