Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933062AbaFIWt7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 18:49:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57195 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933172AbaFIWqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 18:46:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Knut Petersen <Knut_Petersen@t-online.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Weng Meiling <wengmeiling.weng@huawei.com>
Subject: [PATCH 3.10 38/40] perf: Enforce 1 as lower limit for perf_event_max_sample_rate
Date: Mon,  9 Jun 2014 15:49:09 -0700
Message-Id: <20140609224840.454950708@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140609224839.127615063@linuxfoundation.org>
References: <20140609224839.127615063@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Knut Petersen <Knut_Petersen@t-online.de>

commit 723478c8a471403c53cf144999701f6e0c4bbd11 upstream.

/proc/sys/kernel/perf_event_max_sample_rate will accept
negative values as well as 0.

Negative values are unreasonable, and 0 causes a
divide by zero exception in perf_proc_update_handler.

This patch enforces a lower limit of 1.

Signed-off-by: Knut Petersen <Knut_Petersen@t-online.de>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/5242DB0C.4070005@t-online.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Weng Meiling <wengmeiling.weng@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/events/core.c |    2 +-
 kernel/sysctl.c      |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -190,7 +190,7 @@ int perf_proc_update_handler(struct ctl_
 		void __user *buffer, size_t *lenp,
 		loff_t *ppos)
 {
-	int ret = proc_dointvec(table, write, buffer, lenp, ppos);
+	int ret = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
 
 	if (ret || !write)
 		return ret;
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1049,6 +1049,7 @@ static struct ctl_table kern_table[] = {
 		.maxlen		= sizeof(sysctl_perf_event_sample_rate),
 		.mode		= 0644,
 		.proc_handler	= perf_proc_update_handler,
+		.extra1		= &one,
 	},
 	{
 		.procname	= "perf_cpu_time_max_percent",


