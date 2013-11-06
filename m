Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140Ab3KFIs5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 03:48:57 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:56711 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab3KFIs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 03:48:56 -0500
X-AuditID: 9c930197-b7c0bae0000007bd-56-527a0276d7a5
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
Date: Wed, 06 Nov 2013 17:48:54 +0900
In-Reply-To: <20131105174535.GA6385@redhat.com> (Oleg Nesterov's message of
	"Tue, 5 Nov 2013 18:45:35 +0100")
Message-ID: <87zjphx6dl.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Nov 2013 18:45:35 +0100, Oleg Nesterov wrote:
> On 11/05, Namhyung Kim wrote:
>>
>> This is what I have for now:
>>
>> static void __user *get_user_vaddr(struct pt_regs *regs, unsigned long addr,
>> 				   struct trace_uprobe *tu)
>> {
>> 	unsigned long base_addr;
>> 	unsigned long vaddr;
>>
>> 	base_addr = instruction_pointer(regs) - tu->offset;
>> 	vaddr = base_addr + addr;
>>
>> 	return (void __force __user *) vaddr;
>> }
>>
>> When I tested it, it was able to fetch global and bss data from both of
>> executable and library properly.
>
> Heh ;) I didn't expect you will agree with this suggestion. But if you
> think it can work - great!

It seems to work for me well except the cross-fetch.

But I'm not sure it'll work for every cases.  It would be great if some
elf gurus come up and give some feedbacks.

Masami?

>
> Let me clarify just in case. Yes, _personally_ I think we should try
> to avoid the vma games, and it looks better to me this way. But I won't
> argue if you change your mind, I understand this approach has its own
> disadvantages.
>
> As for "-= tu->offset"... Can't we avoid it? User-space needs to calculate
> the "@" argument anyway, why it can't also substruct this offset?

Hmm.. it makes sense too. :)

>
> Or perhaps we can change parse_probe_arg("@") to update "param" ? Yes,
> in this case it needs another argument, not sure...
>
>> But it still doesn't work for uretprobes
>> as you said before.
>
> This looks simple,
>
> 	+	if (is_ret_probe(tu)) {
> 	+		saved_ip = instruction_pointer(regs);
> 	+		instruction_pointer_set(func);
> 	+	}
> 		store_trace_args(...);
> 	+	if (is_ret_probe(tu))
> 	+		instruction_pointer_set(saved_ip);
>
> although not pretty.

So for normal non-uretprobes, func == instruction_pointer(), right?

If so, just passing func as you suggested looks better than this.

Thanks,
Namhyung
