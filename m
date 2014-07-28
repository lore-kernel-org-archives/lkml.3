Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751627AbaG1FW1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 01:22:27 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:59848 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbaG1FW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 01:22:26 -0400
Subject: [PATCH ftrace/core v4 0/4] ftrace,
 kprobes: Introduce IPMODIFY flag for ftrace_ops to detect conflicts
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Steven Rostedt <rostedt@goodmis.org>, Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Date: Mon, 28 Jul 2014 05:22:15 +0000
Message-ID: <20140728052215.29491.23631.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is the 4th version of the series of patches which introduces
IPMODIFY flag for ftrace_ops to detect conflicts of ftrace users
who can modify regs->ip in their handler.
This version is basically an update of previous version, and
I've splitted a patch which adding IPMODIFY to kprobes from ftrace
IPMODIFY introducing patch.

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
The ftrace_ops with IPMODIFY flag requires at least one
entry for filter hash, and its notrace_hash must be empty,
because the IPMODIFY action is very address sensitve and
user must consider the ip address.

The 3rd patch adds a special reservation of IPMODIFY on the
jprobed address, since it is the only user who will change
the regs->ip. Other kprobes do not change it anymore. 

Here is the new testcase.
-------
#!/bin/bash

echo "IPMODIFY test"
ADDR=0x`grep do_fork /proc/kallsyms | cut -f 1 -d" "`

echo "Case1: kprobe->jprobe->ipmodify(fail)"
modprobe kprobe_example
modprobe jprobe_example
insmod ./ipmodify.ko target=$ADDR && echo "Case1: [FAIL]" || echo "Case1: [OK]"
rmmod kprobe_example jprobe_example

echo "Case2: jprobe->kprobe->ipmodify(fail)"
modprobe jprobe_example
modprobe kprobe_example
insmod ./ipmodify.ko target=$ADDR && echo "Case2: [FAIL]" || echo "Case2: [OK]"
rmmod kprobe_example jprobe_example

echo "Case3: jprobe->ipmodify(fail)"
modprobe jprobe_example
insmod ./ipmodify.ko target=$ADDR && echo "Case3: [FAIL]" || echo "Case3: [OK]"
rmmod jprobe_example

echo "Case4: ipmodify->jprobe(fail)"
insmod ./ipmodify.ko target=$ADDR
modprobe jprobe_example && echo "Case4: [FAIL]" || echo "Case4: [OK]"
rmmod ipmodify

echo "Case5: ipmodify->kprobe->jprobe(fail)"
insmod ./ipmodify.ko target=$ADDR
modprobe kprobe_example
modprobe jprobe_example && echo "Case5: [FAIL]" || echo "Case5: [OK]"
rmmod ipmodify kprobe_example

echo "Case6: ipmodify with targeting all functions(fail)"
insmod ./ipmodify.ko && echo "Case6: [FAIL]" || echo "Case6: [OK]"
rmmod ipmodify

echo "Case7: ipmodify with notrace filter (fail)"
insmod ./ipmodify.ko target=$ADDR noexp="do_fork" && echo "Case7: [FAIL]" || echo "Case7: [OK]"
rmmod ipmodify
-------

And ipmodify.c
-------
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
static char *noexp = "";
module_param(noexp, charp, 0444);

static int __init ipmodify_init(void)
{
        int ret;
        unsigned long ip = target;

        if (strlen(noexp) != 0) {
                ret = ftrace_set_notrace(&test_ops, noexp, 0, 0);
                pr_err("ipmodify_test: set notrace \"%s\", ret = %d\n",
                        noexp, ret);
        }
        if (ret < 0)
                return ret;

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
-------

Thank you,

---

Masami Hiramatsu (4):
      kprobes/ftrace: Recover original IP if pre_handler doesn't change it
      ftrace, kprobes: Support IPMODIFY flag to find IP modify conflict
      kprobes: Add IPMODIFY flag to kprobe_ftrace_ops
      kprobes: Set IPMODIFY flag only if the probe can change regs->ip


 Documentation/kprobes.txt        |   12 +--
 Documentation/trace/ftrace.txt   |    5 +
 arch/x86/kernel/kprobes/ftrace.c |    9 ++
 include/linux/ftrace.h           |   16 ++++
 kernel/kprobes.c                 |  123 +++++++++++++++++++++++++++++----
 kernel/trace/ftrace.c            |  143 +++++++++++++++++++++++++++++++++++++-
 6 files changed, 279 insertions(+), 29 deletions(-)

--

