Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556AbaFDOQS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 10:16:18 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:3995 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753506AbaFDOQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 10:16:15 -0400
Date: Wed, 4 Jun 2014 10:16:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Brad Mouring" <bmouring@ni.com>
Cc: linux-rt-users@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Clark Williams <williams@redhat.com>
Subject: Re: [PATCH 1/1] rtmutex: Handle when top lock owner changes
Message-ID: <20140604101612.0d47b399@gandalf.local.home>
In-Reply-To: <20140604130525.GA1621@linuxgetsreal>
References: <1400855410-14773-1-git-send-email-brad.mouring@ni.com>
	<1400855410-14773-2-git-send-email-brad.mouring@ni.com>
	<20140603210609.62de6451@gandalf.local.home>
	<20140604130525.GA1621@linuxgetsreal>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jun 2014 08:05:25 -0500
"Brad Mouring" <bmouring@ni.com> wrote:

 >          A->L2
> 
> This is a slight variation on what I was seeing. To use the nomenclature
> that you proposed at the start, rewinding to the point
> 
>    A->L2->B->L3->C->L4->D
> 
> Let's assume things continue to unfold as you explain. Task is D,
> top_waiter is C. A is scheduled out and the chain shuffles.
> 
>        A->L2->B
> C->L4->D->'

But isn't that a lock ordering problem there?

If B can block on L3 owned by C, I see the following:

  B->L3->C->L4->D->L2->B

Deadlock!

In my scenario I was very careful to point out that the lock ordering
was: L1->L2->L3->L4

But you show that we can have both:

   L2-> ... ->L4

    and

   L4-> ... ->L2

Which is a reverse of lock ordering and a possible deadlock can occur.

-- Steve


> 
> So, we now have D blocking on L2 and L4 has waiters, C again. Also,
> since the codepath to have C block on L4 again is the same as the
> codepath from when it blocked on it in the first place, the location
> is the same since the stack (for what we care about) is the same.
> 
