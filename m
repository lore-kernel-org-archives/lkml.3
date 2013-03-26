Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932941Ab3CZJ6T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 05:58:19 -0400
Received: from relay.parallels.com ([195.214.232.42]:37053 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755029Ab3CZJ6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 05:58:17 -0400
Message-ID: <51517092.2020203@parallels.com>
Date: Tue, 26 Mar 2013 13:55:30 +0400
From: "Maxim V. Patlasov" <mpatlasov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: <dev@parallels.com>, <xemul@parallels.com>,
        <fuse-devel@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>,
        <jbottomley@parallels.com>, <viro@zeniv.linux.org.uk>,
        <linux-fsdevel@vger.kernel.org>, <devel@openvz.org>
Subject: Re: [PATCH 07/14] fuse: Update i_mtime on buffered writes
References: <20130125181700.10037.29163.stgit@maximpc.sw.ru> <20130125182242.10037.3237.stgit@maximpc.sw.ru> <CAJfpegtszx6cDJ9fUPTB_z-1vG7iM8J1jdKuEdqN+wPFkOf6NQ@mail.gmail.com>
In-Reply-To: <CAJfpegtszx6cDJ9fUPTB_z-1vG7iM8J1jdKuEdqN+wPFkOf6NQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.17.2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Miklos,

Sorry for long delay, see please inline comment below.

01/30/2013 02:19 AM, Miklos Szeredi пишет:
> On Fri, Jan 25, 2013 at 7:24 PM, Maxim V. Patlasov
> <MPatlasov@parallels.com> wrote:
>> If writeback cache is on, buffered write doesn't result in immediate mtime
>> update in userspace because the userspace will see modified data later, when
>> writeback happens. Consequently, mtime provided by userspace may be older than
>> actual time of buffered write.
>>
>> The problem can be solved by generating mtime locally (will come in next
>> patches) and flushing it to userspace periodically. Here we introduce a flag to
>> keep the state of fuse_inode: the flag is ON if and only if locally generated
>> mtime (stored in inode->i_mtime) was not pushed to the userspace yet.
>>
>> The patch also implements all bits related to flushing and clearing the flag.
>>
>> Signed-off-by: Maxim Patlasov <MPatlasov@parallels.com>
>> ---
>>   fs/fuse/dir.c    |   42 +++++++++++++++++++++++++----
>>   fs/fuse/file.c   |   31 ++++++++++++++++++---
>>   fs/fuse/fuse_i.h |   13 ++++++++-
>>   fs/fuse/inode.c  |   79 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
>>   4 files changed, 154 insertions(+), 11 deletions(-)
>>
>> diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
>> index ff8b603..969c60d 100644
>> --- a/fs/fuse/dir.c
>> +++ b/fs/fuse/dir.c
>> @@ -177,6 +177,13 @@ static int fuse_dentry_revalidate(struct dentry *entry, unsigned int flags)
>>                  if (flags & LOOKUP_RCU)
>>                          return -ECHILD;
>>
>> +               if (test_bit(FUSE_I_MTIME_UPDATED,
>> +                            &get_fuse_inode(inode)->state)) {
>> +                       err = fuse_flush_mtime(inode, 0);
> ->d_revalidate may be called with or without i_mutex, there's
> absolutely no way to know.  So this won't work.
>
> I know it was me who suggested this approach, but I have second
> thoughts...  I really don't like the way this mixes userspace and
> kernel updates to mtime.  I think it should be either one or the
> other.
>
> I don't think you need to much changes to this patch.  Just clear
> S_NOCMTIME, implement i_op->update_time(), which sets the
> FUSE_I_MTIME_UPDATED flag and flush mtime just like you do now.
> Except now it doesn't need to take i_mutex since all mtime updates are
> now done by the kernel.
>
> Does that make sense?

Yes, but it's not as simple as you described above. mtime updates should 
be strictly serialized, I used i_mutex for this purpose. Abandoning 
i_mutex, we'll have to introduce another lock for synchronization. 
Otherwise, we won't know when it's secure to clear FUSE_I_MTIME_UPDATED 
flag. Another approach is to introduce one more state: 
FUSE_I_MTIME_UPDATE_IN_PROGRESS. But again, we'll need something like 
waitq to wait for mtime update completion.

I'd prefer much more simple solution: clear S_NOCMTIME and implement 
i_op->update_time() as you suggested; but flush mtime only on last 
close. May be we could extend FUSE_RELEASE request (struct 
fuse_release_in) to accommodate mtime. Are you OK about it?

Thanks,
Maxim

>
> Thanks,
> Miklos
>

