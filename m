Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391Ab3KNLjX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 06:39:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26972 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752887Ab3KNLjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 06:39:21 -0500
Date: Thu, 14 Nov 2013 12:40:39 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: zhang.yi20@zte.com.cn, linux-kernel@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: Re: kmod: avoid propagating PF_NO_SETAFFINITY into userspace child
Message-ID: <20131114114039.GA29277@redhat.com>
References: <OFC3933D9B.5510E97E-ON48257C23.0007B7CD-48257C23.000A4246@zte.com.cn> <20131114052326.GA29031@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131114052326.GA29031@mtj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14, Tejun Heo wrote:
>
> Hello,
>
> On Thu, Nov 14, 2013 at 09:51:47AM +0800, zhang.yi20@zte.com.cn wrote:
> > The kernel worker thread has the PF_NO_SETAFFINITY flag, and it is propagated
> > into the userspace child. Clearing this flag in usersapce child to enable its
> > migrating capability.
> >
> >
> > Signed-off-by: Zhang Yi <zhang.yi20@zte.com.cn>
> >
> > --- linux3-12/kernel/kmod.c	2013-11-14 09:06:58.991781656 +0000
> > +++ linux3-12/kernel/kmod.c	2013-11-14 09:08:47.511781621 +0000
> > @@ -217,6 +217,7 @@ static int ____call_usermodehelper(void
> >  	 * Avoid propagating that into the userspace child.
> >  	 */
> >  	set_user_nice(current, 0);
> > +	current->flags &= ~PF_NO_SETAFFINITY;
>
> I'm a bit confused.  kernel_thread() doesn't use workqueue or
> kthread_bind(),

Yes, but kernel_thread() is called by the worker thread which has
PF_NO_SETAFFINITY, this flag is copied to child->flags.

Looks like Zhang is right... But I'd suggest to change flush_old_exec()
instead (see "current->flags &= ...").

Oleg.

