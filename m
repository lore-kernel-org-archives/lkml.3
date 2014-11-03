Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751114AbaKCHhb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 02:37:31 -0500
Received: from mga03.intel.com ([134.134.136.65]:13040 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750826AbaKCHh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 02:37:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,305,1413270000"; 
   d="scan'208";a="600928994"
Message-ID: <5457305B.9080404@intel.com>
Date: Mon, 03 Nov 2014 09:35:55 +0200
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 3/8] perf tools: Get rid of unused dsos__hit_all()
References: <1414999678-31377-1-git-send-email-namhyung@kernel.org> <1414999678-31377-4-git-send-email-namhyung@kernel.org>
In-Reply-To: <1414999678-31377-4-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/14 09:27, Namhyung Kim wrote:
> The dsos__hit_all() and its friends are not used anywhere.  Let's get
> rid of them.

They were added for Intel PT preparation.  Intel PT is still on its way,
so they are still needed.  Note the commit was:

commit 1f625b0b3dd641b74ba21640a1fea19a3dd893a2
Author: Adrian Hunter <adrian.hunter@intel.com>
Date:   Tue Jul 22 16:17:23 2014 +0300

    perf tools: Add dsos__hit_all()
    
    Add ability to mark all dsos as hit.
    
    This is needed in the case of Instruction Tracing.  It takes so long to
    decode an Instruction Trace that it is not worth doing just to determine
    which dsos are hit.  A later patch takes this into use.
    
    Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
    Cc: David Ahern <dsahern@gmail.com>
    Cc: Frederic Weisbecker <fweisbec@gmail.com>
    Cc: Jiri Olsa <jolsa@redhat.com>
    Cc: Namhyung Kim <namhyung@gmail.com>
    Cc: Paul Mackerras <paulus@samba.org>
    Cc: Peter Zijlstra <peterz@infradead.org>
    Cc: Stephane Eranian <eranian@google.com>
    Link: http://lkml.kernel.org/r/1406035081-14301-15-git-send-email-adrian.hunter@intel.com
    Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>



> 
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/util/header.c | 41 -----------------------------------------
>  tools/perf/util/header.h |  2 --
>  2 files changed, 43 deletions(-)
> 
> diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
> index 0ecf4a304cbc..e7c762f54bee 100644
> --- a/tools/perf/util/header.c
> +++ b/tools/perf/util/header.c
> @@ -200,47 +200,6 @@ static int write_buildid(const char *name, size_t name_len, u8 *build_id,
>  	return write_padded(fd, name, name_len + 1, len);
>  }
>  
> -static int __dsos__hit_all(struct list_head *head)
> -{
> -	struct dso *pos;
> -
> -	list_for_each_entry(pos, head, node)
> -		pos->hit = true;
> -
> -	return 0;
> -}
> -
> -static int machine__hit_all_dsos(struct machine *machine)
> -{
> -	int err;
> -
> -	err = __dsos__hit_all(&machine->kernel_dsos.head);
> -	if (err)
> -		return err;
> -
> -	return __dsos__hit_all(&machine->user_dsos.head);
> -}
> -
> -int dsos__hit_all(struct perf_session *session)
> -{
> -	struct rb_node *nd;
> -	int err;
> -
> -	err = machine__hit_all_dsos(&session->machines.host);
> -	if (err)
> -		return err;
> -
> -	for (nd = rb_first(&session->machines.guests); nd; nd = rb_next(nd)) {
> -		struct machine *pos = rb_entry(nd, struct machine, rb_node);
> -
> -		err = machine__hit_all_dsos(pos);
> -		if (err)
> -			return err;
> -	}
> -
> -	return 0;
> -}
> -
>  static int __dsos__write_buildid_table(struct list_head *head,
>  				       struct machine *machine,
>  				       pid_t pid, u16 misc, int fd)
> diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
> index 8f5cbaea64a5..d08cfe499404 100644
> --- a/tools/perf/util/header.h
> +++ b/tools/perf/util/header.h
> @@ -151,8 +151,6 @@ int perf_event__process_build_id(struct perf_tool *tool,
>  				 struct perf_session *session);
>  bool is_perf_magic(u64 magic);
>  
> -int dsos__hit_all(struct perf_session *session);
> -
>  /*
>   * arch specific callback
>   */
> 

