Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751234AbaKXVTH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 16:19:07 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:11199 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750734AbaKXVTF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 16:19:05 -0500
Date: Mon, 24 Nov 2014 16:19:01 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Radim =?UTF-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>, Paolo Bonzini <pbonzini@redhat.com>,
        nick <xerofoify@gmail.com>, gleb@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Another Obsolete Fix me in trace.h?
Message-ID: <20141124161901.6266925c@gandalf.local.home>
In-Reply-To: <20141124210000.GB6795@potion.brq.redhat.com>
References: <5472B5B5.5090201@gmail.com>
	<54730475.9040000@redhat.com>
	<54730B33.1080101@siemens.com>
	<20141124210000.GB6795@potion.brq.redhat.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Nov 2014 22:00:01 +0100
Radim Krčmář <rkrcmar@redhat.com> wrote:

> 2014-11-24 11:40+0100, Jan Kiszka:
> > On 2014-11-24 11:12, Paolo Bonzini wrote:
> > > On 24/11/2014 05:36, nick wrote:
> > >> Greetings Again Gleb and others,
> > >> I am assuming in the code I am pasting below the fix me is obsolete now and I can remove it. :)
> > >> Cheers Nick
> > >> TP_printk("%s (0x%x)",
> > >>                   __print_symbolic(__entry->exception, kvm_trace_sym_exc),
> > >>                    /* FIXME: don't print error_code if not present */
> > >>                   __entry->has_error ? __entry->error_code : 0)
> > >> );
> > >>
> > > 
> > > No, it's not obsolete, the idea is to print only
> > > 
> > >    %s
> > > 
> > > instead of
> > > 
> > >    %s (0x%x)
> > > 
> > > if __entry->has_error is false.  I don't know the trace API well enough
> > > to know if that is possible.
> > 
> > Last time I ran across such a scenario, it was not feasible and
> > essentially required separate tracepoints. But maybe Steven knows a trick.
> 
> The format string has to be a string literal[1]; we could change it to
> allow expressions[2], but what we want is almost possible through a
> direct call to trace_seq_printf()[3].
> 
> The raw result would look like
> 
>   #define __print(fmt, args...) ({ \
>   	const char *buf_start = trace_seq_buffer_ptr(p); \
>   	trace_seq_printf(p, fmt, args); \
>   	trace_seq_putc(p, '\0'); \
>   	buf_start; \
>   	})
> 
>   TP_printk("%s%s", [...],
>             __entry->has_error ? __print("(0x%x)", __entry->error_code) : "")
> 
> and would be acceptable if something __print-like made it into a ftrace
> helper[4].  (Userspace won't be able to nicely print it otherwise.)

You mean if we add something like a __print_conditional(cond, fmt, ...);

For this case you would have:

  TP_printk("%s%s", [...],
	__print_conditional(__entry->has_error, " (0x%x)", __entry->error_code));

Where __print_conditional() will return "" when "cond" is false, and
will return the formatted string otherwise.

That wouldn't be too hard to implement.

-- Steve


> 
> 
> ---
> 1: #define TP_printk(fmt, args...) fmt "\n", args
> 2: TP_printk(__entry->has_error ? "%s (0x%x)" : "%s", [...]
> 3: Already in scsi_dispatch_cmd_start or kvm_mmu_get_page tracepoints.
> 4: Like __print_hex or print_symbolic.

