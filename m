Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156Ab3KAHHZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 03:07:25 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:59148 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433Ab3KAHHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 03:07:24 -0400
X-AuditID: 9c930179-b7c9bae000000e4c-05-5273532a7230
From: Namhyung Kim <namhyung@kernel.org>
To: Rodrigo Campos <rodrigo@sdfg.com.ar>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Arun Sharma <asharma@fb.com>
Subject: Re: [PATCH 08/14] perf report: Cache cumulative callchains
References: <1383202576-28141-1-git-send-email-namhyung@kernel.org>
	<1383202576-28141-9-git-send-email-namhyung@kernel.org>
	<20131031111333.GB27863@sdfg.com.ar>
Date: Fri, 01 Nov 2013 16:07:22 +0900
In-Reply-To: <20131031111333.GB27863@sdfg.com.ar> (Rodrigo Campos's message of
	"Thu, 31 Oct 2013 11:13:34 +0000")
Message-ID: <87r4b04n2t.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rodrigo,

On Thu, 31 Oct 2013 11:13:34 +0000, Rodrigo Campos wrote:
> On Thu, Oct 31, 2013 at 03:56:10PM +0900, Namhyung Kim wrote:
>> From: Namhyung Kim <namhyung.kim@lge.com>
>>  	/*
>> +	 * This is for detecting cycles or recursions so that they're
>> +	 * cumulated only one time to prevent entries more than 100%
>> +	 * overhead.
>> +	 */
>> +	ccache = malloc(sizeof(*ccache) * PERF_MAX_STACK_DEPTH);
>> +	if (ccache == NULL)
>> +		return -ENOMEM;
>> +
>> +	node = callchain_cursor_current(&callchain_cursor);
>> +	if (node == NULL)
>> +		return 0;
>
> Here you return without assigning iter->priv nor iter->priv->dso iter->priv->sym

Right!  I forgot to set iter->priv to ccache in this case.

>
>> +
>> +	ccache[0].dso = node->map->dso;
>> +	ccache[0].sym = node->sym;
>> +
>> +	iter->priv = ccache;
>> +	iter->curr = 1;
>
> Because the assignment is done here.
>
>> +
>> +	/*
>>  	 * The first callchain node always contains same information
>>  	 * as a hist entry itself.  So skip it in order to prevent
>>  	 * double accounting.
>> @@ -501,8 +528,29 @@ iter_add_next_cumulative_entry(struct add_entry_iter *iter,
>>  {
>>  	struct perf_evsel *evsel = iter->evsel;
>>  	struct perf_sample *sample = iter->sample;
>> +	struct cumulative_cache *ccache = iter->priv;
>>  	struct hist_entry *he;
>>  	int err = 0;
>> +	int i;
>> +
>> +	/*
>> +	 * Check if there's duplicate entries in the callchain.
>> +	 * It's possible that it has cycles or recursive calls.
>> +	 */
>> +	for (i = 0; i < iter->curr; i++) {
>> +		if (sort__has_sym) {
>> +			if (ccache[i].sym == al->sym)
>> +				return 0;
>> +		} else {
>> +			/* Not much we can do - just compare the dso. */
>> +			if (ccache[i].dso == al->map->dso)
>
> sym and dso are used here
>
>> +				return 0;
>> +		}
>> +	}
>> +
>> +	ccache[i].dso = al->map->dso;
>> +	ccache[i].sym = al->sym;
>> +	iter->curr++;
>>  
>>  	he = __hists__add_entry(&evsel->hists, al, iter->parent, NULL, NULL,
>>  				sample->period, sample->weight,
>> @@ -538,6 +586,7 @@ iter_finish_cumulative_entry(struct add_entry_iter *iter,
>>  	evsel->hists.stats.total_period += sample->period;
>>  	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
>>  
>> +	free(iter->priv);
>
> And here I'm seeing a double free when trying the patchset with other examples.
> I added a printf to the "if (node == NULL)" case and I'm hitting it. So it seems
> to me that, when reusing the entry, every user is freeing it and then the double
> free.
>
> This is my first time looking at perf code, so I might be missing LOT of things,
> sorry in advance :)

Don't say sorry!  You're very helpful and found a real bug!

>
> I tried copying the dso and sym to the new allocated mem (and assigning
> iter->priv = ccache before the return if "node == NULL"), as shown in the
> attached patch, but when running with valgrind it also added some invalid reads
> and segfaults (without valgrind it didn't segfault, but I must be "lucky").
>
> So if there is no node (node == NULL) and we cannot read the dso and sym from
> the current values of iter->priv (they show invalid reads in valgrind), I'm not
> sure where can we read them. And, IIUC, we should initialize them because they
> are used later. So maybe there are only some cases where we can read iter->priv
> and for the other cases just initialize to something (although doesn't feel
> possible because it's the dso and sym) ? Or should we read/copy them from some
> other place (maybe before some other thing is free'd) ? Or maybe forget about
> the malloc when node == NULL and just use iter->priv and the free shouldn't be
> executed till iter->curr == 1 ? I added that if for the free, but didn't help.
> Although I didn't really check how iter->curr is used. What am I missing ?

If node == NULL, it means there no valid callchains so no need to go in
the loop - iter_next_cumulative_entry() returns 0 so iter_add_next_
cumulative_entry() never called.  So don't worry about the sym and dso
in this case.

The problem is for freeing iter->priv unconditionally.  Since it has
previous ccache pointer (which already freed) it can lead to a double
free if the next entry has no valid callchains.

>
> I'm not really sure which is the fix for this. Also just in case I tried
> assigning "iter->priv = NULL" after it's free'd and it """fixes""" it.

I think the right fix is assigning "iter->priv = NULL" as you said.  But
I changed this patch a bit for v3 so need to check it again.

>
> Just reverting the patch (reverts without conflict) also solves the double free
> problem for me (although it probably introduces the problem the patch tries to
> fix =) and seems to make valgrind happy too.
>
> Thanks a lot and sorry again if I'm completely missing some "rules/invariants",
> I'm really new to perf :)

You didn't miss anything and I'd really appreciate your review. :)

Thanks,
Namhyung
