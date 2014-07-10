Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721AbaGJPkX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 11:40:23 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:13402 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751019AbaGJPkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 11:40:22 -0400
Date: Thu, 10 Jul 2014 11:40:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Javi Merino" <javi.merino@arm.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        punit.agrawal@arm.com, broonie@kernel.org,
        Dave Martin <Dave.Martin@arm.com>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [RFC PATCH v5 01/10] tracing: Add array printing helpers
Message-ID: <20140710114010.4d7b2d77@gandalf.local.home>
In-Reply-To: <1405001928-12697-2-git-send-email-javi.merino@arm.com>
References: <1405001928-12697-1-git-send-email-javi.merino@arm.com>
	<1405001928-12697-2-git-send-email-javi.merino@arm.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jul 2014 15:18:39 +0100
"Javi Merino" <javi.merino@arm.com> wrote:

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

Note, please base any patches like this on my for-next branch, because
I have moved the trace_seq code out of trace_print.c.  Although, I need
to analyze this a little bit more to see if these still belong in
trace_print.c or if they should go into trace_seq.c.

My repo is at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git



> 
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> ---
>  include/linux/ftrace_event.h |  9 ++++++++
>  include/trace/ftrace.h       | 17 ++++++++++++++
>  kernel/trace/trace_output.c  | 55 ++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 81 insertions(+)
> 
> diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
> index cff3106ffe2c..919f21a3420b 100644
> --- a/include/linux/ftrace_event.h
> +++ b/include/linux/ftrace_event.h
> @@ -44,6 +44,15 @@ const char *ftrace_print_bitmask_seq(struct trace_seq *p, void *bitmask_ptr,
>  const char *ftrace_print_hex_seq(struct trace_seq *p,
>  				 const unsigned char *buf, int len);
>  
> +const char *ftrace_print_u8_array_seq(struct trace_seq *p,
> +				      const u8 *buf, int count);
> +const char *ftrace_print_u16_array_seq(struct trace_seq *p,
> +				       const u16 *buf, int count);
> +const char *ftrace_print_u32_array_seq(struct trace_seq *p,
> +				       const u32 *buf, int count);
> +const char *ftrace_print_u64_array_seq(struct trace_seq *p,
> +				       const u64 *buf, int count);
> +
>  struct trace_iterator;
>  struct trace_event;
>  
> diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
> index 26b4f2e13275..15bc5d417aea 100644
> --- a/include/trace/ftrace.h
> +++ b/include/trace/ftrace.h
> @@ -263,6 +263,19 @@
>  #undef __print_hex
>  #define __print_hex(buf, buf_len) ftrace_print_hex_seq(p, buf, buf_len)
>  
> +#undef __print_u8_array
> +#define __print_u8_array(array, count)			\
> +	ftrace_print_u8_array_seq(p, array, count)
> +#undef __print_u16_array
> +#define __print_u16_array(array, count)			\
> +	ftrace_print_u16_array_seq(p, array, count)
> +#undef __print_u32_array
> +#define __print_u32_array(array, count)			\
> +	ftrace_print_u32_array_seq(p, array, count)
> +#undef __print_u64_array
> +#define __print_u64_array(array, count)			\
> +	ftrace_print_u64_array_seq(p, array, count)

print_hex_seq() is still in trace_output.c, so perhaps it is fine to
keep these there too.

> +
>  #undef DECLARE_EVENT_CLASS
>  #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
>  static notrace enum print_line_t					\
> @@ -676,6 +689,10 @@ static inline void ftrace_test_probe_##call(void)			\
>  #undef __get_dynamic_array_len
>  #undef __get_str
>  #undef __get_bitmask
> +#undef __print_u8_array
> +#undef __print_u16_array
> +#undef __print_u32_array
> +#undef __print_u64_array
>  
>  #undef TP_printk
>  #define TP_printk(fmt, args...) "\"" fmt "\", "  __stringify(args)
> diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
> index f3dad80c20b2..b46238e75523 100644
> --- a/kernel/trace/trace_output.c
> +++ b/kernel/trace/trace_output.c
> @@ -454,6 +454,61 @@ ftrace_print_hex_seq(struct trace_seq *p, const unsigned char *buf, int buf_len)
>  }
>  EXPORT_SYMBOL(ftrace_print_hex_seq);
>  
> +static const char *
> +ftrace_print_array_seq(struct trace_seq *p, const void *buf, int buf_len,
> +		       bool (*iterator)(struct trace_seq *p, const char *prefix,
> +					const void **buf, int *buf_len))
> +{
> +	const char *ret = p->buffer + p->len;

There is now a helper in my for-next branch that removes the above open
coded code:

	const char *ret = trace_seq_buffer_ptr(p);

> +	const char *prefix = "";
> +
> +	trace_seq_putc(p, '{');
> +
> +	if (iterator(p, prefix, &buf, &buf_len)) {
> +		prefix = ",";
> +
> +		while (iterator(p, prefix, &buf, &buf_len))

The above doesn't even need the prefix variable. But I would keep it
and remove the if and have this:

	while (iterator(p, prefix, &buf, &buf_len))
		prefix = ",";

and hope gcc just optimizes it. This is not a critical path, don't
micro optimize it and make the code more complex than need be,
especially when gcc should be smart enough to optimize it for you.

> +			;
> +	}
> +
> +	trace_seq_putc(p, '}');
> +	trace_seq_putc(p, 0);

trace_seq is only one page in size, which should be enough. I'm
wondering if we should check the return status of all the trace_seq()
calls and return an error.

> +
> +	return ret;
> +}
> +
> +#define DEFINE_PRINT_ARRAY(type, printk_type, format)			\
> +static bool								\
> +ftrace_print_array_iterator_##type(struct trace_seq *p, const char *prefix, \
> +				   const void **buf, int *buf_len)	\
> +{									\
> +	const type *__src = *buf;					\
> +									\
> +	if (*buf_len < sizeof(*__src))					\
> +		return false;						\
> +									\
> +	trace_seq_printf(p, "%s" format, prefix, (printk_type)*__src++); \
> +									\
> +	*buf = __src;							\
> +	*buf_len -= sizeof(*__src);					\
> +									\
> +	return true;							\
> +}									\
> +									\
> +const char *ftrace_print_##type##_array_seq(				\
> +	struct trace_seq *p, const type *buf, int count)		\
> +{									\
> +	return ftrace_print_array_seq(p, buf, (count) * sizeof(type),	\
> +				      ftrace_print_array_iterator_##type); \
> +}									\
> +									\
> +EXPORT_SYMBOL(ftrace_print_##type##_array_seq);
> +
> +DEFINE_PRINT_ARRAY(u8, unsigned int, "0x%x")

Why not "unsigned char"?

> +DEFINE_PRINT_ARRAY(u16, unsigned int, "0x%x")

Why not "unsigned short"?

> +DEFINE_PRINT_ARRAY(u32, unsigned int, "0x%x")
> +DEFINE_PRINT_ARRAY(u64, unsigned long long, "0x%llx")
> +
>  int ftrace_raw_output_prep(struct trace_iterator *iter,
>  			   struct trace_event *trace_event)
>  {

-- Steve
