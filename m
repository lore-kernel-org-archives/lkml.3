Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323Ab3JJTAV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 15:00:21 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:59033 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755750Ab3JJTAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 15:00:19 -0400
MIME-Version: 1.0
In-Reply-To: <20131010144327.5ded02ec@gandalf.local.home>
References: <20131008102505.404025673@infradead.org>
	<20131009225006.7101379c.akpm@linux-foundation.org>
	<20131010121908.GB28601@twins.programming.kicks-ass.net>
	<20131010145738.GA5167@gmail.com>
	<20131010152612.GA13375@redhat.com>
	<20131010090044.7f12ddaf.akpm@linux-foundation.org>
	<20131010123631.1be60315@gandalf.local.home>
	<20131010094355.6f75e5a2.akpm@linux-foundation.org>
	<20131010165337.GT3081@twins.programming.kicks-ass.net>
	<20131010131305.58558079@gandalf.local.home>
	<20131010104856.8f042977112d5ac2693973ae@linux-foundation.org>
	<CA+55aFx-JxRBbPa5EF1foZORpX_+o3T-qqm+1vh5Goa9znmOxA@mail.gmail.com>
	<20131010144327.5ded02ec@gandalf.local.home>
Date: Thu, 10 Oct 2013 12:00:16 -0700
X-Google-Sender-Auth: QpvC-MHKrHOIjIFL3sn1qILiLtM
Message-ID: <CA+55aFyDAKNox=rSyx7kSiRu9n8gQmfxTarPGtXPGt8wcojpjQ@mail.gmail.com>
Subject: Re: [PATCH 0/6] Optimize the cpu hotplug locking -v2
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 11:43 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> There's places in the kernel that does for_each_cpu() that I'm sure you
> don't want to disable preemption for. Especially when you start having
> 4096 CPU machines!

We could _easily_ add preemption points in for_each_cpu() for the
MAX_SMP case. We can even do it in the macro itself.

So I wouldn't worry about things like that. I'd expect the "Oh damn,
we have to allocate" case to be more painful, but I think that is
fairly easily handled by having something like a "redo_cpu()" macro
that you can call inside for_each_cpu(). So the pattern for the
(nopefully-not-all-that-common) thing would be something like

   sometype *prealloc = NULL;

   for_each_cpu() {
         if (!prealloc) {
               rcu_read_unlock();  // Or whatever we want to call it
               prealloc = kmalloc(..);
               rcu_read_lock();
               redo_cpu();
          }
   }
   kfree(prealloc);

which is certainly more work than a sleeping lock is, but this looks
like a initialization pattern.

Looking at the things that are actually performance-critical, they
tend to be things like "gather all the statistics for all CPUs".

Honesty in advertizing: I only grepped a couple of users of
get_online_cpus(), and they all seemed like they'd be perfectly happy
with preemption-off. But maybe I was just lucky in my few samples: I
have anecdotes, not data.

              Linus
