Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934345Ab3E1OeP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 10:34:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5640 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934279Ab3E1OeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 10:34:14 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 1/4] MN10300: Fix ret_from_kernel_thread
To: torvalds@linux-foundation.org
From: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-am33-list@redhat.com,
        linux-kernel@vger.kernel.org, Ken Cox <jkc@redhat.com>
Date: Tue, 28 May 2013 15:34:09 +0100
Message-ID: <20130528143409.9790.41260.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ret_from_kernel_thread needs to set A2 to the thread_info pointer before
jumping to syscall_exit.

Without this, we never correctly start userspace.

This was caused by the rejuggling of the fork/exec paths in commit:

	ddf23e87a804cbf6fa3818076b33fe023cce09fd
	Author: Al Viro <viro@zeniv.linux.org.uk>
	Date:   Thu Oct 11 17:32:41 2012 -0400
	Subject: mn10300: switch to saner kernel_execve() semantics

Reported-by: Ken Cox <jkc@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Ken Cox <jkc@redhat.com>
Acked-by: Al Viro <viro@ZenIV.linux.org.uk>
---

 arch/mn10300/kernel/entry.S |    1 +
 1 file changed, 1 insertion(+)


diff --git a/arch/mn10300/kernel/entry.S b/arch/mn10300/kernel/entry.S
index 0c631d3..92c3eea 100644
--- a/arch/mn10300/kernel/entry.S
+++ b/arch/mn10300/kernel/entry.S
@@ -60,6 +60,7 @@ ENTRY(ret_from_kernel_thread)
 	mov	(REG_D0,fp),d0
 	mov	(REG_A0,fp),a0
 	calls	(a0)
+	GET_THREAD_INFO a2		# A2 must be set on return from sys_exit()
 	jmp	sys_exit
 
 ENTRY(ret_from_kernel_execve)

