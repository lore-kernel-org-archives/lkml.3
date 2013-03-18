Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383Ab3CRMAd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 08:00:33 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:49268 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469Ab3CRMAb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 08:00:31 -0400
MIME-Version: 1.0
In-Reply-To: <1363572687.14386.66.camel@kjgkr>
References: <1363508828-2920-1-git-send-email-linkinjeon@gmail.com>
	<1363572687.14386.66.camel@kjgkr>
Date: Mon, 18 Mar 2013 21:00:31 +0900
Message-ID: <CAKYAXd_rd-NBL5HjO9yoKg5nzZ_A88Kiz+-OXkG2TW5o+6gBjw@mail.gmail.com>
Subject: Re: [PATCH 4/5] f2fs: remove nid_free from f2fs_new_inode
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/18, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> 2013-03-17 (일), 17:27 +0900, Namjae Jeon:
>> From: Namjae Jeon <namjae.jeon@samsung.com>
>>
>> we can remove nid_free from new inode allocation part.
>> Since, nid_free is used to check if we need to free alloced nid
>> in case of failure.
>> Instead we can directly call alloc_nid_failed from that point, as
>> there is no dependency in that path.
>>
>> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
>> Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
>> ---
>>  fs/f2fs/namei.c |    5 +----
>>  1 file changed, 1 insertion(+), 4 deletions(-)
>>
>> diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
>> index d4a171b..261d821 100644
>> --- a/fs/f2fs/namei.c
>> +++ b/fs/f2fs/namei.c
>> @@ -24,7 +24,6 @@ static struct inode *f2fs_new_inode(struct inode *dir,
>> umode_t mode)
>>  	struct f2fs_sb_info *sbi = F2FS_SB(sb);
>>  	nid_t ino;
>>  	struct inode *inode;
>> -	bool nid_free = false;
>>  	int err;
>>
>>  	inode = new_inode(sb);
>> @@ -58,7 +57,7 @@ static struct inode *f2fs_new_inode(struct inode *dir,
>> umode_t mode)
>>  	err = insert_inode_locked(inode);
>>  	if (err) {
>>  		err = -EINVAL;
>> -		nid_free = true;
>> +		alloc_nid_failed(sbi, ino);
>>  		goto out;
>>  	}
>>
>> @@ -70,8 +69,6 @@ out:
>>  	unlock_new_inode(inode);
>>  fail:
>>  	iput(inode);
>> -	if (nid_free)
>> -		alloc_nid_failed(sbi, ino);
>
> We should call alloc_nid_failed() after iput() is completed.
> Otherwise, another f2fs_new_inode() is able to get this just-released
> nid before iput(). In such a case, insert_inode_locked() can return
> -EBUSY or iput() can free this newly allocated inode due to the i_lock
> race.
> Thanks,
Okay, I see.
Thanks!
>
>>  	return ERR_PTR(err);
>>  }
>>
>
> --
> Jaegeuk Kim
> Samsung
>
