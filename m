Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758852Ab3IBP55 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 11:57:57 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:51194 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753778Ab3IBP5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 11:57:55 -0400
Date: Mon, 2 Sep 2013 16:57:47 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Lennox Wu <lennox.wu@gmail.com>
Cc: Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiang Liu <jiang.liu@huawei.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>, Arnd Bergmann <arnd@arndb.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Liqin Chen <liqin299@gmail.com>
Subject: Re: [PATCH] Remove support for score architecture
Message-ID: <20130902155747.GZ13318@ZenIV.linux.org.uk>
References: <1377914435-24206-1-git-send-email-linux@roeck-us.net>
 <CAF0htA6gW3h82p2sBBpFEi4s0MkQ-NUn79VXWLieZmYNuUPA6w@mail.gmail.com>
 <5224247E.3050600@roeck-us.net>
 <CAF0htA6sYZOvLt_JczGpfjEJZep6cAquJV9tZ2FwYC+C6ngzXQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF0htA6sYZOvLt_JczGpfjEJZep6cAquJV9tZ2FwYC+C6ngzXQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 02, 2013 at 11:18:17PM +0800, Lennox Wu wrote:
> Before we start the development of the S+core, Sunplus had licensed
> ARM and MIPS. We develop S+core for other reason such as the price.
> Some products on the web of Sunplus adopt S+core , for example
> the SPV7050.(http://w3.sunplus.com/products/spv7050.asp) These products
> could still be bought from the market. Some high-end products adopt
> ARM or MIPS. So, there is no conflict for a company adopts multiple
> architectures.
> 
> As I said, we recognize that we rarely update because of the limited
> applications and rare requests from customers. Maybe we don?t
> understand the culture enough; we think that it is unnecessary if we
> have no new bugs or new functions, the thought seems wrong. We can
> commit some patches in the near future.

"New bugs" as in "don't bother with the stuff that had been broken since
the initial merge"?  You might want to take a look at arch/score/kernel/entry.S,
for starters.  And compare these pieces of code:
        brl     r10                     # Do The Real system call

        cmpi.c  r4, 0
        blt     1f  
        ldi     r8, 0
        sw      r8, [r0, PT_R7]
        b 2f
1:
        cmpi.c  r4, -MAX_ERRNO - 1
        ble     2f
        ldi     r8, 0x1;
        sw      r8, [r0, PT_R7]
        neg     r4, r4
2:
        sw      r4, [r0, PT_R4]         # save result
- syscall without being traced vs.
        brl     r8

        li      r8, -MAX_ERRNO - 1
        sw      r8, [r0, PT_R7]         # set error flag

        neg     r4, r4                  # error
        sw      r4, [r0, PT_R0]         # set flag for syscall
                                        # restarting
1:      sw      r4, [r0, PT_R2]         # result
- syscall under ptrace.  Estimate the amount of testing (or reading, for
that matter) the second chunk had...

Both pieces are obviously derived from mips, except that
	* mips ABI has return values go in r2, score one - in r4.  Note where
the ptraced variant stores the result...
	* syscall restart logics on mips uses regs->regs[0] as "syscall restart
allowed" flag; score does no such thing - regs->is_syscall is used and no,
PT_R0 isn't equal to its offset
	* both mips and non-traced path on score implement this:
	r7 = (unsigned long)res >= -MAX_ERRNO;
	if (r7)
		res = -res;
ptraced path on score, OTOH, doesn't do comparison at all, slaps -MAX_ERRNO-1
into r7, always negates the return value and, while we are at it, still
contains the target of lost conditional branch instruction.

And yes, it had been that way since the initial merge into the mainline tree -
this didn't come from subsequent bitrot.  Does that disqualify it from
being a "new bug"?
