Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523AbbAPCVj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 21:21:39 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:20115 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751261AbbAPCVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 21:21:38 -0500
Date: Thu, 15 Jan 2015 21:22:02 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Javi Merino <javi.merino@arm.com>
Cc: linux-kernel@vger.kernel.org, Dave Martin <Dave.Martin@arm.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [RESEND PATCH v2 1/2] tracing: Add array printing helpers
Message-ID: <20150115212202.7939072a@grimm.local.home>
In-Reply-To: <1421340659-18063-1-git-send-email-javi.merino@arm.com>
References: <1421340659-18063-1-git-send-email-javi.merino@arm.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jan 2015 16:50:58 +0000
Javi Merino <javi.merino@arm.com> wrote:
 
> +const char *
> +ftrace_print_array_seq(struct trace_seq *p, const void *buf, int
> buf_len,
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
> +			BUG();

BUG() is a bit extreme don't you think? I'm not sure it even deserves a
WARN_ON().

I would suggest doing:

			trace_seq_printf(p, "BAD SIZE:%d 0x%x", el_size,
					*(u8 *)ptr);
			el_size = 8;

No need to go crashing the kernel or even messing with dmesg over
somebody's tracepoint mistake.

The rest looks fine.

> +		}
> +		prefix = ",";
> +		ptr += el_size / 8;
> +	}
> +
> +	trace_seq_putc(p, '}');
> +	trace_seq_putc(p, 0);

I need to add a trace_seq_terminate() for this.

-- Steve

> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(ftrace_print_array_seq);
> +
>  int ftrace_raw_output_prep(struct trace_iterator *iter,
>  			   struct trace_event *trace_event)
>  {

