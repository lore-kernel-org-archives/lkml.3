Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451Ab3AYOt5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 09:49:57 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.182]:41180 "EHLO
	ironport2-out.teksavvy.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752830Ab3AYOty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 09:49:54 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtoGAG6Zu0/O+Ip3/2dsb2JhbAA8CIF7shaBCIIVAQEFJxMbASMQCxgJJQ8FJSQTiA66CYsdhEViA4hCjFiOGYFYgwc
X-IronPort-AV: E=Sophos;i="4.75,637,1330923600"; 
   d="scan'208";a="213655777"
Date: Fri, 25 Jan 2013 09:49:53 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [tracepoint] cargo-culting considered harmful...
Message-ID: <20130125144953.GB20597@Krystal>
References: <20130123225523.GY4939@ZenIV.linux.org.uk>
 <20130123155147.25fe49a2.akpm@linux-foundation.org>
 <20130124014840.GA4503@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20130124014840.GA4503@ZenIV.linux.org.uk>
X-Editor: vi
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Al Viro (viro@ZenIV.linux.org.uk) wrote:
> On Wed, Jan 23, 2013 at 03:51:47PM -0800, Andrew Morton wrote:
> 
> > > note that
> > > 	* file->f_path is already pinned down by open(), path_get() does not
> > > provide anything extra.
> > > 	* file->f_path.dentry is already pinned by open() *and* path_get()
> > > just above that dget().
> > > 	* ->d_name.name *IS* *NOT* *PROTECTED* by pinning dentry down,
> > > whether it's done once or thrice.
> > 
> > I guess the first two are obvious (or at least, expected).  But the
> > third isn't.

Hi Al,

I agree that the tracepoint example should be removed. There is one
extra piece of module code I think would require fixing (see below).

> 
> ->d_name.name is changed by rename() (as one could expect).  Grabbing
> a reference to dentry will not prevent rename() from happening.  ->i_mutex
> on parent will, but you either need to play with retries (grab reference
> to parent, grab ->i_mutex, check that it's still our parent, if we'd lost
> the race and someone had renamed the sucker - unlock ->i_mutex, dput,
> repeat) *or* to have our dentry looked up with parent locked, with ->i_mutex
> on said parent still held (which happens to cover the majority of valid
> uses in fs code - ->lookup(), ->create(), ->unlink(), rename(), etc. are
> all called that way, so the name of dentry passed to such methods is stable
> for the duration of the method).
> 
> ->d_lock on dentry is also sufficient, but that obviously means that you
> can't block while holding it.
> 
> > Where should a kernel developer go to learn these things? 
> > include/linux/dcache.h doesn't mention d_name locking rules, nor does
> > Documentation/filesystems/vfs.txt.
> 
> See directory locking rules in there; the crucial point is that dentry
> name is changed by rename() *and* that results of a race can be worse than
> just running into a partially rewritten name - long names are allocated
> separately and walking through a stale pointer you might end up in freed
> memory.
> 
> It's a mess, unfortunately, and $BIGNUM other uses of ->i_mutex make it only
> nastier.  Once in a while I go hunting for races in that area, usally with
> a bunch of fixes coming out of such run ;-/

In the light of what you are saying here, am I right to think that the
following code is broken wrt locking wrt use of
filp->f_dentry->d_name.name ?

static
void lttng_enumerate_task_fd(struct lttng_session *session,
                struct task_struct *p, char *tmp)
{
        struct fdtable *fdt;
        struct file *filp;
        unsigned int i;
        const unsigned char *path;

        task_lock(p);
        if (!p->files)
                goto unlock_task;
        spin_lock(&p->files->file_lock);
        fdt = files_fdtable(p->files);
        for (i = 0; i < fdt->max_fds; i++) {
                filp = fcheck_files(p->files, i);
                if (!filp)
                        continue;
                path = d_path(&filp->f_path, tmp, PAGE_SIZE);
                /* Make sure we give at least some info */
                trace_lttng_statedump_file_descriptor(session, p, i,
                        IS_ERR(path) ?
                                filp->f_dentry->d_name.name :
                                path);
        }
        spin_unlock(&p->files->file_lock);
unlock_task:
        task_unlock(p);
}

Since tracepoints never block, holding the ->d_lock around the
trace_lttng_statedump_file_descriptor() tracepoint should probably be
enough to make it correct. Am I missing anything ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
