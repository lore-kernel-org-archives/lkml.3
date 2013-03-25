Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757498Ab3CYMcG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 08:32:06 -0400
Received: from relay.parallels.com ([195.214.232.42]:49300 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756944Ab3CYMcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 08:32:05 -0400
Message-ID: <5150433D.1090408@parallels.com>
Date: Mon, 25 Mar 2013 16:29:49 +0400
From: "Maxim V. Patlasov" <mpatlasov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: <dev@parallels.com>, <xemul@parallels.com>,
        <fuse-devel@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>,
        <jbottomley@parallels.com>, <viro@zeniv.linux.org.uk>,
        <linux-fsdevel@vger.kernel.org>, <devel@openvz.org>
Subject: Re: [PATCH 06/14] fuse: Trust kernel i_size only - v2
References: <20130125181700.10037.29163.stgit@maximpc.sw.ru> <20130125182210.10037.59973.stgit@maximpc.sw.ru> <CAJfpegs-VG6iuBWmJbX+2QSEXRrtRe=6T_n+LNqhy3MaWO3vXw@mail.gmail.com>
In-Reply-To: <CAJfpegs-VG6iuBWmJbX+2QSEXRrtRe=6T_n+LNqhy3MaWO3vXw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.17.2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Miklos,

Sorry for long delay, see please inline comments below.

01/29/2013 02:18 PM, Miklos Szeredi пишет:
> On Fri, Jan 25, 2013 at 7:22 PM, Maxim V. Patlasov
> <MPatlasov@parallels.com> wrote:
>> Make fuse think that when writeback is on the inode's i_size is always
>> up-to-date and not update it with the value received from the userspace.
>> This is done because the page cache code may update i_size without letting
>> the FS know.
>>
>> This assumption implies fixing the previously introduced short-read helper --
>> when a short read occurs the 'hole' is filled with zeroes.
>>
>> fuse_file_fallocate() is also fixed because now we should keep i_size up to
>> date, so it must be updated if FUSE_FALLOCATE request succeeded.
>>
>> Changed in v2:
>>   - improved comment in fuse_short_read()
>>   - fixed fuse_file_fallocate() for KEEP_SIZE mode
>>
>> Original patch by: Pavel Emelyanov <xemul@openvz.org>
>> Signed-off-by: Maxim V. Patlasov <MPatlasov@parallels.com>
>> ---
>>   fs/fuse/dir.c   |    9 ++++++---
>>   fs/fuse/file.c  |   43 +++++++++++++++++++++++++++++++++++++++++--
>>   fs/fuse/inode.c |    6 ++++--
>>   3 files changed, 51 insertions(+), 7 deletions(-)
>>
>> diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
>> index ed8f8c5..ff8b603 100644
>> --- a/fs/fuse/dir.c
>> +++ b/fs/fuse/dir.c
>> @@ -827,7 +827,7 @@ static void fuse_fillattr(struct inode *inode, struct fuse_attr *attr,
>>          stat->mtime.tv_nsec = attr->mtimensec;
>>          stat->ctime.tv_sec = attr->ctime;
>>          stat->ctime.tv_nsec = attr->ctimensec;
>> -       stat->size = attr->size;
>> +       stat->size = i_size_read(inode);
> The old code is correct and you break it.

fuse_fillattr() is called strictly after fuse_change_attributes(). The 
latter usually sets local i_size with server value: i_size_write(inode, 
attr->size). This makes -/+ lines above equivalent. The only exception 
is stale attributes when current fi->attr_version is greater than 
attr_version acquired before sending FUSE_GETATTR request. My patch 
breaks old behaviour in this special case, I'll fix it, thanks for the 
catch.

> We always use the values
> returned by GETATTR, instead of the cached ones.  The cached ones are
> a best guess by the kernel and they may or may not have been correct
> at any point in time.  The attributes returned by userspace are the
> authentic ones.

Yes, that's correct when "write cache" is off.

> For the "write cache" case what we want, I think, is a mode where the
> kernel always trusts the cached attributes.  The attribute cache is
> initialized from values returned in LOOKUP and the kernel never needs
> to call GETATTR since the attributes are always up-to-date.
>
> Is that correct?

No, for "write cache" case the kernel always trusts cached i_size for 
regular files. For other attributes (and for !S_ISGREG() files) the 
kernel relies on userspace.

>
>>          stat->blocks = attr->blocks;
>>
>>          if (attr->blksize != 0)
>> @@ -1541,6 +1541,7 @@ static int fuse_do_setattr(struct dentry *entry, struct iattr *attr,
>>          struct fuse_setattr_in inarg;
>>          struct fuse_attr_out outarg;
>>          bool is_truncate = false;
>> +       bool is_wb = fc->writeback_cache;
>>          loff_t oldsize;
>>          int err;
>>
>> @@ -1613,7 +1614,8 @@ static int fuse_do_setattr(struct dentry *entry, struct iattr *attr,
>>          fuse_change_attributes_common(inode, &outarg.attr,
>>                                        attr_timeout(&outarg));
>>          oldsize = inode->i_size;
>> -       i_size_write(inode, outarg.attr.size);
>> +       if (!is_wb || is_truncate || !S_ISREG(inode->i_mode))
>> +               i_size_write(inode, outarg.attr.size);
> Okay, I managed to understand what is going on here:  if userspace is
> behaving badly and is changing the size even if that was not
> requested, then we silently reject that.  But that's neither clearly
> unrestandable (without a comment) nor sensible, I think.
>
> If the filesystem is behaving badly, just let it.  Or is there some
> other reason why we'd want this check?

The change above has nothing to do with misbehaving userspace. The check 
literally means: do not trust attr.size from server if "write cache" is 
on and the file is regular and there was no explicit user request to 
change size (i.e. ATTR_SIZE bit was not set in attr->ia_valid). The 
check is necessary if the user changes some attribute (not related to 
i_size) and at the time of processing FUSE_SETATTR server doesn't have 
up-to-date info about the size of file. In "write cache" case this 
situation is typical for cached writes extending file.

>
>>          if (is_truncate) {
>>                  /* NOTE: this may release/reacquire fc->lock */
>> @@ -1625,7 +1627,8 @@ static int fuse_do_setattr(struct dentry *entry, struct iattr *attr,
>>           * Only call invalidate_inode_pages2() after removing
>>           * FUSE_NOWRITE, otherwise fuse_launder_page() would deadlock.
>>           */
>> -       if (S_ISREG(inode->i_mode) && oldsize != outarg.attr.size) {
>> +       if ((is_truncate || !is_wb) &&
>> +                       S_ISREG(inode->i_mode) && oldsize != outarg.attr.size) {
>>                  truncate_pagecache(inode, oldsize, outarg.attr.size);
>>                  invalidate_inode_pages2(inode->i_mapping);
>>          }
>> diff --git a/fs/fuse/file.c b/fs/fuse/file.c
>> index b28be33..6b64e11 100644
>> --- a/fs/fuse/file.c
>> +++ b/fs/fuse/file.c
>> @@ -15,6 +15,7 @@
>>   #include <linux/module.h>
>>   #include <linux/compat.h>
>>   #include <linux/swap.h>
>> +#include <linux/falloc.h>
>>
>>   static const struct file_operations fuse_direct_io_file_operations;
>>
>> @@ -543,9 +544,31 @@ static void fuse_short_read(struct fuse_req *req, struct inode *inode,
>>                              u64 attr_ver)
>>   {
>>          size_t num_read = req->out.args[0].size;
>> +       struct fuse_conn *fc = get_fuse_conn(inode);
>> +
>> +       if (fc->writeback_cache) {
>> +               /*
>> +                * A hole in a file. Some data after the hole are in page cache,
>> +                * but have not reached the client fs yet. So, the hole is not
>> +                * present there.
>> +                */
>> +               int i;
>> +               int start_idx = num_read >> PAGE_CACHE_SHIFT;
>> +               size_t off = num_read & (PAGE_CACHE_SIZE - 1);
>>
>> -       loff_t pos = page_offset(req->pages[0]) + num_read;
>> -       fuse_read_update_size(inode, pos, attr_ver);
>> +               for (i = start_idx; i < req->num_pages; i++) {
>> +                       struct page *page = req->pages[i];
>> +                       void *mapaddr = kmap_atomic(page);
>> +
>> +                       memset(mapaddr + off, 0, PAGE_CACHE_SIZE - off);
>> +
>> +                       kunmap_atomic(mapaddr);
>> +                       off = 0;
>> +               }
>> +       } else {
>> +               loff_t pos = page_offset(req->pages[0]) + num_read;
>> +               fuse_read_update_size(inode, pos, attr_ver);
>> +       }
>>   }
>>
>>   static int fuse_readpage(struct file *file, struct page *page)
>> @@ -2285,6 +2308,8 @@ static long fuse_file_fallocate(struct file *file, int mode, loff_t offset,
>>                  .mode = mode
>>          };
>>          int err;
>> +       bool change_i_size = fc->writeback_cache &&
>> +               !(mode & FALLOC_FL_KEEP_SIZE);
>>
>>          if (fc->no_fallocate)
>>                  return -EOPNOTSUPP;
>> @@ -2293,6 +2318,11 @@ static long fuse_file_fallocate(struct file *file, int mode, loff_t offset,
>>          if (IS_ERR(req))
>>                  return PTR_ERR(req);
>>
>> +       if (change_i_size) {
>> +               struct inode *inode = file->f_mapping->host;
>> +               mutex_lock(&inode->i_mutex);
>> +       }
>> +
>>          req->in.h.opcode = FUSE_FALLOCATE;
>>          req->in.h.nodeid = ff->nodeid;
>>          req->in.numargs = 1;
>> @@ -2306,6 +2336,15 @@ static long fuse_file_fallocate(struct file *file, int mode, loff_t offset,
>>          }
>>          fuse_put_request(fc, req);
>>
>> +       if (change_i_size) {
>> +               struct inode *inode = file->f_mapping->host;
>> +
>> +               if (!err)
>> +                       fuse_write_update_size(inode, offset + length);
>> +
>> +               mutex_unlock(&inode->i_mutex);
>> +       }
>> +
>>          return err;
>>   }
>>
>> diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
>> index 9d95a5a..7e07dbd 100644
>> --- a/fs/fuse/inode.c
>> +++ b/fs/fuse/inode.c
>> @@ -196,6 +196,7 @@ void fuse_change_attributes(struct inode *inode, struct fuse_attr *attr,
>>   {
>>          struct fuse_conn *fc = get_fuse_conn(inode);
>>          struct fuse_inode *fi = get_fuse_inode(inode);
>> +       bool is_wb = fc->writeback_cache;
>>          loff_t oldsize;
>>          struct timespec old_mtime;
>>
>> @@ -209,10 +210,11 @@ void fuse_change_attributes(struct inode *inode, struct fuse_attr *attr,
>>          fuse_change_attributes_common(inode, attr, attr_valid);
>>
>>          oldsize = inode->i_size;
>> -       i_size_write(inode, attr->size);
>> +       if (!is_wb || !S_ISREG(inode->i_mode))
>> +               i_size_write(inode, attr->size);

> Same as the previous comment.  I think you simply need to omit these
> checks.  But if something *is* needed to special case the write cache
> case, then it needs some comments to explain what and why.

Are you OK about a comment like this:

/*
  * In case of writeback_cache enabled, the cached writes beyond EOF
  * extend local i_size without keeping userspace server in sync. So,
  * attr->size coming from server can be stale. We cannot trust it.
*/

Thanks,
Maxim

>
>>          spin_unlock(&fc->lock);
>>
>> -       if (S_ISREG(inode->i_mode)) {
>> +       if (!is_wb && S_ISREG(inode->i_mode)) {
>>                  bool inval = false;
>>
>>                  if (oldsize != attr->size) {
>>

