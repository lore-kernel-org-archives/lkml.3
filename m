Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869AbaBNOHg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 09:07:36 -0500
Received: from www.linutronix.de ([62.245.132.108]:42120 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436AbaBNOHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 09:07:35 -0500
Date: Fri, 14 Feb 2014 15:07:29 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Nicholas Mc Guire <der.herr@hofr.at>
Cc: linux-rt-users@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Carsten Emde <C.Emde@osadl.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andreas Platschek <platschek@ict.tuwien.ac.at>
Subject: Re: [PATCH RT 5/5] allow preemption in slab_alloc_node and slab_free
Message-ID: <20140214140729.GI28438@linutronix.de>
References: <20140210154016.GF20017@opentech.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140210154016.GF20017@opentech.at>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nicholas Mc Guire | 2014-02-10 16:40:16 [+0100]:

>__slab_alloc is only called from slub.c:slab_alloc_node
>it runs with local irqs disabled so it can't be pushed off this CPU
>asynchronously, the preempt_disable/enable is thus not needed.
>Aside from that the later this_cpu_cmpxchg_double would catch such a 
>migration event anyay.

Not sure what to do with this one. You do write a longer chapter why it
is okay to drop the preemption disable section and that
this_cpu_cmpxchg_double() would catch it. And I didn't figure out so
far why need to keep preemption disabled while looking at c->tid but not
at c->page.
However, it seems that Christoph Lameter found it important to add a
note in the comment that this preemption disable here is important.
Looking at commit 7cccd80 ("slub: tid must be retrieved from the percpu
area of the current processor") it seems that Steven Rostedt run into
trouble and now we have that preemption_disable() here.

So if you really get better performance and you haven't seen anything
bad happen then you might want to check with Lameter & Rostedt about
your patch and getting it merged upstream.
The commit I mentioned is upstream since v3.11-rc1 and I can see it in
v3.8-RT tree so it looks serious.
I fail to see it in v3.2-RT, Steven, isn't this something we want there,
too?

Sebastian
