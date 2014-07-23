Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123AbaGWNCr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 09:02:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32176 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750815AbaGWNCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 09:02:46 -0400
Date: Wed, 23 Jul 2014 15:02:15 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 52/52] perf tools: Add support for 32-bit compatibility
 VDSOs
Message-ID: <20140723130215.GC1207@krava.brq.redhat.com>
References: <1406035081-14301-1-git-send-email-adrian.hunter@intel.com>
 <1406035081-14301-53-git-send-email-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406035081-14301-53-git-send-email-adrian.hunter@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 04:18:01PM +0300, Adrian Hunter wrote:
> 'perf record' post-processes the event stream  to create
> a list of build-ids for object files for which sample
> events have been recorded.  That results in those object
> files being recorded in the build-id cache.

SNIP

>  
>  	if (vdso_info->vdso.found)
>  		unlink(vdso_info->vdso.temp_file_name);
> +#if BITS_PER_LONG == 64
> +	if (vdso_info->vdso32.found)
> +		unlink(vdso_info->vdso.temp_file_name);
> +	if (vdso_info->vdsox32.found)
> +		unlink(vdso_info->vdso.temp_file_name);
> +#endif
>  
>  	zfree(&machine->vdso_info);
>  }
> @@ -135,6 +159,143 @@ static struct dso *vdso__new(struct machine *machine, const char *short_name,
>  	return dso;
>  }
>  
> +#if BITS_PER_LONG == 64

Does this define mean all 64 archs? Do we want other than x86 in here?
(all of its instances)

jirka

> +
> +static enum dso_type machine__thread_dso_type(struct machine *machine,
> +					      struct thread *thread)
> +{
> +	enum dso_type dso_type = DSO__TYPE_UNKNOWN;
> +	struct map *map;
> +	struct dso *dso;
> +
> +	map = map_groups__first(thread->mg, MAP__FUNCTION);
> +	for (; map ; map = map_groups__next(map)) {
> +		dso = map->dso;
> +		if (!dso || dso->long_name[0] != '/')
> +			continue;
> +		dso_type = dso__type(dso, machine);
> +		if (dso_type != DSO__TYPE_UNKNOWN)
> +			break;
> +	}
> +
> +	return dso_type;
> +}

SNIP
