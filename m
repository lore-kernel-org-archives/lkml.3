Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859AbaGVUgT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 16:36:19 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:40261 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462AbaGVUgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 16:36:18 -0400
Date: Wed, 23 Jul 2014 00:36:14 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Julien Tinnes <jln@google.com>
Subject: Re: [RFC 2/2] prctl: PR_SET_MM -- Introduce PR_SET_MM_MAP operation
Message-ID: <20140722203614.GF838@moon>
References: <20140703143318.568554771@openvz.org>
 <20140703151102.842945837@openvz.org>
 <20140708190849.GC17860@moon.sw.swsoft.com>
 <20140708143830.ea078ef01e1d7d31276edbcd@linux-foundation.org>
 <20140708221336.GL17860@moon.sw.swsoft.com>
 <20140709141318.GM17860@moon.sw.swsoft.com>
 <CAGXu5jKmTSb0YmNFDtr-jymrhy_s_PXUuvj3WKYffSU98gwyqg@mail.gmail.com>
 <20140709150604.GN17860@moon.sw.swsoft.com>
 <20140711173625.GD19702@moon>
 <CAGXu5jL3exT4j+8rjMv1O54uJWQ5UHL69Z-24b61rhXROqZamQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jL3exT4j+8rjMv1O54uJWQ5UHL69Z-24b61rhXROqZamQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 01:07:51PM -0700, Kees Cook wrote:
> On Fri, Jul 11, 2014 at 10:36 AM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> > On Wed, Jul 09, 2014 at 07:06:04PM +0400, Cyrill Gorcunov wrote:
> >>
> >> Thanks a lot for comments, Kees! I tend to agre, leaving off the @prctl_map
> >> variable out of macros should make code also shorter, I'll update that's
> >> not the problem. Could you please re-check if I'm not missing something
> >> in security aspects when time permits.
> 
> I asked Julien (now in CC) into look at this with me, and he had
> several comments that I've paraphrased/expanded on below...

Thanks a huge, Kees!

> >  - @exe_fd is referred from /proc/$pid/exe and when generating
> >    coredump. We uses prctl_set_mm_exe_file_locked helper to update
> >    this member, so exe-file link modification remains one-shot
> >    action.
> 
> Controlling exe_fd without privileges may turn out to be dangerous. At
> least things like tomoyo examine it for making policy decisions (see
> tomoyo_manager()).

OK, so if we worry about this that much -- what if I bring some sysctl
variable which would be able to turn this non-root functionality on
and off? In criu we would turn it off when start restoring (with
root privilegues of course) and the once restore is complete we
turn it off back? Sounds reasonable? (I still personally think this
@exe_fd is just a hint and as I mentioned if we have ptrace/preload
rights there damn a lot of ways to inject own code into any program
so that a user won't even notice ;)

> > +       /*
> > +        * Neither we should allow to override limits if they set.
> > +        */
> > +       rlim = rlimit(RLIMIT_DATA);
> > +       if (rlim < RLIM_INFINITY) {
> > +               if ((prctl_map->brk - prctl_map->start_brk) +
> > +                   (prctl_map->end_data - prctl_map->start_data) > rlim)
> > +                       goto out;
> > +       }
> 
> I think this has an integer overflow in it. This could be avoided by
> checking brk vs start_brk with an additional __prctl_check_order call.
> This is done for start_data and end_data already.

Thanks, will update.

> > +       rlim = rlimit(RLIMIT_STACK);
> > +       if (rlim < RLIM_INFINITY) {
> > +#ifdef CONFIG_STACK_GROWSUP
> > +               unsigned long left = stack_vma->vm_end - prctl_map->start_stack;
> > +#else
> > +               unsigned long left = prctl_map->start_stack - stack_vma->vm_start;
> > +#endif
> > +               if (left > rlim)
> > +                       goto out;
> > +       }
> 
> There should be a  __prctl_check_order for stack_start vs
> stack_vma->vm_end (and another in the stack growsdown case).

Sure, thanks!

> > +       if (prctl_map.auxv && prctl_map.auxv_size) {
> > +               up_read(&mm->mmap_sem);
> > +               memset(user_auxv, 0, sizeof(user_auxv));
> > +               error = copy_from_user(user_auxv,
> > +                                      (const void __user *)prctl_map.auxv,
> > +                                      prctl_map.auxv_size);
> > +               down_read(&mm->mmap_sem);
> > +               if (error)
> > +                       goto out;
> > +       }
> 
> "prctl_map.auxv" should be removed from this if condition (i.e. make
> sure any auxv_size does, in fact, attempt to write to the .auxv
> location).

Hmm, why? Only having two variables valid we can be sure the copy_from_user
is proper to call. You propose to make it as

	if (prctl_map.auxv_size) {
		...
		copy_from_user(user_auxv,

? Or I misunderstand you?

> > +
> > +       if (prctl_map.exe_fd != (u32)-1) {
> > +               error = prctl_set_mm_exe_file_locked(mm, prctl_map.exe_fd);
> > +               if (error)
> > +                       goto out;
> > +       }
> > +
> > +       if (prctl_map.auxv && prctl_map.auxv_size) {
> > +               user_auxv[AT_VECTOR_SIZE - 2] = 0;
> > +               user_auxv[AT_VECTOR_SIZE - 1] = 0;
> > +
> > +               task_lock(current);
> > +               memcpy(mm->saved_auxv, user_auxv, sizeof(user_auxv));
> > +               task_unlock(current);
> > +       }
> 
> This auxv if should probably be consolidated with the first one. And
> it may be worthwhile to mention this is making sure AT_NULL is at the
> end.

As to AT_NULL -- sure, I'll update (0 is the same as AT_NULL iirc,
so I'm sorry to not making it explicit). As to consolidation -- no.

Look, the whole idea is to modify real current->mm if and only if
everything else won't fail so I splitted it as

 1) validate_prctl_map_locked to make sure all members we're
    going to use are valid
 2) copy auxv vector -- if we fail here, we can exit safely
    leaving current->mm completely untouched
 3) setup new exe_fd, again if we fail here current->mm remains
    untouched
 4) finally we can modify current->mm because no error can happen
    here

> > +
> > +       mm->start_code  = prctl_map.start_code;
> > +       mm->end_code    = prctl_map.end_code;
> > +       mm->start_data  = prctl_map.start_data;
> > +       mm->end_data    = prctl_map.end_data;
> > +       mm->start_brk   = prctl_map.start_brk;
> > +       mm->brk         = prctl_map.brk;
> > +       mm->start_stack = prctl_map.start_stack;
> > +       mm->arg_start   = prctl_map.arg_start;
> > +       mm->arg_end     = prctl_map.arg_end;
> > +       mm->env_start   = prctl_map.env_start;
> > +       mm->env_end     = prctl_map.env_end;
> > +
> > +       error = 0;
> > +out:
> > +       up_read(&mm->mmap_sem);
> > +       return error;
> > +}
> > +#endif /* CONFIG_CHECKPOINT_RESTORE */
> 
> To avoid future errors, the rlimit checks should probably go into some
> common place, so that the same functions are called during rlimit
> checks when "classic" modification of fields such as ->brk happen (for
> instance in sys_brk).

OK, I'll take a look, this will require one more patch but I hope
we're fine with that.

Thanks a lot for comments!
