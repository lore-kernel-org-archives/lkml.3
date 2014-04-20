Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161134AbaDTIE1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 04:04:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55742 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932111AbaDTIEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 04:04:07 -0400
Date: Sun, 20 Apr 2014 01:03:33 -0700
From: tip-bot for Alexander Yarygin <tipbot@zytor.com>
Message-ID: <tip-acb61fc8ed73eb477a9044272d7a1b1f5a572f91@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        borntraeger@de.ibm.com, jolsa@redhat.com, yarygin@linux.vnet.ibm.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, jolsa@redhat.com, yarygin@linux.vnet.ibm.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1397053319-2130-3-git-send-email-borntraeger@de.ibm.com>
References: <1397053319-2130-3-git-send-email-borntraeger@de.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf kvm: Fix 'Min time'
  counting in report command
Git-Commit-ID: acb61fc8ed73eb477a9044272d7a1b1f5a572f91
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  acb61fc8ed73eb477a9044272d7a1b1f5a572f91
Gitweb:     http://git.kernel.org/tip/acb61fc8ed73eb477a9044272d7a1b1f5a572f91
Author:     Alexander Yarygin <yarygin@linux.vnet.ibm.com>
AuthorDate: Wed, 9 Apr 2014 16:21:59 +0200
Committer:  Jiri Olsa <jolsa@redhat.com>
CommitDate: Sun, 20 Apr 2014 00:14:08 +0200

perf kvm: Fix 'Min time' counting in report command

Every event in the perf-kvm has a 'stats' structure, which contains
max/min/average/etc times of handling this event.
The problem is that the 'perf-kvm stat report' command always shows
that 'min time' is 0us for every event. Example:

 # perf kvm stat report

 Analyze events for all VCPUs:

    VM-EXIT    Samples  Samples%     Time%   Min Time   Max Time Avg time
  [..]
  0xB2 MSCH         12     0.07%     0.00%        0us        8us 7.31us ( +-   2.11% )
  0xB2 CHSC         12     0.07%     0.00%        0us       18us 9.39us ( +-   9.49% )
  0xB2 STPX          8     0.05%     0.00%        0us        2us 1.88us ( +-   7.18% )
  0xB2 STSI          7     0.04%     0.00%        0us       44us 16.49us ( +-  38.20% )
  [..]

This happens because the 'stats' structure is not initialized and
stats->min equals to 0. Lets initialize the structure for every
event after its allocation using init_stats() function. This initializes
stats->min to -1 and makes 'Min time' statistics counting work:

 # perf kvm stat report

 Analyze events for all VCPUs:

    VM-EXIT    Samples  Samples%     Time%   Min Time   Max Time Avg time
  [..]
  0xB2 MSCH         12     0.07%     0.00%        6us        8us 7.31us ( +-   2.11% )
  0xB2 CHSC         12     0.07%     0.00%        7us       18us 9.39us ( +-   9.49% )
  0xB2 STPX          8     0.05%     0.00%        1us        2us 1.88us ( +-   7.18% )
  0xB2 STSI          7     0.04%     0.00%        1us       44us 16.49us ( +-  38.20% )
  [..]

Signed-off-by: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
Link: http://lkml.kernel.org/r/1397053319-2130-3-git-send-email-borntraeger@de.ibm.com
[ Fixing the perf examples changelog output ]
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/builtin-kvm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 21c164b..0f1e5a2 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -404,6 +404,7 @@ static struct kvm_event *kvm_alloc_init_event(struct event_key *key)
 	}
 
 	event->key = *key;
+	init_stats(&event->total.stats);
 	return event;
 }
 
