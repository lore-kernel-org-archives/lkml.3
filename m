Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933006Ab3CLRGn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 13:06:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6349 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932153Ab3CLRGm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 13:06:42 -0400
Date: Tue, 12 Mar 2013 18:04:24 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Namhyung Kim <namhyung@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] kthread: kill task_get_live_kthread()
Message-ID: <20130312170424.GA12747@redhat.com>
References: <20130311173625.GA13525@redhat.com> <alpine.LFD.2.02.1303112210490.22263@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1303112210490.22263@ionos>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On 03/11, Thomas Gleixner wrote:
>
> On Mon, 11 Mar 2013, Oleg Nesterov wrote:
> >
> > But the actual reason for this cleanup is that I do not understand
> > why park/unpark abuse kthread.c.
>
> It's not abusing it :)

Yes, yes, I didn't mean the code looks bad or something like this.

Just I thought that, perhaps, it would be more clean to hide this
park/unpark logic in kernel/smpboot.c and do not add the "special"
new members into "struct kthread".

But let me repeat, mostly I simply wanted to ask the question. I
just noticed this new code and I was curious if this park/unpark
logic should be applied to every kthread (in future) or it is only
for smpboot_register_percpu_thread/etc.

> > Thomas, can't we move kthread->parked/cpu to smpboot_thread_data
> > and move all this code into kernel/smpboot.c? Just for example,
> > why kthread() does __kthread_parkme() ? smpboot_thread_fn() can do
> > this at the start.
>
> No objection. When I implemented this, I thought this would be the
> correct place and I followed the conventions of kthread.c ...

OK, I'll try to think again if this change is actually possible _and_
it can really make the things more clean/simple.

> What's the issue with that, other than some superflous task_get/put
> calls ?

Do you mean this particular cleanup?

No issues, this is only cleanup. But every cleanup is subjective, so
please tell me if you disagree.

Firstly, to_kthread() + barrier() + "vfork_done != NULL" doesn't look
very clear (cough, yes, this was written by me). And after 1/2

	static struct kthread *task_get_live_kthread(struct task_struct *k)
	{
		get_task_struct(k);
		return to_live_kthread(k);
	}

looks confusing too because it mixes 2 different things and because
its usage is not clear. I mean, it is not clear why the caller needs
get_task_struct() and why it is safe if we do not have a reference.

Oleg.

