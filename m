Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273AbaIVRSK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 13:18:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46994 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754008AbaIVRSI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 13:18:08 -0400
Date: Mon, 22 Sep 2014 19:15:25 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        Mark Wielaard <mjw@redhat.com>, Martin Milata <mmilata@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] coredump: add %i/%I in core_pattern to report the tid
	of the crashed thread
Message-ID: <20140922171525.GA32171@redhat.com>
References: <20140921175349.GA21585@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140921175349.GA21585@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

format_corename() can only pass the leader's pid to the core handler, but
there is no simple way to figure out which thread originated the coredump.

As Jan explains, this also means that there is no simple way to create the
backtrace of the crashed process:

As programs are mostly compiled with implicit gcc -fomit-frame-pointer one
needs program's .eh_frame section (equivalently PT_GNU_EH_FRAME segment) or
.debug_frame section. .debug_frame usually is present only in separate debug
info files usually not even installed on the system.  While .eh_frame is a
part of the executable/library (and it is even always mapped for C++
exceptions unwinding) it no longer has to be present anywhere on the disk
as the program could be upgraded in the meantime and the running instance
has its executable file already unlinked from disk.

One possibility is to echo 0x3f >/proc/*/coredump_filter and dump all the
file-backed memory including the executable's .eh_frame section. But that
can create huge core files, for example even due to mmapped data files.

Other possibility would be to read .eh_frame from /proc/PID/mem at the
core_pattern handler time of the core dump.  For the backtrace one needs to
read the register state first which can be done from core_pattern handler:

	ptrace(PTRACE_SEIZE, tid, 0, PTRACE_O_TRACEEXIT)
	close(0);    // close pipe fd to resume the sleeping dumper
	waitpid();   // should report EXIT
	PTRACE_GETREGS or other requests

The remaining problem is how to get the 'tid' value of the crashed thread.
It could be read from the first NT_PRSTATUS note of the core file but that
makes the core_pattern handler complicated.

Unfortunately %t is already used so this patch uses %i/%I.

Signed-off-by: Jan Kratochvil <jan.kratochvil@redhat.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 Documentation/sysctl/kernel.txt |    2 ++
 fs/coredump.c                   |    8 ++++++++
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index f79eb96..57baff5 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -190,6 +190,8 @@ core_pattern is used to specify a core dumpfile pattern name.
 	%%	output one '%'
 	%p	pid
 	%P	global pid (init PID namespace)
+	%i	tid
+	%I	global tid (init PID namespace)
 	%u	uid
 	%g	gid
 	%d	dump mode, matches PR_SET_DUMPABLE and
diff --git a/fs/coredump.c b/fs/coredump.c
index a93f7e6..b5c86ff 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -199,6 +199,14 @@ static int format_corename(struct core_name *cn, struct coredump_params *cprm)
 				err = cn_printf(cn, "%d",
 					      task_tgid_nr(current));
 				break;
+			case 'i':
+				err = cn_printf(cn, "%d",
+					      task_pid_vnr(current));
+				break;
+			case 'I':
+				err = cn_printf(cn, "%d",
+					      task_pid_nr(current));
+				break;
 			/* uid */
 			case 'u':
 				err = cn_printf(cn, "%d", cred->uid);
-- 
1.5.5.1


