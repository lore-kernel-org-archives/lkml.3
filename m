Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933686AbaDIOWb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 10:22:31 -0400
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:42083 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933489AbaDIOWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 10:22:17 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, KVM <kvm@vger.kernel.org>,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PULL 2/2] perf-kvm: fix of 'Min time' counting in report command
Date: Wed,  9 Apr 2014 16:21:59 +0200
Message-Id: <1397053319-2130-3-git-send-email-borntraeger@de.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1397053319-2130-1-git-send-email-borntraeger@de.ibm.com>
References: <1397053319-2130-1-git-send-email-borntraeger@de.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14040914-3548-0000-0000-000008ADFF85
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
---
 tools/perf/builtin-kvm.c |    1 +
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
1.7.9.5

