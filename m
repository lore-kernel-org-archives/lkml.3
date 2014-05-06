Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631AbaEFQLv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 12:11:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12704 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838AbaEFQLt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 12:11:49 -0400
Message-ID: <536909BE.2050100@redhat.com>
Date: Tue, 06 May 2014 18:11:42 +0200
From: Denys Vlasenko <dvlasenk@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Jim Keniston <jkenisto@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 1/2] uprobes: add comment with insn opcodes, mnemonics
 and why we dont support them
References: <1399314247-7368-1-git-send-email-dvlasenk@redhat.com> <1399329124.4602.22.camel@oc7886638347.ibm.com.usor.ibm.com>
In-Reply-To: <1399329124.4602.22.camel@oc7886638347.ibm.com.usor.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2014 12:32 AM, Jim Keniston wrote:
> All of the following is FYI.
> 
> The good-instruction tables date back 2006-2007.  Back then, the
> philosophy was to disallow any questionable opcodes, and add them back
> into the "good" tables only when a need was demonstrated (i.e., somebody
> needed to probe that particular instruction) and we could verify that
> probing that instruction worked.

For the record, I do agree with this.
I think it's not worthwhile to expend additional work
to add support for instructions which won't ever be seen
in any sane program.

Example: iret instruction works in userspace
(with the correct stack layout, it will successfully
pop instruction pointer, statck pointer, flags, and continue
executing whereever that address points to).
But no one in userspace has any need to do that.

And since we need to expend additional work to support it
(we need to account for the fact it sets EFLAGS),
we can simply prohibit its probing.

However, if a particular insn requires no special support
whatsoever, it should be enabled even if it's not usually used
(examples: arpl, lsl). Merely because we want fewer '0' bits
in the tables - less explaining to ourselves "ok, why is that one
disallowed?".

And second, if a particular insn will be used in legitimate programs
(example: the boatload of new vector insns *will be* used by scientific
supercomputers, and will need debugging), we can't just disable probing
of it at the slightest inconvenience.

Example: 0f 78 - vmread (Intel VMX. CPL0 insn).
We now have it disabled. Presumably because it generates GP exception
when used in userspace, and we aren't sure we handle it absolutely
correctly. (The "slightest inconvenience"). So we disable it.

But there is a problem. With 66 and f2 prefixes, it's not vmread anymore.
These are valid, innocuous SSE4A vector ops. We disable them too.
With EVEX prefix on Knight's Landing CPU these are vector conversion ops.
We disable them too. But they eventually will be used.

I think we should try to support cases like this one.
Especially that in this case (we disabled an insn which
*always* throws an exception) it may even already be working
- we need to check that. If we do, many more '0' bits can become
'1' - in fact more than half of them.

