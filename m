Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751Ab3ISOtw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 10:49:52 -0400
Received: from mail-yh0-f47.google.com ([209.85.213.47]:64527 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914Ab3ISOtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 10:49:51 -0400
Date: Thu, 19 Sep 2013 11:49:43 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 02/11] perf tools: fix path unpopulated in
 machine__create_modules()
Message-ID: <20130919144943.GE17742@ghostprotocols.net>
References: <1379328772-21214-1-git-send-email-adrian.hunter@intel.com>
 <1379328772-21214-3-git-send-email-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379328772-21214-3-git-send-email-adrian.hunter@intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Sep 16, 2013 at 01:52:43PM +0300, Adrian Hunter escreveu:
> In machine__create_modules() the 'path' char array
> was used in a call to symbol__restricted_filename()
> without always being populated.

Isn't this equivalent and shorter?

[acme@zoo linux]$ git diff
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 933d14f..6188d28 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -792,7 +792,7 @@ static int machine__create_modules(struct machine *machine)
                modules = path;
        }
 
-       if (symbol__restricted_filename(path, "/proc/modules"))
+       if (symbol__restricted_filename(modules, "/proc/modules"))
                return -1;
 
        file = fopen(modules, "r");
[acme@zoo linux]$ 

- Arnaldo

> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
>  tools/perf/util/machine.c | 11 ++++-------
>  1 file changed, 4 insertions(+), 7 deletions(-)
> 
> diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
> index 933d14f..1ae917c 100644
> --- a/tools/perf/util/machine.c
> +++ b/tools/perf/util/machine.c
> @@ -782,20 +782,17 @@ static int machine__create_modules(struct machine *machine)
>  	size_t n;
>  	FILE *file;
>  	struct map *map;
> -	const char *modules;
>  	char path[PATH_MAX];
>  
>  	if (machine__is_default_guest(machine))
> -		modules = symbol_conf.default_guest_modules;
> -	else {
> -		sprintf(path, "%s/proc/modules", machine->root_dir);
> -		modules = path;
> -	}
> +		strncpy(path, symbol_conf.default_guest_modules, PATH_MAX);
> +	else
> +		snprintf(path, PATH_MAX, "%s/proc/modules", machine->root_dir);
>  
>  	if (symbol__restricted_filename(path, "/proc/modules"))
>  		return -1;
>  
> -	file = fopen(modules, "r");
> +	file = fopen(path, "r");
>  	if (file == NULL)
>  		return -1;
>  
> -- 
> 1.7.11.7
