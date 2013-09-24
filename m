Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125Ab3IXJFy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 05:05:54 -0400
Received: from mail-bk0-f48.google.com ([209.85.214.48]:35392 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942Ab3IXJFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 05:05:49 -0400
Message-ID: <524155E4.9040501@colorfullife.com>
Date: Tue, 24 Sep 2013 11:05:40 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Davidlohr Bueso <davidlohr@hp.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Paris <eparis@parisplace.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <james.l.morris@oracle.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH 0/4] ipc: shm and msg fixes
References: <1379300677-24188-1-git-send-email-davidlohr@hp.com> <1379625742.2145.19.camel@buesod1.americas.hpqcorp.net> <1379700524.5434.22.camel@flatline.rdu.redhat.com> <1379788235.2145.48.camel@buesod1.americas.hpqcorp.net> <CA+55aFwQp6Fm9-Zrn3uue9bFe9tERCbVv5Z-z9r4ZgOmS0VB+Q@mail.gmail.com> <1379918525.2231.0.camel@buesod1.americas.hpqcorp.net> <CA+55aFzVnivKb=nwzeTjGvi=LvnBLGnr=NZE+Ns6kLSm=WCN4w@mail.gmail.com> <1379981085.2060.18.camel@buesod1.americas.hpqcorp.net>
In-Reply-To: <1379981085.2060.18.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

On 09/24/2013 02:04 AM, Davidlohr Bueso wrote:
>> (In reality, I suspect the reference count is never elevated in
>> practice, so there is only one case that calls the security freeing
>> thing, so this may all be pretty much theoretical, but at least from a
>> logic standpoint the code clearly makes a big deal about the whole
>> refcount and "last user turns off the lights").
> Right, this would/should have come up years ago if it were actually
> occurring in practice.

As far as I see, the only requirement is "last user does kfree()":
spin_lock must be possible and perm.deleted must be valid.

e.g. from msg.c:
>                 rcu_read_lock();
>                 ipc_lock_object(&msq->q_perm);
>
>                 ipc_rcu_putref(msq);
>                 if (msq->q_perm.deleted) {
>                         err = -EIDRM;
>                         goto out_unlock0;
>                 }



> 8<-----------------------------------------
> From: Davidlohr Bueso <davidlohr@hp.com>
> Subject: [PATCH] ipc: fix race with LSMs
>
> Currently, IPC mechanisms do security and auditing related checks under
> RCU. However, since security modules can free the security structure, for
> example, through selinux_[sem,msg_queue,shm]_free_security(), we can race
> if the structure is freed before other tasks are done with it, creating a
> use-after-free condition. Manfred illustrates this nicely, for instance with
> shared mem and selinux:
>
> --> do_shmat calls rcu_read_lock()
> --> do_shmat calls shm_object_check().
>       Checks that the object is still valid - but doesn't acquire any locks.
>       Then it returns.
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
> This patch delays the freeing of the security structures after all RCU readers
> are done. Furthermore it aligns the security life cycle with that of the rest of
> IPC - freeing them based on the reference counter. For situations where we need
> not free security, the current behavior is kept. Linus states:
>
> "... the old behavior was suspect for another reason too: having
> the security blob go away from under a user sounds like it could cause
> various other problems anyway, so I think the old code was at least
> _prone_ to bugs even if it didn't have catastrophic behavior."
>
> I have tested this patch with IPC testcases from LTP on both my quad-core
> laptop and on a 64 core NUMA server. In both cases selinux is enabled, and
> tests pass for both voluntary and forced preemption models. While the mentioned
> races are theoretical (at least no one as reported them), I wanted to make
> sure that this new logic doesn't break anything we weren't aware of.
>
> Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>

