Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510AbaK0Kzb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 05:55:31 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:8655 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400AbaK0Kz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 05:55:28 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7fc86d0000066b7-96-5477031e893b
Content-transfer-encoding: 8BIT
Message-id: <1417085724.1805.7.camel@samsung.com>
Subject: Re: [PATCH] kernel/exit.c: make sure current's nsproxy != NULL while
 checking caps
From: Lukasz Pawelczyk <l.pawelczyk@samsung.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Lukasz Pawelczyk <havner@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, David Rientjes <rientjes@google.com>,
        Sameer Nanda <snanda@chromium.org>,
        Guillaume Morin <guillaume@morinfr.org>, Li Zefan <lizefan@huawei.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 27 Nov 2014 11:55:24 +0100
In-reply-to: <20141126205230.GA22121@redhat.com>
References: <1417011661-19230-1-git-send-email-l.pawelczyk@samsung.com>
 <20141126205230.GA22121@redhat.com>
X-Mailer: Evolution 3.12.5 (3.12.5-1.fc20)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBLMWRmVeSWpSXmKPExsVy+t/xq7pyzOUhBqtW8FnMWb+GzWL3gods
	Fv9f61hc3jWHzWJSRy+7xavm76wWW/e3Mlq0LdnIZHHx90l2B06P2Q0XWTx2zrrL7rFgU6lH
	y5G3rB4nZvxm8ei4v4XJ4/2+q2weZxYcYff4vEkugDOKyyYlNSezLLVI3y6BK2PCOueCh9IV
	8391MzcwHhTrYuTkkBAwkeiZc5wZwhaTuHBvPVsXIxeHkMBSRokzL5axgCR4BQQlfky+B2Rz
	cDALyEscuZQNEmYWUJeYNG8RM0T9f0aJ+Y8eM0LUG0rcb2liBbGFBWIlDn98wAZiswkYSHy/
	sBdsmYiAssSfewvAmpkFVjJJzL5/HayBRUBVovP0CbAGTqCGmU93gdlCArkS785vZoO4VEvi
	fddPlgmMArOQ3DcL4b5ZSO5bwMi8ilE0tTS5oDgpPddIrzgxt7g0L10vOT93EyMkNr7uYFx6
	zOoQowAHoxIPL8OtshAh1sSy4srcQ4wSHMxKIrxcjOUhQrwpiZVVqUX58UWlOanFhxiZODil
	Ghhd1J5OO1Xg1/F+2h1LridXamYtWvT01Kf29+YavLKvJN/s3fw86jTr/d6Sm8uinicq9d+K
	W+r+f/O/1gffJhteP5dzdc7OWD+2DudJG0N2F/ZeyZ4ZWKVifPHVgcMXml9c15++xcymPlIo
	ioN9zgLHRY0tl/6H7giZV9Pt+kPdgOvmjMObPno7KbEUZyQaajEXFScCAByX4nJrAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On śro, 2014-11-26 at 21:52 +0100, Oleg Nesterov wrote:
> On 11/26, Lukasz Pawelczyk wrote:
> >
> > My understanding is that while we have to use task_nsproxy()
> 
> task_nsproxy() has already gone... probably this doesn't matter but which
> kernel version ?

Ah, yes, 728dba3a39c66b3d8ac889ddbe38b5b1c264aec3. But you're right, it
doesn't matter here. I've seen this change, just forgot about it.

> > task's nsproxy and check whether it's NULL, for the 'current' we don't
> > have to and it's expected not to be NULL.
> 
> Well, unless exit_task_namespaces() was called ;)

That's the thing, should we ever get to a point that current's nsproxy
is NULL during an LSM check? That's why I mentioned code like:
current->nsproxy->some_ns

being in a kernel without a check. I think that current's nsproxy should
always be guaranteed to exist.

> > There seem to be no crash currently because of this, but with other LSM
> > modules or in future there might be. This is the backtrace:
> 
> Confused... backtrace of what? did kernel crash or what?

Sorry, probably should have explained this a little better. Yes, this is
backtrace of crash, but one that will not happen in the exact form on
master. This is of a modified smack that makes use of nsproxy during LSM
checks.

But this really doesn't matter. I posted this backtrace to show that
there is an LSM check that happens after exit_task_namespaces() has been
called.

> 
> > 0  smk_tskacc (task=0xffff88003b0b92e0, obj_known=0x2 <irq_stack_union+2>, mode=2, a=0xffff88003be53dd8) at security/smack/smack_access.c:261
> > 1  0xffffffff8130e2aa in smk_curacc (obj_known=<optimized out>, mode=<optimized out>, a=<optimized out>) at security/smack/smack_access.c:318
> > 2  0xffffffff8130a50d in smack_task_kill (p=0xffff88003b0b92e0, info=<optimized out>, sig=<optimized out>, secid=<optimized out>) at security/smack/smack_lsm.c:2071
> 
> I do not know this code, so could you please tell more? How/wher smk_tskacc()
> uses ->nsproxy?  smack_access.c:261 leads to the comment header above smk_curacc()
> in my tree, so this tells me nothing.

This is a code from my working tree. I'm working on Smack/LSM namespaces
that will make Smack use nsproxy during LSM checks. The code above is
not important at the moment. As I said previously this backtrace is just
a proof that an LSM check happens after exit_task_namespaces(), during
exit_notify().

> Well, we can probably move exit_task_namespaces() down (perhaps we even
> want to move it after exit_task_work).
> 
> But I am not sure about exit_notify(), in this case free_nsproxy() can
> be called when the caller is already reaped.
> 
> In any case, please more details?

The capability checks sometimes use nsproxy, e.g. user namespaces. Same
thing might be a case for Smack (or any other LSM module) when working
inside a namespace. I'm WIP on those changes and I will be trying to
upstream them to. This issue is a stopper for me so I though I'd try to
push it earlier.

I'm not expert on this code hence any suggestion would be welcome.
My understanding is that when we do an LSM hook there might be a
capability check inside. And this capability check might be using
ns_capable() instead of capable() if namespaced. And in the case
depicted above the nsproxy of the current process is already destroyed.
I think that this is a bug, even though it has no repercussions in the
kernel yet.


-- 
Lukasz Pawelczyk
Samsung R&D Institute Poland
Samsung Electronics



