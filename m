Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533AbaEWRJp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 13:09:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4163 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752387AbaEWRJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 13:09:44 -0400
Date: Fri, 23 May 2014 19:09:01 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Don Zickus <dzickus@redhat.com>
Cc: acme@ghostprotocols.net, peterz@infradead.org,
        LKML <linux-kernel@vger.kernel.org>, namhyung@gmail.com,
        eranian@google.com, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 6/7] perf: Add support to dynamically get cacheline size
Message-ID: <20140523170901.GF1074@krava>
References: <1400526833-141779-1-git-send-email-dzickus@redhat.com>
 <1400526833-141779-7-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400526833-141779-7-git-send-email-dzickus@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 03:13:52PM -0400, Don Zickus wrote:

SNIP

> diff --git a/tools/perf/util/cpumap.h b/tools/perf/util/cpumap.h
> index 61a6548..b3e7b22 100644
> --- a/tools/perf/util/cpumap.h
> +++ b/tools/perf/util/cpumap.h
> @@ -81,4 +81,16 @@ static inline int cpu__get_node(int cpu)
>  	return cpunode_map[cpu];
>  }
>  
> +int cacheline_size;

hum, so cacheline_size does not need to be global, if you use
cpu__cacheline_size in your next patch, right?

> +
> +int cpu__setup_cacheline_size(void);
> +
> +static inline int cpu__cacheline_size(void)
> +{
> +	if (unlikely(!cacheline_size))
> +		pr_debug("cacheline size not initialized\n");
> +
> +	return cacheline_size;
> +}
> +
>  #endif /* __PERF_CPUMAP_H */
> diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
> index 635cd8f..50adbfb 100644
> --- a/tools/perf/util/sort.c
> +++ b/tools/perf/util/sort.c
> @@ -2,6 +2,7 @@
>  #include "hist.h"
>  #include "comm.h"
>  #include "symbol.h"
> +#include "cpumap.h"
>  
>  regex_t		parent_regex;
>  const char	default_parent_pattern[] = "^sys_|^do_page_fault";
> @@ -1117,6 +1118,8 @@ int setup_sorting(void)
>  		return -ENOMEM;
>  	}
>  
> +	cpu__setup_cacheline_size();
> +

I dont think this is the best place to call the setup,
on the other hand I can't think of any suitable ;-)

how about lazy initialization from cpu__cacheline_size?

We also have page_size variable which gets initialized
in main and is globaly accesable. I wonder we should
add the cacheline_size variable in the same way.

jirka
