Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534AbaAWTgQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 14:36:16 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:45522 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755268AbaAWTgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 14:36:14 -0500
Message-ID: <1390505904.5567.1019.camel@haakon3.risingtidesystems.com>
Subject: Re: [PATCH-v2 1/3] percpu_ida: Make percpu_ida_alloc + callers
 accept task state bitmask
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: kmo@daterainc.com, target-devel <target-devel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Jens Axboe <axboe@kernel.dk>
Date: Thu, 23 Jan 2014 11:38:24 -0800
In-Reply-To: <1390505486.5567.1014.camel@haakon3.risingtidesystems.com>
References: <1390189486-13579-1-git-send-email-nab@linux-iscsi.org>
	 <1390189486-13579-2-git-send-email-nab@linux-iscsi.org>
	 <20140120113415.GE30183@twins.programming.kicks-ass.net>
	 <20140121221852.GT9037@kmo>
	 <1390420413.5567.949.camel@haakon3.risingtidesystems.com>
	 <1390502404.5567.994.camel@haakon3.risingtidesystems.com>
	 <20140123191229.GW11314@laptop.programming.kicks-ass.net>
	 <1390505486.5567.1014.camel@haakon3.risingtidesystems.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-01-23 at 11:31 -0800, Nicholas A. Bellinger wrote:
> On Thu, 2014-01-23 at 20:12 +0100, Peter Zijlstra wrote:
> > On Thu, Jan 23, 2014 at 10:40:04AM -0800, Nicholas A. Bellinger wrote:
> > > On Wed, 2014-01-22 at 11:53 -0800, Nicholas A. Bellinger wrote:
> > > > Hi Peter,
> > > > 
> > > > Does this satisfy your questions..?
> > > > 
> > > > Do you have any more concerns about TASK_RUNNING + prepare_to_wait()
> > > > usage in percpu_ida_alloc() that need to be addressed before I can drop
> > > > this series into target-pending/for-next to address the original bug..?
> > > > 
> > > 
> > > Given the silence, 
> > 
> > You mean the silence in which I send a 4+ emails earlier today?
> > 
> > > I'll assume your OK with the initial TASK_RUNNING +
> > > prepare_to_wait() bit, right..?
> > 
> > No, I would prefer not to do that. While it does work its awkward at
> > best.
> 
> AFAICT, those changes don't address the original bug that the series was
> trying to address, allowing the percpu_ida_alloc() tag stealing slow
> path to be interrupted by a signal..
> 
> Also, keep in mind this change needs to be backported to >= v3.12, which
> is why the percpu_ida changes have been kept to a minimum.
> 

<A little too eager to SEND>

So would you prefer the following addition to the original bugfix
instead..?

diff --git a/lib/percpu_ida.c b/lib/percpu_ida.c
index a48ce2e..58b6714 100644
--- a/lib/percpu_ida.c
+++ b/lib/percpu_ida.c
@@ -174,7 +174,8 @@ int percpu_ida_alloc(struct percpu_ida *pool, int state)
                 *
                 * global lock held and irqs disabled, don't need percpu lock
                 */
-               prepare_to_wait(&pool->wait, &wait, state);
+               if (state != TASK_RUNNING)
+                       prepare_to_wait(&pool->wait, &wait, state);
 
                if (!tags->nr_free)
                        alloc_global_tags(pool, tags);
@@ -199,8 +200,9 @@ int percpu_ida_alloc(struct percpu_ida *pool, int state)
                local_irq_save(flags);
                tags = this_cpu_ptr(pool->tag_cpu);
        }
+       if (state != TASK_RUNNING)
+               finish_wait(&pool->wait, &wait);
 
-       finish_wait(&pool->wait, &wait);
        return tag;
 }
 EXPORT_SYMBOL_GPL(percpu_ida_alloc);


