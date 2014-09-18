Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935AbaIRIxB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 04:53:01 -0400
Received: from bes.se.axis.com ([195.60.68.10]:38990 "EHLO bes.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755109AbaIRIw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 04:52:58 -0400
Date: Thu, 18 Sep 2014 10:52:50 +0200
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Jesper Nilsson <jespern@axis.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-cris-kernel <linux-cris-kernel@axis.com>,
        Mikael Starvik <starvik@axis.com>,
        Grant Likely <grant.likely@linaro.org>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>
Subject: Re: Status of 'cris' architecture support in Linux kernel
Message-ID: <20140918085249.GS4659@axis.com>
References: <20140831175010.GA15408@roeck-us.net>
 <20140915145203.GK4659@axis.com>
 <20140917190753.GA13115@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140917190753.GA13115@roeck-us.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 09:07:53PM +0200, Guenter Roeck wrote:
> Just to give you an update. I "kind of" got an image to run with qemu
> after applying the following patches.
> 
> 8119d33 cris: Add basic qemu_defconfig
> 40d078b cris: time.c: Add missing include file to fix compile error
> a4f2390 cris: Add dummy free_initrd_mem
> 88585aa cris: Add serial driver for Cris v32
> a38d868 cris: Add support for early console
> 
> Let me know if you would like a copy of those patches. Out of those, 40d078b,
> a4f2390, and a38d868 should be pretty much acceptable for upstream integration.
> 88585aa would need a lot of work (and probably a rewrite).

Yes please, that would be helpful.

> Compiler version is 4.7.4; 4.9.1 builds even after applying a number of upstream
> patches, but the resulting image hangs. The weekly gcc snapshot fails to build.
> 
> The configuration is (I believe) derived from the configuration used for the
> image available from the qemu web site. The same is true for the crisv32
> serial driver and early console support. time.c needed an additional include
> file (<linux/mm.h>). free_initrd_mem is needed to be able to build an image
> with initrd support; it currently does nothing.
> 
> With this, I am able to get into a shell using a built-in initrd.
> 
> / # uname -a
> Linux (none) 3.16.2-00005-g8119d33 #40 Wed Sep 17 11:49:31 PDT 2014 crisv32 GNU/Linux
> 
> However, I see the following traceback.
> 
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 186 at kernel/softirq.c:146 0xc000fd72()
> Modules linked in:
> CPU: 0 PID: 186 Comm: init Not tainted 3.16.2-00005-g8119d33 #40
> 
> Stack from c1cf9eb0:
>        00000000 c02569d0 00000009 c0279f80 c1fda770 c1fa3680 c02574d6 c000cbb8
>        00000092 c000fd72 00000200 c02d0d94 00000000 00000000 c000fd72 00000092
>        c000cbea 00000000 c000fd72 c1f862d2 c1cdbc20 c01ff768 c1f862d2 c1f862d6
> Call Trace: [<c02569d0>] [<c02574d6>] [<c000cbb8>] [<c000fd72>] [<c000fd72>] [<c000cbea>] [<c000fd72>]
>        [<c01ff768>] [<c01ff908>] [<c016f83c>] [<c016fb10>] [<c006cfc0>] [<c025855a>] [<c006d0f4>] [<c001f212>]
>        [<c0004b80>] [<c00054f0>]
> ---[ end trace 5bb306335a1f3b62 ]---
> 
> Manual symbol decode (this is from a 3.10 traceback, so the addresses
> are a bit different):
> 
> c0234d8a	printk
> c0012b0e	local_bh_enable
> c0236004	dump_stack
> c000ca4a	warn_slowpath_common
> c000ca78	warn_slowpath_null
> c0012b0e	local_bh_enable
> c01e3c16	unix_release_sock
> c01e3dae	unix_release
> c015fb9a	sock_release
> c015fe68	sock_close
> c0067fae	__fput
> c0237a20	_cond_resched
> c0068168	____fput
> c0022062	task_work_run
> c0004954	do_notify_resume
> c0005324	_work_notifysig


I'm not sure if this has happened here, but please note that
some of the symbols in the stack backtrace might be false,
since the CRIS does not have true stack unwinding,
the backtrace code only checks the stack for any
pointers in the kernel address space and reports them too.

> --> Further debugging shows that interrupts are disabled when this happens.
> 
> This traceback is seen from 3.10 onwards. 3.4 did not show the traceback; I did
> not test any releases in between.

Ok thanks, will try to reproduce here.

> Guenter

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
