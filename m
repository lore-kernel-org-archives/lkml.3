Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143AbbATVGy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 16:06:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45338 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751649AbbATVGw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 16:06:52 -0500
Message-ID: <1421787995.18334.24.camel@localhost>
Subject: Re: [PATCH] Selinux/hooks.c: Fix a NULL pointer dereference caused
 by semop()
From: Eric Paris <eparis@redhat.com>
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Manfred Spraul <manfred@colorfullife.com>,
        Ethan Zhao <ethan.zhao@oracle.com>, james.l.morris@oracle.com,
        serge@hallyn.com, paul@paul-moore.com, ethan.kernel@gmail.conm,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        selinux@tycho.nsa.gov
Date: Tue, 20 Jan 2015 16:06:35 -0500
In-Reply-To: <54BEC23F.8020004@tycho.nsa.gov>
References: <1421745518-18790-1-git-send-email-ethan.zhao@oracle.com>
	 <54BE61F0.202@tycho.nsa.gov> <54BEA337.9060704@colorfullife.com>
	 <54BEC23F.8020004@tycho.nsa.gov>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What kernel version was this?  Didn't we have this problem and solve it
upstream some time ago? IPC could be allocated with a valid security
context, the ipc would be freed.  the isec was free'd syncronously, but
then the ipc could stick around until some rcu period or some usage flag
got to 0, then it got freed...

this seems so familiar, but it was a while ago

On Tue, 2015-01-20 at 16:01 -0500, Stephen Smalley wrote:
> On 01/20/2015 01:49 PM, Manfred Spraul wrote:
> > Hi,
> > 
> > On 01/20/2015 03:10 PM, Stephen Smalley wrote:
> >> On 01/20/2015 04:18 AM, Ethan Zhao wrote:
> >>> A NULL pointer dereference was observed as following panic:
> >>>
> >>> BUG: unable to handle kernel NULL pointer dereference at (null)
> >>> IP: [<ffffffff812735eb>] ipc_has_perm+0x4b/0x60
> >>> ...
> >>> Process opcmon (pid: 30712, threadinfo ffff880237f2a000,
> >>> task ffff88022ac70e40)
> >>> Stack:
> >>> ffff880237f2bc04 ffffffff01020953 ffff880237f2bce8
> >>> ffffffff8125818e
> >>> 0000000000000001 0000000037f78004 ffff880237f2bcd8
> >>> ffffffff81273619
> >>> ffff880237f2bce8 ffffffff8126e3e6 ffff880237f2bf68
> >>> ffffffff8125c206
> >>> Call Trace:
> >>> [<ffffffff8125818e>] ? ipcperms+0xae/0x110
> >>> [<ffffffff81273619>] selinux_sem_semop+0x19/0x20
> >>> [<ffffffff8126e3e6>] security_sem_semop+0x16/0x20
> >>> [<ffffffff8125c206>] sys_semtimedop+0x346/0x750
> >>> [<ffffffff81188c0c>] ? handle_pte_fault+0x1dc/0x200
> >>> [<ffffffff8161d830>] ? __do_page_fault+0x280/0x500
> >>> [<ffffffff810d97d0>] ? __lock_release+0x90/0x1b0
> >>> [<ffffffff8161d830>] ? __do_page_fault+0x280/0x500
> >>> [<ffffffff8109a763>] ? up_read+0x23/0x40
> >>> [<ffffffff8161d830>] ? __do_page_fault+0x280/0x500
> >>> [<ffffffff81182f1c>] ? might_fault+0x5c/0xb0
> >>> [<ffffffff81081f96>] ? sys_newuname+0x66/0xf0
> >>> [<ffffffff810d97d0>] ? __lock_release+0x90/0x1b0
> >>> [<ffffffff81081f96>] ? sys_newuname+0x66/0xf0
> >>> [<ffffffff81622f45>] ? sysret_check+0x22/0x5d
> >>> [<ffffffff8125c620>] sys_semop+0x10/0x20
> >>> [<ffffffff81622f19>] system_call_fastpath+0x16/0x1b
> >>> Code: b8 00 00 48 8b 80 48 06 00 00 41 8b 54 24 40 4c 8d
> >>> 45 d0 89 d9 45 31 c9 48 8b 40 70 8b 78 04 49 8b 44 24 60 c6 45 d0 04
> >>> 89 55 d8
> >>> <0f> b7 10 8b 70 04 e8 0a dc ff ff 48 83 c4 20 5b 41 5c c9 c3 90
> >>> RIP  [<ffffffff812735eb>] ipc_has_perm+0x4b/0x60
> >>> RSP <ffff880237f2bc98>
> >>> CR2: 0000000000000000
> >>>
> >>> The root cause is semtimedop() was called after semget() without
> >>> checking its
> >>> return value in process opcmon. and semget() failed to check
> >>> permission in
> >>> function avc_has_perm() then sem_perm->security was freed shown as
> >>> following:
> >>>
> >>>       sys_semget()
> >>>       ->newary()
> >>>        ->security_sem_alloc()
> >>>          ->sem_alloc_security()
> >>>            selinux_sem_alloc_security()
> >>>            ->ipc_alloc_security() {
> >>>              ->rc = avc_has_perm()
> >>>                 if (rc) {
> >>>                     ipc_free_security(&sma->sem_perm);
> >>>                     return rc;
> >> We free the security structure here to avoid a memory leak on a
> >> failed/denied semaphore set creation.  In this situation, we return an
> >> error to the caller (ultimately to newary), it does an
> >> ipc_rcu_putref(sma, ipc_rcu_free), and it returns an error to the
> >> caller.  Thus, it never calls ipc_addid() and the semaphore set is not
> >> created.  So how then can you call semtimedop() on it?
> > My only idea would be a race of semtimedop() with IPC_RMID:
> > If a rcu grace period happens between sem_obtain_object_check() and the
> > ipc_has_perm() call, the the observed NULL pointer assignment would happen.
> 
> We only free and clear the ipc_perms->security field on a failure during
> newary() -> security_sem_alloc(), in which case we fail with an error
> before the ipc_addid() call has occurred, or during sem_rcu_free() ->
> security_sem_free() just prior to calling ipc_rcu_free().   So I don't
> see how ipc_perms->security can be NULL in ipc_has_perm().  We could rcu
> free the ipc_perms->security field but I don't see why that would be
> correct/necessary.
> 


