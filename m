Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab3KRSsA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 13:48:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57627 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753036Ab3KRSmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 13:42:33 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andrey Konovalov <andreyknvl@google.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 3.10 15/24] tracing: Fix potential out-of-bounds in trace_get_user()
Date: Mon, 18 Nov 2013 10:42:25 -0800
Message-Id: <20131118184223.142913815@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131118184222.017393843@linuxfoundation.org>
References: <20131118184222.017393843@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

commit 057db8488b53d5e4faa0cedb2f39d4ae75dfbdbb upstream.

Andrey reported the following report:

ERROR: AddressSanitizer: heap-buffer-overflow on address ffff8800359c99f3
ffff8800359c99f3 is located 0 bytes to the right of 243-byte region [ffff8800359c9900, ffff8800359c99f3)
Accessed by thread T13003:
  #0 ffffffff810dd2da (asan_report_error+0x32a/0x440)
  #1 ffffffff810dc6b0 (asan_check_region+0x30/0x40)
  #2 ffffffff810dd4d3 (__tsan_write1+0x13/0x20)
  #3 ffffffff811cd19e (ftrace_regex_release+0x1be/0x260)
  #4 ffffffff812a1065 (__fput+0x155/0x360)
  #5 ffffffff812a12de (____fput+0x1e/0x30)
  #6 ffffffff8111708d (task_work_run+0x10d/0x140)
  #7 ffffffff810ea043 (do_exit+0x433/0x11f0)
  #8 ffffffff810eaee4 (do_group_exit+0x84/0x130)
  #9 ffffffff810eafb1 (SyS_exit_group+0x21/0x30)
  #10 ffffffff81928782 (system_call_fastpath+0x16/0x1b)

Allocated by thread T5167:
  #0 ffffffff810dc778 (asan_slab_alloc+0x48/0xc0)
  #1 ffffffff8128337c (__kmalloc+0xbc/0x500)
  #2 ffffffff811d9d54 (trace_parser_get_init+0x34/0x90)
  #3 ffffffff811cd7b3 (ftrace_regex_open+0x83/0x2e0)
  #4 ffffffff811cda7d (ftrace_filter_open+0x2d/0x40)
  #5 ffffffff8129b4ff (do_dentry_open+0x32f/0x430)
  #6 ffffffff8129b668 (finish_open+0x68/0xa0)
  #7 ffffffff812b66ac (do_last+0xb8c/0x1710)
  #8 ffffffff812b7350 (path_openat+0x120/0xb50)
  #9 ffffffff812b8884 (do_filp_open+0x54/0xb0)
  #10 ffffffff8129d36c (do_sys_open+0x1ac/0x2c0)
  #11 ffffffff8129d4b7 (SyS_open+0x37/0x50)
  #12 ffffffff81928782 (system_call_fastpath+0x16/0x1b)

Shadow bytes around the buggy address:
  ffff8800359c9700: fd fd fd fd fd fd fd fd fd fd fd fd fd fd fd fd
  ffff8800359c9780: fd fd fd fd fd fd fd fd fa fa fa fa fa fa fa fa
  ffff8800359c9800: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
  ffff8800359c9880: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
  ffff8800359c9900: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
=>ffff8800359c9980: 00 00 00 00 00 00 00 00 00 00 00 00 00 00[03]fb
  ffff8800359c9a00: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
  ffff8800359c9a80: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
  ffff8800359c9b00: fa fa fa fa fa fa fa fa 00 00 00 00 00 00 00 00
  ffff8800359c9b80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  ffff8800359c9c00: 00 00 00 00 00 00 00 00 fa fa fa fa fa fa fa fa
Shadow byte legend (one shadow byte represents 8 application bytes):
  Addressable:           00
  Partially addressable: 01 02 03 04 05 06 07
  Heap redzone:          fa
  Heap kmalloc redzone:  fb
  Freed heap region:     fd
  Shadow gap:            fe

The out-of-bounds access happens on 'parser->buffer[parser->idx] = 0;'

Although the crash happened in ftrace_regex_open() the real bug
occurred in trace_get_user() where there's an incrementation to
parser->idx without a check against the size. The way it is triggered
is if userspace sends in 128 characters (EVENT_BUF_SIZE + 1), the loop
that reads the last character stores it and then breaks out because
there is no more characters. Then the last character is read to determine
what to do next, and the index is incremented without checking size.

Then the caller of trace_get_user() usually nulls out the last character
with a zero, but since the index is equal to the size, it writes a nul
character after the allocated space, which can corrupt memory.

Luckily, only root user has write access to this file.

Link: http://lkml.kernel.org/r/20131009222323.04fd1a0d@gandalf.local.home

Reported-by: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/trace.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -826,9 +826,12 @@ int trace_get_user(struct trace_parser *
 	if (isspace(ch)) {
 		parser->buffer[parser->idx] = 0;
 		parser->cont = false;
-	} else {
+	} else if (parser->idx < parser->size - 1) {
 		parser->cont = true;
 		parser->buffer[parser->idx++] = ch;
+	} else {
+		ret = -EINVAL;
+		goto out;
 	}
 
 	*ppos += read;


