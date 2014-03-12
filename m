Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730AbaCLIk4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 04:40:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41394 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756669AbaCLIky (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 04:40:54 -0400
Date: Wed, 12 Mar 2014 09:41:53 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kmo@daterainc.com>,
        Shaohua Li <shli@kernel.org>, Christoph Hellwig <hch@lst.de>,
        Mike Christie <michaelc@cs.wisc.edu>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] percpu_ida: Handle out-of-tags gracefully
Message-ID: <20140312084152.GA8838@dhcp-26-207.brq.redhat.com>
References: <531DC851.5060400@acm.org>
 <20140311135137.GA22995@dhcp-26-207.brq.redhat.com>
 <531F518A.1070808@acm.org>
 <20140311204826.GA30105@dhcp-26-207.brq.redhat.com>
 <53200B2E.4060805@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53200B2E.4060805@acm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2014 at 08:22:22AM +0100, Bart Van Assche wrote:
> > Function steal_tags() is entered with disabled interrupts and
> > pool->lock taken. Then the 'for' cycle enters/loops while 'cpus_have_tags'
> > is not zero. Which means we can not end up with no set bits at all -
> > and that is the reason why BUG() is (legitimately) placed there.
> 
> Sorry but the above reasoning is wrong. Even if interrupts are disabled
> on one CPU, even if that CPU holds pool->lock, and even if
> cpus_have_tags has at least one bit set at the time steal_tags() starts,
> it is still possible that another CPU obtains "remote->lock" before
> steal_tags() can obtain that lock and that that other CPU causes
> remote->nr_free to drop to zero. I am aware the percpu_ida code is not
> easy to read due to such complex interactions between CPU cores.
> However, my understanding is that the goal of the percpu_ida allocator
> was not that its code would be easy to read but that its performance
> would be optimal.
> 
> Is this sufficient to make you have another look at my patch ?

Yep, makes sense - thanks for the clarification.

Still the hunk below (a) breaks the 'pool->percpu_max_size' threshold
and (b) somehow suboptimal, because you wake another thread while a
free tag was/is on this CPU. If it is still here we would better to
grab it. If not, it was stolen by another thread and we do not need
to wake one (not sure how could it be addressed, though).

In fact, did you try to remove this hunk at all? A following call to
percpu_ida_free() both honors the threshold and wakes a thread, so
your extra wake could be unnecessary.

@@ -189,6 +189,9 @@ int percpu_ida_alloc(struct percpu_ida *pool, int state)
 		spin_unlock(&pool->lock);
 		local_irq_restore(flags);
 
+		if (tags->nr_free)
+			wake_up(&pool->wait);
+
 		if (tag >= 0 || state == TASK_RUNNING)
 			break;
 
-- 
1.8.4.5



> Thanks,
> 
> Bart.
> 

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
