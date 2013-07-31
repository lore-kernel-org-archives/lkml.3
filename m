Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759238Ab3GaMLY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 08:11:24 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:51405 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751360Ab3GaMLV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 08:11:21 -0400
Date: Wed, 31 Jul 2013 08:10:52 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Li Zefan <lizefan@huawei.com>,
        Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        cgroups@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kent.overstreet@gmail.com,
        Glauber Costa <glommer@gmail.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: memcg creates an unkillable task in 3.11-rc2
Message-ID: <20130731121052.GK715@cmpxchg.org>
References: <20130729075939.GA4678@dhcp22.suse.cz>
 <87ehahg312.fsf@xmission.com>
 <20130729095109.GB4678@dhcp22.suse.cz>
 <20130729161026.GD22605@mtj.dyndns.org>
 <87r4eh70yg.fsf@xmission.com>
 <51F71DE2.4020102@huawei.com>
 <87ppu0a298.fsf_-_@tw-ebiederman.twitter.com>
 <20130730123120.GA15847@dhcp22.suse.cz>
 <874nbc3sx1.fsf@tw-ebiederman.twitter.com>
 <20130731073726.GC30514@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130731073726.GC30514@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 09:37:26AM +0200, Michal Hocko wrote:
> [I am CCing David here as well]
> 
> On Tue 30-07-13 09:37:46, Eric W. Biederman wrote:
> > Michal Hocko <mhocko@suse.cz> writes:
> > 
> > > On Tue 30-07-13 01:19:31, Eric W. Biederman wrote:
> > > [...]
> > >> Hmm. Looking farther I see what is going on. And it has nothing to do
> > >> with the freezer. (I have commented out that code and reproduced it
> > >> without the freezer to be doubly certain).
> > >> 
> > >> 
> > >> On the exit path exit_robust_list is triggering a page fault to fault a
> > >> page back in.  Which since we have no memory causes the exit path
> > >> to get stuck in mem_cgroup_handle_oom.
> > >
> > > Hmm, interesting. I assume the exit is caused by the SIGKILL, right?
> > > If yes, then why it hasn't coughed early in __mem_cgroup_try_charge
> > 
> > Interesting question.  This isn't the primary thread but we do send
> > SIGKILL to the secondary threads as well.
> > 
> > We definitely need those checks on both paths making my change valid.
> > 
> > Oh. Duh!  This is after we act on SIGKILL so SIGKILL is no longer
> > pending.
> 
> Very well spotted Eric! What do you think about the following patch?
> I would have to check since when the exit path could trigger the fault
> but I guess this is worth stable backport.
> ---
> >From 411408558f2858328ea25e69567e9a53a8314032 Mon Sep 17 00:00:00 2001
> From: Michal Hocko <mhocko@suse.cz>
> Date: Wed, 31 Jul 2013 08:48:54 +0200
> Subject: [PATCH] memcg: Do not hang on OOM when killed by userspace OOM
> 
> Eric has reported that he can see task(s) stuck in memcg OOM handler
> regularly. The only way out is to
> 	echo 0 > $GROUP/memory.oom_controll
> 
> His usecase is:
> - Setup a hierarchy with memory and the freezer
>   (disable kernel oom and have a process watch for oom).
> - In that memory cgroup add a process with one thread per cpu.
> - In one thread slowly allocate once per second I think it is 16M of ram
>   and mlock and dirty it (just to force the pages into ram and stay there).
> - When oom is achieved loop:
>   * attempt to freeze all of the tasks.
>   * if frozen send every task SIGKILL, unfreeze, remove the directory in
>     cgroupfs.
> 
> Eric has then pinpointed the issue to be memcg specific.
> 
> All tasks are sitting on the memcg_oom_waitq when memcg oom is disabled.
> Those that have received fatal signal will bypass the charge and should
> continue on their way out. The tricky part is that that exit path might
> trigger a page fault (e.g. exit_robust_list) thus the memcg charge
> while its memcg is still under OOM because nobody has released any
> charges. Unlike with the in-kernel OOM handler the exiting task doesn't
> get TIF_MEMDIE set so it doesn't shortcut charges and falls to the
> memcg OOM again without any way out of it as there are no fatal signals
> pending anymore.
> 
> This patch sets the TIF_MEMDIE flag pro actively in mem_cgroup_handle_oom
> if the memcg is disabled after the task is woken up with fatal signal
> pending. This means that any further charges will be bypassed early in
> __mem_cgroup_try_charge and the task will have chance to exit finally.
> 
> Strictly speaking we might mark also a task which hasn't been killed by
> userspace OOM handler but this is not harmful as the task is going away
> anyway and under-oom group would like to see it go as soon as possible.
> 
> Reported-by: Eric W. Biederman <ebiederm@xmission.com>
> Debugged-by: Eric W. Biederman <ebiederm@xmission.com>
> Signed-off-by: Michal Hocko <mhocko@suse.cz>

Looks good to me, FWIW.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
