Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965195Ab3IELcO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 07:32:14 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:43657 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935586Ab3IELcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 07:32:12 -0400
MIME-Version: 1.0
X-Originating-IP: [86.59.245.170]
In-Reply-To: <20130905111852.GP13318@ZenIV.linux.org.uk>
References: <1378374284-1484-1-git-send-email-miklos@szeredi.hu>
	<1378374284-1484-5-git-send-email-miklos@szeredi.hu>
	<20130905111852.GP13318@ZenIV.linux.org.uk>
Date: Thu, 5 Sep 2013 13:32:10 +0200
Message-ID: <CAJfpeguzpkw3SYm6kBP-acLSHTgYLXMFRZDf2T0U4aowYhfQdA@mail.gmail.com>
Subject: Re: [PATCH 04/11] vfs: check unlinked ancestors before mount
From: Miklos Szeredi <miklos@szeredi.hu>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "mszeredi@suse.cz" <mszeredi@suse.cz>,
        David Howells <dhowells@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 5, 2013 at 1:18 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Thu, Sep 05, 2013 at 11:44:37AM +0200, Miklos Szeredi wrote:
>> +static bool __has_unlinked_ancestor(struct dentry *dentry)
>> +{
>> +     struct dentry *this;
>> +
>> +     for (this = dentry; !IS_ROOT(this); this = this->d_parent) {
>> +             int is_unhashed;
>> +
>> +             /* Need exclusion wrt. check_submounts_and_drop() */
>> +             spin_lock(&this->d_lock);
>> +             is_unhashed = d_unhashed(this);
>> +             spin_unlock(&this->d_lock);
>> +
>> +             if (is_unhashed)
>> +                     return true;
>> +     }
>> +     return false;
>> +}
>> +
>> +/*
>> + * Called by mount code to check if the mountpoint is reachable (e.g. NFS can
>> + * unhash a directory dentry and then the complete subtree can become
>> + * unreachable).
>> + */
>> +bool has_unlinked_ancestor(struct dentry *dentry)
>> +{
>> +     bool found;
>> +
>> +     /* Need exclusion wrt. check_submounts_and_drop() */
>> +     write_seqlock(&rename_lock);
>> +     found = __has_unlinked_ancestor(dentry);
>> +     write_sequnlock(&rename_lock);
>> +
>> +     return found;
>> +}
>> +
>>  /*
>>   * Search the dentry child list of the specified parent,
>>   * and move any unused dentries to the end of the unused
>> diff --git a/fs/internal.h b/fs/internal.h
>> index 7c5f01c..d232355 100644
>> --- a/fs/internal.h
>> +++ b/fs/internal.h
>> @@ -126,6 +126,7 @@ extern int invalidate_inodes(struct super_block *, bool);
>>   * dcache.c
>>   */
>>  extern struct dentry *__d_alloc(struct super_block *, const struct qstr *);
>> +extern bool has_unlinked_ancestor(struct dentry *dentry);
>>
>>  /*
>>   * read_write.c
>> diff --git a/fs/namespace.c b/fs/namespace.c
>> index a45ba4f..91b1c39 100644
>> --- a/fs/namespace.c
>> +++ b/fs/namespace.c
>> @@ -634,6 +634,15 @@ static struct mountpoint *new_mountpoint(struct dentry *dentry)
>>       }
>>       dentry->d_flags |= DCACHE_MOUNTED;
>>       spin_unlock(&dentry->d_lock);
>> +
>> +     if (has_unlinked_ancestor(dentry)) {
>> +             spin_lock(&dentry->d_lock);
>> +             dentry->d_flags &= ~DCACHE_MOUNTED;
>> +             spin_unlock(&dentry->d_lock);
>> +             kfree(mp);
>> +             return ERR_PTR(-ENOENT);
>> +     }
>
> Something's really odd with locking here.  You are take d_lock, do one
> check, set flag, drop d_lock, grab rename_lock, do another check (taking
> and dropping d_lock in process), and, in case that check fails, grab
> d_lock again to clear the flag.
>
> At the very least it's a massive overkill.  Just grab rename_lock, then
> d_lock, then do the damn check and set the flag only on success.  Moreover,
> with rename_lock held, do you need d_lock on ancestors to mess with in
> has_unlinked_ancestor()?

Yes, we need hard exclusion for the __d_drop() part.  rename_lock can
provide one if we always take it for write in
check_submounts_and_drop().  But if we only take it for read then
that's not enough.

And we do in fact also need DCACHE_MOUNTED set *before* checking
ancestors.  Otherwise check_submounts_and_drop() could succeed and
has_unlinked_ancestor() return false, resulting in a dropped dentry
and a mount below it.  Though this is mostly theoretical at this
point.

Thanks,
Miklos
