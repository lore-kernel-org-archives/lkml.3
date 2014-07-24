Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934475AbaGXToo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 15:44:44 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:54244 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933784AbaGXTon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 15:44:43 -0400
Date: Thu, 24 Jul 2014 23:44:38 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michael Kerrisk-manpages <mtk.manpages@gmail.com>,
        Julien Tinnes <jln@google.com>
Subject: Re: [rfc 4/4] prctl: PR_SET_MM -- Introduce PR_SET_MM_MAP operation,
 v3
Message-ID: <20140724194438.GD17876@moon>
References: <20140724164657.452106845@openvz.org>
 <20140724165047.683455139@openvz.org>
 <CAGXu5jL9xMQ3G-pgVneUFqx=v6C7L0-7SBTJ0_bC2B5H0BfeDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jL9xMQ3G-pgVneUFqx=v6C7L0-7SBTJ0_bC2B5H0BfeDQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 12:31:54PM -0700, Kees Cook wrote:
...
> > +
> > +#ifdef CONFIG_STACK_GROWSUP
> > +       if (may_adjust_brk(rlimit(RLIMIT_STACK),
> > +                          stack_vma->vm_end,
> > +                          prctl_map->start_stack, 0, 0))
> > +#else
> > +       if (may_adjust_brk(rlimit(RLIMIT_STACK),
> > +                          prctl_map->start_stack,
> > +                          stack_vma->vm_start, 0, 0))
> > +#endif
> > +               goto out;
> 
> Ah! Sorry, I missed this use of may_adjust_brk here. Perhaps rename
> it, since we're not checking brk here, and pass the RLIMIT_* value to
> the function, which can look it up itself? "check_vma_rlimit" ?

Yeah, a name is a bit confusing, but I guess check_vma_rlimit() is not
much better ;-) What we do inside -- we test if a sum of two intervals
or arguments in this helper so that it won't care about the logical
context it been called from, but then realized that this would be a way
too much of unneeded complexity. So if noone else pop with better suggestion
on name i'll update it to check_vma_rlimit (because it's more general
in compare to may_adjust_brk :-).

> > +
> > +       /*
> > +        * Finally, make sure the caller has the rights to
> > +        * change /proc/pid/exe link: only local root should
> > +        * be allowed to.
> > +        */
> > +       if (prctl_map->exe_fd != (u32)-1) {
> > +               struct user_namespace *ns = current_user_ns();
> > +               const struct cred *cred = current_cred();
> > +
> > +               if (!uid_eq(cred->uid, make_kuid(ns, 0)) ||
> > +                   !gid_eq(cred->gid, make_kgid(ns, 0)))
> > +                       goto out;
> > +       }
> 
> I got tricked for a moment here. :) I see that even if we pass this
> check, prctl_set_mm_exe_file will still do the additional checks too
> during prctl_set_mm_map. Excellent!

Yeah.

> >
> > +#ifdef CONFIG_CHECKPOINT_RESTORE
> > +       if (opt == PR_SET_MM_MAP || opt == PR_SET_MM_MAP_SIZE)
> > +               return prctl_set_mm_map(opt, (const void __user *)addr, arg4);
> > +#endif
> > +
> >         if (!capable(CAP_SYS_RESOURCE))
> >                 return -EPERM;
> >
> >
> 
> I think this is looking good. Thanks for the refactoring!

Thanks a huge for comments!!!
