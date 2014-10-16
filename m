Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751073AbaJPDSh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 23:18:37 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:56203 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035AbaJPDSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 23:18:36 -0400
Date: Wed, 15 Oct 2014 23:11:54 -0400 (EDT)
Message-Id: <20141015.231154.1804074463934900124.davem@davemloft.net>
To: mroos@linux.ee
Cc: iamjoonsoo.kim@lge.com, linux-kernel@vger.kernel.org, cl@linux.com,
        penberg@kernel.org, rientjes@google.com, akpm@linux-foundation.org,
        linux-mm@kvack.org, sparclinux@vger.kernel.org
Subject: Re: unaligned accesses in SLAB etc.
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LRH.2.11.1410152310080.11974@adalberg.ut.ee>
References: <alpine.LRH.2.11.1410151059520.8050@adalberg.ut.ee>
	<20141015.143624.941838991598108211.davem@davemloft.net>
	<alpine.LRH.2.11.1410152310080.11974@adalberg.ut.ee>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 15 Oct 2014 20:11:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Meelis Roos <mroos@linux.ee>
Date: Wed, 15 Oct 2014 23:11:34 +0300 (EEST)

>> >> The gcc-4.9 case is interesting, are you saying that a gcc-4.9 compiled
>> >> kernel works fine on other systems?
>> > 
>> > Yes, all USII based systems work fine with Debian gcc-4.9, as does 
>> > T2000. Of USIII* systems, V210 and V440 exhibit the boot hang with 
>> > gcc-4.9 and V480 crashes wit FATAL exception during boot that is 
>> > probably earlier than the gcc boot hang so I do not know about V480 and 
>> > gcc-4.9. V240 not tested because of fan failures, V245 is in the queue 
>> > for setup but not tested so far.
>> 
>> Ok, on the V210/V440 can you boot with "-p" on the kernel boot command
>> line and post the log?  Let's start by seeing how far it gets, maybe
>> we can figure out roughly where it dies.
> 
> http://www.spinics.net/lists/sparclinux/msg12238.html and 
> http://www.spinics.net/lists/sparclinux/msg12468.html are my relevant 
> posts about it. Should I get something more? It would be easy because of 
> ALOM.

Less information than I had hoped :-/

I thought it was hanging "during boot" meaning before we try to
execute userspace.  When in fact it seems to die exactly when we start
running the init process.

Wrt. disassembly of fault_in_user_windows(), that's not likely the
cause because if it were being miscompiled it would equally not work
on the other systems.

Something in the UltraSPARC-III specific code paths is going wrong
(either it is miscompiled, or the code makes an assumption that isn't
valid which has happened in the past).

Do you happen to have both gcc-4.9 and a previously working compiler
on these systems?  If you do, we can build a kernel with gcc-4.9 and
then selectively compile certain failes with the older working
compiler to narrow down what compiles into something non-working with
gcc-4.9

I would start with the following files:

	arch/sparc/mm/init_64.c
	arch/sparc/mm/tlb.c
	arch/sparc/mm/tsb.c
	arch/sparc/mm/fault_64.c

And failing that, go for various files under arch/sparc/kernel/ such as:

	arch/sparc/kernel/process_64.c
	arch/sparc/kernel/smp_64.c
	arch/sparc/kernel/sys_sparc_64.c
	arch/sparc/kernel/sys_sparc32.c
	arch/sparc/kernel/traps_64.c

Hopefully, this should be a simply matter of doing a complete build
with gcc-4.9, then removing the object file we want to selectively
build with the older compiler and then going:

	make CC="gcc-4.6" arch/sparc/mm/init_64.o

then relinking with plain 'make'.

If the build system rebuilds the object file on you when you try
to relink the final kernel image, we'll have to do some of this
by hand to make the test.

Thanks.

