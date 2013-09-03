Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932359Ab3ICQ1U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 12:27:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46528 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932160Ab3ICQ1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 12:27:16 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 46/58] arm64: perf: fix array out of bounds access in armpmu_map_hw_event()
Date: Tue,  3 Sep 2013 09:23:50 -0700
Message-Id: <1378225442-20654-47-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378225442-20654-1-git-send-email-kamal@canonical.com>
References: <1378225442-20654-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit 868f6fea8fa63f09acbfa93256d0d2abdcabff79 upstream.

This is a port of d9f966357b14 ("ARM: 7810/1: perf: Fix array out of
bounds access in armpmu_map_hw_event()") to arm64, which fixes an oops
in the arm64 perf backend found as a result of Vince's fuzzing tool.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm64/kernel/perf_event.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/perf_event.c b/arch/arm64/kernel/perf_event.c
index 0256b68..8a724a1 100644
--- a/arch/arm64/kernel/perf_event.c
+++ b/arch/arm64/kernel/perf_event.c
@@ -107,7 +107,12 @@ armpmu_map_cache_event(const unsigned (*cache_map)
 static int
 armpmu_map_event(const unsigned (*event_map)[PERF_COUNT_HW_MAX], u64 config)
 {
-	int mapping = (*event_map)[config];
+	int mapping;
+
+	if (config >= PERF_COUNT_HW_MAX)
+		return -EINVAL;
+
+	mapping = (*event_map)[config];
 	return mapping == HW_OP_UNSUPPORTED ? -ENOENT : mapping;
 }
 
-- 
1.8.1.2

