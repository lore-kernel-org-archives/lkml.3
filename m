Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890AbaKYXvc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 18:51:32 -0500
Received: from hydra.tuxags.com ([64.13.172.54]:58693 "EHLO mail.tuxags.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751825AbaKYXva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 18:51:30 -0500
Date: Tue, 25 Nov 2014 15:51:30 -0800
From: Matt Mullins <mmullins@mmlx.us>
To: Tom Huynh <tom.huynh@freescale.com>
Cc: mingo@redhat.com, acme@kernel.org, namhyung@kernel.org, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, paulus@samba.org, kim.phillips@freescale.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf hist browser: change print format from lu to llu
 to fit u64 type
Message-ID: <20141125235128.GA25625@hydra.tuxags.com>
Mail-Followup-To: Tom Huynh <tom.huynh@freescale.com>, mingo@redhat.com,
	acme@kernel.org, namhyung@kernel.org, jolsa@kernel.org,
	a.p.zijlstra@chello.nl, paulus@samba.org,
	kim.phillips@freescale.com, linux-kernel@vger.kernel.org
References: <1416351627-360-1-git-send-email-tom.huynh@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1416351627-360-1-git-send-email-tom.huynh@freescale.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 05:00:27PM -0600, Tom Huynh wrote:
> nr_events in tools/perf/ui/browsers/hists.c is of type u64, thus it should
> be printed as %llu instead of %lu. The print format %lu causes perf report
> to show 0 event count when running with 32-bit userspace without 
> redirection. This patch fixes that problem.
> 
> Signed-off-by: Tom Huynh <tom.huynh@freescale.com>
> ---
>  tools/perf/ui/browsers/hists.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
> index cfb976b..49b2471 100644
> --- a/tools/perf/ui/browsers/hists.c
> +++ b/tools/perf/ui/browsers/hists.c
> @@ -1254,7 +1254,7 @@ static int hists__browser_title(struct hists *hists,
>  
>  	nr_samples = convert_unit(nr_samples, &unit);
>  	printed = scnprintf(bf, size,
> -			   "Samples: %lu%c of event '%s', Event count (approx.): %lu",
> +			   "Samples: %lu%c of event '%s', Event count (approx.): %llu",
>  			   nr_samples, unit, ev_name, nr_events);

If I enable __attribute__((format(printf, ...))) on scnprintf, on a 64-bit
build this gives me:

ui/browsers/hists.c: In function ‘hists__browser_title’:
ui/browsers/hists.c:1258:7: error: format ‘%llu’ expects argument of type ‘long long unsigned int’, but argument 7 has type ‘u64’ [-Werror=format=]
       nr_samples, unit, ev_name, nr_events);
       ^

I would usually suggest using the PRIu64 macro which should(TM) evaluate to the
right string constant for the platform, but that appears to be a C99 thing.
I'm not sure if that's kosher in tools/perf, but it does seem to build for me
(on Fedora 20).
