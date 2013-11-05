Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167Ab3KECtG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 21:49:06 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:47755 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495Ab3KECtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 21:49:05 -0500
X-AuditID: 9c93017d-b7c6fae00000364c-a3-52785c9df45a
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
Date: Tue, 05 Nov 2013 11:49:01 +0900
In-Reply-To: <20131104184741.GA15945@redhat.com> (Oleg Nesterov's message of
	"Mon, 4 Nov 2013 19:47:41 +0100")
Message-ID: <87a9hj1s2q.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Nov 2013 19:47:41 +0100, Oleg Nesterov wrote:
> On 11/04, Oleg Nesterov wrote:
>>
>> On 11/04, Oleg Nesterov wrote:
>> >
>> > But in any case, I strongly believe that it doesn't make any sense to
>> > rely on tu->inode in get_user_vaddr().
>>
>> Hmm. But I forgot about the case when you probe the function in libc
>> and want to dump the variable in libc...
>>
>> So probably I was wrong and this all needs more thinking. Damn.
>> Perhaps we really need to pass @file/offset, but it is not clear what
>> we can do with bss/anon-mapping.
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

Right.  I think this approach is more reliable than playing with vma.

>
> The obvious disadvantage is that it is not easy to calculate the
> offset we need to pass as an argument, it depends on the probed
> function.

Well, maybe it's not that hard if we use symbol address in elf image
rather than file offset for the data.

IOW we can get the base mapping address by subtracting tu->offset from
instruction pointer.  And then adding symbol address of the data should
give us the final virtual address, yay!

I'll try to play with it after lunch.

>
> And this still doesn't allow to, say, probe the executable but read
> the data from libc. Unless, again, we attach to the running process
> or randomize_va_space = 0, so we can know it in advance. But otherwise
> I do not think there is any solution.

Yes, cross-fetching is hard, let's go lunch. :)

Thanks,
Namhyung
