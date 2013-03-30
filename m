Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154Ab3C3F2a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 01:28:30 -0400
Received: from alvesta.synopsys.com ([198.182.60.77]:49391 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754960Ab3C3F22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 01:28:28 -0400
Message-ID: <515677DB.4070803@synopsys.com>
Date: Sat, 30 Mar 2013 10:57:55 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <akpm@linux-foundation.org>, <mingo@redhat.com>, <x86@kernel.org>,
        <rth@twiddle.net>, <linux@arm.linux.org.uk>, <msalter@redhat.com>,
        <starvik@axis.com>, <dhowells@redhat.com>, <tony.luck@intel.com>,
        <benh@kernel.crashing.org>, <takata@linux-m32r.org>,
        <geert@linux-m68k.org>, <james.hogan@imgtec.com>, <monstr@monstr.eu>,
        <ralf@linux-mips.org>, <jonas@southpole.se>, <rkuo@codeaurora.org>,
        <schwidefsky@de.ibm.com>, <liqin.chen@sunplusct.com>,
        <davem@davemloft.net>, <lethal@linux-sh.org>, <chris@zankel.net>,
        <cmetcalf@tilera.com>, <ysato@users.sourceforge.jp>,
        <gxt@mprc.pku.edu.cn>, <jdike@addtoit.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        <linux-s390@vger.kernel.org>, Mike Frysinger <vapier@gentoo.org>,
        <uclinux-dist-devel@blackfin.uclinux.org>
Subject: Re: [PATCH 3/5] dump_stack: consolidate dump_stack() implementations
 and unify their behaviors
References: <1364610428-2074-1-git-send-email-tj@kernel.org> <1364610428-2074-4-git-send-email-tj@kernel.org>
In-Reply-To: <1364610428-2074-4-git-send-email-tj@kernel.org>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.41]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30/2013 07:57 AM, Tejun Heo wrote:
> Both dump_stack() and show_stack() are currently implemented by each
> architecture.  show_stack(NULL, NULL) dumps the backtrace for the
> current task as does dump_stack().  On some archs, dump_stack() prints
> extra information - pid, utsname and so on - in addition to the
> backtrace while the two are identical on other archs.
> 
> The usages in arch-independent code of the two functions indicate
> show_stack(NULL, NULL) should print out bare backtrace while
> dump_stack() is used for debugging purposes when something went wrong,
> so it does make sense to print additional information on the task
> which triggered dump_stack().
> 
> There's no reason to require archs to implement two separate but
> mostly identical functions.  It leads to unnecessary subtle
> differences among archs and makes it very tedius to add generic debug
> information.
> 
> This patch expands the dummy fallback dump_stack() implementation in
> lib/dump_stack.c such that it prints out debug information (taken from
> x86) and invokes show_stack(NULL, NULL) and drops arch-specific
> dump_stack() implementations in all archs except blackfin and s390.
> Blackfin's dump_stack() does something wonky that I don't understand
> and s390 prints its own debug information which includes fields which
> aren't accessible from arch-indepdent code.
> 
> Debug information can be printed separately by calling
> dump_stack_print_info() so that arch-specific dump_stack()
> implementation can still emit the same debug information.  This is
> used in blackfin.
> 
> This patch brings the following behavior changes.
> 
> * On some archs, an extra level in backtrace for show_stack() could be
>   printed.  This is because the top frame was determined in
>   dump_stack() on those archs while generic dump_stack() can't do that
>   reliably.  It can be compensated by inlining dump_stack() but not
>   sure whether that'd be necessary.
> 
> * Most archs didn't use to print debug info on dump_stack().  They do
>   now.
> 
> An example WARN dump follows.
> 
>  WARNING: at /work/os/work/kernel/workqueue.c:4840 init_workqueues+0x35/0x505()
>  Hardware name: empty
>  Modules linked in:
>  Pid: 1, comm: swapper/0 Not tainted 3.9.0-rc1-work+ #17
>   0000000000000009 ffff88007c861e08 ffffffff81c61545 ffff88007c861e48
>   ffffffff8108f50f ffffffff82228240 0000000000000040 ffffffff8234a03c
>   0000000000000000 0000000000000000 0000000000000000 ffff88007c861e58
>  Call Trace:
>   [<ffffffff81c61545>] dump_stack+0x19/0x1b
>   [<ffffffff8108f50f>] warn_slowpath_common+0x7f/0xc0
>   [<ffffffff8108f56a>] warn_slowpath_null+0x1a/0x20
>   [<ffffffff8234a071>] init_workqueues+0x35/0x505
>   ...
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

For arch/arc bits

Acked-by: Vineet Gupta <vgupta@synopsys.com>

Thx,
-Vineet
