Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933261AbaDVQnt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 12:43:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43224 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932250AbaDVQnr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 12:43:47 -0400
Date: Tue, 22 Apr 2014 18:43:11 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 1/9] perf report: Count number of entries and samples
 separately
Message-ID: <20140422164311.GJ1104@krava.brq.redhat.com>
References: <1398156591-11001-1-git-send-email-namhyung@kernel.org>
 <1398156591-11001-2-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398156591-11001-2-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 05:49:43PM +0900, Namhyung Kim wrote:
> Those stats are counted counted in multiple places so that they can
> confuse readers of the code.  This is a preparation of later change
> and do not intend any functional difference.
> 
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---

SNIP

>  
>  		/* Non-group events are considered as leader */
>  		if (symbol_conf.event_group &&
> @@ -526,7 +533,7 @@ static u64 report__collapse_hists(struct report *rep)
>  
>  	ui_progress__finish();
>  
> -	return nr_samples;
> +	return rep->nr_samples;

so this ^^^ is the only usage for rep->nr_samples right?

and the output from report__collapse_hists is used
as a bool if we have at least 1 sample:

        nr_samples = report__collapse_hists(rep);

        if (session_done())
                return 0;

        if (nr_samples == 0) {
                ui__error("The %s file has no samples!\n", file->path);
                return 0;
        }

I think report__collapse_hists does not need to return anything
and above code could use (rep->nr_entries > 0) instead, like:

        report__collapse_hists(rep);

        if (session_done())
                return 0;

        if (rep->nr_entries == 0) {
                ui__error("The %s file has no samples!\n", file->path);
                return 0;
        }

and we could get rid of rep->nr_samples

thanks,
jirka
