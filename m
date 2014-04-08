Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757926AbaDHV4H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 17:56:07 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:52863 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757232AbaDHV4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 17:56:04 -0400
Date: Tue, 8 Apr 2014 23:56:00 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@linux.com>, Mike Galbraith <bitbucket@online.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mike Frysinger <vapier@gentoo.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] kmod: Run usermodehelpers only on cpus allowed for
 kthreadd V2
Message-ID: <20140408215556.GB14519@localhost.localdomain>
References: <20131017122344.39d55db97c3923131bdf2831@linux-foundation.org>
 <0000014233722db9-cc00d0af-a5fa-4090-83bd-73c87377b892-000000@email.amazonses.com>
 <20131107225049.GC28130@localhost.localdomain>
 <0000014238407a1c-34e7bdbc-45c0-48de-a8a3-94a99f276044-000000@email.amazonses.com>
 <20131108163112.GA12853@localhost.localdomain>
 <0000014238ad0fb9-aa252280-8e44-48ac-a096-e6dee26e09ea-000000@email.amazonses.com>
 <20131108191235.GB12853@localhost.localdomain>
 <000001423945fde3-f846f403-58b9-4acd-a2b8-43b62991ce02-000000@email.amazonses.com>
 <20131108200620.GC14606@localhost.localdomain>
 <20140408135712.c761d7b01bd451be5fc41c00@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140408135712.c761d7b01bd451be5fc41c00@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 08, 2014 at 01:57:12PM -0700, Andrew Morton wrote:
> On Fri, 8 Nov 2013 21:06:22 +0100 Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > On Fri, Nov 08, 2013 at 07:52:37PM +0000, Christoph Lameter wrote:
> > > On Fri, 8 Nov 2013, Frederic Weisbecker wrote:
> > > 
> > > > I understand, but why not solving that from the workqueue affinity? We want to
> > > > solve the issue of unbound workqueues in CPU isolation anyway.
> > > 
> > > Sure if you can solve that with an unbound work queue then this patch is
> > > not needed. Do you have a patch that addresses this issue in your
> > > patchset?
> > 
> > No. Sorry.
> > 
> 
> Several months have passed and nothgin has happened.  Any thoughts on
> what we should do with Christoph's patch?

We have taken another direction to solve the initial problem which is
that usermodehelper threads disturb CPUs on some workloads requiring isolation
(ie: workloads that want specific CPUs to not be disturbed by kernel noise)

We eventually agreed that setting the WQ_SYSFS flag to the usermodehelper
workqueue would allow us to control the affinity of these jobs through sysfs.

But eventually I took it one step further by considering that the real problem
is much broader and concerns all unbound workqueues. Not just usermodehelper.
Christoph finds usermodehelper workqueue disturbing on his workloads, but other
CPU isolation users runnning other workloads on other hardware, other IO protocols, etc..
may be disturbed by many other kind of unbound workqueues. Because unbound
workqueues are globally affined and this behaviour can't be tweaked sanely yet.

And there are a big lot of them. Singlethread workqueues for example has more
than 200 users in the kernel:

      $ git grep create_singlethread_workqueue | wc -l
        219

It's actually something that we wanted to fix for a while now. So I'm
currently working on a more general solution that allow users to affine all
unbound workqueues to the desired set of CPUs.

The last version of the patchset is https://lkml.org/lkml/2014/3/27/246
After some discussion with Tejun and others, I'm working on the next iteration.

So I strongly think we should drop Christoph's patch and focus on the
unbound workqueues sysfs' affinity interface patchset.

Ah there is also the problem of this explicit call in kmod:

       "set_cpus_allowed_ptr(current, cpu_all_mask);"

But it looks like something we can drop. The comment above says:

       /* We can run anywhere, unlike our parent keventd(). */

Looks like a stale issue that concerned the old workqueue times when workqueues
really mapped to named thread. But even then I don't see the reason for this
affinity overwrite.

Thanks.
