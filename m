Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751500AbaHMGX2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 02:23:28 -0400
Received: from mga01.intel.com ([192.55.52.88]:7198 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221AbaHMGX1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 02:23:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,855,1400050800"; 
   d="scan'208";a="575960711"
Message-ID: <53EB03EB.4040606@intel.com>
Date: Wed, 13 Aug 2014 09:21:31 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH 01/13] perf script: Fix possible memory leaks
References: <1407825645-24586-1-git-send-email-namhyung@kernel.org> <1407825645-24586-2-git-send-email-namhyung@kernel.org>
In-Reply-To: <1407825645-24586-2-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2014 09:40 AM, Namhyung Kim wrote:
> Some paths in perf script don't call perf_session__delete() after
> creating a new session.
> 
> Cc: Adrian Hunter <adrian.hunter@intel.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/builtin-script.c | 35 ++++++++++++++++++++++-------------
>  1 file changed, 22 insertions(+), 13 deletions(-)
> 
> diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
> index 868c17d09762..534172b889c3 100644
> --- a/tools/perf/builtin-script.c
> +++ b/tools/perf/builtin-script.c
> @@ -1471,12 +1471,13 @@ int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
>  	bool show_full_info = false;
>  	bool header = false;
>  	bool header_only = false;
> +	bool script_started = false;
>  	char *rec_script_path = NULL;
>  	char *rep_script_path = NULL;
>  	struct perf_session *session;
>  	char *script_path = NULL;
>  	const char **__argv;
> -	int i, j, err;
> +	int i, j, err = 0;
>  	struct perf_script script = {
>  		.tool = {
>  			.sample		 = process_sample_event,
> @@ -1730,14 +1731,15 @@ int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
>  	if (header || header_only) {
>  		perf_session__fprintf_info(session, stdout, show_full_info);
>  		if (header_only)
> -			return 0;
> +			goto out_delete;
>  	}
>  
>  	script.session = session;
>  
>  	if (cpu_list) {
> -		if (perf_session__cpu_bitmap(session, cpu_list, cpu_bitmap))
> -			return -1;
> +		err = perf_session__cpu_bitmap(session, cpu_list, cpu_bitmap);
> +		if (err < 0)
> +			goto out_delete;
>  	}
>  
>  	if (!no_callchain)
> @@ -1752,53 +1754,60 @@ int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
>  		if (output_set_by_user()) {
>  			fprintf(stderr,
>  				"custom fields not supported for generated scripts");
> -			return -1;
> +			err = -EINVAL;
> +			goto out_delete;
>  		}
>  
>  		input = open(file.path, O_RDONLY);	/* input_name */
>  		if (input < 0) {
>  			perror("failed to open file");
> -			return -1;
> +			err = -errno;

Need to get errno before calling perror().

> +			goto out_delete;
>  		}
>  
>  		err = fstat(input, &perf_stat);
>  		if (err < 0) {
>  			perror("failed to stat file");
> -			return -1;
> +			goto out_delete;
>  		}
>  
>  		if (!perf_stat.st_size) {
>  			fprintf(stderr, "zero-sized file, nothing to do!\n");
> -			return 0;
> +			goto out_delete;
>  		}
>  
>  		scripting_ops = script_spec__lookup(generate_script_lang);
>  		if (!scripting_ops) {
>  			fprintf(stderr, "invalid language specifier");
> -			return -1;
> +			err = -ENOENT;
> +			goto out_delete;
>  		}
>  
>  		err = scripting_ops->generate_script(session->tevent.pevent,
>  						     "perf-script");
> -		goto out;
> +		goto out_delete;
>  	}
>  
>  	if (script_name) {
>  		err = scripting_ops->start_script(script_name, argc, argv);
>  		if (err)
> -			goto out;
> +			goto out_delete;
>  		pr_debug("perf script started with script %s\n\n", script_name);
> +		script_started = true;
>  	}
>  
>  
>  	err = perf_session__check_output_opt(session);
>  	if (err < 0)
> -		goto out;
> +		goto out_delete;
>  
>  	err = __cmd_script(&script);
>  
> +out_delete:

I added a flush method in a patch which acme has stashed in his
tmp.perf/core branch.  It would go here:

	if (script_started)
		flush_scripting();

>  	perf_session__delete(session);
> -	cleanup_scripting();
> +
> +	if (script_started)
> +		cleanup_scripting();
>  out:
>  	return err;
>  }
> 

