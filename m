Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760148AbaGYNP2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 09:15:28 -0400
Received: from mail.kernel.org ([198.145.19.201]:56389 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752404AbaGYNP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 09:15:27 -0400
Date: Fri, 25 Jul 2014 10:15:21 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH 1/2] perf tools: Ensure --symfs ends with '/'
Message-ID: <20140725131521.GI7831@kernel.org>
References: <1406251908-8195-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406251908-8195-1-git-send-email-namhyung@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Jul 25, 2014 at 10:31:47AM +0900, Namhyung Kim escreveu:
> Minchan reported that perf failed to load vmlinux if --symfs argument
> doesn't end with '/' character.  So make sure that the symfs always
> ends with the '/'.

I don't think this is the right way of doing this, users of
symbol_conf.symfs should instead make sure that they do what they expect
to, i.e. if they want it to be a base directory, make sure that a path
separator is added between it and the relative path following it, if
not, do as they please.

- Arnaldo
 
> Reported-by: Minchan Kim <minchan@kernel.org>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/util/symbol.c | 41 +++++++++++++++++++++++++++++------------
>  1 file changed, 29 insertions(+), 12 deletions(-)
> 
> diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
> index eb06746b06b2..90723a12e947 100644
> --- a/tools/perf/util/symbol.c
> +++ b/tools/perf/util/symbol.c
> @@ -1829,7 +1829,7 @@ static bool symbol__read_kptr_restrict(void)
>  
>  int symbol__init(void)
>  {
> -	const char *symfs;
> +	char *symfs;
>  
>  	if (symbol_conf.initialized)
>  		return 0;
> @@ -1862,23 +1862,40 @@ int symbol__init(void)
>  		       symbol_conf.sym_list_str, "symbol") < 0)
>  		goto out_free_comm_list;
>  
> -	/*
> -	 * A path to symbols of "/" is identical to ""
> -	 * reset here for simplicity.
> -	 */
> -	symfs = realpath(symbol_conf.symfs, NULL);
> -	if (symfs == NULL)
> -		symfs = symbol_conf.symfs;
> -	if (strcmp(symfs, "/") == 0)
> -		symbol_conf.symfs = "";
> -	if (symfs != symbol_conf.symfs)
> -		free((void *)symfs);
> +	if (*symbol_conf.symfs) {
> +		symfs = realpath(symbol_conf.symfs, NULL);
> +		if (symfs == NULL)
> +			symfs = (char *)symbol_conf.symfs;
> +
> +		/*
> +		 * A path to symbols of "/" is identical to ""
> +		 * reset here for simplicity.
> +		 */
> +		if (strcmp(symfs, "/") == 0)
> +			symbol_conf.symfs = "";
> +
> +		/* ensure symfs ends with '/' */
> +		if (symfs[strlen(symfs)-1] != '/') {
> +			char *tmp = realloc(symfs, strlen(symfs) + 2);
> +			if (tmp == NULL)
> +				goto out_free;
> +
> +			tmp[strlen(tmp)+1] = '\0';
> +			tmp[strlen(tmp)] = '/';
> +
> +			symbol_conf.symfs = tmp;
> +		} else {
> +			free(symfs);
> +		}
> +	}
>  
>  	symbol_conf.kptr_restrict = symbol__read_kptr_restrict();
>  
>  	symbol_conf.initialized = true;
>  	return 0;
>  
> +out_free:
> +	free(symfs);
>  out_free_comm_list:
>  	strlist__delete(symbol_conf.comm_list);
>  out_free_dso_list:
> -- 
> 2.0.0
