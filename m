Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747AbaBZORf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 09:17:35 -0500
Received: from mail-yk0-f174.google.com ([209.85.160.174]:50103 "EHLO
	mail-yk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbaBZORd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 09:17:33 -0500
Date: Wed, 26 Feb 2014 11:17:26 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Don Zickus <dzickus@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, jolsa@redhat.com, eranian@google.com
Subject: Re: [PATCH 3/3] perf: fix synthesizing mmaps for threads
Message-ID: <20140226141726.GA7552@ghostprotocols.net>
References: <1393386227-149412-1-git-send-email-dzickus@redhat.com>
 <1393386227-149412-4-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393386227-149412-4-git-send-email-dzickus@redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Feb 25, 2014 at 10:43:47PM -0500, Don Zickus escreveu:
> Currently if a process creates a bunch of threads using pthread_create
> and then perf is run in system_wide mode, the mmaps for those threads
> are not captured with a synthesized mmap event.
> 
> The reason is those threads are not visible when walking the /proc/
> directory looking for /proc/<pid>/maps files.  Instead they are discovered
> using the /proc/<pid>/tasks file (which the synthesized comm event uses).
> 
> This causes problems when a program is trying to map a data address to a
> tid.  Because the tid has no maps, the event is dropped.  Changing the program
> to look up using the pid instead of the tid, finds the correct maps but creates
> ugly hacks in the program to carry the correct tid around.
> 
> Fix this by synthesizing mmap events for each tid found in the /proc/<pid>/tasks
> file.

This seems to cover two problems, the first is for mmap/mmap2 event
processing to lookup pid/tid instead of pid/pid, the other one is to
iterate thru /proc/pid/tasks/, so this needes spliting up.

Now looking at the /tasks/ part...
 
> This may not be entirely clean but it seems to work.
> 
> Signed-off-by: Don Zickus <dzickus@redhat.com>
> ---
>  tools/perf/util/event.c   | 15 +++++++++++----
>  tools/perf/util/machine.c |  4 ++--
>  2 files changed, 13 insertions(+), 6 deletions(-)
> 
> diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
> index 086c7c8..09c53bb 100644
> --- a/tools/perf/util/event.c
> +++ b/tools/perf/util/event.c
> @@ -93,10 +93,13 @@ static pid_t perf_event__get_comm_tgid(pid_t pid, char *comm, size_t len)
>  }
>  
>  static pid_t perf_event__synthesize_comm(struct perf_tool *tool,
> -					 union perf_event *event, pid_t pid,
> +					 union perf_event *event,
> +					 union perf_event *mmap_event,
> +					 pid_t pid,
>  					 int full,
>  					 perf_event__handler_t process,
> -					 struct machine *machine)
> +					 struct machine *machine,
> +					 bool mmap_data)
>  {
>  	char filename[PATH_MAX];
>  	size_t size;
> @@ -168,6 +171,10 @@ static pid_t perf_event__synthesize_comm(struct perf_tool *tool,
>  			tgid = -1;
>  			break;
>  		}
> +
> +		/* process the thread's maps too */
> +		perf_event__synthesize_mmap_events(tool, mmap_event, pid, tgid,
> +						  process, machine, mmap_data);
>  	}
>  
>  	closedir(tasks);
> @@ -331,8 +338,8 @@ static int __event__synthesize_thread(union perf_event *comm_event,
>  				      struct perf_tool *tool,
>  				      struct machine *machine, bool mmap_data)
>  {
> -	pid_t tgid = perf_event__synthesize_comm(tool, comm_event, pid, full,
> -						 process, machine);
> +	pid_t tgid = perf_event__synthesize_comm(tool, comm_event, mmap_event, pid,
> +						 full, process, machine, mmap_data);
>  	if (tgid == -1)
>  		return -1;
>  	return perf_event__synthesize_mmap_events(tool, mmap_event, pid, tgid,
> diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
> index 813e94e..eb26544 100644
> --- a/tools/perf/util/machine.c
> +++ b/tools/perf/util/machine.c
> @@ -1026,7 +1026,7 @@ int machine__process_mmap2_event(struct machine *machine,
>  	}
>  
>  	thread = machine__findnew_thread(machine, event->mmap2.pid,
> -					event->mmap2.pid);
> +					event->mmap2.tid);
>  	if (thread == NULL)
>  		goto out_problem;
>  
> @@ -1074,7 +1074,7 @@ int machine__process_mmap_event(struct machine *machine, union perf_event *event
>  	}
>  
>  	thread = machine__findnew_thread(machine, event->mmap.pid,
> -					 event->mmap.pid);
> +					 event->mmap.tid);
>  	if (thread == NULL)
>  		goto out_problem;
>  
> -- 
> 1.7.11.7
