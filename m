Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178Ab3JAUf1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 16:35:27 -0400
Received: from mout.gmx.net ([212.227.17.22]:59419 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751930Ab3JAUfZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 16:35:25 -0400
Date: Tue, 1 Oct 2013 22:35:20 +0200
From: Helge Deller <deller@gmx.de>
To: Tejun Heo <tj@kernel.org>, Libin <huawei.libin@huawei.com>,
        linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH] [workqueue] check values of pwq and wq in
 print_worker_info() before use
Message-ID: <20131001203520.GA8248@p100.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V03:K0:53QxMYK8HIrwqv4zJhrCJv/5sRXXelopc9OvaW/QfO8lcVTln+H
 T3sQ2es/y0UT91qDzP6vOxtc+snbb9s+/+SRjk4OMI8A6IeL0mi51zDiXgpKZdpkJfsxyU4
 yXoeIgvGgWydh7QpzE+SrlLFA9uWOtqT/1zM1KJ1f/0iGvIGbN5Wh+1i/sIz57EGbmijD97
 V/2e4NyCsV+aq8g0z5cjQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

print_worker_info() includes no validity check on the pwq and wq
pointers before handing them over to the probe_kernel_read() functions.

It seems that most architectures don't care about that, but at least on
the parisc architecture this leads to a kernel crash since accesses to
page zero are protected by the kernel for security reasons.

Fix this problem by verifying the contents of pwq and wq before usage.
Even if probe_kernel_read() usually prevents such crashes by disabling
page faults, clean code should always include such checks. 

Without this fix issuing "echo t > /proc/sysrq-trigger" will immediately
crash the Linux kernel on the parisc architecture.

CC: Tejun Heo <tj@kernel.org>
CC: Libin <huawei.libin@huawei.com>
CC: linux-parisc@vger.kernel.org
CC: James.Bottomley@HansenPartnership.com
Signed-off-by: Helge Deller <deller@gmx.de>

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 987293d..c03b47f 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -4512,8 +4512,10 @@ void print_worker_info(const char *log_lvl, struct task_struct *task)
 	 */
 	probe_kernel_read(&fn, &worker->current_func, sizeof(fn));
 	probe_kernel_read(&pwq, &worker->current_pwq, sizeof(pwq));
-	probe_kernel_read(&wq, &pwq->wq, sizeof(wq));
-	probe_kernel_read(name, wq->name, sizeof(name) - 1);
+	if (pwq)
+		probe_kernel_read(&wq, &pwq->wq, sizeof(wq));
+	if (wq)
+		probe_kernel_read(name, wq->name, sizeof(name) - 1);
 
 	/* copy worker description */
 	probe_kernel_read(&desc_valid, &worker->desc_valid, sizeof(desc_valid));
