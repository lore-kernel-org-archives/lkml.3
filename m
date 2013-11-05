Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667Ab3KEQ1L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 11:27:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22354 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753625Ab3KEQ1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 11:27:10 -0500
Date: Tue, 5 Nov 2013 17:28:20 +0100
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
Message-ID: <20131105162820.GA2460@redhat.com>
References: <1383029621-7384-1-git-send-email-namhyung@kernel.org> <20131102155458.GA6981@redhat.com> <87ob60366m.fsf@sejong.aot.lge.com> <20131104150112.GC4440@redhat.com> <87zjpj1unj.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zjpj1unj.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05, Namhyung Kim wrote:
>
> On Mon, 4 Nov 2013 16:01:12 +0100, Oleg Nesterov wrote:
> > Or the syntax should be "name=probe @file/addr" or something like this.
>
> Okay.  Let's call this kind of thing "cross-fetch" (or a better name can
> be suggested).

Yes ;) and I am afraid there was some confusion in our discussion.
I probably confused "probe other binaries" with cross-fetch and vice
versa sometimes.

> This is more complex situation and needs more discussion
> as you said.  So let's skip the discussion for now. :)

Agreed.

> > So far I think that trace_uprobes.c should not play games with vma. At all.
>
> Yes, playing with vma is fragile.  But otherwise how can we get the
> address from the file+offset in random processes?

Yes, this is not as simple as I thought.

Let me repeat, somehow I completely forgot we need to probe other (libc)
binaries (not only the executable itself) and dump the data from that
binary. That is why I wrongly thought that that ->start_data trick can
work.

OK, I see other emails from you. Perhaps we can rely on instruction_pointer(),
(I'll write more emails on this), But if not, then we probably need tu->inode
and vma games in fetch/get_user_vaddr(). I'd still like to avoid this, if
possible, but I am no longer sure.


> >> > Can't we simply implement get_user_vaddr() as
> >> >
> >> > 	static void __user *get_user_vaddr(unsigned long addr, struct trace_uprobe *tu)
> >> > 	{
> >> > 		void __user *vaddr = (void __force __user *)addr;
> >> >
> >> > 		/* A NULL tu means that we already got the vaddr */
> >> > 		if (tu)
> >> > 			vaddr += (current->mm->start_data & PAGE_MASK);
> >> >
> >> > 		return vaddr;
> >> > 	}
> >> >
> >> This can only work with the probes fetching data from the executable,
> >> right?  But as I said it should support any other binaries too.
> >
> > See above, we can't in general read other binaries.
>
> Okay, I need to clarify my words.  I'm not saying about "cross-fetch"
> here, what I wanted to say is adding a probe in some dso and fetch data
> from the dso.
>
> [...snip...]

Yes, sorry for confusion, see above.

Oleg.

