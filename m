Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558AbaFCMOC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 08:14:02 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43400 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932418AbaFCLkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:40:53 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 041/138] tracepoint: Do not waste memory on mods with no tracepoints
Date: Tue,  3 Jun 2014 12:38:07 +0100
Message-Id: <1401795584-22664-42-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
References: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

commit 7dec935a3aa04412cba2cebe1524ae0d34a30c24 upstream.

No reason to allocate tp_module structures for modules that have no
tracepoints. This just wastes memory.

Fixes: b75ef8b44b1c "Tracepoint: Dissociate from module mutex"
Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/tracepoint.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index 031cc5655a51..63630aef3bd3 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -641,6 +641,9 @@ static int tracepoint_module_coming(struct module *mod)
 	struct tp_module *tp_mod, *iter;
 	int ret = 0;
 
+	if (!mod->num_tracepoints)
+		return 0;
+
 	/*
 	 * We skip modules that taint the kernel, especially those with different
 	 * module headers (for forced load), to make sure we don't cause a crash.
@@ -684,6 +687,9 @@ static int tracepoint_module_going(struct module *mod)
 {
 	struct tp_module *pos;
 
+	if (!mod->num_tracepoints)
+		return 0;
+
 	mutex_lock(&tracepoints_mutex);
 	tracepoint_update_probe_range(mod->tracepoints_ptrs,
 		mod->tracepoints_ptrs + mod->num_tracepoints);
-- 
1.9.1

