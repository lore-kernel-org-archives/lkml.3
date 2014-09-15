Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872AbaIOTXH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 15:23:07 -0400
Received: from mail.kernel.org ([198.145.19.201]:46650 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754490AbaIOTXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:23:04 -0400
Date: Mon, 15 Sep 2014 16:22:59 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: jolsa@redhat.com, linux-kernel@vger.kernel.org, namhyung@kernel.org,
        mingo@kernel.org, peterz@infradead.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] perf, tools: Add PERF_PID
Message-ID: <20140915192259.GI11199@kernel.org>
References: <1410307433-12475-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410307433-12475-1-git-send-email-andi@firstfloor.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Sep 09, 2014 at 05:03:53PM -0700, Andi Kleen escreveu:
> From: Andi Kleen <ak@linux.intel.com>
> 
> It's currently difficult to filter out perf itself using a filter.
> This can give cascading effects during IO tracing when the IO
> perf does itself causes more trace output.
> 
> The best way to filter is to use the pid. But it's difficult to get the pid
> of perf without using hacks.
> 
> Add a PERF_PID meta variable to the perf filter that contains the current pid.
> 
> With this patch the following works
> 
> % perf record -e syscalls:sys_enter_write -a --filter 'common_pid != PERF_PID' ...
> 
> This won't work for more complex perf pipe lines with multiple processes,
> but at least solves the problem nicely for a single perf.
 
> @@ -983,6 +984,13 @@ int parse_filter(const struct option *opt, const char *str,
>  		return -1;
>  	}
>  
> +	/* Assume a pid has not more than 8 characters */

> +	pid = strstr(last->filter, "PERF_PID");
> +	if (pid) {
> +		char buf[9];
> +		snprintf(buf, 9, "%8d", getpid());
> +		memcpy(pid, buf, 8);

Can we please remove this assumption?

If the get to be more than 8 chars we'll be just truncating stuff and
possibly filtering some other, unrelated process, no?

       pid_t getpid(void);

typedef __pid_t pid_t;
__STD_TYPE __PID_T_TYPE __pid_t;	/* Type of process identifications.  */
/usr/include/bits/typesizes.h:#define __PID_T_TYPE __S32_TYPE
/usr/include/bits/types.h:#define	__S32_TYPE		int
[acme@zoo linux]$ uname -a
Linux zoo.ghostprotocols.net 3.17.0-rc1+ #2 SMP Thu Aug 21 12:25:42 BRT 2014 x86_64 x86_64 x86_64 GNU/Linux

[acme@zoo ~]$ cat a.c
#include <limits.h>
#include <stdio.h>

int main(int argc, char *argv[])
{
	printf("%8d", INT_MAX);
}
[acme@zoo ~]$ make a
cc     a.c   -o a
[acme@zoo ~]$ ./a | wc -c
10
[acme@zoo ~]$

The feature is needed, no doubt about it, thanks for working on it.

I guess we need the equivalent of (python regexp) s/PERF_PID/("%d" % getpid())/g
to properly implement this.

- Arnaldo
