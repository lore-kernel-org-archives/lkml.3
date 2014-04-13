Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785AbaDMQW2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 12:22:28 -0400
Received: from mout.gmx.net ([212.227.17.20]:54874 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753518AbaDMQW0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 12:22:26 -0400
MIME-Version: 1.0
Message-ID: <trinity-bb53b48b-0fff-4643-8949-a131e275a3db-1397406144839@3capp-gmx-bs45>
From: Alexander.Kleinsorge@gmx.de
To: "Andi Kleen" <andi@firstfloor.org>
Cc: "Andi Kleen" <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Aw: Re: Re: new module to check constant memory for corruption
Content-Type: text/plain; charset=UTF-8
Date: Sun, 13 Apr 2014 18:22:24 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <20140413155547.GD22728@two.firstfloor.org>
References: <trinity-aef9715a-72d2-4824-a3d8-306d5850c633-1397352790457@3capp-gmx-bs18>
 <87eh12hr1t.fsf@tassilo.jf.intel.com>
 <trinity-516ff83e-4833-4dad-856a-dd0597993837-1397384072115@3capp-gmx-bs62>,
 <20140413155547.GD22728@two.firstfloor.org>
Content-Transfer-Encoding: 8BIT
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K0:1Q7C6G+ZLIHAhKiuZCOz8DYEel3+VmjgbHuTgvkxx0r
 gUkUXjxIXHJn0tWGFWPcMj/lrX2wSSIwR0P6bia2EhxeIEayVn
 90M1qic301tSuHPSUd6jj6CMNb7IeNFJdTbvHuRahDi9RTxF2S
 N2IrJ4XuCTjL+uL426Q78P+HEvLGHynIh/l6LzGW5kWVBy8agm
 VczdRckR4o+8rDdcjlXJxQclAZ8HdG0JnHPE+mcutUJXrXp5ey
 wFu2wTjFXoEe8fjqI8+Qp/9bQBsF3nfqco6uNHHEe3JcMGjGSj TGO1Jo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,
 
1. I build in a check if ftrace is enabled. (like: cat /debug/tracing/tracing_enabled != 1)

2. Main goal is to detect: real ram errors (non crc systems = normal pc). This happens more often than you think:
DRAM Errors in the Wild: A Large-Scale Field Study, Mai 2009 (http://www.cs.toronto.edu/~bianca/papers/sigmetrics09.pdf)
The rate is about 1 bit per GB per year!

3. I read a blog some weeks ago where an Android developer had problem with accidentally corrupted kernel memory (on ARM).
And he asked for the x86 feature [arch\x86\mm\init_32.c + init_64.c / void mark_rodata_ro()]. He wasted long time debugging it.

4. If kernel text or data is wrong by 1 bit (ram error) system can crash, but does not have to!
The worst case: this single bit is producing similar but runnable code.
But this range of memory is the most critical (even if only 1% of all ram).

Alex

-----------------------------------------------------

Gesendet: Sonntag, 13. April 2014 um 17:55 Uhr
Von: "Andi Kleen" <andi@firstfloor.org>
An: Alexander.Kleinsorge@gmx.de
Cc: "Andi Kleen" <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Betreff: Re: Re: new module to check constant memory for corruption
> your question: there are no writes in this write protected adress range (e.g. kernel code).

It's actually not true, Linux changes r/o code. But you could
handle that by hooking into the right places.

> my idea is to calculate a checksum (xor is fastest) over this range and check later (periodically) if its unchanged.
> see source code download (5 KB): http://tauruz.homeip.net/ramcheck.tgz
> the code is working fine and the checksum is (as expected) constant (at least for many hours).
>

So is the goal security or reliability or debugging?

Reliability:
I have doubts it makes sense for that. On most system the code
is only a very small part of the total memory. So you wouldn't
cover most data.

Also if something corrupts the code we likely already detect it
eventually by crashing. Your module would need to panic too in this
case.

Security: If someone can change the code what stops them from changing
the checksum module too?

Also if you use a poor (= fast) checksum it's likely easy to construct
a valid patch that does not change the checksum.

Debugging:
Maybe, but I have never seen a bug where code got corrupted.

The user program technique works reasonably well for finding bad
pointers. Write a program that allocates a lot of memory. Regularly
checksum and recheck all its memory.


-Andi
