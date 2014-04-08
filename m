Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214AbaDHHbi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 03:31:38 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:36273 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbaDHHbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 03:31:37 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: acme@ghostprotocols.net, LKML <linux-kernel@vger.kernel.org>,
        jolsa@redhat.com, jmario@redhat.com, fowles@inreach.com,
        peterz@infradead.org, eranian@google.com, andi.kleen@intel.com
Subject: Re: [PATCH 06/15 V3] perf, c2c: Add in new options to configure latency and stores
References: <1395689826-215033-1-git-send-email-dzickus@redhat.com>
	<1395689826-215033-7-git-send-email-dzickus@redhat.com>
Date: Tue, 08 Apr 2014 16:31:35 +0900
In-Reply-To: <1395689826-215033-7-git-send-email-dzickus@redhat.com> (Don
	Zickus's message of "Mon, 24 Mar 2014 15:36:57 -0400")
Message-ID: <87wqf0wa3s.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Mar 2014 15:36:57 -0400, Don Zickus wrote:
> Modified the code to allow latency settings to be tweaked on the command line
> and also the ability to dynamically profile stores (or disable using stores).
>
> This allows the tool to be used on older Intel platforms like Westmere.
>

[SNIP]
> @@ -277,8 +286,21 @@ static int perf_c2c__record(int argc, const char **argv)
>  		"-d",
>  		"-a",
>  	};
> +	char lat[16], prec[4] = "/";
> +	char buf[256];
> +
> +	snprintf(lat, sizeof(lat), "ldlat=%d", lat_level);
> +
> +	if (prec_level > 3)
> +		prec_level = 3;
> +
> +	for (i = 0; i < (unsigned int)prec_level; i++)
> +		prec[i+1] = 'p';

Hmm.. it seems that negative prec_level can be a problem here - how
about making it unsigned?  Also the 'prec' is not null-terminated and
needs to be increased to 5 to accept max level 3 ('/' + 'ppp' + '\0').

> +
> +	/* how many events to pass in */
> +	n = (no_stores) ? 1 : 2;
>  
> -	rec_argc = ARRAY_SIZE(record_args) + 2 * ARRAY_SIZE(handlers) + argc - 1;
> +	rec_argc = ARRAY_SIZE(record_args) + 2 * n + argc - 1;
>  	rec_argv = calloc(rec_argc + 1, sizeof(char *));
>  
>  	if (rec_argv == NULL)
> @@ -287,9 +309,16 @@ static int perf_c2c__record(int argc, const char **argv)
>  	for (i = 0; i < ARRAY_SIZE(record_args); i++)
>  		rec_argv[i] = strdup(record_args[i]);
>  
> -	for (j = 0; j < ARRAY_SIZE(handlers); j++) {
> +	/* mem-loads is first index */
> +	snprintf(buf, sizeof(buf), "%s,%s%s", handlers[0].name, lat, prec);
> +	rec_argv[i++] = strdup("-e");
> +	rec_argv[i++] = strdup(buf);
> +
> +	if (!no_stores) {
> +		/* mem-stores is second index */
>  		rec_argv[i++] = strdup("-e");
> -		rec_argv[i++] = strdup(handlers[j].name);
> +		snprintf(buf, sizeof(buf), "%s%s", handlers[1].name, prec);
> +		rec_argv[i++] = strdup(buf);
>  	}
>  
>  	for (j = 1; j < (unsigned int)argc; j++, i++)
> @@ -300,6 +329,30 @@ static int perf_c2c__record(int argc, const char **argv)
>  	return cmd_record(i, rec_argv, NULL);
>  }
>  
> +static int
> +opt_no_stores_cb(const struct option *opt __maybe_unused, const char *arg __maybe_unused, int unset)
> +{
> +	int ret;
> +
> +	if (unset) {
> +		struct stat st;
> +		char path[PATH_MAX];
> +
> +		snprintf(path, PATH_MAX, "%s/bus/event_source/devices/cpu/events/mem-stores",
> +			 sysfs__mountpoint());
> +
> +		ret = stat(path, &st);
> +		if (ret) {
> +			pr_debug("Omitting mem-stores event");
> +			no_stores = true;
> +		}
> +		return 0;
> +	}
> +
> +	no_stores = true;
> +	return 0;
> +}
> +
>  int cmd_c2c(int argc, const char **argv, const char *prefix __maybe_unused)
>  {
>  	struct perf_c2c c2c = {
> @@ -316,6 +369,12 @@ int cmd_c2c(int argc, const char **argv, const char *prefix __maybe_unused)
>  	};
>  	const struct option c2c_options[] = {
>  	OPT_BOOLEAN('r', "raw_records", &c2c.raw_records, "dump raw events"),
> +	OPT_INTEGER('l', "latency-level", &lat_level,
> +		 "specify the latency threshold for loads [default=30]"),
> +	OPT_INTEGER('p', "precision-level", &prec_level,
> +		 "specify the precision level of events (0,1,2,3) [default=1]"),

Please use OPT_UINTEGER as I said above.


> +	OPT_CALLBACK_NOOPT(0, "no-stores", &no_stores, "",
> +			   "do not record stores", &opt_no_stores_cb),

Why not using just plain "stores" boolean option - it'd also provide the
"--no-stores" option - and checking availability of "mem-stores" events
before starting record separately?  Negation is always confusing.. (at
least for me ;-p).

Thanks,
Namhyung


>  	OPT_INCR('v', "verbose", &verbose,
>  		 "be more verbose (show counter open errors, etc)"),
>  	OPT_STRING('i', "input", &input_name, "file",
