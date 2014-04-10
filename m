Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935661AbaDJObI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 10:31:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8726 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934798AbaDJObF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 10:31:05 -0400
Message-ID: <5346AB07.4090909@redhat.com>
Date: Thu, 10 Apr 2014 16:30:31 +0200
From: Denys Vlasenko <dvlasenk@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Jim Keniston <jkenisto@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 4/6] uprobes/x86: Emulate rip-relative call's
References: <20140406201628.GA507@redhat.com> <1396995963.5056.46.camel@oc7886638347.ibm.com.usor.ibm.com> <20140409154346.GB18486@redhat.com> <53469F95.1030709@redhat.com> <20140410141806.GA23997@redhat.com>
In-Reply-To: <20140410141806.GA23997@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2014 04:18 PM, Oleg Nesterov wrote:
> On 04/10, Denys Vlasenko wrote:
>>
>> There is this monstrosity, "16-bit override for branches" in 64-mode:
>>
>> 66 e8 nn nn       callw   <offset16>
>>
>> Nobody sane uses it because it truncates instruction pointer.
>>
>> Or rather, *I think* it should truncate it (i.e. zero-extend to full width),
>> but conceivably some CPUs can be buggy wrt that:
>> they can decide to modify only lower 16 bits of IP,
>> or even they can decided to use signed <offset16> but apply it
>> to full-width RIP.
>>
>> AMD manuals are not clear on what exactly should happen.
>>
>> I am sure no one sane uses this form of branch instructions
>> in 32-bit and 64-bit code.
>>
>> I don't think we should be trying to support it "correctly"
>> (we can just let program crash with SIGILL or something),
>> we only need to make sure we don't overlook its existence
>> and thus are not tricked into touching or modifying unrelated data.
> 
> And after the quick check it seems that lib/insn.c doesn't parse
> "66 e8 nn nn" correctly. It treats the next 2 bytes as the part
> of 32bit offset.

I didn't run-test it yet. By code inspection, it seems to work...

x86-opcode-map.txt:
    e8: CALL Jz (f64)

gen-insn-attr-x86.awk:
    imm_flag["Jz"] = "INAT_MAKE_IMM(INAT_IMM_VWORD32)"


insn.c:
        case INAT_IMM_VWORD32:
                if (!__get_immv32(insn))
                        goto err_out;
...
static int __get_immv32(struct insn *insn)
{
        switch (insn->opnd_bytes) {
        case 2:
                insn->immediate.value = get_next(short, insn);
                insn->immediate.nbytes = 2;
                break;
        case 4:
        case 8:
                insn->immediate.value = get_next(int, insn);
                insn->immediate.nbytes = 4;
                break;


...until I notice this code:

void insn_get_modrm(struct insn *insn)
{
...
        if (insn->x86_64 && inat_is_force64(insn->attr))
                insn->opnd_bytes = 8;


The (f64) modifier in x86-opcode-map.txt means that inat_is_force64()
is true for call opcode. So we won't reach "case 2:" in __get_immv32():
insn_get_prefixes() did set insn->opnd_bytes to 2 when it saw 0x66 prefix,
but it was before we reach this place, and here we overrode it.
This is a bug in insn decoder.

