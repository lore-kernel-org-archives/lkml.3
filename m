Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568Ab3LUS0R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 13:26:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14020 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754507Ab3LUS0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 13:26:16 -0500
Date: Sat, 21 Dec 2013 19:27:04 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: naveen yadav <yad.naveen@gmail.com>,
        Vaibhav Shinde <v.bhav.shinde@gmail.com>,
        Ajeet Yadav <ajeet.yadav.77@gmail.com>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] secure unlock_task_sighand() call
Message-ID: <20131221182703.GA11516@redhat.com>
References: <CAJ8eaTzkKtwM2Xvw_GYRrefUVJg0uzaqFNPJcNc_ffSayQiDUA@mail.gmail.com> <CA+55aFyVrrvDzUt0OU4d9YZM8C-N+ycSKEa3+-5nowUoZ=rb8w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyVrrvDzUt0OU4d9YZM8C-N+ycSKEa3+-5nowUoZ=rb8w@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21, Linus Torvalds wrote:
>
> We have coredump serialization in exit_mm() that I think *should* make
> this all ok - if we still see p->mm matching our mm,

Yes. And the comment says:

	lock_task_sighand(p)
	must be used. Since p->mm != NULL and we hold ->mmap_sem
	it can't fail.

IOW, this task can't pass exit_mm() and thus lock_task_sighand() can't
fail.

> >                 do {
> >                         if (p->mm) {
> >                                 if (unlikely(p->mm == mm)) {
> > -                                       lock_task_sighand(p, &flags);
> > -                                       nr += zap_process(p, exit_code);
> > -                                       unlock_task_sighand(p, &flags);
> > +                                       if (lock_task_sighand(p, &flags) {
> > +                                               nr += zap_process(p, exit_code);
> > +                                               unlock_task_sighand(p, &flags);
> > +                                       }

I too do not think this is needed. But perhaps BUG_ON() make sense.

Note: just in case, this has another problem: while_each_thread() is racy.
We already have the initial fixes in -mm, this code (as other users)
should be converted to use for_each_thread(), I'll send the patch(es).

Oleg.

