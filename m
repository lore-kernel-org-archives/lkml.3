Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755051AbaCLPV1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 11:21:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43571 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754566AbaCLPV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 11:21:26 -0400
Date: Wed, 12 Mar 2014 16:21:41 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kmo@daterainc.com>,
        Shaohua Li <shli@kernel.org>, Christoph Hellwig <hch@lst.de>,
        Mike Christie <michaelc@cs.wisc.edu>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] percpu_ida: Handle out-of-tags gracefully
Message-ID: <20140312152140.GA14305@dhcp-26-207.brq.redhat.com>
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
> On 03/11/14 21:48, Alexander Gordeev wrote:
> > On Tue, Mar 11, 2014 at 07:10:18PM +0100, Bart Van Assche wrote:
> >>> I assume the BUG() above hits? If so, I am failing to understand how
> >>> the code gets here. Mind elaborate?
> >>
> >> You are correct, the BUG() mentioned in the call stack in the
> >> description of this patch does indeed correspond with the BUG()
> >> statement in the above code. That BUG() was encountered while testing
> >> the scsi-mq patch series with a workload with a large queue depth. I
> >> think the fact that I hit that BUG() statement means that my workload
> >> was queueing requests faster than these were processed by the SCSI LLD
> >> and hence that percpu_ida_alloc() ran out of tags.
> > 
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
> remote->nr_free to drop to zero.

I stared at the code again and I am still not getting how the BUG() gets
hit. The scenario you describe is impossible, because the code that checks
'cpus_have_tags' on one CPU and the code which can steal tags on another CPU
is protected by 'pool->lock' - that is the same steal_tags() function.

While 'remote->nr_free' could be dropped on another CPU (in fact from
percpu_ida_alloc(), not from concurrent steal_tags()) it still does not
explain how steal_tags() enters the loop, but fails to locate 'cpus_have_tags'
count of bits.

So although v2 of your patch fixes the crash it does not address the root
cause IMHO.

May be the following bits in percpu_ida_free() need a closer look:

	if (nr_free == 1) {
		cpumask_set_cpu(smp_processor_id(),
				&pool->cpus_have_tags);
		wake_up(&pool->wait);
	}

I do not see anything suspicious, but may be the fact cpumask_set_cpu()
is out of any lock contributes to the problem? Do not know.

Would you be able to check if i.e. this hack makes the BUG() to go?

Thanks!

diff --git a/lib/percpu_ida.c b/lib/percpu_ida.c
index 93d145e..8715d0e 100644
--- a/lib/percpu_ida.c
+++ b/lib/percpu_ida.c
@@ -233,6 +233,11 @@ void percpu_ida_free(struct percpu_ida *pool, unsigned tag)
 	nr_free = tags->nr_free;
 	spin_unlock(&tags->lock);
 
+	if (!nr_free)
+		goto out;
+
+	spin_lock(&pool->lock);
+
 	if (nr_free == 1) {
 		cpumask_set_cpu(smp_processor_id(),
 				&pool->cpus_have_tags);
@@ -240,7 +245,6 @@ void percpu_ida_free(struct percpu_ida *pool, unsigned tag)
 	}
 
 	if (nr_free == pool->percpu_max_size) {
-		spin_lock(&pool->lock);
 
 		/*
 		 * Global lock held and irqs disabled, don't need percpu
@@ -253,9 +257,11 @@ void percpu_ida_free(struct percpu_ida *pool, unsigned tag)
 
 			wake_up(&pool->wait);
 		}
-		spin_unlock(&pool->lock);
 	}
 
+	spin_unlock(&pool->lock);
+
+out:
 	local_irq_restore(flags);
 }
 EXPORT_SYMBOL_GPL(percpu_ida_free);

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
