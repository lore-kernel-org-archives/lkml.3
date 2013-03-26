Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756912Ab3CZLXi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 07:23:38 -0400
Received: from relay.parallels.com ([195.214.232.42]:54175 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754817Ab3CZLXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 07:23:36 -0400
Message-ID: <5151855B.6070108@parallels.com>
Date: Tue, 26 Mar 2013 15:24:11 +0400
From: "Maxim V. Patlasov" <mpatlasov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: <dev@parallels.com>, <xemul@parallels.com>,
        <fuse-devel@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>,
        <jbottomley@parallels.com>, <viro@zeniv.linux.org.uk>,
        <linux-fsdevel@vger.kernel.org>, <devel@openvz.org>
Subject: Re: [PATCH 08/14] fuse: Flush files on wb close
References: <20130125181700.10037.29163.stgit@maximpc.sw.ru> <20130125182407.10037.26333.stgit@maximpc.sw.ru> <CAJfpegs85D9GM285gaO-49t7gJQBh9ZgMviXS-AOkp4z9k-6uA@mail.gmail.com>
In-Reply-To: <CAJfpegs85D9GM285gaO-49t7gJQBh9ZgMviXS-AOkp4z9k-6uA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.17.2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Miklos,

01/30/2013 02:58 AM, Miklos Szeredi пишет:
> On Fri, Jan 25, 2013 at 7:24 PM, Maxim V. Patlasov
> <MPatlasov@parallels.com> wrote:
>> Any write request requires a file handle to report to the userspace. Thus
>> when we close a file (and free the fuse_file with this info) we have to
>> flush all the outstanding writeback cache. Note, that simply calling the
>> filemap_write_and_wait() is not enough since fuse finishes page writeback
>> immediately and thus the -wait part of the mentioned call will be no-op.
>> Do real wait on per-inode writepages list.
>>
>> Signed-off-by: Maxim Patlasov <MPatlasov@parallels.com>
>> Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
>> ---
>>   fs/fuse/file.c |   26 +++++++++++++++++++++++++-
>>   1 files changed, 25 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/fuse/file.c b/fs/fuse/file.c
>> index 4f8fa45..496e74c 100644
>> --- a/fs/fuse/file.c
>> +++ b/fs/fuse/file.c
>> @@ -138,6 +138,12 @@ static void fuse_file_put(struct fuse_file *ff, bool sync)
>>          }
>>   }
>>
>> +static void __fuse_file_put(struct fuse_file *ff)
>> +{
>> +       if (atomic_dec_and_test(&ff->count))
>> +               BUG();
>> +}
>> +
>>   int fuse_do_open(struct fuse_conn *fc, u64 nodeid, struct file *file,
>>                   bool isdir)
>>   {
>> @@ -286,8 +292,23 @@ static int fuse_open(struct inode *inode, struct file *file)
>>          return fuse_open_common(inode, file, false);
>>   }
>>
>> +static void fuse_flush_writeback(struct inode *inode, struct file *file)
>> +{
>> +       struct fuse_conn *fc = get_fuse_conn(inode);
>> +       struct fuse_inode *fi = get_fuse_inode(inode);
>> +
>> +       filemap_write_and_wait(file->f_mapping);
>> +       wait_event(fi->page_waitq, list_empty_careful(&fi->writepages));
>> +       spin_unlock_wait(&fc->lock);
>> +}
>> +
>>   static int fuse_release(struct inode *inode, struct file *file)
>>   {
>> +       struct fuse_conn *fc = get_fuse_conn(inode);
>> +
>> +       if (fc->writeback_cache)
>> +               fuse_flush_writeback(inode, file);
>> +
>>          fuse_release_common(file, FUSE_RELEASE);
>>
>>          /* return value is ignored by VFS */
>> @@ -1343,7 +1364,8 @@ static void fuse_writepage_free(struct fuse_conn *fc, struct fuse_req *req)
>>
>>          for (i = 0; i < req->num_pages; i++)
>>                  __free_page(req->pages[i]);
>> -       fuse_file_put(req->ff, false);
>> +       if (!fc->writeback_cache)
>> +               fuse_file_put(req->ff, false);
>>   }
>>
>>   static void fuse_writepage_finish(struct fuse_conn *fc, struct fuse_req *req)
>> @@ -1360,6 +1382,8 @@ static void fuse_writepage_finish(struct fuse_conn *fc, struct fuse_req *req)
>>          }
>>          bdi_writeout_inc(bdi);
>>          wake_up(&fi->page_waitq);
>> +       if (fc->writeback_cache)
>> +               __fuse_file_put(req->ff);
>>   }
> I don't see how this belongs in this patch.  And I suspect this can be
> done unconditionally (for the non-writeback-cache case as well), but
> please move it into a separate patch.

OK, I'll do.

Thanks,
Maxim

>
> Thanks,
> Miklos
>

