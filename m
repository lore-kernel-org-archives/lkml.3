Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711AbbAZMzH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 07:55:07 -0500
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:51238 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753456AbbAZMzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 07:55:03 -0500
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <maasami.hiramatsu.pt@hitachi.com>
Cc: Vojtech Pavlik <vojtech@suse.cz>, Jiri Kosina <jkosina@suse.cz>,
        Jiri Slaby <jslaby@suse.cz>,
        Andreas Krebbel <krebbel@linux.vnet.ibm.com>,
        Dominik Vogt <vogt@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH/RFC 0/3] ftrace: allow arch specific compile options
Date: Mon, 26 Jan 2015 13:54:51 +0100
Message-Id: <1422276894-31302-1-git-send-email-heiko.carstens@de.ibm.com>
X-Mailer: git-send-email 2.1.4
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012612-0041-0000-0000-000003069DEE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set enables s390 to use gcc's s390 specific "--mhotpatch" compile
option if the kernel is instrumented for function tracing.

The normal -pg compile option adds 24 bytes to each function prologue.
Performance measurements have shown that, depending on the workload, we have
an impact of up to 2% - 10% additional cpu time spent as compared to a kernel
which is compiled without the -pg option.

In both cases function tracing is disabled. What we see is the overhead
caused by simply adding 24 additional bytes to each function, where the
first instruction is patched to skip the rest of the code block, which
besides other effects causes instruction cache pollution.

These patches change code generation on s390 to only add a single six byte
nop to each function trace enabled function. With this change the overhead
gets reduced close to zero.

I tried to minimize the common code changes, which resulted mainly in a
new CC_FTRACE_FLAGS makefile variable and a new "nohotpatch" define.
The rest is s390 specific. The patches are against linux-next as of today.

The gcc hotpatch feature patch, which changes the existing hotpatch mechanism
to allow to specify the number of halfwords before/after the beginning of a
function is not yet upstream, but should be soon.

Heiko Carstens (3):
  ftrace: allow architectures to specify ftrace compile options
  ftrace: introduce nohotpatch function attribute
  s390/ftrace: hotpatch support for function tracing

 Makefile                       |  6 +++++-
 arch/s390/Kconfig              |  1 -
 arch/s390/Makefile             | 10 ++++++++++
 arch/s390/include/asm/ftrace.h | 15 +++++++++++++++
 arch/s390/kernel/Makefile      |  4 ++--
 arch/s390/kernel/ftrace.c      | 15 ++++++++++++++-
 arch/s390/kernel/kprobes.c     |  3 ++-
 arch/s390/kernel/mcount.S      |  2 ++
 include/linux/compiler.h       |  8 +++++++-
 kernel/Makefile                |  4 ++--
 kernel/events/Makefile         |  2 +-
 kernel/locking/Makefile        |  8 ++++----
 kernel/sched/Makefile          |  2 +-
 kernel/trace/Makefile          |  4 ++--
 lib/Makefile                   |  2 +-
 scripts/Makefile.build         |  5 +++--
 scripts/recordmcount.pl        |  9 +++++++--
 17 files changed, 78 insertions(+), 22 deletions(-)

-- 
2.1.4

