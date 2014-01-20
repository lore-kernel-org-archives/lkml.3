Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102AbaATSpl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 13:45:41 -0500
Received: from mail-ea0-f175.google.com ([209.85.215.175]:38145 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbaATSpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 13:45:39 -0500
Date: Mon, 20 Jan 2014 19:45:25 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Alan Ott <alan@signal11.us>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-omap@vger.kernel.org
Subject: Re: Deadlock in do_page_fault() on ARM (old kernel)
Message-ID: <20140120184525.GA29193@dhcp22.suse.cz>
References: <52D73220.3030108@signal11.us>
 <20140120101509.GA2626@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140120101509.GA2626@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 20-01-14 11:15:09, Michal Hocko wrote:
> On Wed 15-01-14 20:13:04, Alan Ott wrote:
> [...]
> > 2. __copy_to_user_memcpy() takes a read lock (down_read()) on
> 
> This looks like a bug. copy_to_user_* shouldn't take mmap_sem at all
> Check the might_fault annotation used in generic code. Arm version of
> copy_to_user* doesn't seem to use the annotation and I do not see a good
> reason for that.

OK, so I have looked at the implementation of __copy_to_user_memcpy and
it drops the semaphore before it does __put_user to fault memory in.  It
then reacquires the lock to make sure that the pte doesn't vanish during
memcpy. It holds pte lock to ensure that.

The mmap_sem reacquire happens with pte lock held though and this smells
like a deadlock situation because the page fault takes mmap_sem first
and only then takes ptl. I am not sure this is exactly what happens in
your case though because you seem to have tasks blocked on the mmap_sem
already.

> > mm->mmap_sem. While that lock is held, __copy_to_user_memcpy() can
> > generate a page fault, causing do_page_fault() to get called, which
> > will also try to get a read lock (down_read()) on mm->mmap_sem.
> > Multiple read locks can be taken on an rw_semaphore, but deadlock
> > will occur if another thread tries to get a write lock
> > (down_write()) in between. For example:
> >     Task 1:         Task 2:
> >     down_read(sem)
> >                     down_write(sem)    <-- Goes to sleep
> >     down_read(sem)                     <-- Goes to sleep
> > 
> > There is a thread from 2005[3] which seems to discuss the same
> > concept of recursive rw_semaphores, but for futexes.
> > 
> > Other comments:
> > 1. My analysis of this probably wrong. Otherwise it seems many
> > others would have the same problem, and they don't seem to. I'm
> > hoping this email will help to correct my understanding.
> > 2. I looked through the git logs for recent (since 2.6.37 time
> > frame) and nothing else jumped out at me as being an obvious fix for
> > this situation.
> > 
> > Thanks for any insight you can give,
> > 
> > Alan.
> > 
> > [1] http://www.signal11.us/~alan/show-all-tasks-deadlock.txt
> > 
> > [2] Some websites/bugtrackers mention this commit with a similar
> > issue, but I'm not entirely sure how it's related:
> > http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=8878a539ff19a43cf3729e7562cd528f490246ae
> > 
> > This one seems obviously related, but has no effect on my system:
> > http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=435a7ef52db7d86e67a009b36cac1457f8972391
> > 
> > [3] http://thread.gmane.org/gmane.linux.kernel/280900
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
> -- 
> Michal Hocko
> SUSE Labs
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Michal Hocko
SUSE Labs
