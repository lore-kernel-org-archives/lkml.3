Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917AbaJVB0J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 21:26:09 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:40207 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbaJVB0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 21:26:07 -0400
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: jolsa@redhat.com, linux-kernel@vger.kernel.org, acme@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/8] perf, tools: Add --branch-history option to report
References: <1411774636-6870-1-git-send-email-andi@firstfloor.org>
	<1411774636-6870-3-git-send-email-andi@firstfloor.org>
Date: Wed, 22 Oct 2014 10:26:03 +0900
In-Reply-To: <1411774636-6870-3-git-send-email-andi@firstfloor.org> (Andi
	Kleen's message of "Fri, 26 Sep 2014 16:37:10 -0700")
Message-ID: <87mw8ogaj8.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Sep 2014 16:37:10 -0700, Andi Kleen wrote:
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
> v3: Updates
> v4: Fix conflict with newer perf base
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

[SNIP]
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

I think it'd be better leave this apart from the change.  Users might
want use different callchain_param.key when --branch-history is used.
And please also add a new CCKEY_SRCLINE if you print srcline with the
callchains so that users can give "-g srcline" if they want (regardless
of the branch history feature).


> +		symbol_conf.use_callchain = true;
> +		callchain_register_param(&callchain_param);
> +		if (sort_order == default_sort_order)

I guess this won't work with the current code.  You can check sort_order
being NULL instead.

Thanks,
Namhyung


> +			sort_order = "srcline,symbol,dso";
> +		branch_mode = 0;
> +	}
>  
>  	if (report.mem_mode) {
>  		if (sort__mode == SORT_MODE__BRANCH) {
