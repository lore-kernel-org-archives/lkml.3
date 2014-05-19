Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747AbaESPFX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 11:05:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47441 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754173AbaESPFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 11:05:21 -0400
Message-ID: <537A1D93.7030601@redhat.com>
Date: Mon, 19 May 2014 17:04:51 +0200
From: Denys Vlasenko <dvlasenk@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: linux-kernel@vger.kernel.org, "Frank Ch. Eigler" <fche@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 2/2] x86: extend insn decoder to understand xop and evex
 prefixes
References: <1400265279-22503-1-git-send-email-dvlasenk@redhat.com> <1400265279-22503-2-git-send-email-dvlasenk@redhat.com> <537787A8.7000709@hitachi.com>
In-Reply-To: <537787A8.7000709@hitachi.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2014 06:00 PM, Masami Hiramatsu wrote:
> (2014/05/17 3:34), Denys Vlasenko wrote:
>> Since xop and evex prefixes are extensions of vex mechanism,
>> they have similar bit layouts, and they can never be combined
>> (an instruction can have only one of them),
>> (ab)use insn->vex_prefix to store data of xop and evex too.
>>
>> Users will need to conditionalize on insn->vex_prefix.bytes[0]
>> instead of insn->vex_prefix.nbytes if they want to determine
>> which of vex(-like) prefixes are there.
>>
>> Instead of adding more inattr bits for these prefixes, drop
>> VEX inattr bits and use VEX opcode values directly to detect them.
>> There is no point in having additional level of indirection here.
>> (And we are close to running out of inattr bits for prefixes).
> 
> Thank you very much for trying this work :)
> But sorry, Nak, I don't like to use the prefix byte directly.
> I'd rather like to add additional inattr bits for them.

Ok, I'm looking at inat.h and looks like I need to widen
INAT_PFX_BITS, otherwise I have no space for two more bits
for two more prefixes (XOP and EVEX):

/* AVX VEX prefixes */
#define INAT_PFX_VEX2   13      /* 2-bytes VEX prefix */
#define INAT_PFX_VEX3   14      /* 3-bytes VEX prefix */
...

/* Legacy prefix */
#define INAT_PFX_OFFS   0
#define INAT_PFX_BITS   4
#define INAT_PFX_MAX    ((1 << INAT_PFX_BITS) - 1)
#define INAT_PFX_MASK   (INAT_PFX_MAX << INAT_PFX_OFFS)

