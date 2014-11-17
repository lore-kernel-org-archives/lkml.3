Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391AbaKQBz0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 20:55:26 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:46172 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753377AbaKQBzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 20:55:24 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 1/3] perf tools: Allow vmlinux to fallback to kallsyms on NO_LIBELF=1
References: <1415337606-2186-1-git-send-email-namhyung@kernel.org>
	<20141107082723.GB23531@worktop.programming.kicks-ass.net>
	<1415372259.1648.51.camel@leonhard>
	<20141107173718.GD29390@twins.programming.kicks-ass.net>
	<87mw7zva3c.fsf@sejong.aot.lge.com>
	<20141110121105.GL3337@twins.programming.kicks-ass.net>
	<CAM9d7cgCzkh3_26=g0+6yUr-xBbk7_F8QP2e1sEkYw9o5OTmjw@mail.gmail.com>
	<20141111130229.GS18464@kernel.org>
Date: Mon, 17 Nov 2014 10:55:22 +0900
In-Reply-To: <20141111130229.GS18464@kernel.org> (Arnaldo Carvalho de Melo's
	message of "Tue, 11 Nov 2014 10:02:29 -0300")
Message-ID: <871tp2vbed.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

Sorry for late reply.  I was offline last week.


On Tue, 11 Nov 2014 10:02:29 -0300, Arnaldo Carvalho de Melo wrote:
> Em Tue, Nov 11, 2014 at 01:24:38PM +0900, Namhyung Kim escreveu:
>> Hi Peter,
>> 
>> On Mon, Nov 10, 2014 at 9:11 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> > On Mon, Nov 10, 2014 at 03:33:11PM +0900, Namhyung Kim wrote:
>> >> Hmm.. I don't think it's specific to the minimal elf parser.  The return
>> >> value of dso__load_sym() is a number of symbols found so when it sees a
>> >> dso with 0 symbols it'll fall back to the next option IMHO (not
>> >> tested).  Did you see a problem with the current code?
>> >
>> > So your patch:
>> >
>> > +++ b/tools/perf/util/symbol-minimal.c
>> > @@ -335,6 +335,9 @@ int dso__load_sym(struct dso *dso, struct map *map __maybe_unused,
>> >         unsigned char *build_id[BUILD_ID_SIZE];
>> >         int ret;
>> >
>> > +       if (dso->kernel)
>> > +               return 0;  /* always use kallsyms */
>> > +
>> >
>> > changes the symbol-minimal.c file to add this exception. That is very
>> > much specific to the minimal elf parser, or am I just seeing things?
>> 
>> What minimal parser does here is just skip kernel dsos (vmlinux) since
>> it didn't deal with all the details of parsing vmlinux currently.
>> 
>> 
>> >
>> > What I was saying, why not have a util/symbol.c change that disregards
>> > all DSOs with 0 symbols in.
>> 
>> The util/symbol.c doesn't need this because it can handle vmlinux
>> reliably.  So after reading symbol table, it'll use the dso if it
>
> symbol.c should not be able to handle anything, since the actual ELF
> loader is in symbol-elf.c or simbol-minimal.c, no?

Ah right, I was confused with symbol.c and symbol-elf.c - so I believe
the generic logic in symbol.c already handles DSOs with 0 symbol.  The
problem was symbol-minimal.c didn't return 0 for the DSOs.


>
> I.e.:
>
> 	symbol.c::dso__load()
> 		symbol.c::dso__load_kernel_sym()
> 			symbol.c::dso__load_vmlinux()
>
> And then it heads into one of the ELF loaders, right now, without your
> patch, I see, when the minimal loader is used:
>
> 		symbol-minimal.c::dso__load_sym()
>
> reads the build-id and if it works, returns 1, which is a bug, it should
> return 0 in this case, possibly -1 if it doesn't read the build-id :-\
>
> I.e. it should return 0, because that way it signals: "I can't read it,
> thus no symbols were loaded, symbol.c: please go on looking for them
> somewhere else, kallsyms perhaps?".

Right.  It's a bug for vmlinux.  But by returning 0, it'll iterate over
the candidate binaries in dso__load().  I'm afraid that this *might*
overwrite the build-id of the DSO with different one.  So I think it
also needs to add a check for valid build-id.

I'll update this patch with above.

Thanks,
Namhyung


>
> And this is the bug, probably. Now to look at your patches to see if
> this is touched somehow...
>
>> actually contains symbols or fallback to next dso if it has 0 symbols.
>> IOW it already disregards all dsos with 0 symbols in.
>
> See above.
>  
>> -- 
>> Thanks,
>> Namhyung
