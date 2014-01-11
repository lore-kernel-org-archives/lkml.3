Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751596AbaAKGes (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 01:34:48 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:59950 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbaAKGeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 01:34:44 -0500
Date: Fri, 10 Jan 2014 22:34:38 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Eric Dumazet <edumazet@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] rcu_dereference_check_fdtable fix/cleanups
Message-ID: <20140111063438.GY10038@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140107181258.GA29288@redhat.com>
 <20140108132852.GF10038@linux.vnet.ibm.com>
 <20140108151918.GA5156@redhat.com>
 <20140109011650.GI10038@linux.vnet.ibm.com>
 <20140110153459.GA31491@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140110153459.GA31491@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14011106-7164-0000-0000-000005054A5D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 10, 2014 at 04:34:59PM +0100, Oleg Nesterov wrote:
> On 01/08, Paul E. McKenney wrote:
> >
> > On Wed, Jan 08, 2014 at 04:19:18PM +0100, Oleg Nesterov wrote:
> > > On 01/08, Paul E. McKenney wrote:
> > > >
> > > > Another approach would be to add an argument to files_fdtable()
> > > > that is zero normally and one for "we know we don't need RCU
> > > > protection."  Then rcu_dereference_check() could be something
> > > > like the following:
> > > >
> > > > #define files_fdtable(files, c) \
> > > > 		(rcu_dereference_check_fdtable((files), (files)->fdt) || c)
> > > >
> > > > Would that work?
> > >
> > > Yes, I considered this optiion, but this needs much more uglifications^W
> > > changes.
> > >
> > > Either we need to change all users of files_fdtable(), or we need something
> > > like
> >
> > There are only about 20 uses of files_fdtable() in 3.12, with almost all
> > of them in fs/file.c.  So is changing all the users really all that
> > problematic?
> 
> But only one user, close_files(), needs files_fdtable(files, true). Why
> complicate the patch and the code? I think it would be better to simply
> change close_files() to use rcu_dereference_raw().
> 
> And note that rcu_dereference_check_fdtable() needs the new argument too.
> 
> And we should also take care of fcheck_files(),
> 
> > > 	static inline struct file *__fcheck_files(struct files_struct *files, unsigned int fd)
> > > 	{
> > > 		struct fdtable *fdt = rcu_dereference_raw(files->fdt);
> > > 		struct file *file = NULL;
> > >
> > > 		if (fd < fdt->max_fds)
> > > 			file = rcu_dereference_raw(fdt->fd[fd]);
> > >
> > > 		return file;
> > > 	}
> > >
> > > 	static inline struct file *fcheck_files(struct files_struct *files, unsigned int fd)
> > > 	{
> > > 		rcu_lockdep_assert(rcu_read_lock_held() ||
> > > 				   lockdep_is_held(files->file_lock),
> > > 				   "message");
> > > 		return __fcheck_files(files, fd);
> > > 	}
> 
> doesn't this look much simpler than adding the "bool unshared" argument
> and changing the callers?

I might be being too paranoid, but my concern with using rcu_lock_acquire()
and rcu_lock_release() is the possibility of code needing rcu_read_lock()
appearing somewhere in the function-call graph between rcu_lock_acquire()
and rcu_lock_release().  In that case, lockdep would be happy, but the
required RCU protection would not be present.

Sort of like my experience with people using RCU from idle.

							Thanx, Paul

