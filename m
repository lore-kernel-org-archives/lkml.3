Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489AbbA2I7Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 03:59:24 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44737 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751763AbbA2I7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 03:59:21 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Daniel Borkmann <dborkman@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Richard Weinberger <richard@nod.at>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 128/176] x86, um: actually mark system call tables readonly
Date: Wed, 28 Jan 2015 15:29:18 +0100
Message-Id: <25aa5446d610a17b5729702efd490a0eaddb2f9c.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Borkmann <dborkman@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit b485342bd79af363c77ef1a421c4a0aef2de9812 upstream.

Commit a074335a370e ("x86, um: Mark system call tables readonly") was
supposed to mark the sys_call_table in UML as RO by adding the const,
but it doesn't have the desired effect as it's nevertheless being placed
into the data section since __cacheline_aligned enforces sys_call_table
being placed into .data..cacheline_aligned instead. We need to use
the ____cacheline_aligned version instead to fix this issue.

Before:

$ nm -v arch/x86/um/sys_call_table_64.o | grep -1 "sys_call_table"
                 U sys_writev
0000000000000000 D sys_call_table
0000000000000000 D syscall_table_size

After:

$ nm -v arch/x86/um/sys_call_table_64.o | grep -1 "sys_call_table"
                 U sys_writev
0000000000000000 R sys_call_table
0000000000000000 D syscall_table_size

Fixes: a074335a370e ("x86, um: Mark system call tables readonly")
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/x86/um/sys_call_table_32.c | 2 +-
 arch/x86/um/sys_call_table_64.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/um/sys_call_table_32.c b/arch/x86/um/sys_call_table_32.c
index 531d4269e2e3..bd16d6c370ec 100644
--- a/arch/x86/um/sys_call_table_32.c
+++ b/arch/x86/um/sys_call_table_32.c
@@ -34,7 +34,7 @@ typedef asmlinkage void (*sys_call_ptr_t)(void);
 
 extern asmlinkage void sys_ni_syscall(void);
 
-const sys_call_ptr_t sys_call_table[] __cacheline_aligned = {
+const sys_call_ptr_t sys_call_table[] ____cacheline_aligned = {
 	/*
 	 * Smells like a compiler bug -- it doesn't work
 	 * when the & below is removed.
diff --git a/arch/x86/um/sys_call_table_64.c b/arch/x86/um/sys_call_table_64.c
index f2f0723070ca..95783087f0d3 100644
--- a/arch/x86/um/sys_call_table_64.c
+++ b/arch/x86/um/sys_call_table_64.c
@@ -46,7 +46,7 @@ typedef void (*sys_call_ptr_t)(void);
 
 extern void sys_ni_syscall(void);
 
-const sys_call_ptr_t sys_call_table[] __cacheline_aligned = {
+const sys_call_ptr_t sys_call_table[] ____cacheline_aligned = {
 	/*
 	 * Smells like a compiler bug -- it doesn't work
 	 * when the & below is removed.
-- 
2.2.2

