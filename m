Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739Ab3GOJqg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 05:46:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58485 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754547Ab3GOJqf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 05:46:35 -0400
Date: Mon, 15 Jul 2013 11:46:33 +0200
From: Jan Kara <jack@suse.cz>
To: Paul Taysom <taysom@google.com>
Cc: Jan Kara <jack@suse.cz>, Paul Taysom <taysom@chromium.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        sonnyrao@chromium.org
Subject: Re: [PATCH] fs: sync: fixed performance regression
Message-ID: <20130715094633.GA3747@quack.suse.cz>
References: <1373497956-8770-1-git-send-email-taysom@chromium.org>
 <20130711105346.GA5349@quack.suse.cz>
 <20130711115832.GB5349@quack.suse.cz>
 <20130712154314.GC22823@quack.suse.cz>
 <CAKwO_5HZN1LW6CMJ3V9K-MBpPrYpo6aLpVh9dccUNPC7MJ=3Dw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwO_5HZN1LW6CMJ3V9K-MBpPrYpo6aLpVh9dccUNPC7MJ=3Dw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 12-07-13 09:59:00, Paul Taysom wrote:
> `On Fri, Jul 12, 2013 at 8:43 AM, Jan Kara <jack@suse.cz> wrote:
> > On Thu 11-07-13 13:58:32, Jan Kara wrote:
> >> On Thu 11-07-13 12:53:46, Jan Kara wrote:
> >> > On Wed 10-07-13 16:12:36, Paul Taysom wrote:
> >> > > The following commit introduced a 10x regression for
> >> > > syncing inodes in ext4 with relatime enabled where just
> >> > > the atime had been modified.
> >> > >
> >> > >     commit 4ea425b63a3dfeb7707fc7cc7161c11a51e871ed
> >> > >     Author: Jan Kara <jack@suse.cz>
> >> > >     Date:   Tue Jul 3 16:45:34 2012 +0200
> >> > >     vfs: Avoid unnecessary WB_SYNC_NONE writeback during sys_sync and reorder sync passes
> >> > >
> >> > >     See also: http://www.kernelhub.org/?msg=93100&p=2
> >> > >
> >> > > Fixed by putting back in the call to writeback_inodes_sb.
> >> > >
> >> > > I'll attach the test in a reply to this e-mail.
> >> > >
> >> > > The test starts by creating 512 files, syncing, reading one byte
> >> > > from each of those files, syncing, and then deleting each file
> >> > > and syncing. The time to do each sync is printed. The process
> >> > > is then repeated for 1024 files and then the next power of
> >> > > two up to 262144 files.
> >> > >
> >> > > Note, when running the test, the slow down doesn't always happen
> >> > > but most of the tests will show a slow down.
> >> > >
> >> > > In response to crbug.com/240422
> >> > >
> >> > > Signed-off-by: Paul Taysom <taysom@chromium.org>
> >> >   Thanks for report. Rather than blindly reverting the change, I'd like to
> >> > understand why you see so huge regression. As the changelog in the patch
> >> > says, flusher thread should be doing async writeback equivalent to the
> >> > removed one because it gets woken via wakeup_flusher_threads(). But my
> >> > guess is that for some reason we end up doing all the writeback from
> >> > sync_inodes_one_sb(). I'll try to reproduce your results and investigate...
> >>   Hum, so it must be something timing sensitive. I wasn't able to reproduce
> >> the issue on my test machine in 4 runs of your test program. I was able to
> >> reproduce it on my laptop on every second run of the test program but once
> >> I've enabled some tracepoints, the issue disappeared and I didn't see it in
> >> about 10 runs.
> >>
> >> That being said I think that reverting my patch is just papering over the
> >> problem. We will do the async pass over inodes twice instead of once
> >> and thus the timing changes enough that you aren't able to observe the
> >> problem.
> >>
> >> I'm looking into this more...
> >   So I finally understood what's going on. If the system has no dirty pages
> > at all wakeup_flusher_threads() will submit work with nr_pages == 0.  So
> > wb_writeback() will bail out immediately without doing anything and all the
> > writeback is left for WB_SYNC_ALL pass of sync(1) which is slow. Attached
> > patch fixes the problem for me.
> >
> >                                                                 Honza
> > --
> > Jan Kara <jack@suse.cz>
> > SUSE Labs, CR
> 
> Jan,
> Your fix is a clear win! Not only did it fix the sync after read
> problem but it made the sync after create faster too.
  Thanks for testing! I've sent the patch to Al for inclusion.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
