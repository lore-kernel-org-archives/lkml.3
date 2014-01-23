Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989AbaAWOeJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 09:34:09 -0500
Received: from cnbjrel01.sonyericsson.com ([219.141.167.165]:2808 "EHLO
	cnbjrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752773AbaAWOeH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 09:34:07 -0500
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'Will Deacon'" <will.deacon@arm.com>
CC: "'linux-mmc@vger.kernel.org'" <linux-mmc@vger.kernel.org>,
        "'cjb@laptop.org'" <cjb@laptop.org>,
        "'tgih.jun@samsung.com'" <tgih.jun@samsung.com>,
        "'kdorfman@codeaurora.org'" <kdorfman@codeaurora.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'kdorfman@codeaurora.org'" <kdorfman@codeaurora.org>,
        "'linkinjeon@gmail.com'" <linkinjeon@gmail.com>
Date: Thu, 23 Jan 2014 22:34:00 +0800
Subject: RE: FW: bug fix for mmc  queue.c
Thread-Topic: FW: bug fix for mmc  queue.c
Thread-Index: Ac8YQ4qUUj6qKS7jQhaUlUCwkfUNAAAAXNQQ
Message-ID: <35FD53F367049845BC99AC72306C23D1023A478B1AF3@CNBJMBX05.corpusers.net>
References: <35FD53F367049845BC99AC72306C23D1023A478B1AF0@CNBJMBX05.corpusers.net>
 <20140123140049.GB2355@mudshark.cambridge.arm.com>
In-Reply-To: <20140123140049.GB2355@mudshark.cambridge.arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi  Will,

Wow ,  Thank you very much for your kindly help to me .
I think the suggestions you mentioned are very very important and useful to me ,
I am really a freshman in Linux Opensource Community .

As for the patch ,
The reason why use PAGE_SIZE to decide to use vmalloc or kmalloc is that
If the request size is more than a PAGE_SIZE, use vmalloc will be more efficient and will
Not must use physical continuous memory .
  
Kmalloc is more useful for small objects allocation .
I just refer to this function to use like this:

struct xt_table_info *xt_alloc_table_info(unsigned int size) 
{
	...
}


The vmalloc used here are just used for allocating struct scatterlist objects,
These objects are just used by software to manage physical pages,
They will not be used by DMA, so I think it is safe to use vmalloc if possible .

Sometimes this allocation will fail, if we need allocate lots of scatterlist objects:

mmc1: new high speed SD card at address 1234
kworker/u:29: page allocation failure: order:5, mode:0x40d0
[<c010c514>] (unwind_backtrace+0x0/0x11c) from [<c0217e78>] (warn_alloc_failed+0x104/0x130)
[<c0217e78>] (warn_alloc_failed+0x104/0x130) from [<c021b39c>] (__alloc_pages_nodemask+0x7d4/0x8f4)
[<c021b39c>] (__alloc_pages_nodemask+0x7d4/0x8f4) from [<c021b510>] (__get_free_pages+0x10/0x24)
[<c021b510>] (__get_free_pages+0x10/0x24) from [<c0246630>] (kmalloc_order_trace+0x20/0xe0)
[<c0246630>] (kmalloc_order_trace+0x20/0xe0) from [<c0249550>] (__kmalloc+0x30/0x270)
[<c0249550>] (__kmalloc+0x30/0x270) from [<c061cdbc>] (mmc_alloc_sg+0x18/0x40)
[<c061cdbc>] (mmc_alloc_sg+0x18/0x40) from [<c061d524>] (mmc_init_queue+0x418/0x4fc)
[<c061d524>] (mmc_init_queue+0x418/0x4fc) from [<c06195a0>] (mmc_blk_alloc_req+0x18c/0x3d0)
[<c06195a0>] (mmc_blk_alloc_req+0x18c/0x3d0) from [<c061b2a8>] (mmc_blk_probe+0x74/0x2c0)
[<c061b2a8>] (mmc_blk_probe+0x74/0x2c0) from [<c060d68c>] (mmc_bus_probe+0x14/0x18)
[<c060d68c>] (mmc_bus_probe+0x14/0x18) from [<c045a928>] (driver_probe_device+0x134/0x334)
[<c045a928>] (driver_probe_device+0x134/0x334) from [<c0458e0c>] (bus_for_each_drv+0x48/0x8c)
[<c0458e0c>] (bus_for_each_drv+0x48/0x8c) from [<c045a77c>] (device_attach+0x7c/0xa0)
[<c045a77c>] (device_attach+0x7c/0xa0) from [<c0459ca0>] (bus_probe_device+0x28/0x98)
[<c0459ca0>] (bus_probe_device+0x28/0x98) from [<c04583f0>] (device_add+0x3f4/0x5a8)
[<c04583f0>] (device_add+0x3f4/0x5a8) from [<c060dd7c>] (mmc_add_card+0x1f0/0x2e8)
[<c060dd7c>] (mmc_add_card+0x1f0/0x2e8) from [<c0613990>] (mmc_attach_sd+0x234/0x278)
[<c0613990>] (mmc_attach_sd+0x234/0x278) from [<c060cab8>] (mmc_rescan+0x24c/0x2cc)
[<c060cab8>] (mmc_rescan+0x24c/0x2cc) from [<c01a2a40>] (process_one_work+0x200/0x400)
[<c01a2a40>] (process_one_work+0x200/0x400) from [<c01a2df0>] (worker_thread+0x184/0x2a4)
[<c01a2df0>] (worker_thread+0x184/0x2a4) from [<c01a74ac>] (kthread+0x80/0x90)
[<c01a74ac>] (kthread+0x80/0x90) from [<c0106aec>] (kernel_thread_exit+0x0/0x8)

In this case, it will allocate 32*4kB = 128KB for scatterlist allocation and failed,
Especially on platforms which has memory less than 1GB .

I Add the patch here in case someone need to see it :

------------------------------------------->

diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
index cef1a41..839b506 100644
--- a/drivers/mmc/card/queue.c
+++ b/drivers/mmc/card/queue.c
@@ -15,6 +15,7 @@
 #include <linux/freezer.h>
 #include <linux/kthread.h>
 #include <linux/scatterlist.h>
+#include <linux/vmalloc.h>
 
 #include <linux/mmc/card.h>
 #include <linux/mmc/host.h>
@@ -198,8 +199,13 @@ static void mmc_urgent_request(struct request_queue *q)
 static struct scatterlist *mmc_alloc_sg(int sg_len, int *err)
 {
 	struct scatterlist *sg;
+	size_t size = sizeof(struct scatterlist)*sg_len;
+
+	if (size >= PAGE_SIZE)
+		sg = vmalloc(size);
+	else
+		sg = kmalloc(size, GFP_KERNEL);
 
-	sg = kmalloc(sizeof(struct scatterlist)*sg_len, GFP_KERNEL);
 	if (!sg)
 		*err = -ENOMEM;
 	else {
@@ -210,6 +216,14 @@ static struct scatterlist *mmc_alloc_sg(int sg_len, int *err)
 	return sg;
 }
 
+static void mmc_alloc_free(const void *addr)
+{
+	if (is_vmalloc_addr(addr))
+		vfree(addr);
+	else
+		kfree(addr);
+}
+
 static void mmc_queue_setup_discard(struct request_queue *q,
 				    struct mmc_card *card)
 {
@@ -397,20 +411,20 @@ success:
 
 	return 0;
  free_bounce_sg:
-	kfree(mqrq_cur->bounce_sg);
+	mmc_alloc_free(mqrq_cur->bounce_sg);
 	mqrq_cur->bounce_sg = NULL;
-	kfree(mqrq_prev->bounce_sg);
+	mmc_alloc_free(mqrq_prev->bounce_sg);
 	mqrq_prev->bounce_sg = NULL;
 
  cleanup_queue:
-	kfree(mqrq_cur->sg);
+	mmc_alloc_free(mqrq_cur->sg);
 	mqrq_cur->sg = NULL;
-	kfree(mqrq_cur->bounce_buf);
+	mmc_alloc_free(mqrq_cur->bounce_buf);
 	mqrq_cur->bounce_buf = NULL;
 
-	kfree(mqrq_prev->sg);
+	mmc_alloc_free(mqrq_prev->sg);
 	mqrq_prev->sg = NULL;
-	kfree(mqrq_prev->bounce_buf);
+	mmc_alloc_free(mqrq_prev->bounce_buf);
 	mqrq_prev->bounce_buf = NULL;
 
 	blk_cleanup_queue(mq->queue);
@@ -436,22 +450,22 @@ void mmc_cleanup_queue(struct mmc_queue *mq)
 	blk_start_queue(q);
 	spin_unlock_irqrestore(q->queue_lock, flags);
 
-	kfree(mqrq_cur->bounce_sg);
+	mmc_alloc_free(mqrq_cur->bounce_sg);
 	mqrq_cur->bounce_sg = NULL;
 
-	kfree(mqrq_cur->sg);
+	mmc_alloc_free(mqrq_cur->sg);
 	mqrq_cur->sg = NULL;
 
-	kfree(mqrq_cur->bounce_buf);
+	mmc_alloc_free(mqrq_cur->bounce_buf);
 	mqrq_cur->bounce_buf = NULL;
 
-	kfree(mqrq_prev->bounce_sg);
+	mmc_alloc_free(mqrq_prev->bounce_sg);
 	mqrq_prev->bounce_sg = NULL;
 
-	kfree(mqrq_prev->sg);
+	mmc_alloc_free(mqrq_prev->sg);
 	mqrq_prev->sg = NULL;
 
-	kfree(mqrq_prev->bounce_buf);
+	mmc_alloc_free(mqrq_prev->bounce_buf);
 	mqrq_prev->bounce_buf = NULL;
 
 	mq->card = NULL;

--------------------------------------->


-----Original Message-----
From: Will Deacon [mailto:will.deacon@arm.com] 
Sent: Thursday, January 23, 2014 10:01 PM
To: Wang, Yalin
Subject: Re: FW: bug fix for mmc queue.c

On Thu, Jan 23, 2014 at 08:14:56AM +0000, Wang, Yalin wrote:
> Hi  Will,

Hello,

> I am not sure if you have received this mail, I have send it to linux 
> mail list , But seems no one reply to me ,

Hmm, I didn't see the mail, but you could do a few things in future to make it more likely that people will reply:

  (1) Make sure you put the maintainers on CC. For example:

    $ ./scripts/get_maintainer.pl < /tmp/patch.diff
    Chris Ball <cjb@laptop.org> (maintainer:MULTIMEDIA CARD (...,commit_signer:7/8=88%)
    Seungwon Jeon <tgih.jun@samsung.com> (commit_signer:6/8=75%)
    Konstantin Dorfman <kdorfman@codeaurora.org> (commit_signer:4/8=50%)
    Maya Erez <merez@codeaurora.org> (commit_signer:2/8=25%)
    Namjae Jeon <linkinjeon@gmail.com> (commit_signer:1/8=12%)
    linux-mmc@vger.kernel.org (open list:MULTIMEDIA CARD (...)
    linux-kernel@vger.kernel.org (open list)

  (2) Make sure your lines are wrapped at 80 chars in your email.

  (3) Don't include your patch as an attachment. Instead, include it inline
      after the email. (You can add a --->8 symbol to mark the end of the
      email and the start of the patch).

As for your patch, MMC isn't my area of expertise but I immediately have a few questions:

  - Why is PAGE_SIZE the right limit to decide between kmalloc and vmalloc?
  - vmalloc doesn't return physically-contiguous pages. Is this always safe
    for the sg DMA (can you have segments bigger than a page?).

Will
