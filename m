Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756448Ab3CDJNU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 04:13:20 -0500
Received: from mga02.intel.com ([134.134.136.20]:64910 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755016Ab3CDJJy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 04:09:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,778,1355126400"; 
   d="scan'208";a="270536369"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 07/10] dmatest: return actual state in 'run' file
Date: Mon,  4 Mar 2013 11:09:31 +0200
Message-Id: <1362388174-3435-8-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.2.rc0.22.gb3600c3
In-Reply-To: <1362388174-3435-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1362388174-3435-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following command should return actual state of the test.
	% cat /sys/kernel/debug/dmatest/run

To wait for test done the user may perform a busy loop that checks the state.
	% while [ $(cat /sys/kernel/debug/dmatest/run) = "Y" ]
	> do
	> 	echo -n "."
	> 	sleep 1
	> done
	> echo

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 Documentation/dmatest.txt | 12 ++++++++++++
 drivers/dma/dmatest.c     | 23 +++++++++++++++++++++--
 2 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/Documentation/dmatest.txt b/Documentation/dmatest.txt
index 9a90729..3e17b55 100644
--- a/Documentation/dmatest.txt
+++ b/Documentation/dmatest.txt
@@ -36,6 +36,18 @@ in the original code.
 
 Note that running a new test will stop any in progress test.
 
+The following command should return actual state of the test.
+	% cat /sys/kernel/debug/dmatest/run
+
+To wait for test done the user may perform a busy loop that checks the state.
+
+	% while [ $(cat /sys/kernel/debug/dmatest/run) = "Y" ]
+	> do
+	> 	echo -n "."
+	> 	sleep 1
+	> done
+	> echo
+
 	Part 3 - When built-in in the kernel...
 
 The module parameters that is supplied to the kernel command line will be used
diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index fc31542..d19234b 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -93,6 +93,7 @@ struct dmatest_thread {
 	u8			**srcs;
 	u8			**dsts;
 	enum dma_transaction_type type;
+	bool			done;
 };
 
 struct dmatest_chan {
@@ -603,6 +604,8 @@ err_thread_type:
 	if (ret)
 		dmaengine_terminate_all(chan);
 
+	thread->done = true;
+
 	if (params->iterations > 0)
 		while (!kthread_should_stop()) {
 			DECLARE_WAIT_QUEUE_HEAD_ONSTACK(wait_dmatest_exit);
@@ -884,12 +887,28 @@ static ssize_t dtf_read_run(struct file *file, char __user *user_buf,
 {
 	struct dmatest_info *info = file->private_data;
 	char buf[3];
+	struct dmatest_chan *dtc;
+	bool alive = false;
 
 	mutex_lock(&info->lock);
-	if (info->nr_channels)
+	list_for_each_entry(dtc, &info->channels, node) {
+		struct dmatest_thread *thread;
+
+		list_for_each_entry(thread, &dtc->threads, node) {
+			if (!thread->done) {
+				alive = true;
+				break;
+			}
+		}
+	}
+
+	if (alive) {
 		buf[0] = 'Y';
-	else
+	} else {
+		__stop_threaded_test(info);
 		buf[0] = 'N';
+	}
+
 	mutex_unlock(&info->lock);
 	buf[1] = '\n';
 	buf[2] = 0x00;
-- 
1.8.2.rc0.22.gb3600c3

