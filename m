Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722AbaKTNy2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 08:54:28 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:62697 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbaKTNy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 08:54:26 -0500
X-AuditID: cbfec7f4-b7f6c6d00000120b-e9-546df28e15c3
Subject: [PATCH] random: wait for system_wq before pushing entropy into output
 pools
From: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
To: Tejun Heo <tj@kernel.org>, "Theodore Ts'o" <tytso@mit.edu>,
        linux-kernel@vger.kernel.org
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>,
        Dmitry Vyukov <dvyukov@google.com>
Date: Thu, 20 Nov 2014 16:54:21 +0400
Message-id: <20141120135421.3819.24114.stgit@buzz>
User-Agent: StGit/0.17.1-dirty
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLLMWRmVeSWpSXmKPExsVy+t/xa7p9n3JDDC781bXY9usRm8WEh23s
	Fj929rJaXN41h83i1/KjjBatPT/ZHdg8Fmwq9di0qpPNo+nMUWaPvi2rGD0+b5ILYI3isklJ
	zcksSy3St0vgylj5+QZjwR7eiqMH+BoYv3N1MXJySAiYSMxZ+4YdwhaTuHBvPVsXIxeHkMBS
	Romf0zcxQjiNTBIzNl9jBakSFgiT+PfjLxuIzSZgJrFt321GEFtEIEbiw9ylYJOYBQIkbl97
	D1bDIqAq8XrSH7BeXgEjieaGLWBxUQE5iZWXW6DighI/Jt9j6WLkAOpVl5gyJRdijLzE5jVv
	mScw8s1CUjULoWoWkqoFjMyrGEVTS5MLipPScw31ihNzi0vz0vWS83M3MUKC9MsOxsXHrA4x
	CnAwKvHwHnDMDRFiTSwrrsw9xCjBwawkwquxEyjEm5JYWZValB9fVJqTWnyIkYmDU6qBcXFl
	R4XyZvE7wb57M++oB+VfWhkrqnxmjsje1ZELvD0sln98W5n5W8gjh4WxN0I5P9PD5kW3i9cH
	gYOnt51Qanu0aa9b896t4kbNNsbu2/Z9KlzIo1DjL6Z/+cC+mVePy6nfC2W8ZSvE83ZqQJoZ
	5/cvv5+vqL7E8OPY6rJFMlH/rmZMfNd4WYmlOCPRUIu5qDgRALXhv9swAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First prototype of tool which injects random delays in random places
(implemented on top of kernel address sanitizer by Andrey Ryabinin)
have caught race right at the first try.

credit_entropy_bits() schedules work for pushing entropy from one pool
into another too early, when system_wq isn't yet created. It's called from
add_interrupt_randomness, so this path starts working right after enabling
interrupts in start_kernel, but system workqueues are initialized much
later in early_initcall(init_workqueues). It's impossible to create them
earlier because threads have to be forked from kthreadd.

This patch skips pushing if system_wq isn't here yet. Delaying this till
SYSTEM_RUNNING state might lead to significant lost of precious entropy.

Signed-off-by: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
Reported-and-tested-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---
 drivers/char/random.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 04645c0..d4a684f 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -683,7 +683,7 @@ retry:
 		 * full.
 		 */
 		if (entropy_bits > random_write_wakeup_bits &&
-		    r->initialized &&
+		    system_wq && r->initialized &&
 		    r->entropy_total >= 2*random_read_wakeup_bits) {
 			static struct entropy_store *last = &blocking_pool;
 			struct entropy_store *other = &blocking_pool;
@@ -695,7 +695,7 @@ retry:
 				last = other;
 			if (last->entropy_count <=
 			    3 * last->poolinfo->poolfracbits / 4) {
-				schedule_work(&last->push_work);
+				queue_work(system_wq, &last->push_work);
 				r->entropy_total = 0;
 			}
 		}

