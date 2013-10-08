Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752356Ab3JHBl1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 21:41:27 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:34272 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586Ab3JHBl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 21:41:26 -0400
Message-ID: <525362C1.4010402@gmail.com>
Date: Mon, 07 Oct 2013 19:41:21 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>
CC: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [RFC PATCH 00/50] tools/perf: Speed up the build system
References: <1381147003-2574-1-git-send-email-mingo@kernel.org> <5252BCB4.5030802@gmail.com> <20131007141100.GA21873@gmail.com> <5252D4DB.30302@gmail.com> <20131007164156.GA12790@gmail.com>
In-Reply-To: <20131007164156.GA12790@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/7/13 10:41 AM, Ingo Molnar wrote:
>
> * David Ahern <dsahern@gmail.com> wrote:
>
>> I also noticed that the dwarf test is still run even with the NO_DWARF
>> option passed in:
>>
>> [daahern@nxos-vdc-dev1 perf]$ make O=/tmp/junk LDFLAGS=-static
>> NO_DWARF=1 -j 4
>>      BUILD: Doing 'make -j16' parallel build
>>
>> Auto-detecting system features:
>>
>> ...                     backtrace: [ on  ]
>> ...                         dwarf: [ on  ]
>> ...                fortify-source: [ on  ]
>>
>> Note the dwarf test shows 'on'.
>
> Hm, yes.
>
> This is just the print-out though - the actual feature logic should still
> follow the NO_DWARF=1 setting (modulo bugs).
>
> So I'm wondering, should we solve this by adding extra logic linking the
> feature flags with their legacy names. It would get unwieldy rather
> quickly I think.

yes.

> Another solution would be to introduce a new method to disable features,
> via something like:
>
> 	make FEATURE_dwarf=0
>
> Where the pattern would follow the auto-detected naming. This would
> simplify the printout logic and would simplify the feature support / flags
> decision tree as well.
>
> Furthermore, it would unify the various flags we have today, which is
> rather mixed: for example there's NO_DWARF which is a name that shows
> negated logic, but there's also HAVE_CPLUS_DEMANGLE_SUPPORT is is a name
> with positive logic. We'd have one uniform naming scheme permeating the
> whole build system.

The Kconfig series converts all of the NO_XXXXX to CONFIG_XXXXX. I'd 
like to see that because it mirrors kernel configs and is a stepping 
stone to kconf integration.

If the NO_XXXX takes precedence over the autoprobe detection then the 
user gets what is asked, so I guess we can leave it as is for now.

>
> And that brings in your [K]config patches: which would make sense in that
> context as well, as they'd allow the permanent configuration of features
> with 3 states for each feature flag:
>
> 	off
> 	auto-detect
> 	on
>
> Your scheme I think makes a lot of sense on top of my bits. Packagers
> would likely want to use a .config to build perf, most users would likely
> be fine with a default of everything on auto-detect. Specialized users
> would want to use their own .config's.

Yes. This series helps with the auto-probing config option. Jiri has 
done quite a bit in this direction as well. Once this set goes in I'll 
see if I can find some time to revisit the kconf stuff - unless Jiri 
beats me to it. We have been overlapping on a few features. ;-)

David

