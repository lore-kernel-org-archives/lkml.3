Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751359AbaCAF4k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 00:56:40 -0500
Received: from mail-qc0-f201.google.com ([209.85.216.201]:36211 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbaCAF4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 00:56:39 -0500
From: Filipe Brandenburger <filbranden@google.com>
To: Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizefan@huawei.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org,
        Filipe Brandenburger <filbranden@google.com>
Subject: [PATCH 1/3] tracing: correctly expand len expressions from __dynamic_array macro
Date: Fri, 28 Feb 2014 21:32:16 -0800
Message-Id: <1393651938-16418-2-git-send-email-filbranden@google.com>
X-Mailer: git-send-email 1.9.0.279.gdc9e3eb
In-Reply-To: <1393651938-16418-1-git-send-email-filbranden@google.com>
References: <1393651938-16418-1-git-send-email-filbranden@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes expansion of the len argument in __dynamic_array macros.
The previous code from commit 7d536cb3f would not fully evaluate the
expression before multiplying its result by the size of the type.

This went unnoticed because the length stored in the high 16 bits of the
offset (which is the one that was broken here) is only used by
filter_pred_strloc which only acts on strings for which the size of the
type is 1.

Signed-off-by: Filipe Brandenburger <filbranden@google.com>
---
 include/trace/ftrace.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 1a8b28d..82e8d89 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -375,7 +375,7 @@ ftrace_define_fields_##call(struct ftrace_event_call *event_call)	\
 #define __dynamic_array(type, item, len)				\
 	__data_offsets->item = __data_size +				\
 			       offsetof(typeof(*entry), __data);	\
-	__data_offsets->item |= (len * sizeof(type)) << 16;		\
+	__data_offsets->item |= ((len) * sizeof(type)) << 16;		\
 	__data_size += (len) * sizeof(type);
 
 #undef __string
-- 
1.9.0.279.gdc9e3eb

