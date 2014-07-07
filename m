Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009AbaGGSnM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 14:43:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49343 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752981AbaGGSnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 14:43:08 -0400
Message-ID: <53BAE9F4.4070605@redhat.com>
Date: Mon, 07 Jul 2014 20:41:56 +0200
From: Denys Vlasenko <dvlasenk@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Jim Keniston <jkenisto@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 1/3] uprobes: add comment with insn opcodes, mnemonics
 and why we dont support them
References: <1404479026-9894-1-git-send-email-dvlasenk@redhat.com> <1404753144.4595.21.camel@oc7886638347.ibm.com.usor.ibm.com>
In-Reply-To: <1404753144.4595.21.camel@oc7886638347.ibm.com.usor.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/2014 07:12 PM, Jim Keniston wrote:
> Also, as noted below, some of the opcodes that were invalid back in
> 2006-2007 are now valid.  However, arpl, lar, and lsl still look
> questionable to me.

arpl, lar, and lsl never throw any exceptions
apart from those which any memory-referencing
arithmetic insn can throw.

In particular, they don't throw exceptions
if their operand is an invalid segment selector.

No additional code needed for them to work
when probed.

Thus I think no harm done enabling them.

>> + * Opcodes which can be enabled right away:
>> + * 63 - arpl. This insn has no unusual exceptions (it's basically an arith op).
> 
> The AMD64 Architecture Programmer's Manual documents arpl as a system
> instruction ("Adjust Requestor Privilege Level").  Is this really valid
> for user-space apps?

"arpl r1,r2" does the following:

"If bits 0-1 of r2 are less than same bits of r1,
set them to bits from r1 and set ZF, else clear ZF.

I doubt anyone uses this insn, but it *is* just a funky
arith op. It doesn't even check whether register values
are valid selectors.

The idea was that it helps to perform "lowering"
of selector privileges when code in comforming
code segment uses "untrusted" (caller-supplied)
selector values to access data.
Example: if CPL-2 caller gave us CPL-0 selector,
convert it to CPL-2 selector.
Some misguided guy at Intel thought it's vitally important to save
a few measly CPU cycles doing this, and created a special insn.


>> + * 0f 38-3f - 3-byte opcodes (why?? all look safe)
> 
> My AMD64 reference back then (AMD64 Architecture Programmer's Manual Vol
> 3, dated September 2003) showed all those opcodes as invalid.
> 
>> + * 0f 78 - vmread
>> + * 0f 79 - vmwrite
>> + * 0f 7a - undefined
>> + * 0f 7b - undefined
>> + * 0f 7c - undefined
>> + * 0f 7d - undefined
>> + * 0f a6 - undefined
>> + * 0f a7 - undefined
>> + * 0f b8 - popcnt (why?? it's an ordinary ALU op)hinhinkyky
> 
> Invalid in 2003 AMD64 ref.
>
>> + * 0f d0 - undefined
>> + * 0f f0 - lddqu (why?? it's an ordinary vector load op)
> 
> Invalid in 2003 AMD64 ref.

Correct. There insns are newer than 2003.
