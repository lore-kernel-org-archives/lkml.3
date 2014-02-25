Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656AbaBYTqA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 14:46:00 -0500
Received: from mail.efficios.com ([78.47.125.74]:37942 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753607AbaBYTp6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 14:45:58 -0500
Date: Tue, 25 Feb 2014 19:46:01 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "David S. Miller" <davem@davemloft.net>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <1332921457.30140.1393357561516.JavaMail.zimbra@efficios.com>
In-Reply-To: <1164803689.30103.1393357052243.JavaMail.zimbra@efficios.com>
Subject: [BUG kretprobes] kretprobe triggers General Protection Faults
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [206.248.138.119]
X-Mailer: Zimbra 8.0.5_GA_5839 (ZimbraWebClient - FF27 (Linux)/8.0.5_GA_5839)
Thread-Topic: kretprobe triggers General Protection Faults
Thread-Index: F5LUODDQbD0wZXfS+BkP9/PRTtR17w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I had a bug report[1] from a user trying to add a kretprobe on the system
call entry code path:

arch/x86/kernel/entry_64.S:

ffffffff813dffe2 <system_call_fastpath+0x16>:
        cmpl $__NR_syscall_max,%eax
#endif
        ja badsys
        movq %r10,%rcx
        call *sys_call_table(,%rax,8)  # XXX:    rip relative
        movq %rax,RAX-ARGOFFSET(%rsp)   <--- return address pointing here

And all hell breaks loose (various types of faults, machine reboots,
applications exit randomly, etc.). I understand that this code path
is not marked as unsafe against kprobes, and I tested that a kprobes
indeed works fine there. However, kretprobes probably presumes a function
stack layout that is just not valid for the syscall entry routine.

Any thoughts on how kretprobes should handle this ?

Thanks,

Mathieu

[1] http://bugs.lttng.org/issues/687

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
