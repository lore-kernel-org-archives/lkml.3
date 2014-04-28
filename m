Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932437AbaD1TZK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 15:25:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48565 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756792AbaD1TZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 15:25:05 -0400
Message-ID: <535E9368.6080202@redhat.com>
Date: Mon, 28 Apr 2014 19:44:08 +0200
From: Denys Vlasenko <dvlasenk@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Denys Vlasenko <dvlasenk@redhat.com>, Jim Keniston <jkenisto@us.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] uprobes: use BX register for rip-relative fixups, not
 AX
References: <1398704774-25173-1-git-send-email-dvlasenk@redhat.com> <1398704774-25173-2-git-send-email-dvlasenk@redhat.com>
In-Reply-To: <1398704774-25173-2-git-send-email-dvlasenk@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/28/2014 07:06 PM, Denys Vlasenko wrote:
> +	 * Note: we can't use rax or rdx registers as scratch!
> +	 * There are 3-operand insns which use rax or rdx:rax
> +	 * as an implicit operand, _and_ they use modrm byte
> +	 * whose reg field indicates third register or opcode extension.
> +	 * In particular, these insns:
> +	 *  f7/6 r/m        div r/m
> +	 *  0f b1 r/m       cmpxchg r/m,reg
> +	 *  0f c7/1 mem     cmpxchg{8b,16b} mem
> +	 * Looking at "reg" field won't allow to detect that rax or rdx
> +	 * are in use.

Eek.... even this is not good enough for cmpxchg8b!
The damn thing uses CX and BX too!

AMD docs say -

"""Compares the value in the rDX:rAX registers with a 64-bit
or 128-bit value in the specified memory location.
If the values are equal, the instruction copies the value
in the rCX:rBX registers to the memory location and sets
the zero flag (ZF) of the rFLAGS register to 1."""

So, my patch does fix the cases of div and cmpxchg insns,
but not cmpxchg8b.

