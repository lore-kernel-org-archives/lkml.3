Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525Ab3JBK4h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 06:56:37 -0400
Received: from mail-bk0-f43.google.com ([209.85.214.43]:52907 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330Ab3JBK4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 06:56:34 -0400
Date: Wed, 2 Oct 2013 12:56:30 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Waiman Long <Waiman.Long@hp.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: spinlock contention of files->file_lock
Message-ID: <20131002105630.GB24570@gmail.com>
References: <CA+55aFwp-RAKEMVvbMG53C=kTMqS09NPXy1eP4xEUYZpvV8X5Q@mail.gmail.com>
 <1380589503.5326.13.camel@edumazet-glaptop.roam.corp.google.com>
 <CA+55aFwWi-RveiuFEManbED3DcA76Cf3CKVXrrs5d5FvNgedOg@mail.gmail.com>
 <1380663718.19002.49.camel@edumazet-glaptop.roam.corp.google.com>
 <20131001220453.GY13318@ZenIV.linux.org.uk>
 <20131002051319.GB27982@gmail.com>
 <20131002102037.GZ13318@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131002102037.GZ13318@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Al Viro <viro@ZenIV.linux.org.uk> wrote:

> On Wed, Oct 02, 2013 at 07:13:19AM +0200, Ingo Molnar wrote:
> > 
> > * Al Viro <viro@ZenIV.linux.org.uk> wrote:
> > 
> > > On Tue, Oct 01, 2013 at 02:41:58PM -0700, Eric Dumazet wrote:
> > > > Maybe I am missing something obvious ?
> > > 
> > > Yes.  do_execve_common() starts with unshare_files(); there can be
> > > no other thread capable of modifying that descriptor table.
> > 
> > Btw., might the Android Binder:
> > 
> >   drivers/staging/android/binder.c:       struct files_struct *files = proc->files;
> > ...
> >   drivers/staging/android/binder.c:               __fd_install(proc->files, fd, file);
> > ...
> >   drivers/staging/android/binder.c:       retval = __close_fd(proc->files, fd);
> > 
> > violate that assumption?
> 
> Not unless your thread has managed to call an ioctl between entering
> do_execve_common() and calling do_close_on_exec() ;-)

Indeed - while the binder interface appears to allow the insertion of fds 
into other task's file tables, it refcounts its task->files access and 
only ever receives it via get_files_struct(current), so it cannot possibly 
interfere with a private file table resulting from unshare_files().

Thanks,

	Ingo
