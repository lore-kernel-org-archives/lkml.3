Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750945Ab3I0CIK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 22:08:10 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:63037 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744Ab3I0CIJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 22:08:09 -0400
X-AuditID: 9c93017e-b7ca5ae0000013bb-3b-5244e8861a0b
From: Namhyung Kim <namhyung@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCHSET 0/8] perf tools: Fix scalability problem on callchain merging (v4)
References: <1380185890-25758-1-git-send-email-namhyung@kernel.org>
	<20130926093426.GA24596@gmail.com>
Date: Fri, 27 Sep 2013 11:08:06 +0900
In-Reply-To: <20130926093426.GA24596@gmail.com> (Ingo Molnar's message of
	"Thu, 26 Sep 2013 11:34:26 +0200")
Message-ID: <87ioxnow3d.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Thu, 26 Sep 2013 11:34:26 +0200, Ingo Molnar wrote:
> * Namhyung Kim <namhyung@kernel.org> wrote:
>
>> Hello,
>> 
>> This is a new version of callchain improvement patchset.  I found and
>> fixed bugs in the previous version.  I verified that it produced
>> exactly same output before and after applying rbtree conversion patch
>> (#1).  However after Frederic's new comm infrastructure patches are
>> applied it'd be little different.
>> 
>> The patches are on 'perf/callchain-v4' branch in my tree
>> 
>>   git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git
>
> I pulled this into a test-branch and resolved the builtin-trace.c conflict 
> with tip:master.
>
> I tried your new code out with Linus's testcase of a parallel kernel 
> build:
>
>    perf record -g -- make -j8 bzImage
>
> The 'perf record' session went mostly fine except for lost events:
>
>   Kernel: arch/x86/boot/bzImage is ready  (#25)
>   [ perf record: Woken up 553 times to write data ]
>   [ perf record: Captured and wrote 196.811 MB perf.data (~8598789 samples) ]
>   Warning:
>   Processed 2631982 events and lost 54 chunks!
>
>   Check IO/CPU overload!
>
> So, for completeness I'll mention that perf fails in two ways here:
>
>   - UI bug: it prints some scary warnings about 'IO/CPU overload' but 
>     does not give any idea what the user could do about it. At minimum it 
>     should print something about increasing --mmap-pages. It should also 
>     print the current value of --mmap-pages so that the user knows to what 
>     value to increase it ...
>
>   - defaults bug: this isn't an extreme workload on an extreme box - it's
>     a relatively bog standard system with 8 cores and 16 CPUs. The kernel
>     build was mild as well, with -j8. So losing events in perf record is
>     absolutely unacceptable. A solution might be to automatically increase 
>     the ring-buffer if -g is used, in expectation of a higher data rate.

Both look sensible.  I'll try to cook patches for them.

>
> Once perf record was done I had the ~200 MB perf.data - and the 'perf 
> report' session went much smoother than ever before: the analysis went 
> very quickly, it finished within 10 seconds and displayed a nice progress 
> bar. So this is entirely usable IMO.
>
> One small 'perf report' annoyance is that during the analysis passes 
> missing symbol printouts flash in the TUI - without the user having a 
> chance to read them. So those messages should either linger, or be 
> displayed at a later stage, for example when the user is confronted with 
> non-resolved symbols like:
>
> +  28.63%             cc1  cc1                                [.] 0x00000000006a92cb                                  ◆
>
> that is the point where the message would be useful - but nothing 
> indicates at all that this is an undesirable symbol entry and nothing 
> helps the user what to do about it!
>
> A solution might be to display non-intrusive messages about non-resolved 
> symbols when such a symbol is manipulated (its children are openened, or 
> annotation is attempted).

Hmm.. I'll think about it more how to do it.

>
> Here there is a second annoyance: on the detailed screen the 'annotate' 
> entry is simply missing when the symbol has not been resolved. If I hit 
> 'a' on the symbol entry itself in the graph view, then sometimes 
> annotation works - sometimes it does not and there's no UI feedback 
> whatsoever why it's not working.
>
> I'm not suggesting to change the keyboard flow - that is very smooth - but 
> display information about failed annotations in the status line at the 
> bottom of the screen would be very useful. Remember: it's _always_ an UI 
> bug if the user hits a key and absolutely nothing happens. At minimum a 
> low-key, non-intrusive 'key X not bound' message should appear in the 
> status line bottom. Deterministic action/reaction sequences are utterly 
> important when interacting with computers.
>
> Anyway, very nice progress with the tree here!

Hehe, thanks!
Namhyung
