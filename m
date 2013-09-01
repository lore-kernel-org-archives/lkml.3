Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757496Ab3IAWsF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 18:48:05 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:49850 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754764Ab3IAWsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 18:48:03 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFzkZi6Q1bwSZUJxyfqUgLS05icjrObdCxC+4S-3Tup9Ew@mail.gmail.com>
References: <CA+icZUX3zQEWDoaXk0RMKmbQhDRo0Z7jGZ=9tJu1gZWvGodMkg@mail.gmail.com>
	<CA+icZUUDKExRW3iNXj6jTs8A4DwQNaWvPuUfV5_ExXNPzq=+rA@mail.gmail.com>
	<CA+55aFxvEjdEFK0dXn783eVN0PEXVhb5k8OnrbxSWDpXgyTwWw@mail.gmail.com>
	<CA+icZUXcn6-A+AW5bu_pfRdOcScsNyn3-OZe6n93S5NUEzHtcg@mail.gmail.com>
	<CA+55aFwHx=tCzdo50jJB0ey7-CTVSo6RRQHe6R9fAya7nPn00A@mail.gmail.com>
	<CA+icZUWmQHWHMr1symL7j0iYqUMJBiOuRJ=EJz4F-xkQtdnJLg@mail.gmail.com>
	<CA+55aFxwjx30pC=kcfvOzgJvt2KK9DLm2i6JKYYz+mtOOJEnMA@mail.gmail.com>
	<CA+icZUUwy=sbt6BOirH6N4mSrQOykb=Z3GSdCb7vy_eVfG2RYw@mail.gmail.com>
	<CA+55aFwU054C+zC+G+JrF4ngWvVmvD9WPGWaT_2=nF2j7bpHxA@mail.gmail.com>
	<CA+55aFyc17miqwhncAKsanPQ9fHX_czQx+g-a9At_S1-XNpyKA@mail.gmail.com>
	<20130901212355.GU13318@ZenIV.linux.org.uk>
	<CA+55aFzkZi6Q1bwSZUJxyfqUgLS05icjrObdCxC+4S-3Tup9Ew@mail.gmail.com>
Date: Sun, 1 Sep 2013 15:48:01 -0700
X-Google-Sender-Auth: K5SpVJ7GIuwSx890S1DMmp2fIF4
Message-ID: <CA+55aFzsXwFkYsWY45ZNTaVFC+-1Yh9nxx=NLhv+NxGmQAKHTg@mail.gmail.com>
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Sedat Dilek <sedat.dilek@gmail.com>, Waiman Long <waiman.long@hp.com>,
        Ingo Molnar <mingo@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jeff Layton <jlayton@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 1, 2013 at 3:16 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I wonder if there is some false sharing going on. But I don't see that
> either, this is the percpu offset map afaik:
>
>   000000000000f560 d files_lglock_lock
>   000000000000f564 d nr_dentry
>   000000000000f568 d last_ino
>   000000000000f56c d nr_unused
>   000000000000f570 d nr_inodes
>   000000000000f574 d vfsmount_lock_lock
>   000000000000f580 d bh_accounting

I made DEFINE_LGLOCK use DEFINE_PER_CPU_SHARED_ALIGNED for the
spinlock, so that each local lock gets its own cacheline, and the
total loops jumped to 62M (from 52-54M before). So when I looked at
the numbers, I thought "oh, that helped".

But then I looked closer, and realized that I just see a fair amount
of boot-to-boot variation anyway (probably a lot to do with cache
placement and how dentries got allocated etc). And it didn't actually
help at all, the problem is stilte there, and lg_local_lock is still
really really high on the profile, at 8% cpu time:

-   8.00%  lg_local_lock
   - lg_local_lock
      + 64.83% mntput_no_expire
      + 33.81% path_init
      + 0.78% mntput
      + 0.58% path_lookupat

which just looks insane. And no, no lg_global_lock visible anywhere..

So it's not false sharing. But something is bouncing *that* particular
lock around.

              Linus

---
  34.60%      lockref_get_or_lock
  23.35%      lockref_put_or_lock
  10.57%      dput
   8.00%      lg_local_lock
   1.79%      copy_user_enhanced_fast_string
   1.15%      link_path_walk
   1.04%      path_lookupat
   1.03%      sysret_check
   1.01%      kmem_cache_alloc
   1.00%      selinux_inode_permission
   0.97%      __d_lookup_rcu
   0.95%      kmem_cache_free
   0.90%      0x00007f03e0800ee3
   0.88%      avc_has_perm_noaudit
   0.79%      cp_new_stat
   0.76%      avc_has_perm_flags
   0.69%      path_init
   0.68%      getname_flags
   0.66%      system_call
   0.58%      generic_permission
   0.55%      lookup_fast
   0.54%      user_path_at_empty
   0.51%      vfs_fstatat
   0.49%      vfs_getattr
   0.49%      filename_lookup
   0.49%      strncpy_from_user
   0.44%      generic_fillattr
   0.40%      inode_has_perm.isra.32.constprop.61
   0.38%      ext4_getattr
   0.34%      complete_walk
   0.34%      lg_local_unlock
   0.27%      d_rcu_to_refcount
   0.25%      __inode_permission
   0.23%      _copy_to_user
   0.23%      security_inode_getattr
   0.22%      mntget
   0.22%      selinux_inode_getattr
   0.21%      SYSC_newstat
   0.21%      mntput_no_expire
   0.20%      putname
   0.17%      path_put
   0.16%      security_inode_permission
   0.16%      start_routine
   0.14%      mntput
   0.14%      final_putname
   0.14%      _cond_resched
   0.12%      inode_permission
   0.10%      user_path_at
   0.09%      __xstat64
   0.07%      sys_newstat
   0.03%      __xstat@plt
   0.03%      update_cfs_rq_blocked_load
   0.02%      task_tick_fair
   0.01%      common_interrupt
   0.01%      ktime_get
   0.01%      lapic_next_deadline
   0.01%      run_timer_softirq
   0.01%      hsw_unclaimed_reg_check.isra.6
   0.01%      sched_clock_cpu
   0.01%      rcu_check_callbacks
   0.01%      update_cfs_shares
   0.01%      _raw_spin_lock
   0.01%      irqtime_account_irq
   0.01%      __do_softirq
   0.01%      ret_from_sys_call
   0.01%      i915_read32
   0.01%      hrtimer_interrupt
   0.01%      update_curr
   0.01%      profile_tick
   0.00%      intel_pmu_disable_all
   0.00%      intel_pmu_enable_all
   0.00%      tg_load_down
   0.00%      native_sched_clock
   0.00%      native_apic_msr_eoi_write
   0.00%      irqtime_account_process_tick.isra.2
   0.00%      perf_event_task_tick
   0.00%      clockevents_program_event
   0.00%      __acct_update_integrals
   0.00%      rcu_irq_exit
