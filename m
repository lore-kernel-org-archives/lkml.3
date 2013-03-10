Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337Ab3CJXdW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 19:33:22 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36398 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab3CJXdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 19:33:20 -0400
Date: Sun, 10 Mar 2013 23:33:18 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: J??rn Engel <joern@logfs.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: pipe_release oops.
Message-ID: <20130310233318.GC21522@ZenIV.linux.org.uk>
References: <CA+55aFwDYocNRjSCJk1PYw0MFy7dpKf1yMMEiePP--=ewQcX6A@mail.gmail.com>
 <20130307213819.GB19543@redhat.com>
 <CA+55aFx424SX6S1zFegVaMZ_BkeZctDKCN6eYCLFfaJDKRVG9g@mail.gmail.com>
 <20130307220333.GA31039@redhat.com>
 <20130307223610.GA2494@redhat.com>
 <CA+55aFzdPaFQROzFhz-v1Qn=3aDP=4uGTiOJxR26cR91uJHxyg@mail.gmail.com>
 <20130308145306.GA24085@redhat.com>
 <CA+55aFzwOnRnp2B09fKjt8hd9tOCv44H482z1QpCnYc2mywnpA@mail.gmail.com>
 <20130308182648.GA25175@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130308182648.GA25175@logfs.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 08, 2013 at 01:26:49PM -0500, J??rn Engel wrote:
> On Fri, 8 March 2013 10:30:01 -0800, Linus Torvalds wrote:
> > 
> > Hmm. So I've been trying to figure this out, and I really don't see
> > it. Every single pipe open routine *should* make sure that the inode
> > has an inode->i_pipe field. So if the open() has succeeded and you
> > have a valid file descriptor, the inode->i_pipe thing should be there.
> 
> Ok, here is a wild idea that is very likely wrong.  But some
> background first.  I've had problems with process exit times and one
> of the culprits turned out to be exit_files() where one device driver
> went awol for several seconds.  Fixing the device driver is hard, I
> didn't see a good reason not to call exit_files() earlier and
> exit_mm() was the other big offender, so the idea was to run both in
> parallel and I applied the patch below.
> 
> As a result I've gotten a bunch of NULL pointer dereferences that only
> happen in virtual machines, never on real hardware.  For example
>   [<ffffffff81164bf8>] alloc_fd+0x38/0x130
>   [<ffffffff8114857e>] do_sys_open+0xee/0x1f0
>   [<ffffffff811486a1>] sys_open+0x21/0x30
>   [<ffffffff815bea29>] system_call_fastpath+0x16/0x1b
> 
> Now I can easily see how current->files being NULL will result in such
> backtraces.  I can also see how my patch moves the NULLing of
> current->files a bit back in time.  But I could never figure out how
> my patch could have introduced a race that didn't exist before.
> 
> So the wild idea is that we have always had a very unlikely race with
> current->files being NULL and trinity happens to hit it somehow.
> 
> J??rn

> +	files_cookie = async_schedule(exit_files_async, tsk);
>  	exit_mm(tsk);
>  
>  	if (group_dead)
> @@ -990,7 +998,7 @@ void do_exit(long code)
>  
>  	exit_sem(tsk);
>  	exit_shm(tsk);
> -	exit_files(tsk);
> +	async_synchronize_cookie(files_cookie);

That doesn't do what you seem to think it's doing.  It does *not* wait
for the completion of that sucker's execution - only the ones scheduled
before it.  IOW, your exit_files_async() might very well be executed
*after* do_exit() completes and tsk gets reused.
