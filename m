Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203AbaAIWpr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 17:45:47 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:37585 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbaAIWpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 17:45:39 -0500
Date: Wed, 8 Jan 2014 17:16:50 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Eric Dumazet <edumazet@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] rcu_dereference_check_fdtable fix/cleanups
Message-ID: <20140109011650.GI10038@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140107181258.GA29288@redhat.com>
 <20140108132852.GF10038@linux.vnet.ibm.com>
 <20140108151918.GA5156@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140108151918.GA5156@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14010922-3532-0000-0000-0000049BCAA5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 08, 2014 at 04:19:18PM +0100, Oleg Nesterov wrote:
> On 01/08, Paul E. McKenney wrote:
> >
> > I am not all that excited about invoking rcu_lock_acquire() outside
> > of RCU...
> 
> Yes, me too. That is why I thought about the helper with a good name,
> see below.
> 
> > Another approach would be to add an argument to files_fdtable()
> > that is zero normally and one for "we know we don't need RCU
> > protection."  Then rcu_dereference_check() could be something
> > like the following:
> >
> > #define files_fdtable(files, c) \
> > 		(rcu_dereference_check_fdtable((files), (files)->fdt) || c)
> >
> > Would that work?
> 
> Yes, I considered this optiion, but this needs much more uglifications^W
> changes.
> 
> Either we need to change all users of files_fdtable(), or we need something
> like

There are only about 20 uses of files_fdtable() in 3.12, with almost all
of them in fs/file.c.  So is changing all the users really all that
problematic?

							Thanx, Paul

> 	#define __rcu_dereference_check_fdtable(files, unshared, fdtfd) \
> 		rcu_dereference_check((fdtfd), unshared || lockdep_is_held(&(files)->file_lock))
> 
> 	#define rcu_dereference_check_fdtable(files, fdtfd)
> 		__rcu_dereference_check_fdtable(files, false, fdtfd)
> 
> 	#define __files_fdtable(files)
> 		__rcu_dereference_check_fdtable((files), true, (files)->fdt)
> 
> 	#define files_fdtable(files)
> 		__rcu_dereference_check_fdtable((files), false, (files)->fdt)
> 
> Plus we need
> 
> 	static inline struct file *__fcheck_files(struct files_struct *files,
> 						bool unshared, unsigned int fd)
> 	{
> 		struct file *file = NULL;
> 		struct fdtable *fdt = __rcu_dereference_check_fdtable(files, unshared, files->fdt);
> 
> 		if (fd < fdt->max_fds)
> 			file = __rcu_dereference_check_fdtable(files, unshared, fdt->fd[fd]);
> 		return file;
> 	}
> 
> doesn't look very nice...
> 
> As for 2/2, probably close_files() can simply do
> 
> 	/*
> 	 * It is safe to dereference the fd table without RCU or
> 	 * ->file_lock because this is the last reference to the
> 	 * files structure.
> 	 */
> 	fdt = rcu_dereference_raw(files->fdt);
> 
> Or we can add
> 
> 	#define __files_fdtable(files)	\
> 		 rcu_dereference_raw((files)->fdt)
> 
> but it is not clear to me what 1/1 should do. Perhaps
> 
> 	static inline struct file *__fcheck_files(struct files_struct *files, unsigned int fd)
> 	{
> 		struct fdtable *fdt = rcu_dereference_raw(files->fdt);
> 		struct file *file = NULL;
> 
> 		if (fd < fdt->max_fds)
> 			file = rcu_dereference_raw(fdt->fd[fd]);
> 
> 		return file;
> 	}
> 
> 	static inline struct file *fcheck_files(struct files_struct *files, unsigned int fd)
> 	{
> 		rcu_lockdep_assert(rcu_read_lock_held() ||
> 				   lockdep_is_held(files->file_lock),
> 				   "message");
> 		return __fcheck_files(files, fd);
> 	}
> 
> ?
> 
> Oleg.
> 

