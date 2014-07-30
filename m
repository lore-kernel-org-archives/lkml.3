Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460AbaG3BPq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 21:15:46 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:49578 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbaG3BPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 21:15:44 -0400
Message-ID: <53D84738.1090409@hitachi.com>
Date: Wed, 30 Jul 2014 10:15:36 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
Cc: Jianyu Zhan <nasa4836@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Re: [PATCH RESEND] kprobes: be more permissive when user specifies
 both symbol name and address
References: <20140728105156.GB14215@gmail.com> <1406638058-7761-1-git-send-email-nasa4836@gmail.com> <CAHz2CGUEJ9at2dwj-H-phKrkxO_B3Xt-ksBa7ZsWb2bOZ2nY=g@mail.gmail.com> <87lhrbhg86.fsf@sejong.aot.lge.com>
In-Reply-To: <87lhrbhg86.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/07/30 8:56), Namhyung Kim wrote:
> Hi Jianyu,
> 
> On Tue, 29 Jul 2014 20:50:08 +0800, Jianyu Zhan wrote:
>> Sorry for the noise,
>>
>> plz add these Acked-by and Signed-off-by:
> 
> I think you'd better to send it as a formal patch.

Agreed. Jianyu, please format it again. If you have a comment on it,
you can reply the patch mail.

Thank you,

> 
> Thanks,
> Namhyung
> 
> 
>>
>> Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
>> Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
>>
>> Thanks,
>> Jianyu Zhan
>>
>>
>> On Tue, Jul 29, 2014 at 8:47 PM, Jianyu Zhan <nasa4836@gmail.com> wrote:
>>> Hi, Ingo,
>>>
>>> Here is the new patch with typo fixed.
>>>
>>> Thanks.
>>>
>>> ---8<---
>>>
>>> Currently, if user specifies both symbol name and address, we just
>>> bail out.
>>>
>>> This might be too rude. This patch makes it give more tolerance.
>>> If both are specified, check address first, if the symbol found
>>> does not match the one user specify, print a waring. If not found,
>>> return -ENOENT, because some symbols might have muplitple instances,
>>> we don't bother to check symbol name.
>>> ---
>>>  Documentation/kprobes.txt |  4 +++-
>>>  kernel/kprobes.c          | 32 +++++++++++++++++++++++++++++---
>>>  2 files changed, 32 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/Documentation/kprobes.txt b/Documentation/kprobes.txt
>>> index 4bbeca8..663b5ad 100644
>>> --- a/Documentation/kprobes.txt
>>> +++ b/Documentation/kprobes.txt
>>> @@ -358,7 +358,9 @@ to install a probepoint is known. This field is used to calculate the
>>>  probepoint.
>>>
>>>  3. Specify either the kprobe "symbol_name" OR the "addr". If both are
>>> -specified, kprobe registration will fail with -EINVAL.
>>> +specified, only check "addr", because some symbols might have multiple
>>> +instances. If neither is specified, kprobe registration will fail
>>> +with -EINVAL.
>>>
>>>  4. With CISC architectures (such as i386 and x86_64), the kprobes code
>>>  does not validate if the kprobe.addr is at an instruction boundary.
>>> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
>>> index 734e9a7..9768608 100644
>>> --- a/kernel/kprobes.c
>>> +++ b/kernel/kprobes.c
>>> @@ -1358,15 +1358,41 @@ static bool within_kprobe_blacklist(unsigned long addr)
>>>  static kprobe_opcode_t *kprobe_addr(struct kprobe *p)
>>>  {
>>>         kprobe_opcode_t *addr = p->addr;
>>> +       char namebuf[KSYM_NAME_LEN];
>>> +       const char *sym_name = NULL;
>>> +       unsigned long offset;
>>>
>>> -       if ((p->symbol_name && p->addr) ||
>>> -           (!p->symbol_name && !p->addr))
>>> +       if (!p->symbol_name && !p->addr)
>>>                 goto invalid;
>>>
>>> -       if (p->symbol_name) {
>>> +       /*
>>> +        * Some symbols might have multiple instances,
>>> +        * so if both are specified, only check address.
>>> +        */
>>> +       if (unlikely(p->addr && p->symbol_name)) {
>>> +               sym_name = kallsyms_lookup((unsigned long)(p->addr),
>>> +                               NULL, &offset, NULL, namebuf);
>>> +               if (!sym_name)
>>> +                       return ERR_PTR(-ENOENT);
>>> +
>>> +               if (strncmp(sym_name, p->symbol_name, KSYM_NAME_LEN)
>>> +                               || offset != p->offset) {
>>> +                       pr_err("Incorrect symbol or offset, should be "
>>> +                               "symbol=%s, offset=%ld.\n", sym_name, offset);
>>> +                       goto invalid;
>>> +               }
>>> +       } else if (p->symbol_name) {
>>> +               /* Only symbol case */
>>>                 kprobe_lookup_name(p->symbol_name, addr);
>>>                 if (!addr)
>>>                         return ERR_PTR(-ENOENT);
>>> +       } else {
>>> +               /*
>>> +                * Only address case.
>>> +                * Since we later will do a sanity check of the
>>> +                * address range in check_kprobe_address_safe(),
>>> +                * do nothing here.
>>> +                */
>>>         }
>>>
>>>         addr = (kprobe_opcode_t *)(((char *)addr) + p->offset);
>>> --
>>> 2.0.0
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-doc" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


