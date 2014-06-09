Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934020AbaFIWuA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 18:50:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57190 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934323AbaFIWqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 18:46:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stephane Eranian <eranian@google.com>, peterz@infradead.org,
        dave.hansen@linux.intel.com, ak@linux.intel.com, jolsa@redhat.com,
        Ingo Molnar <mingo@kernel.org>,
        Weng Meiling <wengmeiling.weng@huawei.com>
Subject: [PATCH 3.10 37/40] perf: Fix interrupt handler timing harness
Date: Mon,  9 Jun 2014 15:49:08 -0700
Message-Id: <20140609224840.422698465@linuxfoundation.org>
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

From: Stephane Eranian <eranian@google.com>

commit e5302920da9ef23f9d19d4e9ac85704cc25bee7a upstream.

This patch fixes a serious bug in:

  14c63f17b1fd perf: Drop sample rate when sampling is too slow

There was an misunderstanding on the API of the do_div()
macro. It returns the remainder of the division and this
was not what the function expected leading to disabling the
interrupt latency watchdog.

This patch also remove a duplicate assignment in
perf_sample_event_took().

Signed-off-by: Stephane Eranian <eranian@google.com>
Cc: peterz@infradead.org
Cc: dave.hansen@linux.intel.com
Cc: ak@linux.intel.com
Cc: jolsa@redhat.com
Link: http://lkml.kernel.org/r/20130704223010.GA30625@quad
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Weng Meiling <wengmeiling.weng@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/events/core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -182,7 +182,7 @@ void update_perf_cpu_limits(void)
 	u64 tmp = perf_sample_period_ns;
 
 	tmp *= sysctl_perf_cpu_time_max_percent;
-	tmp = do_div(tmp, 100);
+	do_div(tmp, 100);
 	atomic_set(&perf_sample_allowed_ns, tmp);
 }
 
@@ -230,7 +230,7 @@ DEFINE_PER_CPU(u64, running_sample_lengt
 void perf_sample_event_took(u64 sample_len_ns)
 {
 	u64 avg_local_sample_len;
-	u64 local_samples_len = __get_cpu_var(running_sample_length);
+	u64 local_samples_len;
 
 	if (atomic_read(&perf_sample_allowed_ns) == 0)
 		return;


