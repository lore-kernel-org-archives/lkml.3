Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933AbaEUHjH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 03:39:07 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:49766 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbaEUHjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 03:39:05 -0400
Message-ID: <537C5812.6070002@hitachi.com>
Date: Wed, 21 May 2014 16:38:58 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: linux-kernel@vger.kernel.org, "Frank Ch. Eigler" <fche@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: Re: [PATCH 1/2] x86: insn decoder: create artificial 3rd byte
 for 2-byte VEX
References: <1400265279-22503-1-git-send-email-dvlasenk@redhat.com> <5377877A.2070205@hitachi.com> <537A1C2F.7070005@redhat.com>
In-Reply-To: <537A1C2F.7070005@redhat.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/05/19 23:58), Denys Vlasenko wrote:
> On 05/17/2014 05:59 PM, Masami Hiramatsu wrote:
>> (2014/05/17 3:34), Denys Vlasenko wrote:
>>> Before this patch, users need to do this to fetch vex.vvvv:
>>>
>>>         if (insn->vex_prefix.nbytes == 2) {
>>>                 vex_vvvv = ((insn->vex_prefix.bytes[1] >> 3) & 0xf) ^ 0xf;
>>>         }
>>>         if (insn->vex_prefix.nbytes == 3) {
>>>                 vex_vvvv = ((insn->vex_prefix.bytes[2] >> 3) & 0xf) ^ 0xf;
>>>         }
>>>
>>> Make it so that insn->vex_prefix.bytes[2] always contains vex.wvvvvLpp bits.
>>
>> I like this hack :)
>> If you don't mind, please add inline functions to get such vex bits from
>> struct insn too?
> 
> I prefer to add such functionality when the first user surfaces:
> the needs of the user often dictate more suitable API.

OK, then this should be postponed until the actual user (uprobes)
appears.

> In this case (VEX insns), the API isn't that straightforward.
> For example, uprobe code narrowly escaped the need to detect maskmovq__
> (0f f7) and maskmovdqu (66 0f f7 or equivalent VEX) instructions.
> 
> Let's assume we do need to detect them.
> Merely fetching and looking at vex.mmmmm, vex.pp and opcode doesn't
> really help that much in detecting these instructions:
> with such simplistic help, user needs to check both VEX and legacy forms.
> 
> Perhaps a better API would be to form a word-sized "expanded opcode"
> for vector and VEX insns. Something along the lines of:
> 
> [x.mmmmm.pp.opcode__]
> 
> where x bit indicates XOP insn (as opposed to VEX), pp indicate
> none/66/F2/F3 prefixes, opcode__ is 8-bit opcode.
> then checking for maskmovFOO insns would be easier.

I see, but it also makes things complex just for special
instructions. I'd like to let decoder just decode it, not
elaborate.

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


