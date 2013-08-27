Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821Ab3H0BIi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 21:08:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59657 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689Ab3H0BHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 21:07:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [ 45/74] arm64: perf: fix array out of bounds access in armpmu_map_hw_event()
Date: Mon, 26 Aug 2013 18:08:43 -0700
Message-Id: <20130827010433.999570304@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130827010424.535365435@linuxfoundation.org>
References: <20130827010424.535365435@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit 868f6fea8fa63f09acbfa93256d0d2abdcabff79 upstream.

This is a port of d9f966357b14 ("ARM: 7810/1: perf: Fix array out of
bounds access in armpmu_map_hw_event()") to arm64, which fixes an oops
in the arm64 perf backend found as a result of Vince's fuzzing tool.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/kernel/perf_event.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/arch/arm64/kernel/perf_event.c
+++ b/arch/arm64/kernel/perf_event.c
@@ -107,7 +107,12 @@ armpmu_map_cache_event(const unsigned (*
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
 


