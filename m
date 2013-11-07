Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079Ab3KGHdz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 02:33:55 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:54078 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019Ab3KGHds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 02:33:48 -0500
X-AuditID: 9c93017e-b7c9fae00000057d-e1-527b4259b37c
From: Namhyung Kim <namhyung@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei\(Jovi\)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCHSET 00/13] tracing/uprobes: Add support for more fetch methods (v6)
References: <1383029621-7384-1-git-send-email-namhyung@kernel.org>
	<20131102155458.GA6981@redhat.com> <87ob60366m.fsf@sejong.aot.lge.com>
	<87fvrc35kj.fsf@sejong.aot.lge.com> <20131104155131.GD4440@redhat.com>
	<20131104162229.GA8921@redhat.com> <20131104184741.GA15945@redhat.com>
	<87sivbz65t.fsf@sejong.aot.lge.com> <20131105174535.GA6385@redhat.com>
	<87zjphx6dl.fsf@sejong.aot.lge.com> <20131106162806.GA7089@redhat.com>
Date: Thu, 07 Nov 2013 16:33:45 +0900
In-Reply-To: <20131106162806.GA7089@redhat.com> (Oleg Nesterov's message of
	"Wed, 6 Nov 2013 17:28:06 +0100")
Message-ID: <87eh6swtra.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oleg,

On Wed, 6 Nov 2013 17:28:06 +0100, Oleg Nesterov wrote:
> On 11/06, Namhyung Kim wrote:
>>
>> On Tue, 5 Nov 2013 18:45:35 +0100, Oleg Nesterov wrote:
>> > On 11/05, Namhyung Kim wrote:
>> >>
>> >> This is what I have for now:
>> >>
>> >> static void __user *get_user_vaddr(struct pt_regs *regs, unsigned long addr,
>> >> 				   struct trace_uprobe *tu)
>> >> {
>> >> 	unsigned long base_addr;
>> >> 	unsigned long vaddr;
>> >>
>> >> 	base_addr = instruction_pointer(regs) - tu->offset;
>> >> 	vaddr = base_addr + addr;
>> >>
>> >> 	return (void __force __user *) vaddr;
>> >> }
>> >>
>> >> When I tested it, it was able to fetch global and bss data from both of
>> >> executable and library properly.
>> >
>> > Heh ;) I didn't expect you will agree with this suggestion. But if you
>> > think it can work - great!
>>
>> It seems to work for me well except the cross-fetch.
>
> Yes, but cross-fetching needs something different anyway, so I think we
> should discuss this separately.

Okay.

>
>> But I'm not sure it'll work for every cases.
>
> I think "ip - tu->offset + vaddr" trick should always work, just we need
> to calculate this "vaddr" passed as an argument correctly.

Right.

>
> Except: user-space can create another executable mapping and call the
> probed function via another address, but I think we can ignore this.
> And I think we can do nothing in this case, because in this case we
> can't even rely on tu->inode.

Agreed.


>> > As for "-= tu->offset"... Can't we avoid it? User-space needs to calculate
>> > the "@" argument anyway, why it can't also substruct this offset?
>>
>> Hmm.. it makes sense too. :)
>
> I am no longer sure ;)
>
> This way the "@" argument will look more confusing, it will depend on the
> address/offset of the probed insn. But again, I do not know, this is up
> to you.

That said, I'd prefer the original "-= -tu->offset" approach.  It'll
make debugging easier IMHO.

>
>> >> But it still doesn't work for uretprobes
>> >> as you said before.
>> >
>> > This looks simple,
>> >
>> > 	+	if (is_ret_probe(tu)) {
>> > 	+		saved_ip = instruction_pointer(regs);
>> > 	+		instruction_pointer_set(func);
>> > 	+	}
>> > 		store_trace_args(...);
>> > 	+	if (is_ret_probe(tu))
>> > 	+		instruction_pointer_set(saved_ip);
>> >
>> > although not pretty.
>>
>> So for normal non-uretprobes, func == instruction_pointer(), right?
>
> No, for normal non-uretprobes func == 0 (actually, undefined).

Ah, okay.

>
>> If so, just passing func as you suggested looks better than this.
>
> Not sure I understand... OK, we can change uprobe_trace_func() and
> uprobe_perf_func()
>
> 		if (!is_ret_probe(tu))
> 	-		uprobe_trace_print(tu, 0, regs);
> 	+		uprobe_trace_print(tu, instruction_pointer(regs), regs);
> 		return 0;
>
> but why?
>
> We need the "saved_ip" ugly hack above only if is_ret_probe() == T and
> thus instruction_pointer() doesn't match the address of the probed function.
> And there is no way to pass some additional info to call_fetch/etc from
> uprobe_*_print().

Ah, I was confused that the 'func' is somewhat available in trace_uprobe
and it can make to avoid passing regs to get_user_vaddr().

Sorry for the noise.


> See also another email...

Will do.

Thanks,
Namhyung
