Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847AbaGKOz0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 10:55:26 -0400
Received: from kanga.kvack.org ([205.233.56.17]:37181 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751923AbaGKOzZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 10:55:25 -0400
Date: Fri, 11 Jul 2014 10:55:24 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jeff Moyer <jmoyer@redhat.com>,
        Jens Axboe <axboe@kernel.dk>,
        "dgilbert@interlog.com" <dgilbert@interlog.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Bart Van Assche <bvanassche@fusionio.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: scsi-mq V2
Message-ID: <20140711145524.GB12478@kvack.org>
References: <20140710062040.GB20146@infradead.org> <94D0CD8314A33A4D9D801C0FE68B402958B96E3B@G9W0745.americas.hpqcorp.net> <20140710160422.GA13728@infradead.org> <20140710161438.GA30792@infradead.org> <94D0CD8314A33A4D9D801C0FE68B402958B971BB@G9W0745.americas.hpqcorp.net> <x497g3l10x6.fsf@segfault.boston.devel.redhat.com> <94D0CD8314A33A4D9D801C0FE68B402958B9742E@G9W0745.americas.hpqcorp.net> <94D0CD8314A33A4D9D801C0FE68B402958B979E6@G9W0745.americas.hpqcorp.net> <20140711061441.GA29629@infradead.org> <94D0CD8314A33A4D9D801C0FE68B402958B98323@G9W0745.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402958B98323@G9W0745.americas.hpqcorp.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 02:33:12PM +0000, Elliott, Robert (Server Storage) wrote:
> That ran 9 total hours with no problem.
> 
> Rather than revert in the bisect trees, I added just this single additional
> patch to the no-rebase tree, and the problem appeared:

Can you try the below totally untested patch instead?  It looks like
put_reqs_available() is not irq-safe.

		-ben
-- 
"Thought is the essence of where you are now."


diff --git a/fs/aio.c b/fs/aio.c
index 955947e..4b97180 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -830,16 +830,20 @@ void exit_aio(struct mm_struct *mm)
 static void put_reqs_available(struct kioctx *ctx, unsigned nr)
 {
 	struct kioctx_cpu *kcpu;
+	unsigned long flags;
 
 	preempt_disable();
 	kcpu = this_cpu_ptr(ctx->cpu);
 
+	local_irq_save(flags);
 	kcpu->reqs_available += nr;
+
 	while (kcpu->reqs_available >= ctx->req_batch * 2) {
 		kcpu->reqs_available -= ctx->req_batch;
 		atomic_add(ctx->req_batch, &ctx->reqs_available);
 	}
 
+	local_irq_restore(flags);
 	preempt_enable();
 }
 
