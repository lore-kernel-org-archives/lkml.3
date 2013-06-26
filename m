Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563Ab3FZQCF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 12:02:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34907 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751912Ab3FZQBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 12:01:53 -0400
Date: Wed, 26 Jun 2013 17:57:28 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: Expose /proc/<pid>/task/<tid>/children
	unconditionally
Message-ID: <20130626155728.GA2141@redhat.com>
References: <0e00e9073855c02a382d49ba1ede9c4fda3451b7.1372189875.git.luto@amacapital.net> <20130625201602.GB1726@moon> <20130625201705.GA15966@redhat.com> <CALCETrVxm2wHvLgexG6fZO+h1rNHC_qDCv6B+4XuANHgSQU4iw@mail.gmail.com> <20130625215247.GC1726@moon> <CALCETrV2WZ3m82D4THfxvmASW8AOf1SN7Pu14vE0jMORupO5xw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrV2WZ3m82D4THfxvmASW8AOf1SN7Pu14vE0jMORupO5xw@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25, Andy Lutomirski wrote:
>
> On Tue, Jun 25, 2013 at 2:52 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> > On Tue, Jun 25, 2013 at 02:36:31PM -0700, Andy Lutomirski wrote:
> >> On Tue, Jun 25, 2013 at 1:17 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> >> > On 06/26, Cyrill Gorcunov wrote:
> >> >>
> >> >> On Tue, Jun 25, 2013 at 12:51:45PM -0700, Andy Lutomirski wrote:
> >> >> > This is currently only available if CONFIG_CHECKPOINT_RESTORE, which
> >> >> > is hidden under CONFIG_EXPERT.  It's generally useful functionality,
> >> >> > though, so expose it unconditionally.
> >> >> >
> >> >> > Cc: Cyrill Gorcunov <gorcunov@openvz.org>
> >> >> > Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> >> >> Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
> >> >
> >> > I didn't see the patch but I guess it is trivial and I agree with intent ;)
> >>
> >> The patch works, but "children" is only listed under task/<tid>, not
> >> under /proc/<pid>.  Is that intentional?  Fixing it would be a
> >> one-liner.
> >
> > Yeah, it's intentional. Here some explanations from Oleg (check out
> > the whole thread, it's not that big https://lkml.org/lkml/2011/12/9/220)
> > in short this might require some more code, but i'll re-check tomorrow.
>
> This is a little strange.  It looks like ppid (in status) shows the
> tgid,

Yes,

> but the actual real_parent can refer to a thread (as opposed to
> a thread group leader),

Yes.

This is mostly the internal implementation detail. And probably it
would be nice to move ->children from task_struct to signal_struct.

However. See __WNOTHREAD in man waitpid. I think this is the only
(historical) reason. Otherwise the real_parent's tid doesn't matter,
the parent is always the whole process, not sub-thread.

> and task/tid/children respects that.

Well, it should respect if you want to restart and keep __WNOTHREAD
working.

But there is another reason. It is not trivial to list all children
under /proc/<pid>, and the fix would not be a one-liner ;) You need
to fight with the exiting sub-threads and reparenting. 

> So the
> tree that you get by following task/tid/ children won't be quite the
> same as the tree you get by following ppid.

Not sure I understand... but in any case, yes you need to read
/proc/pid/task/*/children to construct the tree.

> I wonder if the ptid should be added to status.  Is there anything
> (other than task/tid/children)

Perhaps, I dunno.

Better yet, we should kill __WNOTHREAD ;) I am wondering if it is still
used.

Oleg.

