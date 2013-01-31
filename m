Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425Ab3AaTGI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 14:06:08 -0500
Received: from mail-gh0-f180.google.com ([209.85.160.180]:51030 "EHLO
	mail-gh0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835Ab3AaTGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 14:06:06 -0500
Date: Thu, 31 Jan 2013 16:05:58 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 02/25] perf top: Delete maps on exit
Message-ID: <20130131190558.GJ7651@ghostprotocols.net>
References: <1359653128-10433-1-git-send-email-acme@infradead.org>
 <1359653128-10433-3-git-send-email-acme@infradead.org>
 <510AB468.8020904@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <510AB468.8020904@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jan 31, 2013 at 11:14:00AM -0700, David Ahern escreveu:
> On 1/31/13 10:25 AM, Arnaldo Carvalho de Melo wrote:
> >Removing one more memory leak found with valgrind.

> If you are spending time one memory consumption by perf-top one thing

Those are the low hanging fruits :-)

> to look at is handling of terminated threads. Currently, terminated
> threads are stuck onto the dead_threads list and only cleaned up when
> perf terminates (perf_session__delete_dead_threads).

We need to have a refcount to know how many hist_entry instances point
to threads, once that refcount hits zero, because all symbols for such
thread have been decayed to zero samples and thus will be deleted and
removed from its hists struct, then we can remove it from dead_threads
list and delete it for good.

Ditto for dsos, etc.
 
> Since the thread entries can still be referenced in hists perhaps a
> refcnt is needed that indicates when the threads can be deleted.

Yeah, wrote the above before reading this 8-)

> From there regular calls to perf_session__delete_dead_threads can be
> made. I needed to add a regular call to that function in my perf
> daemon to keep memory usage stable - but then I don't have lingering
> references.
> 
> A lot of work yes but will be needed if there is to be an official
> libperf.so that apps can leverage.

Right, I just added this to the TODO list in the perf wiki at:

https://perf.wiki.kernel.org/index.php/Todo

Thanks,

- Arnaldo
