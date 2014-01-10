Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757236AbaAJPef (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 10:34:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22431 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751936AbaAJPec (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 10:34:32 -0500
Date: Fri, 10 Jan 2014 16:34:59 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Eric Dumazet <edumazet@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] rcu_dereference_check_fdtable fix/cleanups
Message-ID: <20140110153459.GA31491@redhat.com>
References: <20140107181258.GA29288@redhat.com> <20140108132852.GF10038@linux.vnet.ibm.com> <20140108151918.GA5156@redhat.com> <20140109011650.GI10038@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140109011650.GI10038@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08, Paul E. McKenney wrote:
>
> On Wed, Jan 08, 2014 at 04:19:18PM +0100, Oleg Nesterov wrote:
> > On 01/08, Paul E. McKenney wrote:
> > >
> > > Another approach would be to add an argument to files_fdtable()
> > > that is zero normally and one for "we know we don't need RCU
> > > protection."  Then rcu_dereference_check() could be something
> > > like the following:
> > >
> > > #define files_fdtable(files, c) \
> > > 		(rcu_dereference_check_fdtable((files), (files)->fdt) || c)
> > >
> > > Would that work?
> >
> > Yes, I considered this optiion, but this needs much more uglifications^W
> > changes.
> >
> > Either we need to change all users of files_fdtable(), or we need something
> > like
>
> There are only about 20 uses of files_fdtable() in 3.12, with almost all
> of them in fs/file.c.  So is changing all the users really all that
> problematic?

But only one user, close_files(), needs files_fdtable(files, true). Why
complicate the patch and the code? I think it would be better to simply
change close_files() to use rcu_dereference_raw().

And note that rcu_dereference_check_fdtable() needs the new argument too.

And we should also take care of fcheck_files(),

> > 	static inline struct file *__fcheck_files(struct files_struct *files, unsigned int fd)
> > 	{
> > 		struct fdtable *fdt = rcu_dereference_raw(files->fdt);
> > 		struct file *file = NULL;
> >
> > 		if (fd < fdt->max_fds)
> > 			file = rcu_dereference_raw(fdt->fd[fd]);
> >
> > 		return file;
> > 	}
> >
> > 	static inline struct file *fcheck_files(struct files_struct *files, unsigned int fd)
> > 	{
> > 		rcu_lockdep_assert(rcu_read_lock_held() ||
> > 				   lockdep_is_held(files->file_lock),
> > 				   "message");
> > 		return __fcheck_files(files, fd);
> > 	}

doesn't this look much simpler than adding the "bool unshared" argument
and changing the callers?

Oleg.

