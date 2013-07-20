Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab3GTQqt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 12:46:49 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:21650 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754397Ab3GTQqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 12:46:48 -0400
Message-ID: <1374338805.2184.3.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [ipc,shm] BUG: lock held when returning to user space!
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: Xiaotian Feng <xtfeng@gmail.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Sasha Levin <sasha.levin@oracle.com>
Date: Sat, 20 Jul 2013 09:46:45 -0700
In-Reply-To: <CAJn8CcFhsTjA1swBu6V0CUED6X9Ty1Y_zxv37iqOR44vkxDUtA@mail.gmail.com>
References: <20130720131343.GB13893@localhost>
	 <CAJn8CcFhsTjA1swBu6V0CUED6X9Ty1Y_zxv37iqOR44vkxDUtA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-07-21 at 00:02 +0800, Xiaotian Feng wrote:
> On Sat, Jul 20, 2013 at 9:13 PM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> > Greetings,
> >
> > I got the below dmesg and the first bad commit is
> >
> > commit c5d0282a0405b0a81fa3390e4230e4cbb3ced7a2
> > Author: Davidlohr Bueso <davidlohr.bueso@hp.com>
> > Date:   Fri Jul 19 09:56:58 2013 +1000
> >
> >     ipc,shm: shorten critical region for shmat
> >
> >     Similar to other system calls, acquire the kern_ipc_perm lock after doing
> >     the initial permission and security checks.
> >
> >     Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
> >     Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
> >     Cc: Rik van Riel <riel@redhat.com>
> >     Cc: Manfred Spraul <manfred@colorfullife.com>
> >     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> >
> > [   20.702156]
> > [   20.702493] ================================================
> > [   20.703511] [ BUG: lock held when returning to user space! ]
> > [   20.704532] 3.11.0-rc1-next-20130719 #50 Not tainted
> > [   20.705416] ------------------------------------------------
> > [   20.706425] trinity-child0/174 is leaving the kernel with locks still held!
> > [   20.707638] 1 lock held by trinity-child0/174:
> > [   20.708475]  #0:  (rcu_read_lock){.+.+..}, at: [<ffffffff814a8491>] do_shmat+0xe1/0x500
> >
> 
> ----
> ns = current->nsproxy->ipc_ns;
> - shp = shm_lock_check(ns, shmid);
> + rcu_read_lock();
> + shp = shm_obtain_object_check(ns, shmid);
> if (IS_ERR(shp)) {
> err = PTR_ERR(shp);
> goto out;
> ----
> 
> If shm_obtain_object_check() failed, goto out will return with
> rcu_read_lock() held.  I think following patch should cure this.

Yep that should solve it, sorry about that. Sasha Levin sent out a fix
for it yesterday (offline).

Thanks,
Davidlohr

> 
> diff --git a/ipc/shm.c b/ipc/shm.c
> index 59f2194..cb2ceda 100644
> --- a/ipc/shm.c
> +++ b/ipc/shm.c
> @@ -1093,7 +1093,7 @@ long do_shmat(int shmid, char __user *shmaddr,
> int shmflg, ulong *raddr,
>   shp = shm_obtain_object_check(ns, shmid);
>   if (IS_ERR(shp)) {
>   err = PTR_ERR(shp);
> - goto out;
> + goto out_unlock;
>   }
> 
>   err = -EACCES;
> 
> 
> 
> 
> > git bisect start c1f631b9a68251007a6353041ae90f9f7dca771c d03792f9db9b892f494d3aa19d767ddf0365d1ff --
> > git bisect good 10a3f1f902465ae1320cc95a3284fd3697e05dd8  # 11:14     65+  binfmt_elf.c: use get_random_int() to fix entropy depleting
> > git bisect  bad dac28788378838efb63e37a7eabd7729d97aba6b  # 11:32      0-  dcache: remove dentries from LRU before putting on dispose list
> > git bisect good 3140b2ed6dfe5c9e5eca371c77ca85dca05321d4  # 11:50     65+  ipc,shm: introduce shmctl_nolock
> > git bisect  bad 48a91248649fa3327bd8a31c114ee9149a07f3a7  # 12:04      0-  staging/lustre/ldlm: convert to shrinkers to count/scan API
> > git bisect good 98b78126a51aa5d3ee6d5dae5768e0d16deeeaa3  # 12:14     65+  ipc,shm: cleanup do_shmat pasta
> > git bisect  bad 36ccfd799cad33e2edd5c14ac8776b33e63d195b  # 12:14      0-  ipc: rename ids->rw_mutex
> > git bisect  bad c5d0282a0405b0a81fa3390e4230e4cbb3ced7a2  # 12:14      0-  ipc,shm: shorten critical region for shmat
> > git bisect good 98b78126a51aa5d3ee6d5dae5768e0d16deeeaa3  # 15:34    195+  ipc,shm: cleanup do_shmat pasta
> > git bisect  bad c1f631b9a68251007a6353041ae90f9f7dca771c  # 15:34      0-  Add linux-next specific files for 20130719
> > git bisect good 709b465ee655387c4ec056383fa27f16c64f48db  # 18:21    195+  Revert "ipc,shm: shorten critical region for shmat"
> > git bisect good d471ce53b1fab60110e4e9f647a345cea31752de  # 18:44    195+  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/rw/uml
> > git bisect  bad c1f631b9a68251007a6353041ae90f9f7dca771c  # 18:44      0-  Add linux-next specific files for 20130719
> >
> > Thanks,
> > Fengguang


