Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895Ab3KFRgi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 12:36:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37278 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751172Ab3KFRgh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 12:36:37 -0500
Date: Wed, 6 Nov 2013 18:37:54 +0100
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
Message-ID: <20131106173754.GA11299@redhat.com>
References: <20131102155458.GA6981@redhat.com> <87ob60366m.fsf@sejong.aot.lge.com> <87fvrc35kj.fsf@sejong.aot.lge.com> <20131104155131.GD4440@redhat.com> <20131104162229.GA8921@redhat.com> <20131104184741.GA15945@redhat.com> <87sivbz65t.fsf@sejong.aot.lge.com> <20131105174535.GA6385@redhat.com> <20131105192401.GA772@redhat.com> <87vc05x5zf.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87vc05x5zf.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06, Namhyung Kim wrote:
>
> On Tue, 5 Nov 2013 20:24:01 +0100, Oleg Nesterov wrote:
> > On 11/05, Oleg Nesterov wrote:
> >>
> >> As for "-= tu->offset"... Can't we avoid it? User-space needs to calculate
> >> the "@" argument anyway, why it can't also substruct this offset?
> >>
> >> Or perhaps we can change parse_probe_arg("@") to update "param" ? Yes,
> >> in this case it needs another argument, not sure...
> >
> > Or,
> >
> >> 	+	if (is_ret_probe(tu)) {
> >> 	+		saved_ip = instruction_pointer(regs);
> >> 	+		instruction_pointer_set(func);
> >> 	+	}
> >> 		store_trace_args(...);
> >> 	+	if (is_ret_probe(tu))
> >> 	+		instruction_pointer_set(saved_ip);
> >
> > we can put "-= tu->offset" here.
>
> I don't think I get the point.

I meant,

		saved_ip = instruction_pointer(regs);

		// pass the "ip" which was used to calculate
		// the @addr argument to fetch_*() methods

		temp_ip = is_ret_probe(tu) ? func : saved_ip;
		temp_ip -= tu->offset;
		instruction_pointer_set(temp_ip);

		store_trace_args(...);

		instruction_pointer_set(saved_ip);

This way we can avoid the new "void *" argument for fetch_func_t,
we do not need it to calculate the address.

But: we still need the additional "bool translate_vaddr" to solve
the problems with FETCH_MTD_deref.

We already discussed this a bit, previously I suggested the new
FETCH_MTD_memory_notranslate and

        -       dprm->fetch = t->fetch[FETCH_MTD_memory];
        +       dprm->fetch = t->fetch[FETCH_MTD_memory_notranslate];

change in parse_probe_arg().

However, now I think it would be more clean to leave FETCH_MTD_memory
alone and add FETCH_MTD_memory_dotranslate instead.

So trace_uprobes.c should define

	void FETCH_FUNC_NAME(memory, type)(addr, ...)
	{
		copy_from_user((void __user *)addr);
	}

	void FETCH_FUNC_NAME(memory_dotranslate, type)(addr, ...)
	{
		void __user *uaddr = get_user_vaddr(regs, addr);
		copy_from_user(uaddr);
	}

Then,

> > Or. Perhaps we can leave "case '@'" in parse_probe_arg() and
> > FETCH_MTD_memory alone. You seem to agree that "absolute address"
> > can be useful anyway.
>
> Yes, but it's only meaningful to process-wide tracing sessions IMHO.

Yes, yes, sure.

I meant, we need both. Say, "perf probe "func global=@addr" means
FETCH_MTD_memory, and "perf probe "func global=*addr" means
FETCH_MTD_memory_dotranslate.

Just in case, of course I do not care about the syntax, for example we
can use "@~addr" for translate (or not translate) or whatever.

My only point: I think we need both to

	1. avoid the new argument in fetch_func_t

	2. allow the dump the data from the absolute address

And just to simplify the discussion, lets assume we use "*addr" for
FETCH_MTD_memory_dotranslate and thus parse_probe_arg() gets the new

	case '*':
		if (is_kprobe)
			return -EINVAL;

		kstrtoul(arg + 1, 0, &param);
		f->fn = t->fetch[FETCH_MTD_memory_dotranslate];
		f->data = (void *)param;
		break;
		
branch.

> > Instead, perhaps we can add FETCH_MTD_memory_do_fancy_addr_translation,
> > and, say, the new "case '*'" in parse_probe_arg() should add all the
> > neccessary info as f->data (like, say, FETCH_MTD_symbol).
>
> Could you elaborate this more?

Yes, I was confusing sorry.

As for FETCH_MTD_memory_do_fancy_addr_translation, please see above.

As for "neccessary info as f->data". Suppose that we still have a reason
for the additional argument in FETCH_MTD_memory_dotranslate method. Even
in this case I don't think we should change the signature of fetch_func_t.

What I think we can do is something like

	1. Changed parse_probe_arg() to accept "struct trace_uprobe *tu"
	   instead of is_kprobe. Naturally, !tu can be used instead.

	2. Introduce

		struct dotranslate_fetch_param {
			struct trace_uprobe	*tu;
			fetch_func_t		fetch;
			fetch_func_t		fetch_size;
		};

	3. Change the "case '*'" above to do

		case '*':
			if (!tu)
				return -EINVAL;

			struct dotranslate_fetch_param *xxx = kmalloc(..);

			xxx->fetch = t->fetch[FETCH_MTD_memory];

			// ... kstrtoul, fetch_size, etc, ...

			f->fn = t->fetch[FETCH_MTD_memory_dotranslate];
			f->data = (void *)xxx;

	4. Update traceprobe_free_probe_arg/etc.

	5. Now,
	
		void FETCH_FUNC_NAME(memory_dotranslate, type)(addr, ...)
		{
			struct dotranslate_fetch_param *xxx = data;
			void __user *uaddr = get_user_vaddr(regs, addr, tu);

			xxx->fetch(regs, addr, dest);
		}

Yes, yes, I am sure I missed something and this is not that simple,
I am new to this "fetch" code.

And even if I am right, let me repeat that I am not going to argue.
Well, at least too much ;) This looks better in my opinion, but this
is always subjective, so please free to ignore.

Oleg.

