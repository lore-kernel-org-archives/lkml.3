Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934Ab3LDBe1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 20:34:27 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:54984 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754316Ab3LDBeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 20:34:25 -0500
Subject: [PATCH -tip v4 0/6] kprobes: introduce NOKPROBE_SYMBOL() and fixes
 crash bugs
To: Ingo Molnar <mingo@kernel.org>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        systemtap@sourceware.org, "David S. Miller" <davem@davemloft.net>
Date: Wed, 04 Dec 2013 01:28:41 +0000
Message-ID: <20131204012841.22118.82992.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Here is the version 4 of NOKPORBE_SYMBOL series.

In this version, I removed the cleanup patches and
add bugfixes I've found, since those bugs will be
critical.
Rest of the cleanup and visible blacklists will be
proposed later in another series.

Oh, just one new thing, I added a new RFC patch which
removes the dependency of notify_die() from kprobes
miss-hit/recovery path. Since the notify_die() involves
locking and lockdep code which invokes a lot of heavy
printk functions etc. This helped me to minimize the
blacklist and provides more stability for kprobes.
Actually, most of int3 handlers are already called
from do_int3 directly, I think this change is acceptable
too.

Here is the updates about NOKPROBE_SYMBOL().
 - Now _ASM_NOKPROBE() macro is introduced for assembly
   symbols on x86.
 - Rename kprobe_blackpoint to kprobe_blacklist_entry
   and simplify it. Also NOKPROBE_SYMBOL() macro just
   saves the address of non-probe-able symbols.

---

Masami Hiramatsu (6):
      kprobes: Prohibit probing on .entry.text code
      kprobes: Introduce NOKPROBE_SYMBOL() macro for blacklist
      [BUGFIX] kprobes/x86: Prohibit probing on debug_stack_*
      [BUGFIX] x86: Prohibit probing on native_set_debugreg
      [BUGFIX] x86: Prohibit probing on thunk functions and restore
      [RFC] kprobes/x86: Call exception handlers directly from do_int3/do_debug


 Documentation/kprobes.txt         |   16 +++++
 arch/x86/include/asm/asm.h        |    7 ++
 arch/x86/include/asm/kprobes.h    |    2 +
 arch/x86/kernel/cpu/common.c      |    4 +
 arch/x86/kernel/entry_32.S        |   33 -----------
 arch/x86/kernel/entry_64.S        |   20 -------
 arch/x86/kernel/kprobes/core.c    |   32 ++++------
 arch/x86/kernel/paravirt.c        |    5 ++
 arch/x86/kernel/traps.c           |   10 +++
 arch/x86/lib/thunk_32.S           |    3 +
 arch/x86/lib/thunk_64.S           |    3 +
 include/asm-generic/vmlinux.lds.h |    9 +++
 include/linux/kprobes.h           |   21 ++++++-
 kernel/kprobes.c                  |  113 ++++++++++++++++++++-----------------
 kernel/sched/core.c               |    1 
 15 files changed, 147 insertions(+), 132 deletions(-)

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com

