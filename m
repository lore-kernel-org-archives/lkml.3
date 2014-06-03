Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933112AbaFCUZS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 16:25:18 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:33683 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752043AbaFCUZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 16:25:17 -0400
Date: Tue, 3 Jun 2014 16:25:14 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Clark Williams <williams@redhat.com>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>
Subject: Re: [BUG] signal: sighand unprotected when accessed by /proc
Message-ID: <20140603162514.7b11f3ea@gandalf.local.home>
In-Reply-To: <20140603200938.GA3384@redhat.com>
References: <20140603130233.658a6a3c@gandalf.local.home>
	<20140603172632.GA27956@redhat.com>
	<CA+55aFzT5CGv_T60voAqR+4PfiMmJmsDZLid2DZ4=+X8uvF+ig@mail.gmail.com>
	<20140603160524.7895f225@gandalf.local.home>
	<20140603200938.GA3384@redhat.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jun 2014 22:09:38 +0200
Oleg Nesterov <oleg@redhat.com> wrote:
 
> > Now, if that lock is released and reused (I didn't trace other tasks
> > allocating these locks), it reinitializes the lock->wait_list.
> 
> How? From where? This should be done by sighand_ctor() only?

This looks definitely like an -rt only bug and it's an obvious one at
that :-p

Looking in mm/slub.c: slab_alloc_node() we have this:

        if (unlikely(gfpflags & __GFP_ZERO) && object)
                memset(object, 0, s->object_size);
#ifdef CONFIG_PREEMPT_RT_FULL
        if (unlikely(s->ctor) && object)
                s->ctor(object);
#endif  

        slab_post_alloc_hook(s, gfpflags, object);

        return object;
}


We call the ctor on the object when it is allocated, not when the page
is created.

Doh! I guess we now know why we shouldn't do that.

-- Steve
