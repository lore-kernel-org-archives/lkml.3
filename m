Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933784AbaE2FDG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 01:03:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58382 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932965AbaE2EiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:38:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 3.10 07/86] tracepoint: Do not waste memory on mods with no tracepoints
Date: Wed, 28 May 2014 21:36:42 -0700
Message-Id: <20140529043514.486988385@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043513.451722422@linuxfoundation.org>
References: <20140529043513.451722422@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

commit 7dec935a3aa04412cba2cebe1524ae0d34a30c24 upstream.

No reason to allocate tp_module structures for modules that have no
tracepoints. This just wastes memory.

Fixes: b75ef8b44b1c "Tracepoint: Dissociate from module mutex"
Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/tracepoint.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -641,6 +641,9 @@ static int tracepoint_module_coming(stru
 	struct tp_module *tp_mod, *iter;
 	int ret = 0;
 
+	if (!mod->num_tracepoints)
+		return 0;
+
 	/*
 	 * We skip modules that taint the kernel, especially those with different
 	 * module headers (for forced load), to make sure we don't cause a crash.
@@ -684,6 +687,9 @@ static int tracepoint_module_going(struc
 {
 	struct tp_module *pos;
 
+	if (!mod->num_tracepoints)
+		return 0;
+
 	mutex_lock(&tracepoints_mutex);
 	tracepoint_update_probe_range(mod->tracepoints_ptrs,
 		mod->tracepoints_ptrs + mod->num_tracepoints);


