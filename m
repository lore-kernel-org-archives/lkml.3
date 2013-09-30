Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866Ab3I3KNo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 06:13:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43807 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755825Ab3I3KNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:13:36 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Greg Thelen <gthelen@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 093/104] memcg: fix multiple large threshold notifications
Date: Mon, 30 Sep 2013 11:11:10 +0100
Message-Id: <1380535881-9239-94-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
References: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Thelen <gthelen@google.com>

commit 2bff24a3707093c435ab3241c47dcdb5f16e432b upstream.

A memory cgroup with (1) multiple threshold notifications and (2) at least
one threshold >=2G was not reliable.  Specifically the notifications would
either not fire or would not fire in the proper order.

The __mem_cgroup_threshold() signaling logic depends on keeping 64 bit
thresholds in sorted order.  mem_cgroup_usage_register_event() sorts them
with compare_thresholds(), which returns the difference of two 64 bit
thresholds as an int.  If the difference is positive but has bit[31] set,
then sort() treats the difference as negative and breaks sort order.

This fix compares the two arbitrary 64 bit thresholds returning the
classic -1, 0, 1 result.

The test below sets two notifications (at 0x1000 and 0x81001000):
  cd /sys/fs/cgroup/memory
  mkdir x
  for x in 4096 2164264960; do
    cgroup_event_listener x/memory.usage_in_bytes $x | sed "s/^/$x listener:/" &
  done
  echo $$ > x/cgroup.procs
  anon_leaker 500M

v3.11-rc7 fails to signal the 4096 event listener:
  Leaking...
  Done leaking pages.

Patched v3.11-rc7 properly notifies:
  Leaking...
  4096 listener:2013:8:31:14:13:36
  Done leaking pages.

The fixed bug is old.  It appears to date back to the introduction of
memcg threshold notifications in v2.6.34-rc1-116-g2e72b6347c94 "memcg:
implement memory thresholds"

Signed-off-by: Greg Thelen <gthelen@google.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 mm/memcontrol.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 08bcbd8..226b63e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4298,7 +4298,13 @@ static int compare_thresholds(const void *a, const void *b)
 	const struct mem_cgroup_threshold *_a = a;
 	const struct mem_cgroup_threshold *_b = b;
 
-	return _a->threshold - _b->threshold;
+	if (_a->threshold > _b->threshold)
+		return 1;
+
+	if (_a->threshold < _b->threshold)
+		return -1;
+
+	return 0;
 }
 
 static int mem_cgroup_oom_notify_cb(struct mem_cgroup *memcg)
-- 
1.8.3.2

