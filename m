Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933314AbaGWUoS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 16:44:18 -0400
Received: from mail.kernel.org ([198.145.19.201]:34588 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932847AbaGWUoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 16:44:17 -0400
Date: Wed, 23 Jul 2014 17:44:12 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 49/52] perf tools: Build programs to copy 32-bit
 compatibility VDSOs
Message-ID: <20140723204412.GQ20303@kernel.org>
References: <1406035081-14301-1-git-send-email-adrian.hunter@intel.com>
 <1406035081-14301-50-git-send-email-adrian.hunter@intel.com>
 <20140723124849.GB1207@krava.brq.redhat.com>
 <53CFBEB7.9000903@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53CFBEB7.9000903@intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Jul 23, 2014 at 04:55:03PM +0300, Adrian Hunter escreveu:
> On 07/23/2014 03:48 PM, Jiri Olsa wrote:
> > On Tue, Jul 22, 2014 at 04:17:58PM +0300, Adrian Hunter wrote:
> > 
> > SNIP
> > 
> >> index 1f67aa0..45ab040 100644
> >> --- a/tools/perf/config/Makefile
> >> +++ b/tools/perf/config/Makefile
> >> @@ -604,6 +604,27 @@ ifdef HAVE_KVM_STAT_SUPPORT
> >>      CFLAGS += -DHAVE_KVM_STAT_SUPPORT
> >>  endif
> >>  
> >> +ifeq (${IS_64_BIT}, 1)
> >> +  ifndef NO_PERF_READ_VDSO32
> >> +    CAN_DO := $(shell echo "main() {}" | ${CC} -m32 -x c - >/dev/null 2>/dev/null && echo 1 || echo 0)
> >> +    ifneq (${CAN_DO}, 1)
> >> +      NO_PERF_READ_VDSO32 := 1
> >> +    endif
> >> +  endif
> >> +  ifneq (${IS_X86_64}, 1)
> >> +    NO_PERF_READ_VDSOX32 := 1
> >> +  endif
> >> +  ifndef NO_PERF_READ_VDSOX32
> >> +    CAN_DO := $(shell echo 'main() {}' | ${CC} -mx32 -x c - >/dev/null 2>/dev/null && echo 1 || echo 0)
> >> +    ifneq (${CAN_DO}, 1)
> >> +      NO_PERF_READ_VDSOX32 := 1
> >> +    endif
> >> +  endif

> > please move those check into feature config code under config/features/..
 
> I will look at doing that.

Ok, probably this can be done in a follow up patch, Jiri?
 
> > SNIP
> >> +++ b/tools/perf/perf-read-vdso.c
> >> @@ -0,0 +1,59 @@
> >> +#include <stdio.h>
> >> +#include <string.h>
> >> +
> >> +#define VDSO__MAP_NAME "[vdso]"
> >> +
> >> +static int find_vdso_map(void **start, void **end)
> >> +{
> >> +	FILE *maps;
> >> +	char line[128];
> >> +	int found = 0;
> >> +
> >> +	maps = fopen("/proc/self/maps", "r");
> >> +	if (!maps) {
> >> +		fprintf(stderr, "vdso: cannot open maps\n");
> >> +		return -1;
> >> +	}
> >> +
> >> +	while (!found && fgets(line, sizeof(line), maps)) {
> >> +		int m = -1;
> >> +
> >> +		/* We care only about private r-x mappings. */
> >> +		if (2 != sscanf(line, "%p-%p r-xp %*x %*x:%*x %*u %n",
> >> +				start, end, &m))
> >> +			continue;
> >> +		if (m < 0)
> >> +			continue;
> >> +
> >> +		if (!strncmp(&line[m], VDSO__MAP_NAME,
> >> +			     sizeof(VDSO__MAP_NAME) - 1))
> >> +			found = 1;
> >> +	}
> >> +
> >> +	fclose(maps);
> >> +	return !found;
> >> +}
> > 
> > hum, any easy way to use/share find_vdso_map from vdso.c?
> > I guess this way is more straighforward and clear.. it's
> > probably not worthy for function this simple
> 
> Would have to create another source file and include it.
> I am not sure it is worth it.  Maybe Arnaldo can decide?

I think it is, either do direct sourcing with #include or add it to a
linking list for the binaries that use it.

- Arnaldo
