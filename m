Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751746AbaANUM7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 15:12:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60207 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751472AbaANUM4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 15:12:56 -0500
Date: Tue, 14 Jan 2014 21:13:11 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Will Drewry <wad@chromium.org>
Cc: linux-kernel@vger.kernel.org, nschichan@freebox.fr, keescook@chromium.org,
        james.l.morris@oracle.com, akpm@linux-foundation.org, holt@sgi.com,
        viro@zeniv.linux.org.uk
Subject: Re: [PATCH 2/2] sys, seccomp: add PR_SECCOMP_EXT and
	SECCOMP_EXT_ACT_TSYNC
Message-ID: <20140114201311.GA1259@redhat.com>
References: <1389645028-17157-1-git-send-email-wad@chromium.org> <1389645028-17157-2-git-send-email-wad@chromium.org> <20140114192118.GA31411@redhat.com> <20140114200240.GA801@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140114200240.GA801@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14, Oleg Nesterov wrote:
>
> On 01/14, Oleg Nesterov wrote:
> >
> > > +			get_seccomp_filter(caller);
> > > +			/*
> > > +			 * Drop the task reference to the shared ancestor since
> > > +			 * current's path will hold a reference.  (This also
> > > +			 * allows a put before the assignment.)
> > > +			 */
> > > +			put_seccomp_filter(thread);
> > > +			thread->seccomp.filter = caller->seccomp.filter;
> >
> > As I said, I do not understand this patch yet, but this looks suspicious.
> >
> > Why we can't race with this thread doing clone(CLONE_THREAD) ? We do
> > not the the new thread yet, but its ->seccomp can be already copied
> > by copy_process(), no?
>
> And it seems that this can obviously race with seccomp_attach_filter()
> called by this "thread".

Heh. I just noticed that this patch is not first in series, and I wasn't
cc'ed. I found this one on marc.info,

	http://marc.info/?l=linux-kernel&m=138964557211277

this explains task_lock(). But this can't fix the race with copy_process,
and the patch itself doesn't look right... if nothing else, we can't do
copy_from_user() under task_lock().

Oleg.

