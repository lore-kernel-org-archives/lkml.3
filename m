Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757754Ab3KHQbW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 11:31:22 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:56385 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757684Ab3KHQbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 11:31:19 -0500
Date: Fri, 8 Nov 2013 17:31:14 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Mike Galbraith <bitbucket@online.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH] kmod: Run usermodehelpers only on cpus allowed for
 kthreadd V2
Message-ID: <20131108163112.GA12853@localhost.localdomain>
References: <00000141c1b99b20-64f9d142-961a-447e-8ebe-40f86b638278-000000@email.amazonses.com>
 <20131016141326.2e517e18e4d8af880c97a282@linux-foundation.org>
 <00000141c36b03b6-2f9bd3de-d153-4359-901f-084aeb4c040d-000000@email.amazonses.com>
 <20131017122344.39d55db97c3923131bdf2831@linux-foundation.org>
 <0000014233722db9-cc00d0af-a5fa-4090-83bd-73c87377b892-000000@email.amazonses.com>
 <20131107225049.GC28130@localhost.localdomain>
 <0000014238407a1c-34e7bdbc-45c0-48de-a8a3-94a99f276044-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000014238407a1c-34e7bdbc-45c0-48de-a8a3-94a99f276044-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 08, 2013 at 03:06:59PM +0000, Christoph Lameter wrote:
> On Thu, 7 Nov 2013, Frederic Weisbecker wrote:
> 
> > usermodehelper works are created via workqueues, right? And workqueues are an issue as
> > well for those who want CPU isolation.
> 
> AFAICT usermodehelper can be called from a variety of contexts.

But it looks like it always end up calling a workqueue. May be I missed something though.

Now we can argue that this workqueue seem to create kernel threads, which in turn create other kernel thread (uhh?)
and I don't know if those inherit the kworker affinity. But from a quick look, it seems to me that
this is what we want.

BTW the use of kernel_thread is justified in this comment: "/* Keventd can't block, but this (a child) can. */"
Do these kernel_threads exist because kworker can't block? Actually the new workqueue subsystem can have blocking
worklets now, may be something can be simplified there although I haven't checked the details. But perhaps
we can spare one level of kernel threads.

Can't we use kthreads there btw? Or may be we need a task->mm to do the user things.

> 
> > So this looks like a more general problem than just call_usermodehelper.
> 
> Well the code explicitly sets the the affinity mask to all cpus which
> creates a problem for low latency processors. It does not inherit the
> affinity from any calling process.

But how is that an argument in favour of changing this to inheriting the affinity from
the workqueue thread rather than kthread?

> 
> > Last time I checked, it seemed to me that this is an unbound workqueue? If so can't we tune
> > the affinity of this workqueue? If not perhaps that's something we want to solve and which
> > could be useful for all the users who don't want their CPU to be disturbed.
> 
> There are various contexts from which usermodehelper can be called.
> Drivers use it etc.

But they all converge to the workqueue, or I'm missing other code paths?

Thanks.
