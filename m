Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751475AbaDQRcA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 13:32:00 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:24734 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbaDQRbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 13:31:55 -0400
Message-ID: <53500FF8.8010804@oracle.com>
Date: Thu, 17 Apr 2014 13:31:36 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: vegard.nossum@oracle.com, penberg@kernel.org, jamie.iles@oracle.com,
        mingo@redhat.com, tglx@linutronix.de, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] x86/insn: Extract more information about instructions
References: <1397497450-6440-1-git-send-email-sasha.levin@oracle.com> <1397497450-6440-3-git-send-email-sasha.levin@oracle.com> <534CA38C.80501@hitachi.com> <534D4BF3.3020102@oracle.com> <534DF868.2020901@zytor.com> <534DFD61.4070700@oracle.com> <534DFEDC.8090503@zytor.com> <534E0124.70700@oracle.com> <534E1559.8050904@hitachi.com> <534FF135.40404@oracle.com> <534FF31E.1000104@zytor.com>
In-Reply-To: <534FF31E.1000104@zytor.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2014 11:28 AM, H. Peter Anvin wrote:
> On 04/17/2014 08:20 AM, Sasha Levin wrote:
>>
>> It's not like the instruction decoder is a generic piece of code right now anyways,
>> it only serves mostly [k,u]probes and was built around the their requirements, and
>> now everybody are surprised that kmemcheck has different requirements than kprobes.
>>
> 
> What *ARE* kmemcheck's requirements?  That's the real issue, I believe.

As far as kmemcheck is concerned, it needs to decode instructions so that
it could learn whether an instruction will access memory, and if it does -
the size of memory an instruction attempts to access.

Note that right now kmemcheck implements a dumb instruction decoder (see
arch/x86/mm/kmemcheck/opcode.c) which works for most cases, but breaks on
more than few. The first patch in this series adds a few cases where that
decoder will fail.

This is the main purpose of the patch series. We want to switch kmemcheck
to use the generic instruction decoder to avoid bugs found in the dumbed
down instruction decoder used by kmemcheck.

On top of that, there are several features which need to know more about
instructions:

1. kmemcheck wants to know if a given instruction may act on only part of
the memory it addresses, or all of it. This solves the problem of partially
initialized bitfields where uninitialized bits are never accessed.

For the above, kmemcheck needs to recognize whether an instruction is AND,
OR or XOR.

2. There are two sets of instructions, MOVS and CMPS which work a bit
differently than the rest. They take two memory addresses but will
generate only one page fault on access, which will make kmemcheck miss
a memory access.

kmemcheck needs to know if an instruction is a MOVS or CMPS to deal with
that corner case properly.

> I also have seen several attempts at using the generic instruction
> decoder which has resulted in more complexity, not less, because of
> excess generality, so it is not an obvious thing.

Let's split this patchset into two:

We have one part which moves kmemcheck to the generic instruction decoder
and adds memory access size to the instruction decoder. There seems to be
no objection to that part beyond technical issues regarding how we store
the new size value.

The other part is adding mnemonics to the instruction decoder. If my
explanation above makes sense, and kmemcheck does need to know about AND,
OR, XOR, MOVS and CMPS then let me know how to proceed about changing
the instruction decoder to add that functionality.

If I'm wrong about needing to know about those mnemonics, I'd be happy
to fix that issue in kmemcheck, but for that I need to know why I'm
wrong.


Thanks,
Sasha


