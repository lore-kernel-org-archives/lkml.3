Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756355Ab3INDsQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 23:48:16 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45893 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756254Ab3INDsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 23:48:15 -0400
Date: Sat, 14 Sep 2013 04:48:02 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: keescook@chromium.org, joe@perches.com, linux@horizon.com,
        akpm@linux-foundation.org, dan.carpenter@oracle.com,
        davem@davemloft.net, eldad@fogrefinery.com, jbeulich@suse.com,
        jkosina@suse.cz, linux-kernel@vger.kernel.org, rdunlap@infradead.org
Subject: Re: [PATCH] vsprintf: drop comment claiming %n is ignored
Message-ID: <20130914034801.GA13318@ZenIV.linux.org.uk>
References: <20130913195335.18955.qmail@science.horizon.com>
 <1379111268.2066.22.camel@joe-AO722>
 <CAGXu5jJxJVK7cu2Sc4Sdng_rLDL8ziC6aecAi7G0zL4fYnY-9Q@mail.gmail.com>
 <201309141149.HGF39054.QLJVHFtMFOSOOF@I-love.SAKURA.ne.jp>
 <20130914030521.GZ13318@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130914030521.GZ13318@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 14, 2013 at 04:05:21AM +0100, Al Viro wrote:
> Again, the normal return value of ->show() is 0 and that includes the case of
> overflow.  THE ONLY reason to check for overflow early is when subsequent
> output of ->show() takes long to generate and we want to skip that and
> have seq_read() do realloc-and-call-show-again immediately.  And in that
> case the right fix is often to get saner iterator and stop shoving everything
> into a single ->show() call...

Actually, let's take a look at the suckers.

* a bunch in arch/arm/plat-pxa/dma.c:dbg_show_requester_chan(): all buggy;
shouldn't care about pos at all and return 0.   Additionally,
dbg_show_descriptors() is buggy _and_ dumb - max_show shouldn't exist at all
and it shouldn't be using single_open(); it's iterating over a linked list,
for fsck sake...

* cris fasttimer: apparently valid "skip pointless work if we'd overflown"
uses; not sure if it's really needed here.

* cris show_cpuinfo(): buggy, should return 0 regardless.

* microblaze show_cpuinfo(): pointless sum is calculated and never used.

* openrisc show_cpuinfo(): buggy, should return 0 regardless.

* s390 pci_perf_show(): ditto.

* mtrr_seq_show(): pointless sum is calculated and never used.

* print_wakeup_source_stats(): buggy, should return 0 regardless.

* i8k_proc_show(): ditto.

* 3 ->show() instances in impi: ditto.

* i2o_report_query_status(): ditto.

* drivers/mfd/ab8500-debugfs.c:ab8500_registers_print(): legimitate use,
a side effect of lousy iterator, unfortunately complicated by the same
thing used for printk as well.

* same file, in ab8500_print_modem_registers() - return value of seq_printf()
is stored in local variable and immediately overwritten.

* same file, a metric arseload of return seq_printf(....): buggy, should
return 0.

* doc3g: ditto.

* drivers/parisc callers: pointless sums calculated and never used.

* drivers/regulator/dbx500-prcmu.c: somebody got religious about reporting
!!!scary!!! overflows.  Even though debugging printks are completely pointless
there.

* drivers/rtc: return value passed to caller and discarded there.  If it ever
stops being discarded, we'll get a bug.

drivers/s390/cio/blacklist.c: buggy, should return 0.

lustre: a bunch "should return 0" cases, AFAICS all of them are of that kind.

rtl8192*: a couple of such cases.

* drivers/usb/gadget/goku_udc.c: apparently valid uses, this time with what
looks like a damn good reason to skip extra work - it's reading from IO
ports and that can be slow.

* drivers/usb/gadget/pxa27x_udc.c: pointless sums discarded.

* debugfs_print_regs32(): should return 0.  The only caller ignores its
return value, fortunately, otherwise we'd have bugs.

* fs/dlm: valid, but very likely to be begging for better iterators.

* fs/proc children_seq_show(): buggy, should return 0.

* sysvipc_proc_show() and stuff it's calling (i.e. all show_... in
ipc/*): buggy, should return 0.

Enough for now...

Overall: I suspect that Joe might be right.  The very few callers that
use the return value and use it correctly can bloody well call
seq_overflow(), preferably with a detailed comment about the reasons
for doing so.  Anything that really wants the length of output (if we
have such places at all) can use %n or see Figure 1.  I haven't
crawled through lib/*, net/* and sound/* yet, but that's how the things
look so far.
