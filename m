Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726Ab3AYPcF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 10:32:05 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:36009 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754825Ab3AYPcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 10:32:03 -0500
Date: Fri, 25 Jan 2013 15:32:00 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [tracepoint] cargo-culting considered harmful...
Message-ID: <20130125153159.GE4503@ZenIV.linux.org.uk>
References: <20130123225523.GY4939@ZenIV.linux.org.uk>
 <20130123155147.25fe49a2.akpm@linux-foundation.org>
 <20130124014840.GA4503@ZenIV.linux.org.uk>
 <20130125144953.GB20597@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130125144953.GB20597@Krystal>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 09:49:53AM -0500, Mathieu Desnoyers wrote:
> static
> void lttng_enumerate_task_fd(struct lttng_session *session,
>                 struct task_struct *p, char *tmp)
> {
>         struct fdtable *fdt;
>         struct file *filp;
>         unsigned int i;
>         const unsigned char *path;
> 
>         task_lock(p);
>         if (!p->files)
>                 goto unlock_task;
>         spin_lock(&p->files->file_lock);
>         fdt = files_fdtable(p->files);
>         for (i = 0; i < fdt->max_fds; i++) {
>                 filp = fcheck_files(p->files, i);
>                 if (!filp)
>                         continue;
>                 path = d_path(&filp->f_path, tmp, PAGE_SIZE);
>                 /* Make sure we give at least some info */
>                 trace_lttng_statedump_file_descriptor(session, p, i,
>                         IS_ERR(path) ?
>                                 filp->f_dentry->d_name.name :
>                                 path);
>         }
>         spin_unlock(&p->files->file_lock);
> unlock_task:
>         task_unlock(p);
> }

*cringe*

a) yes, it needs d_lock for that ->d_name access
b) iterate_fd() is there for purpose; use it, instead of open-coding the
damn loop.  Something like

struct ctx {
	char *page;
	struct lttng_session *session,
	struct task_struct *p;
};
	
static int dump_one(void *p, struct file *file, unsigned fd)
{
	struct ctx *ctx = p;
	const char *s = d_path(&file->f_path, ctx->page, PAGE_SIZE);
	struct dentry *dentry;
	if (!IS_ERR(s)) {
		trace_lttng_statedump_file_descriptor(ctx->session, ctx->p, fd, s);
		return 0;
	}
	/* Make sure we give at least some info */
	dentry = file->f_path.dentry;
	spin_lock(&dentry->d_lock);
	trace_lttng_statedump_file_descriptor(ctx->session, ctx->p, fd,
		dentry->d_name);
	spin_unlock(&dentry->d_lock);
	return 0;
}

...
	task_lock(p);
	iterate_fd(p->files, 0, dump_one, &(struct ctx){tmp, session, p});
	task_unlock(p);

assuming it wouldn't be better to pass tmp/session/p as the single pointer
to struct in the first place - I don't know enough about the callers of
that sucker to tell.  And yes, iterate_fd() will DTRT if given NULL as the
first argument.  The second argument is "which descriptor should I start
from?", callback is called for everything present in the table starting from
that place until it returns non-zero or the end of table is reached...

PS: people really ought to be forced to read their code aloud over the phone -
that would rapidly improve the choice of identifiers ;-)
