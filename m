Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764Ab3AYRae (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 12:30:34 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.182]:4441 "EHLO
	ironport2-out.teksavvy.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751208Ab3AYRab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 12:30:31 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtkGAG6Zu0/O+Ip3/2dsb2JhbABEgXuyFoEIghUBAQUnExsBIxALGAklDwUlJBOIDroJj2JiA4hCjFiOGYFYgwc
X-IronPort-AV: E=Sophos;i="4.75,637,1330923600"; 
   d="scan'208";a="213674801"
Date: Fri, 25 Jan 2013 12:30:30 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, lttng-dev@lists.lttng.org
Subject: Re: [tracepoint] cargo-culting considered harmful...
Message-ID: <20130125173030.GB23720@Krystal>
References: <20130123225523.GY4939@ZenIV.linux.org.uk>
 <20130123155147.25fe49a2.akpm@linux-foundation.org>
 <20130124014840.GA4503@ZenIV.linux.org.uk>
 <20130125144953.GB20597@Krystal>
 <20130125153159.GE4503@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20130125153159.GE4503@ZenIV.linux.org.uk>
X-Editor: vi
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Al Viro (viro@ZenIV.linux.org.uk) wrote:
> On Fri, Jan 25, 2013 at 09:49:53AM -0500, Mathieu Desnoyers wrote:
> > static
> > void lttng_enumerate_task_fd(struct lttng_session *session,
> >                 struct task_struct *p, char *tmp)
> > {
> >         struct fdtable *fdt;
> >         struct file *filp;
> >         unsigned int i;
> >         const unsigned char *path;
> > 
> >         task_lock(p);
> >         if (!p->files)
> >                 goto unlock_task;
> >         spin_lock(&p->files->file_lock);
> >         fdt = files_fdtable(p->files);
> >         for (i = 0; i < fdt->max_fds; i++) {
> >                 filp = fcheck_files(p->files, i);
> >                 if (!filp)
> >                         continue;
> >                 path = d_path(&filp->f_path, tmp, PAGE_SIZE);
> >                 /* Make sure we give at least some info */
> >                 trace_lttng_statedump_file_descriptor(session, p, i,
> >                         IS_ERR(path) ?
> >                                 filp->f_dentry->d_name.name :
> >                                 path);
> >         }
> >         spin_unlock(&p->files->file_lock);
> > unlock_task:
> >         task_unlock(p);
> > }
> 
> *cringe*
> 
> a) yes, it needs d_lock for that ->d_name access
> b) iterate_fd() is there for purpose; use it, instead of open-coding the
> damn loop.  Something like
> 
> struct ctx {
> 	char *page;
> 	struct lttng_session *session,
> 	struct task_struct *p;
> };
> 	
> static int dump_one(void *p, struct file *file, unsigned fd)
> {
> 	struct ctx *ctx = p;
> 	const char *s = d_path(&file->f_path, ctx->page, PAGE_SIZE);
> 	struct dentry *dentry;
> 	if (!IS_ERR(s)) {
> 		trace_lttng_statedump_file_descriptor(ctx->session, ctx->p, fd, s);
> 		return 0;
> 	}
> 	/* Make sure we give at least some info */
> 	dentry = file->f_path.dentry;
> 	spin_lock(&dentry->d_lock);
> 	trace_lttng_statedump_file_descriptor(ctx->session, ctx->p, fd,
> 		dentry->d_name);
> 	spin_unlock(&dentry->d_lock);
> 	return 0;
> }
> 
> ...
> 	task_lock(p);
> 	iterate_fd(p->files, 0, dump_one, &(struct ctx){tmp, session, p});
> 	task_unlock(p);
> 
> assuming it wouldn't be better to pass tmp/session/p as the single pointer
> to struct in the first place - I don't know enough about the callers of
> that sucker to tell.  And yes, iterate_fd() will DTRT if given NULL as the
> first argument.  The second argument is "which descriptor should I start
> from?", callback is called for everything present in the table starting from
> that place until it returns non-zero or the end of table is reached...

Thanks !! Modulo a couple of trivial nits, I've integrated your
suggestions. I'm creating a lttng_iterate_fd() wrapper for older kernels
(yeah.. we deal with kernels back to 2.6.32).

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
