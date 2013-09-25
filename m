Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857Ab3IYPp4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 11:45:56 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:48370 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659Ab3IYPpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 11:45:54 -0400
Date: Wed, 25 Sep 2013 12:45:48 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH V2 01/10] perf tools: fix path unpopulated in
 machine__create_modules()
Message-ID: <20130925154548.GF2634@ghostprotocols.net>
References: <1379845338-29637-1-git-send-email-adrian.hunter@intel.com>
 <1379845338-29637-2-git-send-email-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379845338-29637-2-git-send-email-adrian.hunter@intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sun, Sep 22, 2013 at 01:22:09PM +0300, Adrian Hunter escreveu:
> In machine__create_modules() the 'path' char array
> was used in a call to symbol__restricted_filename()
> without always being populated.
> 
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
>  tools/perf/util/machine.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
> index 933d14f..ddf917b 100644
> --- a/tools/perf/util/machine.c
> +++ b/tools/perf/util/machine.c
> @@ -785,14 +785,14 @@ static int machine__create_modules(struct machine *machine)
>  	const char *modules;
>  	char path[PATH_MAX];
>  
> -	if (machine__is_default_guest(machine))
> +	if (machine__is_default_guest(machine)) {
>  		modules = symbol_conf.default_guest_modules;
> -	else {
> -		sprintf(path, "%s/proc/modules", machine->root_dir);
> +	} else {
> +		snprintf(path, PATH_MAX, "%s/proc/modules", machine->root_dir);
>  		modules = path;
>  	}

While I don't dispute the above is an improvement, I think it is
unrelated to the fix described in the changeset comment, so I'm breaking
this patch into two and adding the strict fix to perf/urgent, the other
part (s/sprintf/snprintf/g) to perf/core, with respective explanation,

Thanks,

- Arnaldo

>  
> -	if (symbol__restricted_filename(path, "/proc/modules"))
> +	if (symbol__restricted_filename(modules, "/proc/modules"))
>  		return -1;
>  
>  	file = fopen(modules, "r");
> -- 
> 1.7.11.7
