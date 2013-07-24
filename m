Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751310Ab3GXC0z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 22:26:55 -0400
Received: from ozlabs.org ([203.10.76.45]:53808 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750864Ab3GXC0y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 22:26:54 -0400
From: Michael Ellerman <michael@ellerman.id.au>
To: <linux-kernel@vger.kernel.org>
Cc: acme@ghostprotocols.net, a.p.zijlstra@chello.nl, mingo@redhat.com,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>
Subject: [PATCH] perf tools: Add support for pinned modifier
Date: Wed, 24 Jul 2013 12:26:42 +1000
Message-Id: <1374632802-15436-1-git-send-email-michael@ellerman.id.au>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit adds support for a new modifier "P", which requests that the
event, or group of events, be pinned to the PMU.

This is an oft-requested feature from our HW folks, who want to be able
to run a large number of events, but also want 100% accurate results for
instructions per cycle.

Comparison of results with and without pinning:

$ perf stat -e '{cycles,instructions}:P' -e cycles,instructions,...

  79,590,480,683 cycles         #  0.000 GHz
 166,123,716,524 instructions   #  2.09  insns per cycle
                                #  0.11  stalled cycles per insn
  79,352,134,463 cycles         #  0.000 GHz                     [11.11%]
 165,178,301,818 instructions   #  2.08  insns per cycle
                                #  0.11  stalled cycles per insn [11.13%]

As you can see although perf does a very good job of scaling the values
in the non-pinned case, there is some small discrepancy.

The patch is fairly straight forward, the one detail is that we need to
make sure we only request pinning for the group leader when we have a
group.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
---

I would have used "p" obviously, but that's taken. Are folks happy that
"P" is sufficiently different from "p"? I couldn't think of anything
better.
---
 tools/perf/Documentation/perf-list.txt | 1 +
 tools/perf/util/parse-events.c         | 9 +++++++++
 tools/perf/util/parse-events.l         | 2 +-
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/tools/perf/Documentation/perf-list.txt b/tools/perf/Documentation/perf-list.txt
index 826f3d6..7ecf655 100644
--- a/tools/perf/Documentation/perf-list.txt
+++ b/tools/perf/Documentation/perf-list.txt
@@ -29,6 +29,7 @@ counted. The following modifiers exist:
  G - guest counting (in KVM guests)
  H - host counting (not in KVM guests)
  p - precise level
+ P - pin the event to the PMU
 
 The 'p' modifier can be used for specifying how precise the instruction
 address should be. The 'p' modifier can be specified multiple times:
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 2c460ed..962093a 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -687,6 +687,7 @@ struct event_modifier {
 	int eG;
 	int precise;
 	int exclude_GH;
+	int pinned;
 };
 
 static int get_event_modifier(struct event_modifier *mod, char *str,
@@ -698,6 +699,7 @@ static int get_event_modifier(struct event_modifier *mod, char *str,
 	int eH = evsel ? evsel->attr.exclude_host : 0;
 	int eG = evsel ? evsel->attr.exclude_guest : 0;
 	int precise = evsel ? evsel->attr.precise_ip : 0;
+	int pinned = evsel ? evsel->attr.pinned : 0;
 
 	int exclude = eu | ek | eh;
 	int exclude_GH = evsel ? evsel->exclude_GH : 0;
@@ -730,6 +732,8 @@ static int get_event_modifier(struct event_modifier *mod, char *str,
 			/* use of precise requires exclude_guest */
 			if (!exclude_GH)
 				eG = 1;
+		} else if (*str == 'P') {
+			pinned = 1;
 		} else
 			break;
 
@@ -756,6 +760,8 @@ static int get_event_modifier(struct event_modifier *mod, char *str,
 	mod->eG = eG;
 	mod->precise = precise;
 	mod->exclude_GH = exclude_GH;
+	mod->pinned = pinned;
+
 	return 0;
 }
 
@@ -806,6 +812,9 @@ int parse_events__modifier_event(struct list_head *list, char *str, bool add)
 		evsel->attr.exclude_host   = mod.eH;
 		evsel->attr.exclude_guest  = mod.eG;
 		evsel->exclude_GH          = mod.exclude_GH;
+
+		if (evsel->leader == evsel)
+			evsel->attr.pinned = mod.pinned;
 	}
 
 	return 0;
diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
index e9d1134..587dac0 100644
--- a/tools/perf/util/parse-events.l
+++ b/tools/perf/util/parse-events.l
@@ -82,7 +82,7 @@ num_hex		0x[a-fA-F0-9]+
 num_raw_hex	[a-fA-F0-9]+
 name		[a-zA-Z_*?][a-zA-Z0-9_*?]*
 name_minus	[a-zA-Z_*?][a-zA-Z0-9\-_*?]*
-modifier_event	[ukhpGH]+
+modifier_event	[ukhpGHP]+
 modifier_bp	[rwx]{1,3}
 
 %%
-- 
1.8.1.2

