Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021AbaEEAoa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 20:44:30 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:47102 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753891AbaEEAo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 20:44:28 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        Kyle McMartin <kmcmarti@redhat.com>, Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH] x32: use compat shims for io_{setup,submit}
Date: Sun,  4 May 2014 20:43:15 -0400
Message-Id: <1399250595-5005-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 arch/x86/syscalls/syscall_64.tbl | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/syscalls/syscall_64.tbl b/arch/x86/syscalls/syscall_64.tbl
index 04376ac..ec255a1 100644
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
@@ -359,3 +359,5 @@
 540	x32	process_vm_writev	compat_sys_process_vm_writev
 541	x32	setsockopt		compat_sys_setsockopt
 542	x32	getsockopt		compat_sys_getsockopt
+543	x32	io_setup		compat_sys_io_setup
+544	x32	io_submit		compat_sys_io_submit
-- 
1.9.2

