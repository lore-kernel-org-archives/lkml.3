Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751590AbaJIUlR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 16:41:17 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:41619 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815AbaJIUlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 16:41:14 -0400
Date: Thu, 9 Oct 2014 22:41:01 +0200
From: Rabin Vincent <rabin@rab.in>
To: Felipe Balbi <balbi@ti.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>, josh@joshtriplett.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Rik van Riel <riel@redhat.com>
Subject: Re: RCU bug with v3.17-rc3 ?
Message-ID: <20141009204101.GA25955@debian>
References: <20140904184021.GA13421@saruman.home>
 <20140904191642.GJ5001@linux.vnet.ibm.com>
 <20140904192535.GJ13421@saruman.home>
 <20140904200403.GL13421@saruman.home>
 <20140905213216.GD5001@linux.vnet.ibm.com>
 <20141008171322.GH22688@saruman>
 <20141008175707.GI22688@saruman>
 <20141008212938.GP22688@saruman>
 <20141009160138.GA2396@cmpxchg.org>
 <20141009162656.GE16002@saruman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141009162656.GE16002@saruman>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2014 at 11:26:56AM -0500, Felipe Balbi wrote:
> alright, it's pretty deterministic however. Always on the same test, no
> matter which USB controller, no matter if backing store is RAM or MMC.
> 
> Those two undefined instructions on the disassembly caught my attention,
> perhaps I'm facing a GCC bug ?

The undefined instructions are just ARM's BUG() implementation.

But did you see the question I asked you yesterday in your other thread?
http://www.spinics.net/lists/arm-kernel/msg368634.html

Here it is again:

  What GCC version are you using?
  
  4.8.1 and 4.8.2 are known to miscompile the ARM kernel and these
  find_get_entry() crashes with 0xffffffff involved smell a lot like the
  earlier reports from kernels build with those compilers:
  
  https://lkml.org/lkml/2014/6/25/456
  https://lkml.org/lkml/2014/6/30/375
  https://lkml.org/lkml/2014/6/30/660
  https://gcc.gnu.org/bugzilla/show_bug.cgi?id=58854
  https://lkml.org/lkml/2014/5/9/330

Also, I didn't see any public email making a definitive link between GCC
PR 58854 that Nathan pointed out in https://lkml.org/lkml/2014/6/30/660
and the earlier find_get_entry() crashes, but I just built GCC 4.8.1 and
an ARM kernel with that, and the GCC bug is clearly seen in
radix_tree_lookup_slot() which returns the pointer which
find_get_entry() is dereferencing:

  <radix_tree_lookup_slot>:
   e1a0c00d  mov     ip, sp
   e92dd800  push    {fp, ip, lr, pc}
   e24cb004  sub     fp, ip, #4
   e24dd008  sub     sp, sp, #8
   e3a02000  mov     r2, #0
   e24b3010  sub     r3, fp, #16
   ebffffc5  bl      c0176ab8 <__radix_tree_lookup>
   e24bd00c  sub     sp, fp, #12		<--- sp moved up
   e3500000  cmp     r0, #0
   151b0010  ldrne   r0, [fp, #-16]		<--- load from under sp 
   e89da800  ldm     sp, {fp, sp, pc}

Please check your compiler to make sure it's not the same problem.
