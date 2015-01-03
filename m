Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751275AbbACMLS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2015 07:11:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50752 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917AbbACMLR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2015 07:11:17 -0500
From: Daniel Borkmann <dborkman@redhat.com>
To: richard@nod.at
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] x86, um: actually mark system call tables readonly
Date: Sat,  3 Jan 2015 13:11:10 +0100
Message-Id: <1420287070-23450-1-git-send-email-dborkman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 arch/x86/um/sys_call_table_32.c | 2 +-
 arch/x86/um/sys_call_table_64.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/um/sys_call_table_32.c b/arch/x86/um/sys_call_table_32.c
index 531d426..bd16d6c 100644
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
index 20c3649..5cdfa9d 100644
--- a/arch/x86/um/sys_call_table_64.c
+++ b/arch/x86/um/sys_call_table_64.c
@@ -47,7 +47,7 @@ typedef void (*sys_call_ptr_t)(void);
 
 extern void sys_ni_syscall(void);
 
-const sys_call_ptr_t sys_call_table[] __cacheline_aligned = {
+const sys_call_ptr_t sys_call_table[] ____cacheline_aligned = {
 	/*
 	 * Smells like a compiler bug -- it doesn't work
 	 * when the & below is removed.
-- 
1.7.11.7

