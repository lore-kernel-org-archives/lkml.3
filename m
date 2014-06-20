Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbaFTBEb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 21:04:31 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:58405 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753688AbaFTBEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 21:04:30 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Stanislav Fomichev <stfomichev@yandex-team.ru>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@kernel.org, artagnon@gmail.com, jolsa@redhat.com,
        rusty@rustcorp.com.au, bp@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] perf timechart: implement IO mode
References: <1403180583-12309-1-git-send-email-stfomichev@yandex-team.ru>
	<1403180583-12309-2-git-send-email-stfomichev@yandex-team.ru>
Date: Fri, 20 Jun 2014 10:04:21 +0900
In-Reply-To: <1403180583-12309-2-git-send-email-stfomichev@yandex-team.ru>
	(Stanislav Fomichev's message of "Thu, 19 Jun 2014 16:23:01 +0400")
Message-ID: <87egyk75nu.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stanislav,

On Thu, 19 Jun 2014 16:23:01 +0400, Stanislav Fomichev wrote:
> In IO mode timechart shows any disk/network activity.
> +	for (i = 0; i < disk_events_nr; i++) {
> +		if (!is_valid_tracepoint(disk_events[i])) {
> +			rec_argc--;

It (and others below) should be 'rec_argc -= 4' - i.e. I still see the
segfault. :)


> +			continue;
> +		}
> +
> +		*p++ = "-e";
> +		*p++ = strdup(disk_events[i]);
> +		*p++ = "--filter";
> +		*p++ = filter;
> +	}


[SNIP]
> +void svg_ubox(int Yslot, u64 start, u64 end, double height, const char *type, int fd, int err, int merges)
> +{
> +	double w = time2pixels(end) - time2pixels(start);
> +	height = normalize_height(height);
> +
> +	if (!svgfile)
> +		return;
> +
> +	fprintf(svgfile, "<g>\n");
> +	fprintf(svgfile, "<title>fd=%d error=%d merges=%d</title>\n", fd, err, merges);
> +	fprintf(svgfile, "<rect x=\"%.8f\" width=\"%.8f\" y=\"%.1f\" height=\"%.1f\" class=\"%s\"/>\n",

Looks like this change should be applied to the exsting (for cpu and
power events) boxes too.  Care to send it as a separate fix?


> +		time2pixels(start),
> +		w,
> +		Yslot * SLOT_MULT,
> +		SLOT_HALF * height,
> +		type);
> +	fprintf(svgfile, "</g>\n");
> +}


[SNIP]
> @@ -579,8 +669,10 @@ void svg_time_grid(void)
>  			color = 128;
>  		}
>  
> -		fprintf(svgfile, "<line x1=\"%4.8f\" y1=\"%4.2f\" x2=\"%4.8f\" y2=\"%" PRIu64 "\" style=\"stroke:rgb(%i,%i,%i);stroke-width:%1.3f\"/>\n",
> -			time2pixels(i), SLOT_MULT/2, time2pixels(i), total_height, color, color, color, thickness);
> +		if (thickness >= min_thickness)
> +			fprintf(svgfile, "<line x1=\"%4.8f\" y1=\"%4.2f\" x2=\"%4.8f\" y2=\"%" PRIu64 "\" style=\"stroke:rgb(%i,%i,%i);stroke-width:%1.3f\"/>\n",

It seems you missed the change above (s/4.8f/.8f/g). :)

Thanks,
Namhyung


> +				time2pixels(i), SLOT_MULT/2, time2pixels(i),
> +				total_height, color, color, color, thickness);
>  
>  		i += 10000000;
>  	}
