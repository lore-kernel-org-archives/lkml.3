Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751900AbbALMTL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 07:19:11 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:53039 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485AbbALMTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 07:19:09 -0500
From: Wang Nan <wangnan0@huawei.com>
To: <masami.hiramatsu.pt@hitachi.com>
CC: <tixy@linaro.org>, <linux@arm.linux.org.uk>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <lizefan@huawei.com>
Subject: [PATCH] kprobes: bugfix: checks kprobes_all_disarmed in unoptimized_kprobe().
Date: Mon, 12 Jan 2015 20:09:23 +0800
Message-ID: <1421064563-77831-1-git-send-email-wangnan0@huawei.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <54B3B32E.7070709@hitachi.com>
References: <54B3B32E.7070709@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Original code failed to disarm the probed instruction after

echo 0 > /sys/kernel/debug/kprobes/enabled

if OPTPROBE is enabled.

This patch checks kprobes_all_disarmed in unoptimized_kprobe().

Signed-off-by: Wang Nan <wangnan0@huawei.com>
---
 kernel/kprobes.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 9471710..f16936b 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -630,6 +630,9 @@ static void unoptimize_kprobe(struct kprobe *p, bool force)
 {
 	struct optimized_kprobe *op;
 
+	if (kprobes_all_disarmed)
+		return;
+
 	if (!kprobe_aggrprobe(p) || kprobe_disarmed(p))
 		return; /* This is not an optprobe nor optimized */
 
-- 
1.8.4

