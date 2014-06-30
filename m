Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756296AbaF3MrN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:47:13 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:53045 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754325AbaF3Mar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 08:30:47 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mike Frysinger <vapier@gentoo.org>,
        "H.J. Lu" <hjl.tools@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 159/181] x86, x32: Use compat shims for io_{setup,submit}
Date: Mon, 30 Jun 2014 13:53:00 +0200
Message-Id: <826f4ea5eea1b61dc4858a72ca3dd5ab34946259.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier@gentoo.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
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
2.0.0

