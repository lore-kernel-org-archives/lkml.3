Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759765Ab3ICIsl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 04:48:41 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:44307 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759738Ab3ICIsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 04:48:39 -0400
X-AuditID: 9c93017e-b7c76ae000003897-f8-5225a266151a
From: Namhyung Kim <namhyung@kernel.org>
To: Robert Richter <rric@kernel.org>
Cc: Sedat Dilek <sedat.dilek@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] tools: perf: Fix liblk not built when using perf_install target
References: <1377875916-5208-1-git-send-email-sedat.dilek@gmail.com>
	<20130830164905.GA31061@rric.localhost>
Date: Tue, 03 Sep 2013 17:48:38 +0900
In-Reply-To: <20130830164905.GA31061@rric.localhost> (Robert Richter's message
	of "Fri, 30 Aug 2013 18:49:05 +0200")
Message-ID: <874na2uw7t.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 30 Aug 2013 18:49:05 +0200, Robert Richter wrote:
> On 30.08.13 17:18:36, Sedat Dilek wrote:
>> So, I tried to build perf the "official" way:
>> 
>>    $ make -C tools/ perf_install
>> 
>> Unfortunately, my build breaks like this:
>> ...
>> make[2]: Entering directory
>> `~/src/linux-kernel/linux/tools/lib/traceevent'
>> make[2]: Leaving directory
>> `~/src/linux-kernel/linux/tools/lib/traceevent'
>>     LINK perf
>> gcc: error: ~/src/linux-kernel/linux/tools/lib/lk/liblk.a: No such file or directory
>> make[1]: *** [perf] Error 1
>> make[1]: Leaving directory `~/src/linux-kernel/linux/tools/perf'
>> make: *** [perf_install] Error 2
>> 
>> After some discussion on IRC with peterz and acme and a closer look at
>> the targets in "tools/Makefile", I have noticed that the perf_install
>> target misses liblk to be built beforehand.
>
> There are no build prerequisites on purpose for install targets.
> Install targets are intended to be run with root permissions. We don't
> want to create/overwrite files in the build directory as root while
> running install rules. Thus, you always need to run:
>
>  $ make -C tools/ perf
>
> or similar first.

But AFAIK install target usually depends on build targets on many
projects.  And perf too already does the same:

  [ tools/perf/Makefile ]
  install-bin: all
	...

  install: install-bin


So if you really concern the permission problem, install target should
not build perf itself, right?  But in this case, it tried to build perf
but failed to do it on liblk.

>
>> On the contrary the perf_clean target invokes to clean liblk when perf
>> is cleaned.
>> 
>> [ tools/Makefile ]
>> ...
>> perf_clean: liblk_clean
>> 	$(call descend,$(@:_clean=),clean)
>> ...
>> 
>> Fix this by adding liblk target to perf_install target.
>
> So no, this is not the proper fix.
>
> Before installing you *need* to build. You might want to fix the
> documenation...

Hmm.. I don't know.  What I'm curious about is why it didn't build liblk
during building perf.

Thanks,
Namhyung
