Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895AbaFQLEs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 07:04:48 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:52209 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173AbaFQLEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 07:04:46 -0400
Subject: [PATCH -tip v2 0/3] ftrace,
 kprobes: Introduce IPMODIFY flag for ftrace_ops to detect conflicts
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Steven Rostedt <rostedt@goodmis.org>, Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Date: Tue, 17 Jun 2014 11:04:36 +0000
Message-ID: <20140617110436.15167.7179.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is the version 2 of the series of patches which introduces
IPMODIFY flag for ftrace_ops to detect conflicts of ftrace users
who can modify regs->ip in their handler.
In this version, I fixed some bugs in previous version and
added a patch which made kprobe itself free from IPMODIFY
except for jprobe.

Currently, only kprobes can change the regs->ip in the handler,
but recently kpatch is also want to change it. Moreover, since
the ftrace itself exported to modules, it might be considerable
senario.

Here we talked on github.
 https://github.com/dynup/kpatch/issues/47

To protect modified regs-ip from each other, this series
introduces FTRACE_OPS_FL_IPMODIFY flag and ftrace now ensures
the flag can be set on each function entry location. If there
is someone who already reserve regs->ip on target function
entry, ftrace_set_filter_ip or register_ftrace_function will
return -EBUSY. Users must handle that.

The 3rd patch adds a special reservation of IPMODIFY on the
jprobed address, since it is the only user who will change
the regs->ip. Other kprobes do not change it anymore. 

Testing:
BTW, I've tested it with samples/kprobes/{k,j}probe_example.ko
and a small test module which I added to the last of this mail.

Here is the test script. I think I should put this under
tools/testing, maybe kprobes? or selftest/kprobes?

----
#!/bin/bash

echo "IPMODIFY test"
ADDR=0x`grep do_fork /proc/kallsyms | cut -f 1 -d" "`

echo "Case1: kprobe->jprobe->ipmodify(fail)"
modprobe kprobe_example
modprobe jprobe_example
insmod ./ipmodify.ko && echo "Case1: [FAIL]" || echo "Case1: [OK]"
rmmod kprobe_example jprobe_example

echo "Case2: jprobe->kprobe->ipmodify(fail)"
modprobe jprobe_example
modprobe kprobe_example
insmod ./ipmodify.ko && echo "Case2: [FAIL]" || echo "Case2: [OK]"
rmmod kprobe_example jprobe_example

echo "Case3: jprobe->ipmodify(fail)"
modprobe jprobe_example
insmod ./ipmodify.ko && echo "Case3: [FAIL]" || echo "Case3: [OK]"
rmmod jprobe_example

echo "Case4: ipmodify->jprobe(fail)"
insmod ./ipmodify.ko
modprobe jprobe_example && echo "Case4: [FAIL]" || echo "Case4: [OK]"
rmmod ipmodify

echo "Case5: ipmodify->kprobe->jprobe(fail)"
insmod ./ipmodify.ko
modprobe kprobe_example
modprobe jprobe_example && echo "Case5: [FAIL]" || echo "Case5: [OK]"
rmmod ipmodify kprobe_example
-----

Thank you,

---

Masami Hiramatsu (3):
      ftrace: Simplify ftrace_hash_disable/enable path in ftrace_hash_move
      ftrace, kprobes: Support IPMODIFY flag to find IP modify conflict
      kprobes: Set IPMODIFY flag only if the probe can change regs->ip


 Documentation/kprobes.txt        |   12 +--
 Documentation/trace/ftrace.txt   |    5 +
 arch/x86/kernel/kprobes/ftrace.c |    9 +-
 include/linux/ftrace.h           |   10 ++
 kernel/kprobes.c                 |  115 +++++++++++++++++++++++----
 kernel/trace/ftrace.c            |  164 +++++++++++++++++++++++++++++++++-----
 6 files changed, 265 insertions(+), 50 deletions(-)

--

-----<ipmodify.c>
#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/ftrace.h>


static void ftrace_ipmodify_handler(unsigned long a0, unsigned long a1,
				struct ftrace_ops *op, struct pt_regs *regs)
{
	return;
}

static struct ftrace_ops test_ops __read_mostly = {
	.func = ftrace_ipmodify_handler,
	.flags = FTRACE_OPS_FL_SAVE_REGS | FTRACE_OPS_FL_IPMODIFY,
};

static unsigned long target;
module_param(target, ulong, 0444);

static int __init ipmodify_init(void)
{
	int ret;
	unsigned long ip = target;

	ret = ftrace_set_filter_ip(&test_ops, ip, 0, 0);
	pr_err("ipmodify_test: set filter ip 0x%lx, ret = %d\n", ip, ret);

        if (ret >= 0) {
		ret = register_ftrace_function(&test_ops);
		pr_err("ipmodify_test: register ftrace on 0x%lx, ret = %d\n",
			ip, ret);
        }

	return ret;
}

static void __exit ipmodify_exit(void)
{
	int ret;
	unsigned long ip = target;

	ret = unregister_ftrace_function(&test_ops);
	pr_err("ipmodify_test: unregister ftrace on 0x%lx, ret = %d\n", ip, ret);
        if (ret >= 0) {
		ret = ftrace_set_filter_ip(&test_ops, ip, 1, 0);
		pr_err("ipmodify_test: clear filter ip 0x%lx, ret = %d\n",
			ip, ret);
        }
}

module_init(ipmodify_init)
module_exit(ipmodify_exit)
MODULE_LICENSE("GPL");
-----

