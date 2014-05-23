Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751422AbaEWSLS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 14:11:18 -0400
Received: from mga03.intel.com ([143.182.124.21]:65246 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751010AbaEWSLR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 14:11:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,895,1392192000"; 
   d="scan'208";a="436164258"
Date: Fri, 23 May 2014 11:11:13 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, jolsa@redhat.com,
        linux-kernel@vger.kernel.org, acme@infradead.org
Subject: Re: [PATCH 2/9] perf, tools: Add --branch-history option to report v3
Message-ID: <20140523181113.GC29957@tassilo.jf.intel.com>
References: <1400259938-3436-1-git-send-email-andi@firstfloor.org>
 <1400259938-3436-3-git-send-email-andi@firstfloor.org>
 <87bnuujhsl.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bnuujhsl.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
> > index 1a2d7fc..e6d8ed0 100644
> > --- a/tools/perf/builtin-report.c
> > +++ b/tools/perf/builtin-report.c
> > @@ -315,8 +315,9 @@ static int report__setup_sample_type(struct report *rep)
> >  			return -EINVAL;
> >  		}
> >  		if (symbol_conf.use_callchain) {
> > -			ui__error("Selected -g but no callchain data. Did "
> > -				    "you call 'perf record' without -g?\n");
> > +			ui__error("Selected -g or --branch-history but no "
> > +				  "callchain data. Did\n"
> 
> An unwanted newline in the message.

It was intentional to make it fit onto a 80 column terminal
> 
> 
> > +				  "you call 'perf record' without -g?\n");
> >  			return -1;
> >  		}
> >  	} else if (!rep->dont_use_callchains &&
> > @@ -631,6 +632,16 @@ parse_branch_mode(const struct option *opt __maybe_unused,
> >  }
> >  
> >  static int
> > +parse_branch_call_mode(const struct option *opt __maybe_unused,
> > +		  const char *str __maybe_unused, int unset)
> > +{
> > +	int *branch_mode = opt->value;
> > +
> > +	*branch_mode = !unset;
> > +	return 0;
> > +}
> > +
> > +static int
> >  parse_percent_limit(const struct option *opt, const char *str,
> >  		    int unset __maybe_unused)
> >  {
> > @@ -645,7 +656,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
> >  	struct perf_session *session;
> >  	struct stat st;
> >  	bool has_br_stack = false;
> > -	int branch_mode = -1;
> > +	int branch_mode = -1, branch_call_mode = -1;
> >  	int ret = -1;
> >  	char callchain_default_opt[] = "fractal,0.5,callee";
> >  	const char * const report_usage[] = {
> > @@ -754,7 +765,11 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
> >  	OPT_BOOLEAN(0, "group", &symbol_conf.event_group,
> >  		    "Show event group information together"),
> >  	OPT_CALLBACK_NOOPT('b', "branch-stack", &branch_mode, "",
> > -		    "use branch records for histogram filling", parse_branch_mode),
> > +		    "use branch records for per branch histogram filling",
> > +		    parse_branch_mode),
> > +	OPT_CALLBACK_NOOPT(0, "branch-history", &branch_call_mode, "",
> > +		    "add last branch records to call history",
> > +		    parse_branch_call_mode),
> 
> Looks like it can be a boolean option, or at least can share
> parse_branch_mode() callback.

No it can't. It's a tristate.
> 
> 
> >  	OPT_STRING(0, "objdump", &objdump_path, "path",
> >  		   "objdump binary to use for disassembly and annotations"),
> >  	OPT_BOOLEAN(0, "demangle", &symbol_conf.demangle,
> > @@ -804,8 +819,16 @@ repeat:
> >  	has_br_stack = perf_header__has_feat(&session->header,
> >  					     HEADER_BRANCH_STACK);
> >  
> > -	if (branch_mode == -1 && has_br_stack)
> > +	if (branch_mode == -1 && has_br_stack && branch_call_mode == -1)
> >  		sort__mode = SORT_MODE__BRANCH;
> > +	if (branch_call_mode != -1) {
> 
> s/-1/1/ ?

-1 means not specified by the user.


-Andi
