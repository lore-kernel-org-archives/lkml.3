Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740AbaBJC6x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 21:58:53 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:56463 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277AbaBJC6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 21:58:51 -0500
X-AuditID: 9c93017d-b7b1fae00000636d-c6-52f8406976c4
From: Namhyung Kim <namhyung@kernel.org>
To: Rodrigo Campos <rodrigo@sdfg.com.ar>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Arun Sharma <asharma@fb.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 18/21] perf top: Convert to hist_entry_iter
In-Reply-To: <20140207132601.GA25259@sdfg.com.ar> (Rodrigo Campos's message of
	"Fri, 7 Feb 2014 13:26:01 +0000")
References: <1391736923-30765-1-git-send-email-namhyung@kernel.org>
	<1391736923-30765-19-git-send-email-namhyung@kernel.org>
	<20140207132601.GA25259@sdfg.com.ar>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
Date: Mon, 10 Feb 2014 11:58:49 +0900
Message-ID: <87mwhzzn9y.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Feb 2014 13:26:01 +0000, Rodrigo Campos wrote:
> On Fri, Feb 07, 2014 at 10:35:20AM +0900, Namhyung Kim wrote:
>> Reuse hist_entry_iter__add() function to share the similar code with
>> perf report.  Note that it needs to be called with hists.lock so tweak
>> some internal functions not to deadlock or hold the lock too long.
>> 
>> Tested-by: Arun Sharma <asharma@fb.com>
>> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
>> ---
>>  tools/perf/builtin-top.c | 78 ++++++++++++++++++++++++++----------------------
>>  1 file changed, 43 insertions(+), 35 deletions(-)
>> 
>> diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
>> index 40e430530168..e7d67421eb0f 100644
>> --- a/tools/perf/builtin-top.c
>> +++ b/tools/perf/builtin-top.c
>> @@ -194,6 +194,12 @@ static void perf_top__record_precise_ip(struct perf_top *top,
>>  
>>  	pthread_mutex_unlock(&notes->lock);
>>  
>> +	/*
>> +	 * This function is now called with he->hists->lock held.
>> +	 * Release it before going to sleep.
>> +	 */
>> +	pthread_mutex_unlock(&he->hists->lock);
>> +
>>  	if (err == -ERANGE && !he->ms.map->erange_warned)
>>  		ui__warn_map_erange(he->ms.map, sym, ip);
>>  	else if (err == -ENOMEM) {
>> @@ -201,6 +207,8 @@ static void perf_top__record_precise_ip(struct perf_top *top,
>>  		       sym->name);
>>  		sleep(1);
>>  	}
>> +
>> +	pthread_mutex_lock(&he->hists->lock);
>>  }
>
>
> I've seen Jiri's comment on this on a previous version of the patch, and the
> comment now really helps. Thanks :)
>
> But it still feels weird for me unlocking and then re-aquiring the lock at the
> end. Maybe is error prone too, as it's easy to add a "return" in between where
> we don't have yet aquired the lock and everything breaks, for example. I would
> document that this function must always return with that lock acquired. But
> maybe this is too personal :)

Yeah, it's a bit sad to require such weird locking behavior.  And I
agree that adding more comments will help preventing those possible
mistakes.

>
> And just curious, isn't it possible that the caller releases the lock before
> calling the function and aquires it after ? This function could then aquire +
> release the lock and be done with it. Or do you need that atomicity and know
> that nobody else have taken the lock between the caller took it and this
> function was called ? Although I'm not sure if this is better... Maybe is the
> same at the end, as the caller should (maybe) always unlock before calling.
>
> Also, I realize this is shared code so it might not make any sense or even
> complicate things a lot more in some other places where this ends-up being
> called. Sorry in advance if this is the case, I really don't know about perf :S

Don't say sorry. :)

The perf_top__record_precise_ip() is called in hist_iter_cb() callback
function so that we cannot control how it'll be called since it's now in
the generic code.  So it acquires the lock before calling the generic
code and then release-and-reacquire in the callback function.

And the hist lock is needed during inserting an entry since display
thread can switch to another tree anytime.

Thanks,
Namhyung
