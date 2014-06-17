Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932829AbaFQM5k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 08:57:40 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:53460 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932196AbaFQM5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 08:57:39 -0400
Message-ID: <53A03B3C.4000300@hitachi.com>
Date: Tue, 17 Jun 2014 21:57:32 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [PATCH -tip v2 0/3] ftrace, kprobes: Introduce IPMODIFY flag
 for ftrace_ops to detect conflicts
References: <20140617110436.15167.7179.stgit@kbuild-fedora.novalocal>
In-Reply-To: <20140617110436.15167.7179.stgit@kbuild-fedora.novalocal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/06/17 20:04), Masami Hiramatsu wrote:
> Hi,
> 
> Here is the version 2 of the series of patches which introduces
> IPMODIFY flag for ftrace_ops to detect conflicts of ftrace users
> who can modify regs->ip in their handler.
> In this version, I fixed some bugs in previous version and
> added a patch which made kprobe itself free from IPMODIFY
> except for jprobe.
> 
> Currently, only kprobes can change the regs->ip in the handler,
> but recently kpatch is also want to change it. Moreover, since
> the ftrace itself exported to modules, it might be considerable
> senario.
> 
> Here we talked on github.
>  https://github.com/dynup/kpatch/issues/47
> 
> To protect modified regs-ip from each other, this series
> introduces FTRACE_OPS_FL_IPMODIFY flag and ftrace now ensures
> the flag can be set on each function entry location. If there
> is someone who already reserve regs->ip on target function
> entry, ftrace_set_filter_ip or register_ftrace_function will
> return -EBUSY. Users must handle that.
> 
> The 3rd patch adds a special reservation of IPMODIFY on the
> jprobed address, since it is the only user who will change
> the regs->ip. Other kprobes do not change it anymore. 
> 
> Testing:
> BTW, I've tested it with samples/kprobes/{k,j}probe_example.ko
> and a small test module which I added to the last of this mail.
> 
> Here is the test script. I think I should put this under
> tools/testing, maybe kprobes? or selftest/kprobes?
> 
> ----
> #!/bin/bash
> 
> echo "IPMODIFY test"
> ADDR=0x`grep do_fork /proc/kallsyms | cut -f 1 -d" "`
> 
> echo "Case1: kprobe->jprobe->ipmodify(fail)"
> modprobe kprobe_example
> modprobe jprobe_example
> insmod ./ipmodify.ko && echo "Case1: [FAIL]" || echo "Case1: [OK]"

Oops, I missed the target=$ADDR for these insmod...

Anyway, without passing target=$ADDR option, ipmodify.ko tries to
register ftrace_ops with an empty filter hash which means
trace all functions. So anyway jprobe and that ftrace_ops collide
with each other on the do_fork and the 2nd one should be failed.

Thus, of course this test doesn't fail with or without target=
param.

Thank you,


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


