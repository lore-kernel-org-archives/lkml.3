Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163AbaAOOpj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 09:45:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10237 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751774AbaAOOpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 09:45:33 -0500
Date: Wed, 15 Jan 2014 15:44:42 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: acme@infradead.org, namhyung@kernel.org, mingo@kernel.org,
        dsahern@gmail.com, fweisbec@gmail.com, adrian.hunter@intel.com,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 3/6] perf, tools: Add --branch-history option to report v2
Message-ID: <20140115144442.GA14966@krava.redhat.com>
References: <1389661461-18996-1-git-send-email-andi@firstfloor.org>
 <1389661461-18996-4-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389661461-18996-4-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 13, 2014 at 05:04:18PM -0800, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Add a --branch-history option to perf report that changes all
> the settings necessary for using the branches in callstacks.
> 
> This is just a short cut to make this nicer to use, it does
> not enable any functionality by itself.
> 
> v2: Change sort order. Rename option to --branch-history to
> be less confusing.
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---

SNIP

> @@ -729,7 +739,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
>  	struct perf_session *session;
>  	struct stat st;
>  	bool has_br_stack = false;
> -	int branch_mode = -1;
> +	int branch_mode = -1, branch_call_mode = -1;
>  	int ret = -1;
>  	char callchain_default_opt[] = "fractal,0.5,callee";
>  	const char * const report_usage[] = {
> @@ -838,7 +848,10 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
>  	OPT_BOOLEAN(0, "group", &symbol_conf.event_group,
>  		    "Show event group information together"),
>  	OPT_CALLBACK_NOOPT('b', "branch-stack", &branch_mode, "",
> -		    "use branch records for histogram filling", parse_branch_mode),
> +		    "use branch records for per branch histogram filling", parse_branch_mode),
> +	OPT_CALLBACK_NOOPT(0, "branch-history", &branch_call_mode, "",
> +		    "add last branch records to call history",
> +		    parse_branch_call_mode),
>  	OPT_STRING(0, "objdump", &objdump_path, "path",
>  		   "objdump binary to use for disassembly and annotations"),
>  	OPT_BOOLEAN(0, "demangle", &symbol_conf.demangle,
> @@ -886,8 +899,16 @@ repeat:
>  	has_br_stack = perf_header__has_feat(&session->header,
>  					     HEADER_BRANCH_STACK);
>  
> -	if (branch_mode == -1 && has_br_stack)
> +	if (branch_mode == -1 && has_br_stack && branch_call_mode == -1)
>  		sort__mode = SORT_MODE__BRANCH;
> +	if (branch_call_mode != -1) {
> +		callchain_param.branch_callstack = 1;
> +		callchain_param.key = CCKEY_ADDRESS;
> +		symbol_conf.use_callchain = true;
> +		callchain_register_param(&callchain_param);
> +		if (sort_order == default_sort_order)
> +			sort_order = "srcline,symbol,dso";
> +	}

this sort of settings needs to be in for the previous patch,
to make the following command work:

  $ perf report --call-graph=fractal,0.5,callee,function,branch

will just set symbol_conf.use_callchain, but the sorting stays
as SORT_MODE__BRANCH.. and callchains are invisible

as you said in the changelog, this should be 'short cut to make this nicer to use',
but it's actually currently the only way..

jirka
