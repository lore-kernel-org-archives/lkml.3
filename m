Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756287Ab3AOOER (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 09:04:17 -0500
Received: from relay.parallels.com ([195.214.232.42]:48756 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288Ab3AOOEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 09:04:16 -0500
Message-ID: <50F561DC.6000700@parallels.com>
Date: Tue, 15 Jan 2013 18:04:12 +0400
From: "Maxim V. Patlasov" <mpatlasov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Brian Foster <bfoster@redhat.com>
CC: <miklos@szeredi.hu>, <dev@parallels.com>, <xemul@parallels.com>,
        <fuse-devel@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>,
        <devel@openvz.org>, <anand.avati@gmail.com>
Subject: Re: [PATCH 3/5] fuse: wait for end of IO on release
References: <20121220122702.4101.80042.stgit@maximpc.sw.ru> <20121220123144.4101.84499.stgit@maximpc.sw.ru> <50E49A06.4060901@redhat.com>
In-Reply-To: <50E49A06.4060901@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.17.2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Brian,

01/03/2013 12:35 AM, Brian Foster пишет:
> On 12/20/2012 07:31 AM, Maxim Patlasov wrote:
>> There are two types of I/O activity that can be "in progress" at the time
>> of fuse_release() execution: asynchronous read-ahead and write-back. The
>> patch ensures that they are completed before fuse_release_common sends
>> FUSE_RELEASE to userspace.
>>
>> So far as fuse_release() waits for end of async I/O, its callbacks
>> (fuse_readpages_end and fuse_writepage_finish) calling fuse_file_put cannot
>> be the last holders of fuse file anymore. To emphasize the fact, the patch
>> replaces fuse_file_put with __fuse_file_put there.
>>
>> Signed-off-by: Maxim Patlasov <mpatlasov@parallels.com>
>> ---
>>   fs/fuse/file.c |   55 ++++++++++++++++++++++++++++++++++++++++++++++++++++---
>>   1 files changed, 52 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/fuse/file.c b/fs/fuse/file.c
>> index 4f23134..aed9be2 100644
>> --- a/fs/fuse/file.c
>> +++ b/fs/fuse/file.c
>> @@ -137,6 +137,12 @@ static void fuse_file_put(struct fuse_file *ff, bool sync)
>>   	}
>>   }
>>   
>> +static void __fuse_file_put(struct fuse_file *ff)
>> +{
>> +	if (atomic_dec_and_test(&ff->count))
>> +		BUG();
>> +}
>> +
> I think a comment in or before this function to explain the reasoning
> for the BUG would be helpful.
>
>>   int fuse_do_open(struct fuse_conn *fc, u64 nodeid, struct file *file,
>>   		 bool isdir)
>>   {
>> @@ -260,7 +266,12 @@ void fuse_release_common(struct file *file, int opcode)
>>   	 * Make the release synchronous if this is a fuseblk mount,
>>   	 * synchronous RELEASE is allowed (and desirable) in this case
>>   	 * because the server can be trusted not to screw up.
>> +	 *
>> +	 * We might wait for them (asynchronous READ or WRITE requests), so:
>>   	 */
>> +	if (ff->fc->close_wait)
>> +		BUG_ON(atomic_read(&ff->count) != 1);
>> +
> It might be cleaner to pull the new part of the comment and the BUG_ON()
> check to before the existing comment and fuse_file_put (e.g., create a
> new comment).
>
>>   	fuse_file_put(ff, ff->fc->destroy_req != NULL);
>>   }
>>   
>> @@ -271,6 +282,31 @@ static int fuse_open(struct inode *inode, struct file *file)
>>   
>>   static int fuse_release(struct inode *inode, struct file *file)
>>   {
>> +	struct fuse_file *ff = file->private_data;
>> +
>> +	if (ff->fc->close_wait) {
>> +		struct fuse_inode *fi = get_fuse_inode(inode);
>> +
>> +		/*
>> +		 * Must remove file from write list. Otherwise it is possible
>> +		 * this file will get more writeback from another files
>> +		 * rerouted via write_files.
>> +		 */
>> +		spin_lock(&ff->fc->lock);
>> +		list_del_init(&ff->write_entry);
>> +		spin_unlock(&ff->fc->lock);
>> +
>> +		wait_event(fi->page_waitq, atomic_read(&ff->count) == 1);
>> +
>> +		/*
>> +		 * Wait for threads just released ff to leave their critical
>> +		 * sections. Taking spinlock is the first thing
>> +		 * fuse_release_common does, so that this is unnecessary, but
>> +		 * it is still good to emphasize right here, that we need this.
>> +		 */
>> +		spin_unlock_wait(&ff->fc->lock);
> I'm all for clarity, but if the wait is unnecessary, perhaps just leave
> the comment..? Just my .02.
>
> Aside from the few nits here, the set looks pretty good to me.

Thanks for review, the suggestions look reasonable. I'll resend 
corrected patch soon.

Maxim
