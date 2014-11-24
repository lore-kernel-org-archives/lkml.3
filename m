Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751009AbaKXVA0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 16:00:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39654 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750729AbaKXVAZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 16:00:25 -0500
Date: Mon, 24 Nov 2014 22:00:01 +0100
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, nick <xerofoify@gmail.com>,
        gleb@kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Another Obsolete Fix me in trace.h?
Message-ID: <20141124210000.GB6795@potion.brq.redhat.com>
References: <5472B5B5.5090201@gmail.com>
 <54730475.9040000@redhat.com>
 <54730B33.1080101@siemens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54730B33.1080101@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-11-24 11:40+0100, Jan Kiszka:
> On 2014-11-24 11:12, Paolo Bonzini wrote:
> > On 24/11/2014 05:36, nick wrote:
> >> Greetings Again Gleb and others,
> >> I am assuming in the code I am pasting below the fix me is obsolete now and I can remove it. :)
> >> Cheers Nick
> >> TP_printk("%s (0x%x)",
> >>                   __print_symbolic(__entry->exception, kvm_trace_sym_exc),
> >>                    /* FIXME: don't print error_code if not present */
> >>                   __entry->has_error ? __entry->error_code : 0)
> >> );
> >>
> > 
> > No, it's not obsolete, the idea is to print only
> > 
> >    %s
> > 
> > instead of
> > 
> >    %s (0x%x)
> > 
> > if __entry->has_error is false.  I don't know the trace API well enough
> > to know if that is possible.
> 
> Last time I ran across such a scenario, it was not feasible and
> essentially required separate tracepoints. But maybe Steven knows a trick.

The format string has to be a string literal[1]; we could change it to
allow expressions[2], but what we want is almost possible through a
direct call to trace_seq_printf()[3].

The raw result would look like

  #define __print(fmt, args...) ({ \
  	const char *buf_start = trace_seq_buffer_ptr(p); \
  	trace_seq_printf(p, fmt, args); \
  	trace_seq_putc(p, '\0'); \
  	buf_start; \
  	})

  TP_printk("%s%s", [...],
            __entry->has_error ? __print("(0x%x)", __entry->error_code) : "")

and would be acceptable if something __print-like made it into a ftrace
helper[4].  (Userspace won't be able to nicely print it otherwise.)


---
1: #define TP_printk(fmt, args...) fmt "\n", args
2: TP_printk(__entry->has_error ? "%s (0x%x)" : "%s", [...]
3: Already in scsi_dispatch_cmd_start or kvm_mmu_get_page tracepoints.
4: Like __print_hex or print_symbolic.
