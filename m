Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751734Ab3LLLgp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 06:36:45 -0500
Received: from smtp3-g21.free.fr ([212.27.42.3]:42381 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751585Ab3LLLgn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 06:36:43 -0500
Message-ID: <1386848190.9959.12.camel@localhost.localdomain>
Subject: Re: [PATCH] fs: clear close-on-exec flag as part of put_unused_fd()
From: Yann Droneaud <ydroneaud@opteya.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Mateusz Guzik <mguzik@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yann Droneaud <ydroneaud@opteya.com>
Date: Thu, 12 Dec 2013 12:36:30 +0100
In-Reply-To: <20131211233011.GA10323@ZenIV.linux.org.uk>
References: <1386796107-4197-1-git-send-email-ydroneaud@opteya.com>
	 <20131211223634.GA13828@mguzik.redhat.com>
	 <20131211233011.GA10323@ZenIV.linux.org.uk>
Organization: OPTEYA
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Le mercredi 11 décembre 2013 à 23:30 +0000, Al Viro a écrit :
> On Wed, Dec 11, 2013 at 11:36:35PM +0100, Mateusz Guzik wrote:
> 
> > >From my reading this will break at least the following:
> > fd = open(..., .. | O_CLOEXEC);
> > dup2(whatever, fd);
> > 
> > now fd has O_CLOEXEC even though it should not
> 
> Moreover, consider fork() done by a thread that shares descriptor
> table with somebody else.  Suppose it happens in the middle of
> open() with O_CLOEXEC being done by another thread.  We copy descriptor
> table after descriptor had been reserved (and marked close-on-exec),
> but before a reference to struct file has actually been inserted there.
> This code
>         for (i = open_files; i != 0; i--) {
>                 struct file *f = *old_fds++;
>                 if (f) {
>                         get_file(f);
>                 } else {
>                         /*    
>                          * The fd may be claimed in the fd bitmap but not yet
>                          * instantiated in the files array if a sibling thread
>                          * is partway through open().  So make sure that this
>                          * fd is available to the new process.
>                          */
>                         __clear_open_fd(open_files - i, new_fdt);
>                 }
>                 rcu_assign_pointer(*new_fds++, f);
>         }
>         spin_unlock(&oldf->file_lock);
> in dup_fd() will clear the corresponding bit in open_fds, leaving close_on_exec
> alone.  Currently that's fine (we will override whatever had been in
> close_on_exec when we reserve that descriptor again), but AFAICS with this
> patch it will break.
> 

That's a terrible subtle case. it will indeed break with the patch.

> Sure, it can be fixed up (ditto with dup2(), etc.), but what's the point?

It was only an attempt at making close-on-exec handling "simpler".

> Result will require more subtle reasoning to prove correctness and will
> be more prone to breakage.  Does that really yield visible performance
> improvements that would be worth the extra complexity?  After all, you
> trade some writes to close_on_exec on descriptor reservation for unconditional
> write on descriptor freeing; if anything, I would expect that you'll get
> minor _loss_ from that change, assuming they'll be measurable in the first
> place...

Since it's not so straightforward to get it correct, and the only
advantage I was trying to address is aesthetic, I will discard it.

Thanks a lot for the review and the comments.

Regards.

-- 
Yann Droneaud
OPTEYA


