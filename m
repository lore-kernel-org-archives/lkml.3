Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab3F1NqY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 09:46:24 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:34297 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132Ab3F1NqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 09:46:23 -0400
Message-ID: <51CD93AF.3060908@gmail.com>
Date: Fri, 28 Jun 2013 07:46:23 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Adrian Hunter <adrian.hunter@intel.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH V2 15/15] perf tools: fix ppid in thread__fork()
References: <1372319707-13892-1-git-send-email-adrian.hunter@intel.com> <1372319707-13892-16-git-send-email-adrian.hunter@intel.com> <51CC6F16.40004@gmail.com> <51CD3187.5050603@intel.com>
In-Reply-To: <51CD3187.5050603@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/28/13 12:47 AM, Adrian Hunter wrote:
>> knowledge of the specific thread within the parent that created the process
>> can be valuable -- that's what we get now. This change drops that
>> information. I'd prefer this stays at thread id -- or save the parent thread
>> id in addition to the pid.
>
> That means renaming ppid to ptid.  Do you want to do that?

Don't lose information, so if you want the process id add ppid and ptid. 
I like knowing the exact thread.

>
> Isn't it possible that the parent could exit and the pid or tid be re-used
> for another process?  In that case, to reliable identify the parent a
> pointer to its struct thread would be needed.  i.e.
>
> diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
> --- a/tools/perf/util/thread.h
> +++ b/tools/perf/util/thread.h
> @@ -14,6 +14,7 @@ struct thread {
>          struct map_groups       mg;
>          pid_t                   pid_; /* Not all tools update this */
>          pid_t                   tid;
> -       pid_t                   ppid;
> +       struct thread           *parent;
>          char                    shortname[3];
>          bool                    comm_set;
>
> However that means tracking the lifetime of 'parent' to ensure that it is
> not left dangling.
>
> Do you want to do that?

No, I do not think we want to save pointers to other thread structs. We 
actually need to be able to clean up the dead_threads list for long 
running sessions and dangling pointers would add to the problem.

David

