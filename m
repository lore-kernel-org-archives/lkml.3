Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757296AbaGNUn2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 16:43:28 -0400
Received: from mail.kernel.org ([198.145.19.201]:57079 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756749AbaGNUnX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 16:43:23 -0400
Date: Mon, 14 Jul 2014 17:43:10 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 12/41] perf tools: Fix leak of 'struct thread' on error
 path
Message-ID: <20140714204310.GC18133@kernel.org>
References: <1405332185-4050-1-git-send-email-adrian.hunter@intel.com>
 <1405332185-4050-13-git-send-email-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405332185-4050-13-git-send-email-adrian.hunter@intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Jul 14, 2014 at 01:02:36PM +0300, Adrian Hunter escreveu:
> __machine__findnew_thread() creates a 'struct thread'
> but does not free it on the error path.

Ok, but that second one is a separate bug, i.e. its not fixing the
described leak, please break this into two patches with separate commit
messages.

- Arnaldo
 
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
>  tools/perf/util/machine.c | 4 +++-
>  tools/perf/util/thread.c  | 6 ++++--
>  2 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
> index c1c5ca3..18eaf31 100644
> --- a/tools/perf/util/machine.c
> +++ b/tools/perf/util/machine.c
> @@ -349,8 +349,10 @@ static struct thread *__machine__findnew_thread(struct machine *machine,
>  		 * within thread__init_map_groups to find the thread
>  		 * leader and that would screwed the rb tree.
>  		 */
> -		if (thread__init_map_groups(th, machine))
> +		if (thread__init_map_groups(th, machine)) {
> +			thread__delete(th);
>  			return NULL;
> +		}
>  	}
>  
>  	return th;
> diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
> index 149e417..b9a3ee4 100644
> --- a/tools/perf/util/thread.c
> +++ b/tools/perf/util/thread.c
> @@ -95,8 +95,10 @@ void thread__delete(struct thread *thread)
>  {
>  	struct comm *comm, *tmp;
>  
> -	map_groups__put(thread->mg);
> -	thread->mg = NULL;
> +	if (thread->mg) {
> +		map_groups__put(thread->mg);
> +		thread->mg = NULL;
> +	}
>  	list_for_each_entry_safe(comm, tmp, &thread->comm_list, list) {
>  		list_del(&comm->list);
>  		comm__free(comm);
> -- 
> 1.8.3.2
