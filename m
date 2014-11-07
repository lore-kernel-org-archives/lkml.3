Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176AbaKGS7c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 13:59:32 -0500
Received: from smtprelay0236.hostedemail.com ([216.40.44.236]:59407 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752018AbaKGS7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 13:59:31 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:800:967:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2393:2525:2560:2563:2682:2685:2693:2828:2859:2902:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3868:3871:3872:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:4605:5007:6119:6261:7903:8599:8603:9025:10004:10049:10400:10848:10913:11026:11232:11473:11658:11914:12043:12296:12517:12519:12555:12663:12740:12783:13018:13019:13846:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: spot23_6fd23f1ed6816
X-Filterd-Recvd-Size: 3959
Message-ID: <1415386767.23530.14.camel@perches.com>
Subject: Re: [RFC][PATCH 03/12 v3] tracing: Create seq_buf layer in trace_seq
From: Joe Perches <joe@perches.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Petr Mladek <pmladek@suse.cz>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Fri, 07 Nov 2014 10:59:27 -0800
In-Reply-To: <20141107133017.0d0ecd2e@gandalf.local.home>
References: <20141104155237.228431433@goodmis.org>
	 <20141104160221.864997179@goodmis.org>
	 <20141105142222.GC4570@pathway.suse.cz>
	 <20141105134147.226a23ef@gandalf.local.home>
	 <20141105150007.1c543b9e@gandalf.local.home>
	 <20141105161720.71abdbdb@gandalf.local.home>
	 <20141105162146.6edc1567@gandalf.local.home>
	 <20141106163352.GJ2001@dhcp128.suse.cz>
	 <20141107133017.0d0ecd2e@gandalf.local.home>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-11-07 at 13:30 -0500, Steven Rostedt wrote:
> I'm not going to waist bandwidth reposting the entire series. Here's a
> new version of this patch. I'm getting ready to pull it into my next
> queue.

All this seems sensible enough though I think it'd
be nicer if all the touch-ups were compressed into
a single patch.

and some trivia:

> Create a seq_buf layer that trace_seq sits on. The seq_buf will not
> be limited to page size. This will allow other usages of seq_buf
> instead of a hard set PAGE_SIZE one that trace_seq has.
> 
> Link: http://lkml.kernel.org/r/20141104160221.864997179@goodmis.org
[]
> diff --git a/include/linux/seq_buf.h b/include/linux/seq_buf.h
[]
> +extern __printf(2, 3)
> +int seq_buf_printf(struct seq_buf *s, const char *fmt, ...);
> +extern __printf(2, 0)
> +int seq_buf_vprintf(struct seq_buf *s, const char *fmt, va_list args);
> +extern int
> +seq_buf_bprintf(struct seq_buf *s, const char *fmt, const u32 *binary);
> +extern int seq_buf_print_seq(struct seq_file *m, struct seq_buf *s);
> +extern int seq_buf_to_user(struct seq_buf *s, char __user *ubuf,
> +			   int cnt);
> +extern int seq_buf_puts(struct seq_buf *s, const char *str);
> +extern int seq_buf_putc(struct seq_buf *s, unsigned char c);
> +extern int seq_buf_putmem(struct seq_buf *s, const void *mem, unsigned int len);
> +extern int seq_buf_putmem_hex(struct seq_buf *s, const void *mem,
> +			      unsigned int len);
> +extern int seq_buf_path(struct seq_buf *s, const struct path *path);
> +
> +extern int seq_buf_bitmask(struct seq_buf *s, const unsigned long *maskp,
> +			   int nmaskbits);

Maybe remove the extern bits from the function definitions?
And maybe the unsigned int len/cnt could be size_t

> diff --git a/include/linux/trace_seq.h b/include/linux/trace_seq.h
[]
> @@ -12,16 +12,14 @@
>  
>  struct trace_seq {
>  	unsigned char		buffer[PAGE_SIZE];
> -	unsigned int		len;
> -	unsigned int		readpos;
> +	struct seq_buf		seq;
>  	int			full;
>  };
>  
>  static inline void
>  trace_seq_init(struct trace_seq *s)
>  {
> -	s->len = 0;
> -	s->readpos = 0;
> +	seq_buf_init(&s->seq, s->buffer, PAGE_SIZE);

Maybe the PAGE_SIZE uses could be ARRAY_SIZE(s->buffer)

> diff --git a/kernel/trace/trace_seq.c b/kernel/trace/trace_seq.c
[]
>  /* How much buffer is written? */
> -#define TRACE_SEQ_BUF_USED(s) min((s)->len, (unsigned int)(PAGE_SIZE - 1))
> +#define TRACE_SEQ_BUF_USED(s) min((s)->seq.len, (unsigned int)(PAGE_SIZE - 1))

min_t?
maybe this should be FIELD_SIZEOF(struct trace_seq, buffer) - 1




