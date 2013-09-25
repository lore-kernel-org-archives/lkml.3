Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757004Ab3IYA0R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 20:26:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39802 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756798Ab3IYAVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:21:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Greg Thelen <gthelen@google.com>, Michal Hocko <mhocko@suse.cz>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 099/117] memcg: fix multiple large threshold notifications
Date: Tue, 24 Sep 2013 17:19:25 -0700
Message-Id: <20130925001751.737359877@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001740.833541979@linuxfoundation.org>
References: <20130925001740.833541979@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/memcontrol.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5616,7 +5616,13 @@ static int compare_thresholds(const void
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


