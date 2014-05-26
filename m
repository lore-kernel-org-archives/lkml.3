Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751501AbaEZCz2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 22:55:28 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:35314 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbaEZCz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 22:55:27 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, jolsa@redhat.com,
        linux-kernel@vger.kernel.org, acme@infradead.org
Subject: Re: [PATCH 2/9] perf, tools: Add --branch-history option to report v3
References: <1400259938-3436-1-git-send-email-andi@firstfloor.org>
	<1400259938-3436-3-git-send-email-andi@firstfloor.org>
	<87bnuujhsl.fsf@sejong.aot.lge.com>
	<20140523181113.GC29957@tassilo.jf.intel.com>
Date: Mon, 26 May 2014 11:55:24 +0900
In-Reply-To: <20140523181113.GC29957@tassilo.jf.intel.com> (Andi Kleen's
	message of "Fri, 23 May 2014 11:11:13 -0700")
Message-ID: <87y4xpi6zn.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 May 2014 11:11:13 -0700, Andi Kleen wrote:
>> > diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
>> > index 1a2d7fc..e6d8ed0 100644
>> > --- a/tools/perf/builtin-report.c
>> > +++ b/tools/perf/builtin-report.c
>> > @@ -315,8 +315,9 @@ static int report__setup_sample_type(struct report *rep)
>> >  			return -EINVAL;
>> >  		}
>> >  		if (symbol_conf.use_callchain) {
>> > -			ui__error("Selected -g but no callchain data. Did "
>> > -				    "you call 'perf record' without -g?\n");
>> > +			ui__error("Selected -g or --branch-history but no "
>> > +				  "callchain data. Did\n"
>> 
>> An unwanted newline in the message.
>
> It was intentional to make it fit onto a 80 column terminal

Did you mean '\n' after the "Did" or line break after "but no"?  I meant
the former is weird..  The 80 column rule (in the source code) is not
applied to user messages AFAIK.  And ui__error() also needs to handle
line breaks to fit the message on the screen in a dynamic manner.

>> 
>> 
>> > +				  "you call 'perf record' without -g?\n");
>> >  			return -1;
>> >  		}
>> >  	} else if (!rep->dont_use_callchains &&
>> > @@ -631,6 +632,16 @@ parse_branch_mode(const struct option *opt __maybe_unused,
>> >  }
>> >  
>> >  static int
>> > +parse_branch_call_mode(const struct option *opt __maybe_unused,
>> > +		  const char *str __maybe_unused, int unset)
>> > +{
>> > +	int *branch_mode = opt->value;
>> > +
>> > +	*branch_mode = !unset;
>> > +	return 0;
>> > +}
>> > +
>> > +static int
>> >  parse_percent_limit(const struct option *opt, const char *str,
>> >  		    int unset __maybe_unused)
>> >  {
>> > @@ -645,7 +656,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
>> >  	struct perf_session *session;
>> >  	struct stat st;
>> >  	bool has_br_stack = false;
>> > -	int branch_mode = -1;
>> > +	int branch_mode = -1, branch_call_mode = -1;
>> >  	int ret = -1;
>> >  	char callchain_default_opt[] = "fractal,0.5,callee";
>> >  	const char * const report_usage[] = {
>> > @@ -754,7 +765,11 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
>> >  	OPT_BOOLEAN(0, "group", &symbol_conf.event_group,
>> >  		    "Show event group information together"),
>> >  	OPT_CALLBACK_NOOPT('b', "branch-stack", &branch_mode, "",
>> > -		    "use branch records for histogram filling", parse_branch_mode),
>> > +		    "use branch records for per branch histogram filling",
>> > +		    parse_branch_mode),
>> > +	OPT_CALLBACK_NOOPT(0, "branch-history", &branch_call_mode, "",
>> > +		    "add last branch records to call history",
>> > +		    parse_branch_call_mode),
>> 
>> Looks like it can be a boolean option, or at least can share
>> parse_branch_mode() callback.
>
> No it can't. It's a tristate.
>> 
>> 
>> >  	OPT_STRING(0, "objdump", &objdump_path, "path",
>> >  		   "objdump binary to use for disassembly and annotations"),
>> >  	OPT_BOOLEAN(0, "demangle", &symbol_conf.demangle,
>> > @@ -804,8 +819,16 @@ repeat:
>> >  	has_br_stack = perf_header__has_feat(&session->header,
>> >  					     HEADER_BRANCH_STACK);
>> >  
>> > -	if (branch_mode == -1 && has_br_stack)
>> > +	if (branch_mode == -1 && has_br_stack && branch_call_mode == -1)
>> >  		sort__mode = SORT_MODE__BRANCH;
>> > +	if (branch_call_mode != -1) {
>> 
>> s/-1/1/ ?
>
> -1 means not specified by the user.

But what about --no-branch-history?

Thanks,
Namhyung
