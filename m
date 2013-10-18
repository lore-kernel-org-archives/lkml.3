Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247Ab3JROcQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 10:32:16 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:49763 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754873Ab3JROcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 10:32:14 -0400
Date: Fri, 18 Oct 2013 11:32:06 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 07/19] perf script: Set up output options for in-stream
 attributes
Message-ID: <20131018143206.GB4320@ghostprotocols.net>
References: <1382099356-4918-1-git-send-email-adrian.hunter@intel.com>
 <1382099356-4918-8-git-send-email-adrian.hunter@intel.com>
 <526137E5.3050803@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <526137E5.3050803@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Oct 18, 2013 at 07:30:13AM -0600, David Ahern escreveu:
> On 10/18/13 6:29 AM, Adrian Hunter wrote:

> >Attributes (struct perf_event_attr) are recorded separately in the perf.data
> >file.  perf script uses them to set up output options.  However attributes
> >can also be in the event stream, for example when the input is a pipe (i.e.
> >live mode).  This patch makes perf script process in-stream attributes in
> >the same way as on-file attributes.
 
> You have multiple changes in this patch -- expanding attribute
> processing to set output options per the description above and you
> are also making perf_script a stack variable. The latter should be a
> separate patch.

Agreed, and this conversion of struct perf_script to be a stack variable is
nice (killing globals, a favourite pastime, yeah!), I like it, but in the past
one such conversion showed something nasty that made several people stare at
the build seeing builtin-sched.o take ages to build...

Please consider testing before/after that specific stack move:

commit f36f83f947ede547833e462696893f866df77324
Author: Namhyung Kim <namhyung.kim@lge.com>
Date:   Tue Jun 4 14:46:19 2013 +0900

    perf sched: Move struct perf_sched definition out of cmd_sched()
    
    For some reason it consumed quite amount of compile time when declared
    as local variable, and it disappeared when moved out of the function.
    Moving other variables/tables didn't help.
    
    On my system this single-file-change build time reduced from 11s to 3s.
