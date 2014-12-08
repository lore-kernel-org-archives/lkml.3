Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586AbaLHPmQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 10:42:16 -0500
Received: from smtprelay0059.hostedemail.com ([216.40.44.59]:60329 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752383AbaLHPmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 10:42:15 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:4605:5007:6119:6120:6261:7875:8603:10004:10400:10848:10967:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12740:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: angle37_30621bef9df3f
X-Filterd-Recvd-Size: 3663
Date: Mon, 8 Dec 2014 10:42:10 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: "Javi Merino" <javi.merino@arm.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        punit.agrawal@arm.com, broonie@kernel.org,
        Dave Martin <Dave.Martin@arm.com>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [RFC PATCH v6 1/9] tracing: Add array printing helpers
Message-ID: <20141208104210.69874f14@gandalf.local.home>
In-Reply-To: <1417806260-9264-2-git-send-email-javi.merino@arm.com>
References: <1417806260-9264-1-git-send-email-javi.merino@arm.com>
	<1417806260-9264-2-git-send-email-javi.merino@arm.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  5 Dec 2014 19:04:12 +0000
"Javi Merino" <javi.merino@arm.com> wrote:

 
> +static const char *
> +ftrace_print_array_seq(struct trace_seq *p, const void *buf, int buf_len,
> +		       bool (*iterator)(struct trace_seq *p, const char *prefix,
> +					const void **buf, int *buf_len))
> +{
> +	const char *ret = trace_seq_buffer_ptr(p);
> +	const char *prefix = "";
> +
> +	trace_seq_putc(p, '{');
> +
> +	while (iterator(p, prefix, &buf, &buf_len))
> +		prefix = ",";
> +
> +	trace_seq_putc(p, '}');
> +	trace_seq_putc(p, 0);
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
> +EXPORT_SYMBOL(ftrace_print_##type##_array_seq)
> +
> +DEFINE_PRINT_ARRAY(u8, unsigned int, "0x%x");
> +DEFINE_PRINT_ARRAY(u16, unsigned int, "0x%x");
> +DEFINE_PRINT_ARRAY(u32, unsigned int, "0x%x");
> +DEFINE_PRINT_ARRAY(u64, unsigned long long, "0x%llx");
> +

I would really like to avoid adding a bunch of macros for each type.
Can't we have something like this:

ftrace_print_array(struct trace_seq *p, void *buf, int buf_len, 
		int size)
{
	char *prefix = "";
	void *ptr = buf;

	while (ptr < buf + buf_len) {
		switch(size) {
		case 8:
			trace_seq_printf("%s0x%x", prefix,
				*(unsigned char *)ptr);
			break;
		case 16:
			trace_seq_printf("%s0x%x", prefix,
				*(unsigned short *)ptr);
			break;
		case 32:
			trace_seq_printf("%s0x%x", prefix,
				*(unsigned int *)ptr);
			break;
		case 64:
			trace_seq_printf("%s0x%llx", prefix,
				*(unsigned long long *)ptr);
			break;
		default:
			BUG();
		}
		prefix = ",";
		ptr += size;
	}

}

We probably could even make the "BUG()" into a build bug, with a little
work.

-- Steve

>  int ftrace_raw_output_prep(struct trace_iterator *iter,
>  			   struct trace_event *trace_event)
>  {

