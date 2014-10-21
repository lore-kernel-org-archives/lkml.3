Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269AbaJUIak (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 04:30:40 -0400
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:58014 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536AbaJUIag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 04:30:36 -0400
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>
Cc: Vojtech Pavlik <vojtech@suse.cz>, Jiri Kosina <jkosina@suse.cz>,
        Jiri Slaby <jslaby@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH v3 0/2] s390 vs. kprobes on ftrace
Date: Tue, 21 Oct 2014 10:30:27 +0200
Message-Id: <1413880229-4796-1-git-send-email-heiko.carstens@de.ibm.com>
X-Mailer: git-send-email 1.8.5.5
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102108-0013-0000-0000-000001887556
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v3:
Changed patch 1/2 to incorporate feedback from Steven Rostedt and
Masami Hiramatsu: rename helper function check_ftrace_location()
to arch_check_ftrace_location() and convert it to a weak function,
so architectures can override it without the need for new config
option.

v2:
Changed patch 1/2 to incorporate feedback from Masami Hiramatsu, and
introduce a new helper function check_ftrace_location().
The requested ftracetest has been sent as an own patch set, since it
has no dependency to these patches.

v1:
We would like to implement an architecture specific variant of "kprobes
on ftrace" without using the current HAVE_KPROBES_ON_FTRACE infrastructure
which is currently only used by x86.

The rationale for these two patches is:
- we want to patch the first instruction of the mcount code block to
  reduce the overhead of the function tracer
- we'd like to keep the ftrace_caller function as simple as possible and
  not require it to generate a 100% valid pt_regs structure as required
  by the combination of DYNAMIC_FTRACE_WITH_REGS and HAVE_KPROBES_ON_FTRACE.
  This allows us to not generate the psw mask field in the pt_regs
  structure on each function tracer enabled function, which otherwise would
  be very expensive. Besides that program check generated pt_regs contents
  are "more" accurate than program generated ones and don't require any
  maintenance.
  And also we can keep the ftrace and kprobes backends quite separated.

In order to make this work a small common code change is necessary which
removes a check if kprobe is being placed on an ftrace location (see
first patch).

If possible, I'd like to have an ACK from at least one of the kprobes
maintainers for the first patch and bring it upstream via the s390 tree.

Thanks,
Heiko

Heiko Carstens (2):
  kprobes: introduce weak arch_check_ftrace_location() helper function
  s390/ftrace,kprobes: allow to patch first instruction

 arch/s390/include/asm/ftrace.h  |  52 ++++++++++++++--
 arch/s390/include/asm/kprobes.h |   1 +
 arch/s390/include/asm/lowcore.h |   4 +-
 arch/s390/include/asm/pgtable.h |  12 ++++
 arch/s390/kernel/asm-offsets.c  |   1 -
 arch/s390/kernel/early.c        |   4 --
 arch/s390/kernel/ftrace.c       | 132 +++++++++++++++++++++++++---------------
 arch/s390/kernel/kprobes.c      |  92 ++++++++++++++++++++--------
 arch/s390/kernel/mcount.S       |   1 +
 arch/s390/kernel/setup.c        |   2 -
 arch/s390/kernel/smp.c          |   1 -
 include/linux/kprobes.h         |   1 +
 kernel/kprobes.c                |  18 +++---
 scripts/recordmcount.c          |   2 +-
 scripts/recordmcount.pl         |   2 +-
 15 files changed, 226 insertions(+), 99 deletions(-)

-- 
1.8.5.5

