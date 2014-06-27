Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280AbaF0T3Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 15:29:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55971 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714AbaF0T3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 15:29:15 -0400
Date: Fri, 27 Jun 2014 15:29:04 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Joe Thornber <thornber@redhat.com>,
        device-mapper development <dm-devel@redhat.com>,
        linux-kernel@vger.kernel.org, Minfei Huang <huangminfei@ucloud.cn>,
        linux-raid@vger.kernel.org, agk@redhat.com
Subject: Re: dm-io: Prevent the danging point of the sync io callback function
Message-ID: <20140627192904.GA21254@redhat.com>
References: <1403841690-4401-1-git-send-email-huangminfei@ucloud.cn>
 <20140627151105.GA30592@debian>
 <alpine.LRH.2.02.1406271432430.18515@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1406271432430.18515@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27 2014 at  2:44pm -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> 
> 
> On Fri, 27 Jun 2014, Joe Thornber wrote:
> 
> > On Fri, Jun 27, 2014 at 12:01:30PM +0800, Minfei Huang wrote:
> > > The io address in callback function will become the danging point,
> > > cause by the thread of sync io wakes up by other threads
> > > and return to relieve the io address,
> > 
> > Yes, well found.  I prefer the following fix however.
> > 
> > - Joe
> 
> It seems ok.
> 
> The patch is too big, I think the only change that needs to be done to fix 
> the bug is to replace "struct task_struct *sleeper;" with "struct 
> completion *completion;", replace "if (io->sleeper) 
> wake_up_process(io->sleeper);" with "if (io->completion) 
> complete(io->completion);" and declare the completion in sync_io() and 
> wait on it instead of "while (1)" loop there.

Here is the minimalist fix you suggested (I agree that splitting out a
minimalist fix is useful):

 drivers/md/dm-io.c | 22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
index 2a20986..e60c2ea 100644
--- a/drivers/md/dm-io.c
+++ b/drivers/md/dm-io.c
@@ -10,6 +10,7 @@
 #include <linux/device-mapper.h>
 
 #include <linux/bio.h>
+#include <linux/completion.h>
 #include <linux/mempool.h>
 #include <linux/module.h>
 #include <linux/sched.h>
@@ -32,7 +33,7 @@ struct dm_io_client {
 struct io {
 	unsigned long error_bits;
 	atomic_t count;
-	struct task_struct *sleeper;
+	struct completion *wait;
 	struct dm_io_client *client;
 	io_notify_fn callback;
 	void *context;
@@ -121,8 +122,8 @@ static void dec_count(struct io *io, unsigned int region, int error)
 			invalidate_kernel_vmap_range(io->vma_invalidate_address,
 						     io->vma_invalidate_size);
 
-		if (io->sleeper)
-			wake_up_process(io->sleeper);
+		if (io->wait)
+			complete(io->wait);
 
 		else {
 			unsigned long r = io->error_bits;
@@ -385,6 +386,7 @@ static int sync_io(struct dm_io_client *client, unsigned int num_regions,
 	 */
 	volatile char io_[sizeof(struct io) + __alignof__(struct io) - 1];
 	struct io *io = (struct io *)PTR_ALIGN(&io_, __alignof__(struct io));
+	DECLARE_COMPLETION_ONSTACK(wait);
 
 	if (num_regions > 1 && (rw & RW_MASK) != WRITE) {
 		WARN_ON(1);
@@ -393,7 +395,7 @@ static int sync_io(struct dm_io_client *client, unsigned int num_regions,
 
 	io->error_bits = 0;
 	atomic_set(&io->count, 1); /* see dispatch_io() */
-	io->sleeper = current;
+	io->wait = &wait;
 	io->client = client;
 
 	io->vma_invalidate_address = dp->vma_invalidate_address;
@@ -401,15 +403,7 @@ static int sync_io(struct dm_io_client *client, unsigned int num_regions,
 
 	dispatch_io(rw, num_regions, where, dp, io, 1);
 
-	while (1) {
-		set_current_state(TASK_UNINTERRUPTIBLE);
-
-		if (!atomic_read(&io->count))
-			break;
-
-		io_schedule();
-	}
-	set_current_state(TASK_RUNNING);
+	wait_for_completion_io(&wait);
 
 	if (error_bits)
 		*error_bits = io->error_bits;
@@ -432,7 +426,7 @@ static int async_io(struct dm_io_client *client, unsigned int num_regions,
 	io = mempool_alloc(client->pool, GFP_NOIO);
 	io->error_bits = 0;
 	atomic_set(&io->count, 1); /* see dispatch_io() */
-	io->sleeper = NULL;
+	io->wait = NULL;
 	io->client = client;
 	io->callback = fn;
 	io->context = context;
