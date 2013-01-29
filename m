Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756906Ab3A2NvQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 08:51:16 -0500
Received: from mail.skyhub.de ([78.46.96.112]:40196 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755361Ab3A2NvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 08:51:13 -0500
Date: Tue, 29 Jan 2013 14:51:09 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>, Ben Widawsky <ben@bwidawsk.net>,
        "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Subject: Re: [PATCH v5 16/20] scripts/gdb: Add internal helper and
 convenience function for per-cpu lookup
Message-ID: <20130129135109.GF14302@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	Jason Wessel <jason.wessel@windriver.com>,
	kgdb-bugreport@lists.sourceforge.net,
	Andi Kleen <andi@firstfloor.org>, Tom Tromey <tromey@redhat.com>,
	Ben Widawsky <ben@bwidawsk.net>,
	"David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
References: <cover.1359463075.git.jan.kiszka@siemens.com>
 <04960fa208fbd9c0962eb4f70aa45d28aec59e8d.1359463075.git.jan.kiszka@siemens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <04960fa208fbd9c0962eb4f70aa45d28aec59e8d.1359463075.git.jan.kiszka@siemens.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2013 at 01:37:59PM +0100, Jan Kiszka wrote:
> This function allows to obtain a per-cpu variable, either of the current
> or an explicitly specified CPU.
> 
> Note: sparc64 version is untested.
> 
> CC: "David S. Miller" <davem@davemloft.net>
> CC: sparclinux@vger.kernel.org
> Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
> ---
>  scripts/gdb/percpu.py      |   61 ++++++++++++++++++++++++++++++++++++++++++++
>  scripts/gdb/vmlinux-gdb.py |    1 +
>  2 files changed, 62 insertions(+), 0 deletions(-)
>  create mode 100644 scripts/gdb/percpu.py
> 
> diff --git a/scripts/gdb/percpu.py b/scripts/gdb/percpu.py
> new file mode 100644
> index 0000000..864962c
> --- /dev/null
> +++ b/scripts/gdb/percpu.py
> @@ -0,0 +1,61 @@
> +#
> +# gdb helper commands and functions for Linux kernel debugging
> +#
> +#  per-cpu tools

This is actually a very cool thing for CPU guys: it can show what kind
of hybrid CPUs they've been glueing together, like the following, for
example:

...
(gdb) p $lx_per_cpu("cpu_info").x86_virt_bits
$5 = 48 '0'
(gdb) p $lx_per_cpu("cpu_info").x86_vendor_id
$6 = "GenuineIntel\000\000\000"
(gdb) p $lx_per_cpu("cpu_info").x86_model_id
$7 = "AMD Phenom(tm) 9550 Quad-Core Processor", '\000' <repeats 24 times>
(gdb)

Since when does Intel produce CPUs called "AMD Phenom(tm) 9550 Quad-Core
Processor"? .. hahaha..

> +#
> +# Copyright (c) Siemens AG, 2011-2013
> +#
> +# Authors:
> +#  Jan Kiszka <jan.kiszka@siemens.com>
> +#
> +# This work is licensed under the terms of the GNU GPL version 2.
> +#
> +
> +import gdb
> +
> +from utils import *
> +from task import *
> +
> +MAX_CPUS = 4096
> +
> +def get_current_cpu():
> +	if get_gdbserver_type() == GDBSERVER_QEMU:
> +		return gdb.selected_thread().num - 1
> +	elif get_gdbserver_type() == GDBSERVER_KGDB:
> +		tid = gdb.selected_thread().ptid[2]
> +		if tid > (0x100000000 - MAX_CPUS - 2):
> +			return 0x100000000 - tid - 2
> +		else:
> +			return get_thread_info(get_task_by_pid(tid))['cpu']
> +	else:
> +		raise gdb.GdbError("Sorry, obtaining the current CPU is "
> +				   "not yet supported with this gdb server.")
> +
> +def per_cpu(var_ptr, cpu):
> +	if cpu == -1:
> +		cpu = get_current_cpu()
> +	if is_target_arch("sparc:v9"):
> +		offset = gdb.parse_and_eval("trap_block[" + str(cpu) +
> +					    "].__per_cpu_base")
> +	else:
> +		offset = gdb.parse_and_eval("__per_cpu_offset[" + str(cpu) +
> +					    "]")
> +	pointer = var_ptr.cast(get_long_type()) + offset
> +	return pointer.cast(var_ptr.type).dereference()
> +
> +
> +class PerCpu(gdb.Function):
> +	__doc__ = "Return per-cpu variable.\n" \
> +		  "\n" \
> +		  "$lx_per_cpu(\"VAR\"[, CPU]): Return the per-cpu variable called VAR for the\n" \
> +		  "given CPU number. If CPU is omitted, the CPU of the current context is used.\n" \
> +		  "Note that VAR has to be quoted as string."


Ok, seriously now:

apropos shows the "Return per-cpu... " line above. Have you found out
which gdb command shows the rest? help and info both say "Undefined
command".

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
