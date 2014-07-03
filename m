Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758094AbaGCJVS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:21:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51452 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758062AbaGCJVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:21:15 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mike Frysinger <vapier@gentoo.org>, "H.J. Lu" <hjl.tools@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 015/198] x86, x32: Use compat shims for io_{setup,submit}
Date: Thu,  3 Jul 2014 10:17:38 +0100
Message-Id: <1404379241-8590-16-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Frysinger <vapier@gentoo.org>

commit 7fd44dacdd803c0bbf38bf478d51d280902bb0f1 upstream.

The io_setup takes a pointer to a context id of type aio_context_t.
This in turn is typed to a __kernel_ulong_t.  We could tweak the
exported headers to define this as a 64bit quantity for specific
ABIs, but since we already have a 32bit compat shim for the x86 ABI,
let's just re-use that logic.  The libaio package is also written to
expect this as a pointer type, so a compat shim would simplify that.

The io_submit func operates on an array of pointers to iocb structs.
Padding out the array to be 64bit aligned is a huge pain, so convert
it over to the existing compat shim too.

We don't convert io_getevents to the compat func as its only purpose
is to handle the timespec struct, and the x32 ABI uses 64bit times.

With this change, the libaio package can now pass its testsuite when
built for the x32 ABI.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Link: http://lkml.kernel.org/r/1399250595-5005-1-git-send-email-vapier@gentoo.org
Cc: H.J. Lu <hjl.tools@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/x86/syscalls/syscall_64.tbl | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/syscalls/syscall_64.tbl b/arch/x86/syscalls/syscall_64.tbl
index 38ae65dfd14f..63a899304d27 100644
--- a/arch/x86/syscalls/syscall_64.tbl
+++ b/arch/x86/syscalls/syscall_64.tbl
@@ -212,10 +212,10 @@
 203	common	sched_setaffinity	sys_sched_setaffinity
 204	common	sched_getaffinity	sys_sched_getaffinity
 205	64	set_thread_area
-206	common	io_setup		sys_io_setup
+206	64	io_setup		sys_io_setup
 207	common	io_destroy		sys_io_destroy
 208	common	io_getevents		sys_io_getevents
-209	common	io_submit		sys_io_submit
+209	64	io_submit		sys_io_submit
 210	common	io_cancel		sys_io_cancel
 211	64	get_thread_area
 212	common	lookup_dcookie		sys_lookup_dcookie
@@ -356,3 +356,5 @@
 540	x32	process_vm_writev	compat_sys_process_vm_writev
 541	x32	setsockopt		compat_sys_setsockopt
 542	x32	getsockopt		compat_sys_getsockopt
+543	x32	io_setup		compat_sys_io_setup
+544	x32	io_submit		compat_sys_io_submit
-- 
1.9.1

