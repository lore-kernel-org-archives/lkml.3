Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756477AbaDHLnk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 07:43:40 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:33728 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755454AbaDHLni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 07:43:38 -0400
Message-ID: <5343E0E3.70808@hitachi.com>
Date: Tue, 08 Apr 2014 20:43:31 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
Cc: Jim Keniston <jkenisto@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jonathan Lebon <jlebon@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/6] uprobes/x86: fix the reprel jmp/call handling
References: <20140404185038.GA14679@redhat.com> <20140404193226.GA23092@redhat.com> <1396655065.4769.8.camel@oc7886638347.ibm.com.usor.ibm.com> <20140406201524.GA32694@redhat.com>
In-Reply-To: <20140406201524.GA32694@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/04/07 5:15), Oleg Nesterov wrote:
> On 04/04, Jim Keniston wrote:
>>
>> On Fri, 2014-04-04 at 21:32 +0200, Oleg Nesterov wrote:
>>>
>>> 	1. Why insn_get_displacement() doesn't work? See "HELP!!!"
>>> 	   below.
>>
>> insn->moffset1.value seems to be what you want.
> 
> Works! Thanks a lot.
> 
> Still I can't understand why displacement.nbytes == 0 in this case...
> Nevermind.

I guess that you misunderstanding what the displacement means.
insn->displacement means what x86 instruction encoding as
"displacement" bytes, which is an extension of addressing mode.

The relative Jumps are JMP(near) which operand is Jz,
and JMP(short) which operand is Jb, according to the Intel SDM 2b
appendix A2.

According to SDM2b A.2.1 and A.2.2, the J means
  ----
  The instruction contains a relative offset to be added to the instruction
  pointer register (for example, JMP (0E9), LOOP).
  ----

and z and b means
  ----
  b	Byte, regardless of operand-size attribute.
  z 	Word for 16-bit operand-size or doubleword for 32 or 64-bit operand-size.
  ----
Ok, so these are have one immediate operand which has 1,2(word),
4(doubleword) bytes.
In that case, you should use insn->immediate, instead of insn->moffset1 which
is only for MOV(A0-A3) on x86-64. (please see Intel SDM2a 2.2.1.4)

Thank you,

> OK. Please see the RFC changes. Obviously not for inclusion yet. And
> totally untested, except I verified that the test-case from 4/6 works.
> 
> Please comment.
> 
> Oleg.
> 
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


