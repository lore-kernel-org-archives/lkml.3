Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878AbaDRKVP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 06:21:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31764 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034AbaDRKVK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 06:21:10 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 1/3] perf kvm: Fix of 'Min time' counting in report command
Date: Fri, 18 Apr 2014 12:20:41 +0200
Message-Id: <1397816443-14630-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1397816443-14630-1-git-send-email-jolsa@redhat.com>
References: <1397816443-14630-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Yarygin <yarygin@linux.vnet.ibm.com>

Every event in the perf-kvm has a 'stats' structure, which contains
max/min/average/etc times of handling this event.
The problem is that the 'perf-kvm stat report' command always shows
that 'min time' is 0us for every event. Example:

 # perf kvm stat report
Analyze events for all VCPUs:

    VM-EXIT    Samples  Samples%     Time%   Min Time   Max Time
    Avg time
[..]
0xB2 MSCH         12     0.07%     0.00%        0us        8us
    7.31us ( +-   2.11% )
0xB2 CHSC         12     0.07%     0.00%        0us       18us
    9.39us ( +-   9.49% )
0xB2 STPX          8     0.05%     0.00%        0us        2us
    1.88us ( +-   7.18% )
0xB2 STSI          7     0.04%     0.00%        0us       44us
    16.49us ( +-  38.20% )
[..]

This happens because 'stats' structure is not initialized and
stats->min equals to 0. Lets initialize the structure for every
event after it's allocation using init_stats() function. This initialize
stats->min to -1 and makes 'Min time' statistics counting work:

 # perf kvm stat report

Analyze events for all VCPUs:

    VM-EXIT    Samples  Samples%     Time%   Min Time   Max Time
    Avg time
[..]
0xB2 MSCH         12     0.07%     0.00%        6us        8us
    7.31us ( +-   2.11% )
0xB2 CHSC         12     0.07%     0.00%        7us       18us
    9.39us ( +-   9.49% )
0xB2 STPX          8     0.05%     0.00%        1us        2us
    1.88us ( +-   7.18% )
0xB2 STSI          7     0.04%     0.00%        1us       44us
    16.49us ( +-  38.20% )
[..]

Signed-off-by: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
Link: http://lkml.kernel.org/r/1397053319-2130-3-git-send-email-borntraeger@de.ibm.com
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
 
-- 
1.8.3.1

