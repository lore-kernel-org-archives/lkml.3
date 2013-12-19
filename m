Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717Ab3LSOVo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 09:21:44 -0500
Received: from mail-qe0-f50.google.com ([209.85.128.50]:50318 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754563Ab3LSOVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 09:21:40 -0500
Date: Thu, 19 Dec 2013 11:21:33 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, dsahern@gmail.com,
        adrian.hunter@intel.com, mingo@redhat.com, paulus@samba.org,
        a.p.zijlstra@chello.nl
Subject: Re: [PATCH 1/4] perf tools: Add support of guest in
 synthesize_threads.
Message-ID: <20131219142133.GN4819@ghostprotocols.net>
References: <cover.1387493396.git.yangds.fnst@cn.fujitsu.com>
 <c1922c3cf1b16ae6fc8c009cf7c02db5144ab001.1387493396.git.yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c1922c3cf1b16ae6fc8c009cf7c02db5144ab001.1387493396.git.yangds.fnst@cn.fujitsu.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Dec 19, 2013 at 05:54:51PM -0500, Dongsheng Yang escreveu:
> We are using XXX__synthesize_threads() function to synthesize the
> symbols of user space for host. This patch add support of guest
> for these functions.

I think this patch should be split in at least two, please read below.

And please write here an outline of what will happen so that it can find
the right /proc files using machine->root_dir, etc, so that casual (and
experienced too) hackers can figure out what your patch does more
quickly.

- Arnaldo
 
> Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
> ---
>  tools/perf/util/event.c | 33 +++++++++++++++++++++++++++------
>  1 file changed, 27 insertions(+), 6 deletions(-)
> 
> diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
> index 6948768..6e36bbb 100644
> --- a/tools/perf/util/event.c
> +++ b/tools/perf/util/event.c
> @@ -106,8 +106,12 @@ static pid_t perf_event__synthesize_comm(struct perf_tool *tool,
>  
>  	memset(&event->comm, 0, sizeof(event->comm));
>  
> -	tgid = perf_event__get_comm_tgid(pid, event->comm.comm,
> -					 sizeof(event->comm.comm));
> +	if (machine__is_host(machine))
> +		tgid = perf_event__get_comm_tgid(pid, event->comm.comm,
> +						 sizeof(event->comm.comm));
> +	else
> +		tgid = machine->pid;
> +
>  	if (tgid < 0)
>  		goto out;
>  
> @@ -129,7 +133,11 @@ static pid_t perf_event__synthesize_comm(struct perf_tool *tool,
>  		goto out;
>  	}
>  
> -	snprintf(filename, sizeof(filename), "/proc/%d/task", pid);
> +	if (machine__is_default_guest(machine))
> +		return 0;

So the hunk above, the one that makes it bail out if it is a default
guest, I think it should be a separate patch with an explanation that
since pid is equal to 0:

#define DEFAULT_GUEST_KERNEL_ID         (0)

opendir("/proc/0/task") will fail, so its better to check if it is the
default guest instead of trying to opendir a directory that doesn't
exists and print a meaningless message in debug mode:

                pr_debug("couldn't open %s\n", filename);

Then, the rest, which is to use machine->root_dir to find the right proc
dir, probably via sshfs (right?), will work as expected _and_ is a
separate, unrelated to the above (bailing out on default guest pid))
patch, ok?

> +	snprintf(filename, sizeof(filename), "%s/proc/%d/task",
> +		 machine->root_dir, pid);
>  
>  	tasks = opendir(filename);
>  	if (tasks == NULL) {
> @@ -178,7 +186,11 @@ static int perf_event__synthesize_mmap_events(struct perf_tool *tool,
>  	FILE *fp;
>  	int rc = 0;
>  
> -	snprintf(filename, sizeof(filename), "/proc/%d/maps", pid);
> +	if (machine__is_default_guest(machine))

This one should be on the first patch, together with the other
machine__is_default_guest() test, please look for any other such test
and group them in a separate patch, as outlined above.

> +		return 0;
> +
> +	snprintf(filename, sizeof(filename), "%s/proc/%d/maps",
> +		 machine->root_dir, pid);
>  
>  	fp = fopen(filename, "r");
>  	if (fp == NULL) {
> @@ -218,7 +230,10 @@ static int perf_event__synthesize_mmap_events(struct perf_tool *tool,
>  		/*
>  		 * Just like the kernel, see __perf_event_mmap in kernel/perf_event.c
>  		 */
> -		event->header.misc = PERF_RECORD_MISC_USER;
> +		if (machine__is_host(machine))
> +			event->header.misc = PERF_RECORD_MISC_USER;
> +		else
> +			event->header.misc = PERF_RECORD_MISC_GUEST_USER;
>  
>  		if (prot[2] != 'x') {
>  			if (!mmap_data || prot[0] != 'r')
> @@ -387,6 +402,7 @@ int perf_event__synthesize_threads(struct perf_tool *tool,
>  				   struct machine *machine, bool mmap_data)
>  {
>  	DIR *proc;
> +	char proc_path[PATH_MAX];
>  	struct dirent dirent, *next;
>  	union perf_event *comm_event, *mmap_event;
>  	int err = -1;
> @@ -399,7 +415,12 @@ int perf_event__synthesize_threads(struct perf_tool *tool,
>  	if (mmap_event == NULL)
>  		goto out_free_comm;
>  
> -	proc = opendir("/proc");
> +	if (machine__is_default_guest(machine))
> +		return 0;

One more :-)

> +	snprintf(proc_path, sizeof(proc_path), "%s/proc", machine->root_dir);
> +	proc = opendir(proc_path);
> +
>  	if (proc == NULL)
>  		goto out_free_mmap;
>  
> -- 
> 1.8.2.1
