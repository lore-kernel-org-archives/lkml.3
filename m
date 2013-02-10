Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750950Ab3BJFWp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 00:22:45 -0500
Received: from mail-oa0-f45.google.com ([209.85.219.45]:33142 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768Ab3BJFWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 00:22:44 -0500
MIME-Version: 1.0
Date: Sun, 10 Feb 2013 13:22:43 +0800
Message-ID: <CAJd=RBCi0gRGf2ronNyGDBeNsBJkEZ6aTe29gVnTUD2qh6Bnog@mail.gmail.com>
Subject: [PATCH 1/2] stop_machine: check work->done while handling enqueued works
From: Hillf Danton <dhillf@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In cpu_stopper_thread(), @work->done may be NULL if the cpu stop work
is queued from stop_one_cpu_nowait(); however, cpu_stopper_thread()
updates @done->ret without checking whether @done exists or not when
the work function fails.

While this can lead to oops, the only current user of
stop_one_cpu_nowait() - active_load_balance_cpu_stop() - always
returns 0 and thus there's no in-kernel user which triggers this bug.

Fix it by checking whether @done exists before updating @done->ret.

Thanks Tejun for sharing commit message.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Reviewed-by: Namhyung Kim <namhyung@kernel.org>
---

--- a/kernel/stop_machine.c	Sun Feb 10 12:51:46 2013
+++ b/kernel/stop_machine.c	Sun Feb 10 12:58:58 2013
@@ -279,7 +279,7 @@ repeat:
 		preempt_disable();

 		ret = fn(arg);
-		if (ret)
+		if (ret && done)
 			done->ret = ret;

 		/* restore preemption and check it's still balanced */
--
