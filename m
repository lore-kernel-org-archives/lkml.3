Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467AbaCEBAd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 20:00:33 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:42731 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904AbaCEBAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 20:00:31 -0500
Message-ID: <53167729.5060104@gmail.com>
Date: Tue, 04 Mar 2014 18:00:25 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Ramkumar Ramachandra <artagnon@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH] perf kvm: introduce --list-cmds for use by scripts
References: <1393896396-10427-1-git-send-email-artagnon@gmail.com>
In-Reply-To: <1393896396-10427-1-git-send-email-artagnon@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/3/14, 6:26 PM, Ramkumar Ramachandra wrote:
> Introduce
>
>    $ perf kvm --list-cmds
>
> to dump a raw list of commands for use by the completion script. In
> order to do this, introduce parse_options_subcommand() for handling
> subcommands as a special case in the parse-options machinery.
>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>

Looks ok to me. Jiri?

David

> ---
>   Does this example justify the creation of parse_options_subcommand()?
>   Initializing the usagestr to { NULL, NULL } and passing it to
>   parse_options_subcommand() isn't intuitive -- what can we do about
>   that?
>
>   tools/perf/builtin-kvm.c        | 12 +++++-------
>   tools/perf/perf-completion.sh   |  2 +-
>   tools/perf/util/parse-options.c | 37 +++++++++++++++++++++++++++++++++----
>   tools/perf/util/parse-options.h |  8 +++++++-
>   4 files changed, 46 insertions(+), 13 deletions(-)
>
> diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
> index a735051..21c164b 100644
> --- a/tools/perf/builtin-kvm.c
> +++ b/tools/perf/builtin-kvm.c
> @@ -1691,17 +1691,15 @@ int cmd_kvm(int argc, const char **argv, const char *prefix __maybe_unused)
>   		OPT_END()
>   	};
>
> -
> -	const char * const kvm_usage[] = {
> -		"perf kvm [<options>] {top|record|report|diff|buildid-list|stat}",
> -		NULL
> -	};
> +	const char *const kvm_subcommands[] = { "top", "record", "report", "diff",
> +						"buildid-list", "stat", NULL };
> +	const char *kvm_usage[] = { NULL, NULL };
>
>   	perf_host  = 0;
>   	perf_guest = 1;
>
> -	argc = parse_options(argc, argv, kvm_options, kvm_usage,
> -			PARSE_OPT_STOP_AT_NON_OPTION);
> +	argc = parse_options_subcommand(argc, argv, kvm_options, kvm_subcommands, kvm_usage,
> +					PARSE_OPT_STOP_AT_NON_OPTION);
>   	if (!argc)
>   		usage_with_options(kvm_usage, kvm_options);
>
> diff --git a/tools/perf/perf-completion.sh b/tools/perf/perf-completion.sh
> index 496e2ab..ae3a576 100644
> --- a/tools/perf/perf-completion.sh
> +++ b/tools/perf/perf-completion.sh
> @@ -123,7 +123,7 @@ __perf_main ()
>   		__perfcomp_colon "$evts" "$cur"
>   	# List subcommands for 'perf kvm'
>   	elif [[ $prev == "kvm" ]]; then
> -		subcmds="top record report diff buildid-list stat"
> +		subcmds=$($cmd $prev --list-cmds)
>   		__perfcomp_colon "$subcmds" "$cur"
>   	# List long option names
>   	elif [[ $cur == --* ]];  then
> diff --git a/tools/perf/util/parse-options.c b/tools/perf/util/parse-options.c
> index d22e3f8..bf48092 100644
> --- a/tools/perf/util/parse-options.c
> +++ b/tools/perf/util/parse-options.c
> @@ -407,7 +407,9 @@ int parse_options_step(struct parse_opt_ctx_t *ctx,
>   		if (internal_help && !strcmp(arg + 2, "help"))
>   			return usage_with_options_internal(usagestr, options, 0);
>   		if (!strcmp(arg + 2, "list-opts"))
> -			return PARSE_OPT_LIST;
> +			return PARSE_OPT_LIST_OPTS;
> +		if (!strcmp(arg + 2, "list-cmds"))
> +			return PARSE_OPT_LIST_SUBCMDS;
>   		switch (parse_long_opt(ctx, arg + 2, options)) {
>   		case -1:
>   			return parse_options_usage(usagestr, options, arg + 2, 0);
> @@ -433,25 +435,45 @@ int parse_options_end(struct parse_opt_ctx_t *ctx)
>   	return ctx->cpidx + ctx->argc;
>   }
>
> -int parse_options(int argc, const char **argv, const struct option *options,
> -		  const char * const usagestr[], int flags)
> +int parse_options_subcommand(int argc, const char **argv, const struct option *options,
> +			const char *const subcommands[], const char *usagestr[], int flags)
>   {
>   	struct parse_opt_ctx_t ctx;
>
>   	perf_header__set_cmdline(argc, argv);
>
> +	/* build usage string if it's not provided */
> +	if (subcommands && !usagestr[0]) {
> +		struct strbuf buf = STRBUF_INIT;
> +
> +		strbuf_addf(&buf, "perf %s [<options>] {", argv[0]);
> +		for (int i = 0; subcommands[i]; i++) {
> +			if (i)
> +				strbuf_addstr(&buf, "|");
> +			strbuf_addstr(&buf, subcommands[i]);
> +		}
> +		strbuf_addstr(&buf, "}");
> +
> +		usagestr[0] = strdup(buf.buf);
> +		strbuf_release(&buf);
> +	}
> +
>   	parse_options_start(&ctx, argc, argv, flags);
>   	switch (parse_options_step(&ctx, options, usagestr)) {
>   	case PARSE_OPT_HELP:
>   		exit(129);
>   	case PARSE_OPT_DONE:
>   		break;
> -	case PARSE_OPT_LIST:
> +	case PARSE_OPT_LIST_OPTS:
>   		while (options->type != OPTION_END) {
>   			printf("--%s ", options->long_name);
>   			options++;
>   		}
>   		exit(130);
> +	case PARSE_OPT_LIST_SUBCMDS:
> +		for (int i = 0; subcommands[i]; i++)
> +			printf("%s ", subcommands[i]);
> +		exit(130);
>   	default: /* PARSE_OPT_UNKNOWN */
>   		if (ctx.argv[0][1] == '-') {
>   			error("unknown option `%s'", ctx.argv[0] + 2);
> @@ -464,6 +486,13 @@ int parse_options(int argc, const char **argv, const struct option *options,
>   	return parse_options_end(&ctx);
>   }
>
> +int parse_options(int argc, const char **argv, const struct option *options,
> +		  const char * const usagestr[], int flags)
> +{
> +	return parse_options_subcommand(argc, argv, options, NULL,
> +					(const char **) usagestr, flags);
> +}
> +
>   #define USAGE_OPTS_WIDTH 24
>   #define USAGE_GAP         2
>
> diff --git a/tools/perf/util/parse-options.h b/tools/perf/util/parse-options.h
> index cbf0149..d8dac8a 100644
> --- a/tools/perf/util/parse-options.h
> +++ b/tools/perf/util/parse-options.h
> @@ -140,6 +140,11 @@ extern int parse_options(int argc, const char **argv,
>                            const struct option *options,
>                            const char * const usagestr[], int flags);
>
> +extern int parse_options_subcommand(int argc, const char **argv,
> +				const struct option *options,
> +				const char *const subcommands[],
> +				const char *usagestr[], int flags);
> +
>   extern NORETURN void usage_with_options(const char * const *usagestr,
>                                           const struct option *options);
>
> @@ -148,7 +153,8 @@ extern NORETURN void usage_with_options(const char * const *usagestr,
>   enum {
>   	PARSE_OPT_HELP = -1,
>   	PARSE_OPT_DONE,
> -	PARSE_OPT_LIST,
> +	PARSE_OPT_LIST_OPTS,
> +	PARSE_OPT_LIST_SUBCMDS,
>   	PARSE_OPT_UNKNOWN,
>   };
>
>

