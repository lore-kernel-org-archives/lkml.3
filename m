Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634AbaG2X4M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 19:56:12 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:53518 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754408AbaG2X4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 19:56:11 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Jianyu Zhan <nasa4836@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND] kprobes: be more permissive when user specifies both symbol name and address
References: <20140728105156.GB14215@gmail.com>
	<1406638058-7761-1-git-send-email-nasa4836@gmail.com>
	<CAHz2CGUEJ9at2dwj-H-phKrkxO_B3Xt-ksBa7ZsWb2bOZ2nY=g@mail.gmail.com>
Date: Wed, 30 Jul 2014 08:56:09 +0900
In-Reply-To: <CAHz2CGUEJ9at2dwj-H-phKrkxO_B3Xt-ksBa7ZsWb2bOZ2nY=g@mail.gmail.com>
	(Jianyu Zhan's message of "Tue, 29 Jul 2014 20:50:08 +0800")
Message-ID: <87lhrbhg86.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jianyu,

On Tue, 29 Jul 2014 20:50:08 +0800, Jianyu Zhan wrote:
> Sorry for the noise,
>
> plz add these Acked-by and Signed-off-by:

I think you'd better to send it as a formal patch.

Thanks,
Namhyung


>
> Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
>
> Thanks,
> Jianyu Zhan
>
>
> On Tue, Jul 29, 2014 at 8:47 PM, Jianyu Zhan <nasa4836@gmail.com> wrote:
>> Hi, Ingo,
>>
>> Here is the new patch with typo fixed.
>>
>> Thanks.
>>
>> ---8<---
>>
>> Currently, if user specifies both symbol name and address, we just
>> bail out.
>>
>> This might be too rude. This patch makes it give more tolerance.
>> If both are specified, check address first, if the symbol found
>> does not match the one user specify, print a waring. If not found,
>> return -ENOENT, because some symbols might have muplitple instances,
>> we don't bother to check symbol name.
>> ---
>>  Documentation/kprobes.txt |  4 +++-
>>  kernel/kprobes.c          | 32 +++++++++++++++++++++++++++++---
>>  2 files changed, 32 insertions(+), 4 deletions(-)
>>
>> diff --git a/Documentation/kprobes.txt b/Documentation/kprobes.txt
>> index 4bbeca8..663b5ad 100644
>> --- a/Documentation/kprobes.txt
>> +++ b/Documentation/kprobes.txt
>> @@ -358,7 +358,9 @@ to install a probepoint is known. This field is used to calculate the
>>  probepoint.
>>
>>  3. Specify either the kprobe "symbol_name" OR the "addr". If both are
>> -specified, kprobe registration will fail with -EINVAL.
>> +specified, only check "addr", because some symbols might have multiple
>> +instances. If neither is specified, kprobe registration will fail
>> +with -EINVAL.
>>
>>  4. With CISC architectures (such as i386 and x86_64), the kprobes code
>>  does not validate if the kprobe.addr is at an instruction boundary.
>> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
>> index 734e9a7..9768608 100644
>> --- a/kernel/kprobes.c
>> +++ b/kernel/kprobes.c
>> @@ -1358,15 +1358,41 @@ static bool within_kprobe_blacklist(unsigned long addr)
>>  static kprobe_opcode_t *kprobe_addr(struct kprobe *p)
>>  {
>>         kprobe_opcode_t *addr = p->addr;
>> +       char namebuf[KSYM_NAME_LEN];
>> +       const char *sym_name = NULL;
>> +       unsigned long offset;
>>
>> -       if ((p->symbol_name && p->addr) ||
>> -           (!p->symbol_name && !p->addr))
>> +       if (!p->symbol_name && !p->addr)
>>                 goto invalid;
>>
>> -       if (p->symbol_name) {
>> +       /*
>> +        * Some symbols might have multiple instances,
>> +        * so if both are specified, only check address.
>> +        */
>> +       if (unlikely(p->addr && p->symbol_name)) {
>> +               sym_name = kallsyms_lookup((unsigned long)(p->addr),
>> +                               NULL, &offset, NULL, namebuf);
>> +               if (!sym_name)
>> +                       return ERR_PTR(-ENOENT);
>> +
>> +               if (strncmp(sym_name, p->symbol_name, KSYM_NAME_LEN)
>> +                               || offset != p->offset) {
>> +                       pr_err("Incorrect symbol or offset, should be "
>> +                               "symbol=%s, offset=%ld.\n", sym_name, offset);
>> +                       goto invalid;
>> +               }
>> +       } else if (p->symbol_name) {
>> +               /* Only symbol case */
>>                 kprobe_lookup_name(p->symbol_name, addr);
>>                 if (!addr)
>>                         return ERR_PTR(-ENOENT);
>> +       } else {
>> +               /*
>> +                * Only address case.
>> +                * Since we later will do a sanity check of the
>> +                * address range in check_kprobe_address_safe(),
>> +                * do nothing here.
>> +                */
>>         }
>>
>>         addr = (kprobe_opcode_t *)(((char *)addr) + p->offset);
>> --
>> 2.0.0
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-doc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
