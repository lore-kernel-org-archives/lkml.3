Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197AbaABTXL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 14:23:11 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:45518 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbaABTXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 14:23:09 -0500
MIME-Version: 1.0
In-Reply-To: <1388675120-8017-5-git-send-email-davidlohr@hp.com>
References: <1388675120-8017-1-git-send-email-davidlohr@hp.com>
	<1388675120-8017-5-git-send-email-davidlohr@hp.com>
Date: Thu, 2 Jan 2014 11:23:05 -0800
X-Google-Sender-Auth: W8tDgTDaRxLBVnkyB_EuQNgsT88
Message-ID: <CA+55aFwNPgzORGyKaziqBGqY9Uubuuo0w=rGQvcHS-Ftz4HQ9g@mail.gmail.com>
Subject: Re: [PATCH v5 4/4] futex: Avoid taking hb lock if nothing to wakeup
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Darren Hart <dvhart@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>, Jeff Mahoney <jeffm@suse.com>,
        Jason Low <jason.low2@hp.com>, Waiman Long <Waiman.Long@hp.com>,
        Tom Vaden <tom.vaden@hp.com>, "Norton, Scott J" <scott.norton@hp.com>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 2, 2014 at 7:05 AM, Davidlohr Bueso <davidlohr@hp.com> wrote:
>
> In futex_wake() there is clearly no point in taking the hb->lock if we know
> beforehand that there are no tasks to be woken.

Btw, I think we could optimize this a bit further for the wakeup case.

wake_futex() does a get_task_struct(p)/put_task_struct(p) around its
actual waking logic, and I don't think that's necessary. The task
structures are RCU-delayed, and the task cannot go away until the
"q->lock_ptr = NULL" afaik, so you could replace that atomic inc/dec
with just a RCU read region.

Maybe it's not a big deal ("wake_up_state()" ends up getting the task
struct pi_lock anyway, so it's not like we can avoid toucing the task
structure), but I'm getting the feeling that we're doing a lot of
unnecessary work here.

This only triggers for the actual case of having a task to wake up,
though, so not your particular test load.

              Linus
