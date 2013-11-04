Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951Ab3KDS5k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 13:57:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63320 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752720Ab3KDS5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 13:57:39 -0500
Date: Mon, 4 Nov 2013 19:57:54 +0100
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
Message-ID: <20131104185754.GA16428@redhat.com>
References: <1383029621-7384-1-git-send-email-namhyung@kernel.org> <20131102155458.GA6981@redhat.com> <87ob60366m.fsf@sejong.aot.lge.com> <87fvrc35kj.fsf@sejong.aot.lge.com> <20131104155131.GD4440@redhat.com> <20131104162229.GA8921@redhat.com> <20131104184741.GA15945@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131104184741.GA15945@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04, Oleg Nesterov wrote:
>
> On 11/04, Oleg Nesterov wrote:
> >
> > On 11/04, Oleg Nesterov wrote:
> > >
> > > But in any case, I strongly believe that it doesn't make any sense to
> > > rely on tu->inode in get_user_vaddr().
> >
> > Hmm. But I forgot about the case when you probe the function in libc
> > and want to dump the variable in libc...
> >
> > So probably I was wrong and this all needs more thinking. Damn.
> > Perhaps we really need to pass @file/offset, but it is not clear what
> > we can do with bss/anon-mapping.
>
> Or. Not that I really like this, but just for discussion...
>
> How about
>
> 	static void __user *get_user_vaddr(struct pt_regs *regs, unsigned long addr)
> 	{
> 		return (void __force __user *)addr + instruction_pointer(regs);
> 	}
>
> ?
>
> This should solve the problems with relocations/randomization/bss.
>
> The obvious disadvantage is that it is not easy to calculate the
> offset we need to pass as an argument, it depends on the probed
> function.

forgot to mention... and instruction_pointer() can't work in ret-probe,
we need to pass the "unsigned long func" arg somehow...

>
> And this still doesn't allow to, say, probe the executable but read
> the data from libc. Unless, again, we attach to the running process
> or randomize_va_space = 0, so we can know it in advance. But otherwise
> I do not think there is any solution.
>
> Oleg.

