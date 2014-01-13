Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751809AbaAMNBR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 08:01:17 -0500
Received: from adelie.canonical.com ([91.189.90.139]:39531 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbaAMNBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 08:01:13 -0500
Subject: [PATCH 1/7] sched: allow try_to_wake_up to be used internally outside
 of core.c
To: linux-kernel@vger.kernel.org
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: linux-arch@vger.kernel.org, ccross@google.com,
        linaro-mm-sig@lists.linaro.org, robdclark@gmail.com,
        dri-devel@lists.freedesktop.org, daniel@ffwll.ch,
        sumit.semwal@linaro.org, linux-media@vger.kernel.org
Date: Mon, 13 Jan 2014 13:31:31 +0100
Message-ID: <20140113123126.20574.74329.stgit@patser>
In-Reply-To: <20140113122818.20574.34710.stgit@patser>
References: <20140113122818.20574.34710.stgit@patser>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel fence implementation doesn't use event queues, but needs
to perform the same wake up. The symbol is not exported, since the
fence implementation is not built as a module.

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
---
 include/linux/wait.h |    1 +
 kernel/sched/core.c  |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/wait.h b/include/linux/wait.h
index eaa00b10abaa..c54e3ef50134 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -12,6 +12,7 @@
 typedef struct __wait_queue wait_queue_t;
 typedef int (*wait_queue_func_t)(wait_queue_t *wait, unsigned mode, int flags, void *key);
 int default_wake_function(wait_queue_t *wait, unsigned mode, int flags, void *key);
+int try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags);
 
 struct __wait_queue {
 	unsigned int		flags;
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index a88f4a485c5e..f41d317042dd 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1578,7 +1578,7 @@ static void ttwu_queue(struct task_struct *p, int cpu)
  * Return: %true if @p was woken up, %false if it was already running.
  * or @state didn't match @p's state.
  */
-static int
+int
 try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
 {
 	unsigned long flags;

