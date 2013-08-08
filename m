Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965771Ab3HHPGz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 11:06:55 -0400
Received: from mail-ye0-f172.google.com ([209.85.213.172]:45009 "EHLO
	mail-ye0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965702Ab3HHPGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 11:06:54 -0400
Date: Thu, 8 Aug 2013 12:06:47 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 07/19] perf top: Use new idle_sym check
Message-ID: <20130808150647.GB6102@ghostprotocols.net>
References: <1375930261-77273-1-git-send-email-dsahern@gmail.com>
 <1375930261-77273-8-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1375930261-77273-8-git-send-email-dsahern@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Aug 07, 2013 at 10:50:49PM -0400, David Ahern escreveu:
> Avoids strcmp processing each sample.

How so? This is done just when loading a DSO, when then each symbol is
checked against this list.

Tangentially, Frédéric, wasn't there a patchset from you that marks the
context of idle samples, in perf_event_header->misc, additiotally to
PERF_RECORD_MISC_KERNEL, etc? I think there were some for IRQ context as
well, right?

- Arnaldo

> Signed-off-by: David Ahern <dsahern@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Stephane Eranian <eranian@google.com>
> ---
>  tools/perf/builtin-top.c |   25 ++-----------------------
>  1 file changed, 2 insertions(+), 23 deletions(-)
> 
> diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
> index 440c3b3..8eb0e3a 100644
> --- a/tools/perf/builtin-top.c
> +++ b/tools/perf/builtin-top.c
> @@ -634,26 +634,9 @@ repeat:
>  	return NULL;
>  }
>  
> -/* Tag samples to be skipped. */
> -static const char *skip_symbols[] = {
> -	"intel_idle",
> -	"default_idle",
> -	"native_safe_halt",
> -	"cpu_idle",
> -	"enter_idle",
> -	"exit_idle",
> -	"mwait_idle",
> -	"mwait_idle_with_hints",
> -	"poll_idle",
> -	"ppc64_runlatch_off",
> -	"pseries_dedicated_idle_sleep",
> -	NULL
> -};
> -
>  static int symbol_filter(struct map *map __maybe_unused, struct symbol *sym)
>  {
>  	const char *name = sym->name;
> -	int i;
>  
>  	/*
>  	 * ppc64 uses function descriptors and appends a '.' to the
> @@ -671,12 +654,8 @@ static int symbol_filter(struct map *map __maybe_unused, struct symbol *sym)
>  	    strstr(name, "_text_end"))
>  		return 1;
>  
> -	for (i = 0; skip_symbols[i]; i++) {
> -		if (!strcmp(skip_symbols[i], name)) {
> -			sym->ignore = true;
> -			break;
> -		}
> -	}
> +	if (symbol__is_idle(sym))
> +		sym->ignore = true;
>  
>  	return 0;
>  }
> -- 
> 1.7.10.1
