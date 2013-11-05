Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034Ab3KERqV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 12:46:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42598 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838Ab3KERqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 12:46:20 -0500
Date: Tue, 5 Nov 2013 18:45:35 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCHSET 00/13] tracing/uprobes: Add support for more fetch
	methods (v6)
Message-ID: <20131105174535.GA6385@redhat.com>
References: <1383029621-7384-1-git-send-email-namhyung@kernel.org> <20131102155458.GA6981@redhat.com> <87ob60366m.fsf@sejong.aot.lge.com> <87fvrc35kj.fsf@sejong.aot.lge.com> <20131104155131.GD4440@redhat.com> <20131104162229.GA8921@redhat.com> <20131104184741.GA15945@redhat.com> <87sivbz65t.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sivbz65t.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05, Namhyung Kim wrote:
>
> This is what I have for now:
>
> static void __user *get_user_vaddr(struct pt_regs *regs, unsigned long addr,
> 				   struct trace_uprobe *tu)
> {
> 	unsigned long base_addr;
> 	unsigned long vaddr;
>
> 	base_addr = instruction_pointer(regs) - tu->offset;
> 	vaddr = base_addr + addr;
>
> 	return (void __force __user *) vaddr;
> }
>
> When I tested it, it was able to fetch global and bss data from both of
> executable and library properly.

Heh ;) I didn't expect you will agree with this suggestion. But if you
think it can work - great!

Let me clarify just in case. Yes, _personally_ I think we should try
to avoid the vma games, and it looks better to me this way. But I won't
argue if you change your mind, I understand this approach has its own
disadvantages.

As for "-= tu->offset"... Can't we avoid it? User-space needs to calculate
the "@" argument anyway, why it can't also substruct this offset?

Or perhaps we can change parse_probe_arg("@") to update "param" ? Yes,
in this case it needs another argument, not sure...

> But it still doesn't work for uretprobes
> as you said before.

This looks simple,

	+	if (is_ret_probe(tu)) {
	+		saved_ip = instruction_pointer(regs);
	+		instruction_pointer_set(func);
	+	}
		store_trace_args(...);
	+	if (is_ret_probe(tu))
	+		instruction_pointer_set(saved_ip);

although not pretty.

> This symbol offset calculation was done in the getsymoff which implemented
> like below (I'm sure there's a much simpler way to do this, but ...).

Perhaps I'll even try to read/understand it later, but this elf stuff is
the black magic to me ;)

Oleg.

