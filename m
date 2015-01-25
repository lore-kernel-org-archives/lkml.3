Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756845AbbAYSMA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:12:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58027 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446AbbAYSKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:10:37 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 3.18 177/183] x86, um: actually mark system call tables readonly
Date: Sun, 25 Jan 2015 10:08:19 -0800
Message-Id: <20150125180817.853552427@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <dborkman@redhat.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/um/sys_call_table_32.c |    2 +-
 arch/x86/um/sys_call_table_64.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/um/sys_call_table_32.c
+++ b/arch/x86/um/sys_call_table_32.c
@@ -34,7 +34,7 @@ typedef asmlinkage void (*sys_call_ptr_t
 
 extern asmlinkage void sys_ni_syscall(void);
 
-const sys_call_ptr_t sys_call_table[] __cacheline_aligned = {
+const sys_call_ptr_t sys_call_table[] ____cacheline_aligned = {
 	/*
 	 * Smells like a compiler bug -- it doesn't work
 	 * when the & below is removed.
--- a/arch/x86/um/sys_call_table_64.c
+++ b/arch/x86/um/sys_call_table_64.c
@@ -46,7 +46,7 @@ typedef void (*sys_call_ptr_t)(void);
 
 extern void sys_ni_syscall(void);
 
-const sys_call_ptr_t sys_call_table[] __cacheline_aligned = {
+const sys_call_ptr_t sys_call_table[] ____cacheline_aligned = {
 	/*
 	 * Smells like a compiler bug -- it doesn't work
 	 * when the & below is removed.


