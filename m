Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692Ab3ILPm2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 11:42:28 -0400
Received: from b232-131.smtp-out.amazonses.com ([199.127.232.131]:24061 "EHLO
	b232-131.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754657Ab3ILPmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 11:42:24 -0400
Date: Thu, 12 Sep 2013 15:42:21 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC] Restrict kernel spawning of threads to a specified set of
 cpus.
In-Reply-To: <alpine.DEB.2.02.1309121030390.21473@gentwo.org>
Message-ID: <0000014112d66287-d0abaeb1-71ff-48a0-8740-f984d47400a7-000000@email.amazonses.com>
References: <00000140efbcb701-c26320b3-f434-4538-bc80-8e92fed6f303-000000@email.amazonses.com> <20130911220228.GB15367@somewhere> <000001411282afa6-fe9c0543-0447-492b-991e-dc8214884b88-000000@email.amazonses.com> <20130912141625.GA23357@somewhere>
 <00000141128d759a-44dcacb6-8f48-4f9b-8381-d14003bd6da1-000000@email.amazonses.com> <20130912143137.GA23839@somewhere> <0000014112a921ae-51d171bf-e8d4-4569-bd20-94dabda2d5ba-000000@email.amazonses.com> <20130912151102.GB23839@somewhere>
 <alpine.DEB.2.02.1309121030390.21473@gentwo.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.127.232.131
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let me just say that the user space approach does not work because the
kernel sets the cpumask to all and then spawns a thread f.e. for
usermodehelper.

This mean we would have to run a daemon that keeps scanning for errand
threads and then move them. But at that point the damage would already
have been done. Short term threads would never be caught.

So I think the kernel based approach is unavoidable.

Look at this in kernel/kmod.c:

static int ____call_usermodehelper(void *data)
{
        struct subprocess_info *sub_info = data;
        struct cred *new;
        int retval;

        spin_lock_irq(&current->sighand->siglock);
        flush_signal_handlers(current, 1);
        spin_unlock_irq(&current->sighand->siglock);

        /* We can run anywhere, unlike our parent keventd(). */
        set_cpus_allowed_ptr(current, cpu_all_mask);


!!!!! No chance to catch this from user space.



	....

        retval = do_execve(sub_info->path,
                       (const char __user *const __user *)sub_info->argv,
                           (const char __user *const __user *)sub_info->envp);
        if (!retval)


	....

