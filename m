Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933270Ab3GLPnS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 11:43:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37737 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933150Ab3GLPnQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 11:43:16 -0400
Date: Fri, 12 Jul 2013 17:43:14 +0200
From: Jan Kara <jack@suse.cz>
To: Paul Taysom <taysom@chromium.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, jack@suse.cz, sonnyrao@chromium.org
Subject: Re: [PATCH] fs: sync: fixed performance regression
Message-ID: <20130712154314.GC22823@quack.suse.cz>
References: <1373497956-8770-1-git-send-email-taysom@chromium.org>
 <20130711105346.GA5349@quack.suse.cz>
 <20130711115832.GB5349@quack.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="GvXjxJ+pjyke8COw"
Content-Disposition: inline
In-Reply-To: <20130711115832.GB5349@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu 11-07-13 13:58:32, Jan Kara wrote:
> On Thu 11-07-13 12:53:46, Jan Kara wrote:
> > On Wed 10-07-13 16:12:36, Paul Taysom wrote:
> > > The following commit introduced a 10x regression for
> > > syncing inodes in ext4 with relatime enabled where just
> > > the atime had been modified.
> > > 
> > >     commit 4ea425b63a3dfeb7707fc7cc7161c11a51e871ed
> > >     Author: Jan Kara <jack@suse.cz>
> > >     Date:   Tue Jul 3 16:45:34 2012 +0200
> > >     vfs: Avoid unnecessary WB_SYNC_NONE writeback during sys_sync and reorder sync passes
> > > 
> > >     See also: http://www.kernelhub.org/?msg=93100&p=2
> > > 
> > > Fixed by putting back in the call to writeback_inodes_sb.
> > > 
> > > I'll attach the test in a reply to this e-mail.
> > > 
> > > The test starts by creating 512 files, syncing, reading one byte
> > > from each of those files, syncing, and then deleting each file
> > > and syncing. The time to do each sync is printed. The process
> > > is then repeated for 1024 files and then the next power of
> > > two up to 262144 files.
> > > 
> > > Note, when running the test, the slow down doesn't always happen
> > > but most of the tests will show a slow down.
> > > 
> > > In response to crbug.com/240422
> > > 
> > > Signed-off-by: Paul Taysom <taysom@chromium.org>
> >   Thanks for report. Rather than blindly reverting the change, I'd like to
> > understand why you see so huge regression. As the changelog in the patch
> > says, flusher thread should be doing async writeback equivalent to the
> > removed one because it gets woken via wakeup_flusher_threads(). But my
> > guess is that for some reason we end up doing all the writeback from
> > sync_inodes_one_sb(). I'll try to reproduce your results and investigate...
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
  So I finally understood what's going on. If the system has no dirty pages
at all wakeup_flusher_threads() will submit work with nr_pages == 0.  So
wb_writeback() will bail out immediately without doing anything and all the
writeback is left for WB_SYNC_ALL pass of sync(1) which is slow. Attached
patch fixes the problem for me.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--GvXjxJ+pjyke8COw
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-writeback-Fix-occasional-slow-sync-1.patch"

>From 2e3d6f21ffa990780e9b25e11be31a6e0da13c79 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Fri, 12 Jul 2013 17:30:07 +0200
Subject: [PATCH] writeback: Fix occasional slow sync(1)

In case when system contains no dirty pages, wakeup_flusher_threads()
will submit WB_SYNC_NONE writeback for 0 pages so wb_writeback() exits
immediately without doing anything. Thus sync(1) will write all the
dirty inodes from a WB_SYNC_ALL writeback pass which is slow.

Fix the problem by using get_nr_dirty_pages() in
wakeup_flusher_threads() instead of calculating number of dirty pages
manually. That function also takes number of dirty inodes into account.

CC: stable@vger.kernel.org
Reported-by: Paul Taysom <taysom@chromium.org>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/fs-writeback.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index a85ac4e..d0d70a8 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1055,10 +1055,8 @@ void wakeup_flusher_threads(long nr_pages, enum wb_reason reason)
 {
 	struct backing_dev_info *bdi;
 
-	if (!nr_pages) {
-		nr_pages = global_page_state(NR_FILE_DIRTY) +
-				global_page_state(NR_UNSTABLE_NFS);
-	}
+	if (!nr_pages)
+		nr_pages = get_nr_dirty_pages();
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(bdi, &bdi_list, bdi_list) {
-- 
1.8.1.4


--GvXjxJ+pjyke8COw--
