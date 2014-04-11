Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199AbaDKB3z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 21:29:55 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:54542 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754080AbaDKB3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 21:29:53 -0400
Message-ID: <53474587.5080805@hitachi.com>
Date: Fri, 11 Apr 2014 10:29:43 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jonathan Lebon <jlebon@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Re: [RFC PATCH 4/6] uprobes/x86: Emulate rip-relative call's
References: <20140406201628.GA507@redhat.com> <1396995963.5056.46.camel@oc7886638347.ibm.com.usor.ibm.com> <20140409154346.GB18486@redhat.com> <53469F95.1030709@redhat.com> <5346A362.9010802@hitachi.com> <20140410142820.GA24720@redhat.com>
In-Reply-To: <20140410142820.GA24720@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/04/10 23:28), Oleg Nesterov wrote:
> On 04/10, Masami Hiramatsu wrote:
>>
>> (2014/04/10 22:41), Denys Vlasenko wrote:
>>> On 04/09/2014 05:43 PM, Oleg Nesterov wrote:
>>>> On 04/08, Jim Keniston wrote:
>>>>>
>>>>> On Sun, 2014-04-06 at 22:16 +0200, Oleg Nesterov wrote:
>>>>>> 0xe8. Anything else?
>>>>>
>>>>> No, I think e8 is the only call instruction uprobes will see.
>>>>
>>>> Good.
>>>
>>> There is this monstrosity, "16-bit override for branches" in 64-mode:
>>>
>>> 66 e8 nn nn       callw   <offset16>
>>>
>>> Nobody sane uses it because it truncates instruction pointer.
>>
>> No problem, insn.c can handle that too. :)
> 
> Does it?
> 
> 	"callw 1f; 1:\n"
> 	"rep; nop\n"
> 
> objdump:
> 
> 	66 e8 00 00             callw  485 <_init-0x3ffed3>
> 	f3 90                   pause
> 
> 
> if we probe this "callw", we copy MAX_INSN_BYTES into auprobe->insn,
> and after insn_get_length() (insn_complete() == T)
> 
> 	// this is correct
> 	OPCODE1() == e8	
> 
> 	// this all looks wrong
> 	insn->length == 6
> 	insn->immediate.value == -1863122944
> 	insn->immediate.nbytes == 4



Oops, that should be a bug in insn.c!
I'll fix that asap!

Thank you,


> 
> so it seems that lib/insn.c treats the next "pause" insn as the high
> 16 bits of address.
> 
> Oleg.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


