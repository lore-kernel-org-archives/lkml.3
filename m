Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047AbaAOCBH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 21:01:07 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:10998 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750880AbaAOCBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 21:01:04 -0500
Date: Tue, 14 Jan 2014 21:00:58 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 01/17] tools lib traceevent: Add state member to struct
 trace_seq
Message-ID: <20140114210058.6b75c47a@gandalf.local.home>
In-Reply-To: <1389750340-15965-2-git-send-email-namhyung@kernel.org>
References: <1389750340-15965-1-git-send-email-namhyung@kernel.org>
	<1389750340-15965-2-git-send-email-namhyung@kernel.org>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jan 2014 10:45:24 +0900
Namhyung Kim <namhyung@kernel.org> wrote:

>  
> @@ -32,8 +33,9 @@
>  #define TRACE_SEQ_POISON	((void *)0xdeadbeef)
>  #define TRACE_SEQ_CHECK(s)						\
>  do {									\
> -	if ((s)->buffer == TRACE_SEQ_POISON)			\
> -		die("Usage of trace_seq after it was destroyed");	\
> +	if (WARN_ONCE((s)->buffer == TRACE_SEQ_POISON,			\
> +		      "Usage of trace_seq after it was destroyed"))	\
> +		(s)->state = TRACE_SEQ__BUFFER_POISONED;		\
>  } while (0)
>  
>  /**
> @@ -46,6 +48,7 @@ void trace_seq_init(struct trace_seq *s)
>  	s->readpos = 0;
>  	s->buffer_size = TRACE_SEQ_BUF_SIZE;
>  	s->buffer = malloc_or_die(s->buffer_size);
> +	s->state = TRACE_SEQ__GOOD;
>  }
>  
>  /**
> @@ -80,8 +83,9 @@ static void expand_buffer(struct trace_seq *s)
>  {
>  	s->buffer_size += TRACE_SEQ_BUF_SIZE;
>  	s->buffer = realloc(s->buffer, s->buffer_size);
> -	if (!s->buffer)
> -		die("Can't allocate trace_seq buffer memory");
> +	if (WARN_ONCE(!s->buffer,
> +		      "Can't allocate trace_seq buffer memory"))
> +		s->state = TRACE_SEQ__MEM_ALLOC_FAILED;
>  }
>  
>  /**
> @@ -108,6 +112,9 @@ trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
>  	TRACE_SEQ_CHECK(s);
>  
>   try_again:
> +	if (s->state != TRACE_SEQ__GOOD)
> +		return 0;
> +
>  	len = (s->buffer_size - 1) - s->len;
>  
>  	va_start(ap, fmt);
> @@ -144,6 +151,9 @@ trace_seq_vprintf(struct trace_seq *s, const char *fmt, va_list args)
>  	TRACE_SEQ_CHECK(s);
>  
>   try_again:
> +	if (s->state != TRACE_SEQ__GOOD)
> +		return 0;
> +
>  	len = (s->buffer_size - 1) - s->len;
>  
>  	ret = vsnprintf(s->buffer + s->len, len, fmt, args);
> @@ -174,11 +184,17 @@ int trace_seq_puts(struct trace_seq *s, const char *str)
>  
>  	TRACE_SEQ_CHECK(s);
>  
> +	if (s->state != TRACE_SEQ__GOOD)
> +		return 0;
> +
>  	len = strlen(str);
>  
>  	while (len > ((s->buffer_size - 1) - s->len))
>  		expand_buffer(s);
>  
> +	if (s->state != TRACE_SEQ__GOOD)
> +		return 0;
> +
>  	memcpy(s->buffer + s->len, str, len);
>  	s->len += len;
>  
> @@ -189,9 +205,15 @@ int trace_seq_putc(struct trace_seq *s, unsigned char c)
>  {
>  	TRACE_SEQ_CHECK(s);
>  
> +	if (s->state != TRACE_SEQ__GOOD)
> +		return 0;
> +

Instead of adding all of these, we can extend the macro
TRACE_SEQ_CHECK() which does a
	if (s->state != TRACE_SEQ__GOOD)
		return;

and a TRACE_SEQ_CHECK_RET() that does a return 0;

-- Steve

>  	while (s->len >= (s->buffer_size - 1))
>  		expand_buffer(s);
>  
> +	if (s->state != TRACE_SEQ__GOOD)
> +		return 0;
> +
>  	s->buffer[s->len++] = c;
>  
>  	return 1;
> @@ -201,6 +223,9 @@ void trace_seq_terminate(struct trace_seq *s)
>  {
>  	TRACE_SEQ_CHECK(s);
>  
> +	if (s->state != TRACE_SEQ__GOOD)
> +		return;
> +
>  	/* There's always one character left on the buffer */
>  	s->buffer[s->len] = 0;
>  }
> @@ -208,5 +233,16 @@ void trace_seq_terminate(struct trace_seq *s)
>  int trace_seq_do_printf(struct trace_seq *s)
>  {
>  	TRACE_SEQ_CHECK(s);
> -	return printf("%.*s", s->len, s->buffer);
> +
> +	switch (s->state) {
> +	case TRACE_SEQ__GOOD:
> +		return printf("%.*s", s->len, s->buffer);
> +	case TRACE_SEQ__BUFFER_POISONED:
> +		puts("Usage of trace_seq after it was destroyed");
> +		break;
> +	case TRACE_SEQ__MEM_ALLOC_FAILED:
> +		puts("Can't allocate trace_seq buffer memory");
> +		break;
> +	}
> +	return -1;
>  }

