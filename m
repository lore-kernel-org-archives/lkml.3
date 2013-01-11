Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928Ab3AKVVU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 16:21:20 -0500
Received: from mail-ye0-f177.google.com ([209.85.213.177]:40607 "EHLO
	mail-ye0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753704Ab3AKVVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 16:21:19 -0500
Date: Fri, 11 Jan 2013 02:17:45 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 07/10] perf sort: Check return value of strdup()
Message-ID: <20130111051745.GF3054@ghostprotocols.net>
References: <1356599507-14226-1-git-send-email-namhyung@kernel.org>
 <1356599507-14226-8-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356599507-14226-8-git-send-email-namhyung@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Dec 27, 2012 at 06:11:44PM +0900, Namhyung Kim escreveu:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> When setup_sorting() is called, 'str' is passed to strtok_r() but it's
> not checked to have a valid pointer.  As strtok_r() accepts NULL
> pointer on a first argument and use the third argument in that case,
> it can cause a trouble since our third argument, tmp, is not
> initialized.

Ok, but calling exit from here? Better to check it at the callers and
propagate the error, letting things like TUI/gui exit routines to
execute.
 
> Cc: Stephane Eranian <eranian@google.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/util/sort.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
> index c02964cabdd0..9f827e25a2b5 100644
> --- a/tools/perf/util/sort.c
> +++ b/tools/perf/util/sort.c
> @@ -552,6 +552,11 @@ void setup_sorting(const char * const usagestr[], const struct option *opts)
>  {
>  	char *tmp, *tok, *str = strdup(sort_order);
>  
> +	if (str == NULL) {
> +		error("Not enough memory to setup sort keys");
> +		exit(-1);
> +	}
> +
>  	for (tok = strtok_r(str, ", ", &tmp);
>  			tok; tok = strtok_r(NULL, ", ", &tmp)) {
>  		if (sort_dimension__add(tok) < 0) {
> -- 
> 1.7.11.7
