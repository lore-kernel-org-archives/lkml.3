Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399Ab3ITSQj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 14:16:39 -0400
Received: from mail-ye0-f178.google.com ([209.85.213.178]:49242 "EHLO
	mail-ye0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753072Ab3ITSQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 14:16:38 -0400
Message-ID: <1379700524.5434.22.camel@flatline.rdu.redhat.com>
Subject: Re: [PATCH 0/4] ipc: shm and msg fixes
From: Eric Paris <eparis@parisplace.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Manfred Spraul <manfred@colorfullife.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Mike Galbraith <efault@gmx.de>,
        sedat.dilek@gmail.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <james.l.morris@oracle.com>,
        linux-security-module@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>
Date: Fri, 20 Sep 2013 14:08:44 -0400
In-Reply-To: <1379625742.2145.19.camel@buesod1.americas.hpqcorp.net>
References: <1379300677-24188-1-git-send-email-davidlohr@hp.com>
	 <1379625742.2145.19.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-09-19 at 14:22 -0700, Davidlohr Bueso wrote:
> On Sun, 2013-09-15 at 20:04 -0700, Davidlohr Bueso wrote:
> > This patchset deals with the selinux and rmid races Manfred found on
> > the ipc scaling work that has been going on. It specifically addresses
> > shared mem and msg queues. While semaphores still need updated, I want
> > to make sure these are correct first. Also, Manfred had already sent out
> > a patchset that deals with a race in sem complex operations. So any changes
> > should be on top of his.
> > 
> > Patches 1 and 2 deal with shared memory.
> > Patches 3 and 4 deal with msg queues.
> > Specific details about each race and its fix are in the corresponding
> > patches.
> > 
> > Note that Linus suggested a good alternative to patches 1 and 3: use
> > kfree_rcu() and delay the freeing of the security structure. I would
> > much prefer that approach to doing security checks with the lock held,
> > but I want to leave the patches out and ready in case we go with the
> > later solution.
> 
> Cc'ing selinux/security people - folks, could you please confirm that
> this change is ok and won't break anything related to security?

I agree with the approach to delay the freeing and it does not appear to
be a problem from an SELinux PoV, but I don't necessarily agree with the
location of the delay.  Why should every LSM be required to know the
details of that object lifetime?  It seems to me like we might want to
move this delay up to shm_destroy.  I know that's going to be more code
then using kfree_rcu(), but it seems like a much better abstraction to
hide that knowledge away from the LSM.

Possibly place the rcu_head in struct kern_ipc_perm?  Then use
call_rcu() to call the security destroy hook?  You'll have to re-write
to LSM hook to take an rcu_head, etc, but that shouldn't be a big
problem.

Doing it this way, also means you won't break the security model of
SMACK.  It looks like you'd still have the exact same race with SMACK,
except they can't be fixed with kfree_rcu().  They are just setting a
pointer to NULL.  Which could then be dereferenced later.  They don't
actually do allocation/free.

So ACK on the RCU delay, but NACK to making the hooks do the delay,
instead do it in the IPC code.

> 
> Thanks!
> 
> 
> 8<-------------------------------------------
> 
> From: Davidlohr Bueso <davidlohr@hp.com>
> Date: Thu, 19 Sep 2013 09:32:05 -0700
> Subject: [PATCH] selinux: rely on rcu to free ipc isec
> 
> Currently, IPC mechanisms do security and auditing related checks under
> RCU. However, since selinux can free the security structure, through
> selinux_[sem,msg_queue,shm]_free_security(), we can race if the structure
> is freed before other tasks are done with it, creating a use-after-free
> condition. Manfred illustrates this nicely, for example with shared mem:
> 
> --> do_shmat calls rcu_read_lock()
> --> do_shmat calls shm_object_check().
>      Checks that the object is still valid - but doesn't acquire any locks.
>      Then it returns.
> --> do_shmat calls security_shm_shmat (e.g. selinux_shm_shmat)
> --> selinux_shm_shmat calls ipc_has_perm()
> --> ipc_has_perm accesses ipc_perms->security
> 
> shm_close()
> --> shm_close acquires rw_mutex & shm_lock
> --> shm_close calls shm_destroy
> --> shm_destroy calls security_shm_free (e.g. selinux_shm_free_security)
> --> selinux_shm_free_security calls ipc_free_security(&shp->shm_perm)
> --> ipc_free_security calls kfree(ipc_perms->security)
> 
> There are two solutions to this: (i) perform the security checking and whatever
> IPC operation(s) atomically (that is, with the kern_ipc_perm.lock held), or
> (ii) delay the freeing of the isec structure after all RCU readers are done.
> This patch takes the second approach, which, at least from a performance perspective,
> is more practical than the first as it keeps the IPC critical regions smaller.
> 
> I have tested this patch with IPC testcases from LTP on both my quad-core
> laptop and on a 64 core NUMA server. In both cases selinux is enabled, and
> tests pass for both voluntary and forced preemption models.
> 
> Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
> ---
>  security/selinux/hooks.c          | 9 ++++++++-
>  security/selinux/include/objsec.h | 5 +++--
>  2 files changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index a5091ec..179ffe9 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -4892,8 +4892,15 @@ static int ipc_alloc_security(struct task_struct *task,
>  static void ipc_free_security(struct kern_ipc_perm *perm)
>  {
>  	struct ipc_security_struct *isec = perm->security;
> +
> +	/*
> +	 * All IPC mechanisms do security and audit
> +	 * checking under RCU: wait a grace period before
> +	 * freeing isec, otherwise we can run into a
> +	 * use-after-free scenario.
> +	 */
> +	kfree_rcu(isec, rcu);
>  	perm->security = NULL;
> -	kfree(isec);
>  }
>  
>  static int msg_msg_alloc_security(struct msg_msg *msg)
> diff --git a/security/selinux/include/objsec.h b/security/selinux/include/objsec.h
> index aa47bca..38d17b7 100644
> --- a/security/selinux/include/objsec.h
> +++ b/security/selinux/include/objsec.h
> @@ -70,8 +70,9 @@ struct msg_security_struct {
>  };
>  
>  struct ipc_security_struct {
> -	u16 sclass;	/* security class of this object */
> -	u32 sid;	/* SID of IPC resource */
> +	u16 sclass;	     /* security class of this object */
> +	u32 sid;             /* SID of IPC resource */
> +	struct rcu_head	rcu; /* rcu struct for selinux based IPC security */
>  };
>  
>  struct netif_security_struct {


