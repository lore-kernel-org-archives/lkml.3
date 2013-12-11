Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751761Ab3LKXa3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 18:30:29 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:43268 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492Ab3LKXaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 18:30:14 -0500
Date: Wed, 11 Dec 2013 23:30:11 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Mateusz Guzik <mguzik@redhat.com>
Cc: Yann Droneaud <ydroneaud@opteya.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: clear close-on-exec flag as part of put_unused_fd()
Message-ID: <20131211233011.GA10323@ZenIV.linux.org.uk>
References: <1386796107-4197-1-git-send-email-ydroneaud@opteya.com>
 <20131211223634.GA13828@mguzik.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131211223634.GA13828@mguzik.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 11, 2013 at 11:36:35PM +0100, Mateusz Guzik wrote:

> >From my reading this will break at least the following:
> fd = open(..., .. | O_CLOEXEC);
> dup2(whatever, fd);
> 
> now fd has O_CLOEXEC even though it should not

Moreover, consider fork() done by a thread that shares descriptor
table with somebody else.  Suppose it happens in the middle of
open() with O_CLOEXEC being done by another thread.  We copy descriptor
table after descriptor had been reserved (and marked close-on-exec),
but before a reference to struct file has actually been inserted there.
This code
        for (i = open_files; i != 0; i--) {
                struct file *f = *old_fds++;
                if (f) {
                        get_file(f);
                } else {
                        /*    
                         * The fd may be claimed in the fd bitmap but not yet
                         * instantiated in the files array if a sibling thread
                         * is partway through open().  So make sure that this
                         * fd is available to the new process.
                         */
                        __clear_open_fd(open_files - i, new_fdt);
                }
                rcu_assign_pointer(*new_fds++, f);
        }
        spin_unlock(&oldf->file_lock);
in dup_fd() will clear the corresponding bit in open_fds, leaving close_on_exec
alone.  Currently that's fine (we will override whatever had been in
close_on_exec when we reserve that descriptor again), but AFAICS with this
patch it will break.

Sure, it can be fixed up (ditto with dup2(), etc.), but what's the point?
Result will require more subtle reasoning to prove correctness and will
be more prone to breakage.  Does that really yield visible performance
improvements that would be worth the extra complexity?  After all, you
trade some writes to close_on_exec on descriptor reservation for unconditional
write on descriptor freeing; if anything, I would expect that you'll get
minor _loss_ from that change, assuming they'll be measurable in the first
place...
