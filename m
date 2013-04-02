Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760686Ab3DBJW1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 05:22:27 -0400
Received: from anubis.se.axis.com ([195.60.68.12]:53021 "EHLO
	anubis.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152Ab3DBJWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 05:22:24 -0400
Date: Tue, 2 Apr 2013 11:22:20 +0200
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, mingo@redhat.com, x86@kernel.org,
        rth@twiddle.net, linux@arm.linux.org.uk, msalter@redhat.com,
        starvik@axis.com, dhowells@redhat.com, tony.luck@intel.com,
        benh@kernel.crashing.org, takata@linux-m32r.org, geert@linux-m68k.org,
        james.hogan@imgtec.com, monstr@monstr.eu, ralf@linux-mips.org,
        jonas@southpole.se, rkuo@codeaurora.org, schwidefsky@de.ibm.com,
        liqin.chen@sunplusct.com, davem@davemloft.net, lethal@linux-sh.org,
        vgupta@synopsys.com, chris@zankel.net, cmetcalf@tilera.com,
        ysato@users.sourceforge.jp, gxt@mprc.pku.edu.cn, jdike@addtoit.com,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux-s390@vger.kernel.org,
        Mike Frysinger <vapier@gentoo.org>,
        uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH 3/5] dump_stack: consolidate dump_stack()
 implementations and unify their behaviors
Message-ID: <20130402092220.GH19150@axis.com>
References: <1364610428-2074-1-git-send-email-tj@kernel.org>
 <1364610428-2074-4-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364610428-2074-4-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 29, 2013 at 07:27:06PM -0700, Tejun Heo wrote:
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
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> Cc: linux-s390@vger.kernel.org
> Cc: Mike Frysinger <vapier@gentoo.org>
> Cc: uclinux-dist-devel@blackfin.uclinux.org

For the CRIS bits:

Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
