Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751133Ab3CISuP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 13:50:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7424 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750798Ab3CISuN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 13:50:13 -0500
Date: Sat, 9 Mar 2013 19:48:08 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Neil Horman <nhorman@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Tejun Heo <tj@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] coredump: introduce dump_interrupted()
Message-ID: <20130309184808.GA778@redhat.com>
References: <20130308175852.GA26300@redhat.com> <20130308175915.GA26322@redhat.com> <CACBanvqn=fmcBcWDKoL+oQ==n4JHhsxHSiEw7UY8S=V_Q59b+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACBanvqn=fmcBcWDKoL+oQ==n4JHhsxHSiEw7UY8S=V_Q59b+g@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08, Mandeep Singh Baines wrote:
>
> On Fri, Mar 8, 2013 at 9:59 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> > By discussion with Mandeep Singh Baines <msb@chromium.org>.
> >
> > Change dump_write(), dump_seek() and do_coredump() to check
> > signal_pending() and abort if it is true.
> >
> > We add the new trivial helper, dump_interrupted(), to document that
> > this probably needs more work and to simplify the potential freezer
> > changes. Perhaps it will have more callers.
> >
> > Ideally it should do try_to_freeze() but then we need the unpleasant
> > changes in dump_write() and wait_for_dump_helpers(). So far we simply
> > accept the fact that the freezer can truncate a core-dump but at least
> > you can reliably suspend.
> >
> > Signed-off-by: Oleg Nesterov <oleg@redhat.com>
>
> Acked-by: Mandeep Singh Baines <msb@chromium.org>

Thanks!

> dump_write aborts anyway in the pipe case. pipe_wait is interruptible
> and should return -ERESTARTSYS if there is a signal pending.

Yes,

> But I guess there is no signal pending check in the disk write path.
> So this allows you to bail out early and unblock suspend instead of
> trying to write out all the vmas to a slow disk.

Exactly.

And, please do not forget, we want to bail out even without suspend.
Someone told me they had to reboot the machine because they could not
interrupt the huge coredump on the slow media.

> You may want to consider just checking dump_interrupted() at the very
> top of the functions instead.

What do you mean?

dump_write/seek check it at the start. Probably dump_seek() should do
this unconditionally (with this patch the non-llseek case relies on
dump_write), I am fine either way.

Oleg.

