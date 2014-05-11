Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145AbaEKNco (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 09:32:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3237 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751094AbaEKNcn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 09:32:43 -0400
Date: Sun, 11 May 2014 15:30:18 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH v6 1/2] perf record: Propagate exit status of a command
 line workload
Message-ID: <20140511133018.GB2272@krava.brq.redhat.com>
References: <1399612458-18758-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399612458-18758-1-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2014 at 02:14:17PM +0900, Namhyung Kim wrote:
> Currently perf record doesn't propagate the exit status of a workload
> given by the command line.  But sometimes it'd useful if it's
> propagated so that a monitoring script can handle errors
> appropriately.
> 
> To do that, it got rid of exit handlers and run/call them directly in
> the __cmd_record().  I don't see any reason why those are in a form of
> exit handlers in the first place.  Also it cleaned up the resource
> management code in record__exit().

so in this last change we keep one exit handler, please update
the changelog

> 
> With this change, perf record returns the child exit status in case of
> normal termination and send signal to itself when terminated by signal.
> 

SNIP

>  
>  out_delete_session:
>  	perf_session__delete(session);
> -	return err;
> +	return status;

we dont set status correctly before the 'goto out_delete_session'
in the following condition:

                err = perf_evlist__prepare_workload(rec->evlist, &opts->target,
                                                    argv, file->is_pipe,
                                                    workload_exec_failed_signal);
                if (err < 0) {
                        pr_err("Couldn't run the workload!\n");
                        goto out_delete_session;
                }

so we dont propagate status correctly in case the above function fails:

[jolsa@krava perf]$ ulimit -n 6
[jolsa@krava perf]$ ./perf record sleep 100
failed to create 'go' pipe: Too many open files
Couldn't run the workload!
[jolsa@krava perf]$ echo $?
0
[jolsa@krava perf]$

thanks,
jirka
