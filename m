Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748Ab3GKVm0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 17:42:26 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:63103 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756669Ab3GKVmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 17:42:24 -0400
MIME-Version: 1.0
In-Reply-To: <20130711115832.GB5349@quack.suse.cz>
References: <1373497956-8770-1-git-send-email-taysom@chromium.org>
	<20130711105346.GA5349@quack.suse.cz>
	<20130711115832.GB5349@quack.suse.cz>
Date: Thu, 11 Jul 2013 14:42:23 -0700
Message-ID: <CAKwO_5HJxbwmNrGG2J1N08rzNFH30afDfTeNypg1mUbwB7ubBw@mail.gmail.com>
Subject: Re: [PATCH] fs: sync: fixed performance regression
From: Paul Taysom <taysom@google.com>
To: Jan Kara <jack@suse.cz>
Cc: Paul Taysom <taysom@chromium.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        sonnyrao@chromium.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 11, 2013 at 4:58 AM, Jan Kara <jack@suse.cz> wrote:
> On Thu 11-07-13 12:53:46, Jan Kara wrote:
>> On Wed 10-07-13 16:12:36, Paul Taysom wrote:
>> > The following commit introduced a 10x regression for
>> > syncing inodes in ext4 with relatime enabled where just
>> > the atime had been modified.
>> >
>> >     commit 4ea425b63a3dfeb7707fc7cc7161c11a51e871ed
>> >     Author: Jan Kara <jack@suse.cz>
>> >     Date:   Tue Jul 3 16:45:34 2012 +0200
>> >     vfs: Avoid unnecessary WB_SYNC_NONE writeback during sys_sync and reorder sync passes
>> >
>> >     See also: http://www.kernelhub.org/?msg=93100&p=2
>> >
>> > Fixed by putting back in the call to writeback_inodes_sb.
>> >
>> > I'll attach the test in a reply to this e-mail.
>> >
>> > The test starts by creating 512 files, syncing, reading one byte
>> > from each of those files, syncing, and then deleting each file
>> > and syncing. The time to do each sync is printed. The process
>> > is then repeated for 1024 files and then the next power of
>> > two up to 262144 files.
>> >
>> > Note, when running the test, the slow down doesn't always happen
>> > but most of the tests will show a slow down.
>> >
>> > In response to crbug.com/240422
>> >
>> > Signed-off-by: Paul Taysom <taysom@chromium.org>
>>   Thanks for report. Rather than blindly reverting the change, I'd like to
>> understand why you see so huge regression. As the changelog in the patch
>> says, flusher thread should be doing async writeback equivalent to the
>> removed one because it gets woken via wakeup_flusher_threads(). But my
>> guess is that for some reason we end up doing all the writeback from
>> sync_inodes_one_sb(). I'll try to reproduce your results and investigate...
>   Hum, so it must be something timing sensitive. I wasn't able to reproduce
> the issue on my test machine in 4 runs of your test program. I was able to
> reproduce it on my laptop on every second run of the test program but once
> I've enabled some tracepoints, the issue disappeared and I didn't see it in
> about 10 runs.
>
> That being said I think that reverting my patch is just papering over the
> problem. We will do the async pass over inodes twice instead of once
> and thus the timing changes enough that you aren't able to observe the
> problem.
>
> I'm looking into this more...
>
>                                                                 Honza
>> > ---
>> >  fs/sync.c | 7 +++++++
>> >  1 file changed, 7 insertions(+)
>> >
>> > diff --git a/fs/sync.c b/fs/sync.c
>> > index 905f3f6..55c3316 100644
>> > --- a/fs/sync.c
>> > +++ b/fs/sync.c
>> > @@ -73,6 +73,12 @@ static void sync_inodes_one_sb(struct super_block *sb, void *arg)
>> >             sync_inodes_sb(sb);
>> >  }
>> >
>> > +static void writeback_inodes_one_sb(struct super_block *sb, void *arg)
>> > +{
>> > +   if (!(sb->s_flags & MS_RDONLY))
>> > +           writeback_inodes_sb(sb, WB_REASON_SYNC);
>> > +}
>> > +
>> >  static void sync_fs_one_sb(struct super_block *sb, void *arg)
>> >  {
>> >     if (!(sb->s_flags & MS_RDONLY) && sb->s_op->sync_fs)
>> > @@ -104,6 +110,7 @@ SYSCALL_DEFINE0(sync)
>> >     int nowait = 0, wait = 1;
>> >
>> >     wakeup_flusher_threads(0, WB_REASON_SYNC);
>> > +   iterate_supers(writeback_inodes_one_sb, NULL);
>> >     iterate_supers(sync_inodes_one_sb, NULL);
>> >     iterate_supers(sync_fs_one_sb, &nowait);
>> >     iterate_supers(sync_fs_one_sb, &wait);
>> > --
>> > 1.8.3
>> >
>> --
>> Jan Kara <jack@suse.cz>
>> SUSE Labs, CR
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR

I've tried Dave Chinner's patch but it doesn't seem to help.

Looking at the references to WB_SYNC_NONE flag I found the interesting
comment in fs/ext4/inodes.c write_cache_pages_da:
 ...
lock_page(page);

/*
 * If the page is no longer dirty, or its
 * mapping no longer corresponds to inode we
 * are writing (which means it has been
 * truncated or invalidated), or the page is
 * already under writeback and we are not
 * doing a data integrity writeback, skip the page
 */
if (!PageDirty(page) ||
   (PageWriteback(page) &&
    (wbc->sync_mode == WB_SYNC_NONE)) ||
   unlikely(page->mapping != mapping)) {
unlock_page(page);
continue;
}

wait_on_page_writeback(page);
BUG_ON(PageWriteback(page));
...

I'm wondering if one inode is getting written out then the next inode
in the same page waits for the writeback to finish.

writeback_inodes_sb_nt sets the sync_mode to WB_SYNC_NONE
sync_inodes_sb set the sync_mode to WB_SYNC_ALL.
