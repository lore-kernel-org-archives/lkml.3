Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697AbaB1V3f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 16:29:35 -0500
Received: from merlin.infradead.org ([205.233.59.134]:43344 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023AbaB1V3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 16:29:34 -0500
Date: Fri, 28 Feb 2014 22:29:23 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 2/2] perf tools: Fix strict alias issue for find_first_bit
Message-ID: <20140228212923.GI14089@laptop.programming.kicks-ass.net>
References: <1393622751-21513-1-git-send-email-acme@infradead.org>
 <1393622751-21513-3-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1393622751-21513-3-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 28, 2014 at 06:25:51PM -0300, Arnaldo Carvalho de Melo wrote:
> From: Jiri Olsa <jolsa@redhat.com>
> 
> When compiling perf tool code with gcc 4.4.7 I'm getting
> following error:
> 
>     CC       util/session.o
>   cc1: warnings being treated as errors
>   util/session.c: In function ‘perf_session_deliver_event’:
>   tools/perf/util/include/linux/bitops.h:109: error: dereferencing pointer ‘p’ does break strict-aliasing rules
>   tools/perf/util/include/linux/bitops.h:101: error: dereferencing pointer ‘p’ does break strict-aliasing rules
>   util/session.c:697: note: initialized from here
>   tools/perf/util/include/linux/bitops.h:101: note: initialized from here
>   make[1]: *** [util/session.o] Error 1
>   make: *** [util/session.o] Error 2
> 
> The aliased types here are u64 and unsigned long pointers, which is safe
> for the find_first_bit processing.
> 
> This error shows up for me only for gcc 4.4 on 32bit x86, even for
> -Wstrict-aliasing=3, while newer gcc are quiet and scream here for
> -Wstrict-aliasing={2,1}. Looks like newer gcc changed the rules for
> strict alias warnings.
> 
> The gcc documentation offers workaround for valid aliasing by using
> __may_alias__ attribute:
> 
>   http://gcc.gnu.org/onlinedocs/gcc-4.4.0/gcc/Type-Attributes.html
> 
> Using this workaround for the find_first_bit function.

Hurm; didn't I suggest using -fno-strict-aliasing just like the kernel
does? Because the C aliasing rules are bonghits heavy?
