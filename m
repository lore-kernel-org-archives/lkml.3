Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751013AbaCAF5h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 00:57:37 -0500
Received: from mail-vc0-f202.google.com ([209.85.220.202]:35290 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbaCAF5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 00:57:36 -0500
From: Filipe Brandenburger <filbranden@google.com>
To: Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizefan@huawei.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org,
        Filipe Brandenburger <filbranden@google.com>
Subject: [PATCH 2/3] tracing: evaluate len expression only once in __dynamic_array macro
Date: Fri, 28 Feb 2014 21:32:17 -0800
Message-Id: <1393651938-16418-3-git-send-email-filbranden@google.com>
X-Mailer: git-send-email 1.9.0.279.gdc9e3eb
In-Reply-To: <1393651938-16418-1-git-send-email-filbranden@google.com>
References: <1393651938-16418-1-git-send-email-filbranden@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a temporary variable to store the expansion of the len expression.
If the evaluation is expensive, this commit will ensure it is evaluated
only once inside ftrace_get_offsets_<call>.

Signed-off-by: Filipe Brandenburger <filbranden@google.com>
---
 include/trace/ftrace.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 82e8d89..86a056a 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -373,10 +373,11 @@ ftrace_define_fields_##call(struct ftrace_event_call *event_call)	\
 
 #undef __dynamic_array
 #define __dynamic_array(type, item, len)				\
+	__item_length = (len) * sizeof(type);				\
 	__data_offsets->item = __data_size +				\
 			       offsetof(typeof(*entry), __data);	\
-	__data_offsets->item |= ((len) * sizeof(type)) << 16;		\
-	__data_size += (len) * sizeof(type);
+	__data_offsets->item |= __item_length << 16;			\
+	__data_size += __item_length;
 
 #undef __string
 #define __string(item, src) __dynamic_array(char, item,			\
@@ -388,6 +389,7 @@ static inline notrace int ftrace_get_offsets_##call(			\
 	struct ftrace_data_offsets_##call *__data_offsets, proto)       \
 {									\
 	int __data_size = 0;						\
+	int __maybe_unused __item_length;				\
 	struct ftrace_raw_##call __maybe_unused *entry;			\
 									\
 	tstruct;							\
-- 
1.9.0.279.gdc9e3eb

