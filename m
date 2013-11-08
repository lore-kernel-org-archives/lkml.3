Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757186Ab3KHMw0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 07:52:26 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:41137 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144Ab3KHMwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 07:52:25 -0500
X-AuditID: 85900ec0-d272ab9000001514-83-527cde853373
Subject: [PATCH -tip RFC 0/2] kprobes: introduce NOKPROBE_SYMBOL() and
 prohibit probing on .entry.text
To: Ingo Molnar <mingo@kernel.org>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: x86@kernel.org, Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        virtualization@lists.linux-foundation.org,
        "David S. Miller" <davem@davemloft.net>
Date: Fri, 08 Nov 2013 12:52:13 +0000
Message-ID: <20131108125213.19972.49271.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the blacklist is maintained by hand in kprobes.c 
which is separated from the function definition and is hard
to catch up the kernel update.
To solve this issue, I've tried to implement new
NOKPROBE_SYMBOL() macro for making kprobe blacklist at 
build time. Since the NOKPROBE_SYMBOL() macros can be placed
right after the function is defined, it is easy to maintain.
At this moment, I applied the macro only for the symbols
which is listed in kprobes.c. As we discussed in previous
thread, if the gcc accepts to introduce new annotation to
store the function address (and size) at somewhere, we can
easily move onto that by replacing NOKPROBE_SYMBOL() with
nokprobe annotation (and just modifying the
populate_kprobe_blacklist() a bit).

This series also includes a change which prohibits probing
on the address in .entry.text because the code is used for
very low-level sensitive interrupt/syscall entries. Probing
such code may cause unexpected result (actually most of
that area is already in the kprobe blacklist).
So I've decide to prohibit probing all of them.

Since Ingo wasn't convinced about the idea in the previous
discussion, I just make this series as RFC series.
I'd like to ask again with actual implementation and plan.

Thank you,

---

Masami Hiramatsu (2):
      kprobes: Prohibit probing on .entry.text code
      kprobes: Introduce NOKPROBE_SYMBOL() macro for blacklist


 arch/x86/kernel/entry_32.S        |   33 ------------
 arch/x86/kernel/entry_64.S        |   20 --------
 arch/x86/kernel/paravirt.c        |    4 ++
 include/asm-generic/vmlinux.lds.h |    9 +++
 include/linux/kprobes.h           |   19 +++++++
 kernel/kprobes.c                  |   98 ++++++++++++++++++-------------------
 kernel/sched/core.c               |    1 
 7 files changed, 80 insertions(+), 104 deletions(-)

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
