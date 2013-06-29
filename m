Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923Ab3F2R5u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 13:57:50 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:35529 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009Ab3F2R5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 13:57:48 -0400
Date: Sat, 29 Jun 2013 10:57:43 -0700
From: Tejun Heo <tj@kernel.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org,
        Sam Ravnborg <sam@ravnborg.org>, linux-arch@vger.kernel.org
Subject: Re: [PATCH] WIP: HACK: LPAE, BOOTMEM and NO_BOOTMEM
Message-ID: <20130629175743.GA382@mtj.dyndns.org>
References: <1372467663-31425-1-git-send-email-santosh.shilimkar@ti.com>
 <20130629152959.GB31339@mtj.dyndns.org>
 <20130629172123.GA3353@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130629172123.GA3353@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

( Expanding cc list, original thread is at
  http://thread.gmane.org/gmane.linux.kernel/1518046 )

Hello,

On Sat, Jun 29, 2013 at 06:21:24PM +0100, Russell King - ARM Linux wrote:
> Unfortunately, that has not been true on ARM - it's very common for
> there to be an offset on physical memory, sometimes of the order of
> 3GB or more.  This is because on reset, ARMs start executing the code
> at physical address zero, which therefore can't be RAM - and there's
> a desire to avoid complex switching games in hardware to temporarily
> map ROM there instead of RAM.
> 
> On these SoCs which Santosh is working on, the main physical memory
> mapping is above 4GB, with just a small alias below 4GB to allow the
> system to boot without the MMU being on, as they may have more than
> 4GB of RAM.  As I understand it, the small alias below 4GB is not
> suitable for use as a "lowmem" mapping.

Ah, okay, so the @limit which is in physical address can be over 4GB
even for lowmem mappings and alloc_bootmem takes them in ulongs,
urghhh....

Given that still about half of the archs aren't using memblock yet, I
think there are three options.

1. Converting all bootmem interface to use physaddr_t.  But that's
   what memblock is.

2. Introducing new interface.  Easier right now but the danger there
   is that it might end up duplicating most of alloc_bootmem()
   interface anyway and we'll have yet another variant of early mem
   allocator to enjoy.

3. Make all generic code use memblock interface instead of bootmem and
   implement memblock wrapper on archs which don't use memblock yet.
   We'll probably need to sort out different combinations of
   HAVE_MEMBLOCK and NO_BOOTMEM.  If this is doable, it probably is
   the most future proof way.  While it adds new memblock interface
   built on top of bootmem, it would also allow removing the bootmem
   interface built on top of memblock - ie. nobootmem.c, which
   probably is what we should have done from the beginning.

What do you guys think?

Thanks.

-- 
tejun
