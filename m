Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056Ab3JJIWL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 04:22:11 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:46770 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019Ab3JJIWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 04:22:08 -0400
X-AuditID: 9c93017d-b7b96ae000006e96-fa-525663ae6582
From: Namhyung Kim <namhyung@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 02/52] tools/perf/build: Add feature check core code
References: <1381227082-22039-1-git-send-email-mingo@kernel.org>
	<1381227082-22039-3-git-send-email-mingo@kernel.org>
	<87pprdk7ft.fsf@sejong.aot.lge.com> <20131010072121.GM10246@gmail.com>
Date: Thu, 10 Oct 2013 17:22:06 +0900
In-Reply-To: <20131010072121.GM10246@gmail.com> (Ingo Molnar's message of
	"Thu, 10 Oct 2013 09:21:21 +0200")
Message-ID: <87pprdcz81.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Oct 2013 09:21:21 +0200, Ingo Molnar wrote:
> * Namhyung Kim <namhyung@kernel.org> wrote:
>
>> Hi Ingo,
>> 
>> On Tue,  8 Oct 2013 12:10:32 +0200, Ingo Molnar wrote:
>> > +feature_check = $(eval $(feature_check_code)); $(info CHK: config/feature-checks/test-$(1))
>> > +define feature_check_code
>> > +  feature-$(2) := $(shell make -C config/feature-checks test-$1 >/dev/null 2>/dev/null && echo 1 || echo 0)
>> > +endef
>> > +
>> > +#
>> > +# Build the feature check binaries in parallel, ignore errors, ignore return value and suppress output:
>> > +#
>> > +$(info Testing features:)
>> > +$(shell make -i -j -C config/feature-checks >/dev/null 2>&1)
>> > +$(info done)
>> > +
>> > +FEATURE_TESTS = hello
>> > +
>> > +$(foreach test,$(FEATURE_TESTS),$(call feature_check,$(test),$(test)))
>> 
>> So as far as I can see, all the feature checking goes twice - once in 
>> $(shell make ...) and another in $(foreach test,...).  They look like 
>> doing exactly same thing.  And the final Makefile in this series still 
>> has it twice.  Is it intentional or did I miss something?
>
> Yes - and this is a performance trick.
>
> The first run is to build them all in parallel:
>
>  $(shell $(MAKE) OUTPUT=$(OUTPUT_FEATURES) LDFLAGS=$(LDFLAGS) -i -j -C config/feature-checks $(CORE_FEATURE_TESTS) >/dev/null 2>&1)
>
> Note how we build in parallel (-j), ignore errors (-i) and suppress all 
> output.
>
> This is very fast even if all testcases are rebuilt, but we cannot 
> possibly recover which feature test failed.
>
> So we run it once more, this time serially, and recover the test results. 
> The vast majority of testcases will pass, and the repeat build will do, in 
> essence:
>
>  comet:~/tip/tools/perf/config/feature-checks> perf stat --null --repeat 10 make test-libelf >/dev/null
>
>  Performance counter stats for 'make test-libelf' (10 runs):
>
>        0.014682647 seconds time elapsed                                          ( +-  0.14% )
>
> so it's just 14 msecs to recover each testcase result.

Okay, got it.  Thanks for the explanation! :)

>
> In theory we could optimize this further, by generating an actual test 
> success/failure file via the initial parallel make attempt, and recovering 
> those flags via the serial loop. That should be even faster.

Well, I think it's already fast enough. ;)

Thanks,
Namhyung
