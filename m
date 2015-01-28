Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756333AbbA1DgD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 22:36:03 -0500
Received: from smtprelay0033.hostedemail.com ([216.40.44.33]:39780 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753901AbbA1DgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 22:36:01 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::,RULES_HIT:2:41:355:379:541:599:800:960:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1535:1593:1594:1605:1606:1730:1747:1777:1792:2196:2199:2393:2553:2559:2562:2692:2737:2892:2895:3138:3139:3140:3141:3142:3622:3865:3866:3867:3868:3870:3871:3872:3874:4321:4362:4605:5007:6119:6261:7576:7875:7903:8603:8660:10004:10848:10967:11026:11232:11473:11658:11914:12043:12291:12296:12438:12517:12519:12555:12683:12740:13148:13230:14093:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: boats19_170c3623cdf61
X-Filterd-Recvd-Size: 5999
Date: Tue, 27 Jan 2015 22:35:57 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Javi Merino <javi.merino@arm.com>
Cc: linux-kernel@vger.kernel.org, Dave Martin <Dave.Martin@arm.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v4 1/3] tracing: Add array printing helpers
Message-ID: <20150127223557.407f3a13@gandalf.local.home>
In-Reply-To: <1422274311-19738-2-git-send-email-javi.merino@arm.com>
References: <1422274311-19738-1-git-send-email-javi.merino@arm.com>
	<1422274311-19738-2-git-send-email-javi.merino@arm.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Jan 2015 12:11:49 +0000
Javi Merino <javi.merino@arm.com> wrote:

> From: Dave Martin <Dave.Martin@arm.com>
> 
> If a trace event contains an array, there is currently no standard
> way to format this for text output.  Drivers are currently hacking
> around this by a) local hacks that use the trace_seq functionailty
> directly, or b) just not printing that information.  For fixed size
> arrays, formatting of the elements can be open-coded, but this gets
> cumbersome for arrays of non-trivial size.
> 
> These approaches result in non-standard content of the event format
> description delivered to userspace, so userland tools needs to be
> taught to understand and parse each array printing method
> individually.
> 
> This patch implements common __print_<type>_array() helpers that
> tracepoint implementations can use instead of reinventing them.  A
> simple C-style syntax is used to delimit the array and its elements
> {like,this}.
> 
> So that the helpers can be used with large static arrays as well as
> dynamic arrays, they take a pointer and element count: they can be
> used with __get_dynamic_array() for use with dynamic arrays.
> 
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> Signed-off-by: Javi Merino <javi.merino@arm.com>
> ---
>  include/linux/ftrace_event.h |  4 ++++
>  include/trace/ftrace.h       |  9 +++++++++
>  kernel/trace/trace_output.c  | 44 ++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 57 insertions(+)
> 
> diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
> index 0bebb5c348b8..5aa4a9269547 100644
> --- a/include/linux/ftrace_event.h
> +++ b/include/linux/ftrace_event.h
> @@ -44,6 +44,10 @@ const char *ftrace_print_bitmask_seq(struct trace_seq *p, void *bitmask_ptr,
>  const char *ftrace_print_hex_seq(struct trace_seq *p,
>  				 const unsigned char *buf, int len);
>  
> +const char *ftrace_print_array_seq(struct trace_seq *p,
> +				   const void *buf, int buf_len,
> +				   size_t el_size);
> +
>  struct trace_iterator;
>  struct trace_event;
>  
> diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
> index 139b5067345b..36afd0ed3458 100644
> --- a/include/trace/ftrace.h
> +++ b/include/trace/ftrace.h
> @@ -263,6 +263,14 @@
>  #undef __print_hex
>  #define __print_hex(buf, buf_len) ftrace_print_hex_seq(p, buf, buf_len)
>  
> +#undef __print_array
> +#define __print_array(array, count, el_size)				\
> +	({								\
> +		BUILD_BUG_ON(el_size != 8 && el_size != 16 &&		\
> +			el_size != 32 && el_size != 64);		\

I tried testing this patch by writing a print_array myself, and I kept
hitting this BUILD_BUG_ON, and was wondering WTF? Then it dawned on me.

el_size should not be based on bits, it should be based on bytes. I
passed in "sizeof()" which doesn't work with bits.

Please update to "el_size < 1 || el_size > 8".

and adjust the rest accordingly.

Thanks,

-- Steve


> +		ftrace_print_array_seq(p, array, count, el_size);	\
> +	})
> +
>  #undef DECLARE_EVENT_CLASS
>  #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
>  static notrace enum print_line_t					\
> @@ -674,6 +682,7 @@ static inline void ftrace_test_probe_##call(void)			\
>  #undef __get_dynamic_array_len
>  #undef __get_str
>  #undef __get_bitmask
> +#undef __print_array
>  
>  #undef TP_printk
>  #define TP_printk(fmt, args...) "\"" fmt "\", "  __stringify(args)
> diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
> index b77b9a697619..c06bd6e4ae0e 100644
> --- a/kernel/trace/trace_output.c
> +++ b/kernel/trace/trace_output.c
> @@ -177,6 +177,50 @@ ftrace_print_hex_seq(struct trace_seq *p, const unsigned char *buf, int buf_len)
>  }
>  EXPORT_SYMBOL(ftrace_print_hex_seq);
>  
> +const char *
> +ftrace_print_array_seq(struct trace_seq *p, const void *buf, int buf_len,
> +		       size_t el_size)
> +{
> +	const char *ret = trace_seq_buffer_ptr(p);
> +	const char *prefix = "";
> +	void *ptr = (void *)buf;
> +
> +	trace_seq_putc(p, '{');
> +
> +	while (ptr < buf + buf_len) {
> +		switch (el_size) {
> +		case 8:
> +			trace_seq_printf(p, "%s0x%x", prefix,
> +					 *(u8 *)ptr);
> +			break;
> +		case 16:
> +			trace_seq_printf(p, "%s0x%x", prefix,
> +					 *(u16 *)ptr);
> +			break;
> +		case 32:
> +			trace_seq_printf(p, "%s0x%x", prefix,
> +					 *(u32 *)ptr);
> +			break;
> +		case 64:
> +			trace_seq_printf(p, "%s0x%llx", prefix,
> +					 *(u64 *)ptr);
> +			break;
> +		default:
> +			trace_seq_printf(p, "BAD SIZE:%zu 0x%x", el_size,
> +					 *(u8 *)ptr);
> +			el_size = 8;
> +		}
> +		prefix = ",";
> +		ptr += el_size / 8;
> +	}
> +
> +	trace_seq_putc(p, '}');
> +	trace_seq_putc(p, 0);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(ftrace_print_array_seq);
> +
>  int ftrace_raw_output_prep(struct trace_iterator *iter,
>  			   struct trace_event *trace_event)
>  {

