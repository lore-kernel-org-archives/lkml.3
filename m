Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449Ab3JUJRs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 05:17:48 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39545 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753765Ab3JUIve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:51:34 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Greg Thelen" <gthelen@google.com>,
        "Johannes Weiner" <hannes@cmpxchg.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "Michal Hocko" <mhocko@suse.cz>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.798733980@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 066/149] memcg: fix multiple large threshold notifications
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 mm/memcontrol.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4385,7 +4385,13 @@ static int compare_thresholds(const void
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

