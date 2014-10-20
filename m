Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530AbaJTRwJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 13:52:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23604 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751233AbaJTRwE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 13:52:04 -0400
Date: Mon, 20 Oct 2014 19:51:46 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, namhyung@kernel.org, acme@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/8] perf, tools: Add --branch-history option to report
Message-ID: <20141020175146.GA9913@krava.brq.redhat.com>
References: <1411774636-6870-1-git-send-email-andi@firstfloor.org>
 <1411774636-6870-3-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411774636-6870-3-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 04:37:10PM -0700, Andi Kleen wrote:

SNIP

> @@ -564,7 +575,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
>  	struct perf_session *session;
>  	struct stat st;
>  	bool has_br_stack = false;
> -	int branch_mode = -1;
> +	int branch_mode = -1, branch_call_mode = -1;
>  	int ret = -1;
>  	char callchain_default_opt[] = "fractal,0.5,callee";
>  	const char * const report_usage[] = {
> @@ -675,7 +686,11 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
>  	OPT_BOOLEAN(0, "group", &symbol_conf.event_group,
>  		    "Show event group information together"),
>  	OPT_CALLBACK_NOOPT('b', "branch-stack", &branch_mode, "",
> -		    "use branch records for histogram filling", parse_branch_mode),
> +		    "use branch records for per branch histogram filling",
> +		    parse_branch_mode),
> +	OPT_CALLBACK_NOOPT(0, "branch-history", &branch_call_mode, "",
> +		    "add last branch records to call history",
> +		    parse_branch_call_mode),

I think we've been through this before, but why's not
branch_mode and branch_call_mode bools? sry if we already
sorted this out, but I couldnt find it

>  	OPT_STRING(0, "objdump", &objdump_path, "path",
>  		   "objdump binary to use for disassembly and annotations"),
>  	OPT_BOOLEAN(0, "demangle", &symbol_conf.demangle,
> @@ -732,10 +747,20 @@ repeat:
>  	has_br_stack = perf_header__has_feat(&session->header,
>  					     HEADER_BRANCH_STACK);
>  
> -	if ((branch_mode == -1 && has_br_stack) || branch_mode == 1) {
> +	if (((branch_mode == -1 && has_br_stack) || branch_mode == 1) &&
> +	    branch_call_mode == -1) {
>  		sort__mode = SORT_MODE__BRANCH;
>  		symbol_conf.cumulate_callchain = false;
>  	}
> +	if (branch_call_mode != -1) {
> +		callchain_param.branch_callstack = 1;
> +		callchain_param.key = CCKEY_ADDRESS;
> +		symbol_conf.use_callchain = true;
> +		callchain_register_param(&callchain_param);
> +		if (sort_order == default_sort_order)
> +			sort_order = "srcline,symbol,dso";
> +		branch_mode = 0;
> +	}

also why set branch_mode if there's no further usage of it?

thanks,
jirka
