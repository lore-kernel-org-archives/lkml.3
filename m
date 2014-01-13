Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751850AbaAMKpV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 05:45:21 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:56349 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbaAMKpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 05:45:19 -0500
X-AuditID: 9c93017e-b7ba2ae000003516-34-52d3c3bc1248
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Arun Sharma <asharma@fb.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: Re: [PATCH 25/28] perf top: Convert to hist_entry_iter
References: <1389170793-21926-1-git-send-email-namhyung@kernel.org>
	<1389170793-21926-26-git-send-email-namhyung@kernel.org>
	<20140111163529.GF1131@krava.brq.redhat.com>
	<87ob3gb6r1.fsf@sejong.aot.lge.com>
Date: Mon, 13 Jan 2014 19:45:16 +0900
In-Reply-To: <87ob3gb6r1.fsf@sejong.aot.lge.com> (Namhyung Kim's message of
	"Mon, 13 Jan 2014 17:55:46 +0900")
Message-ID: <877ga4b1oj.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Jan 2014 17:55:46 +0900, Namhyung Kim wrote:
> On Sat, 11 Jan 2014 17:35:29 +0100, Jiri Olsa wrote:
>> On Wed, Jan 08, 2014 at 05:46:30PM +0900, Namhyung Kim wrote:
>>> Reuse hist_entry_iter__add() function to share the similar code with
>>> perf report.  Note that it needs to be called with hists.lock so tweak
>>> some internal functions not to deadlock or hold the lock too long.
>>> 
>>> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
>>> ---
>>>  tools/perf/builtin-top.c | 75 ++++++++++++++++++++++++------------------------
>>>  1 file changed, 37 insertions(+), 38 deletions(-)
>>> 
>>> diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
>>> index f0f55e6030cd..cf330c66bed7 100644
>>> --- a/tools/perf/builtin-top.c
>>> +++ b/tools/perf/builtin-top.c
>>> @@ -186,9 +186,6 @@ static void perf_top__record_precise_ip(struct perf_top *top,
>>>  	sym = he->ms.sym;
>>>  	notes = symbol__annotation(sym);
>>>  
>>> -	if (pthread_mutex_trylock(&notes->lock))
>>> -		return;
>>> -
>>>  	ip = he->ms.map->map_ip(he->ms.map, ip);
>>>  	err = hist_entry__inc_addr_samples(he, counter, ip);
>>>  
>>> @@ -201,6 +198,8 @@ static void perf_top__record_precise_ip(struct perf_top *top,
>>>  		       sym->name);
>>>  		sleep(1);
>>>  	}
>>> +
>>> +	pthread_mutex_lock(&notes->lock);
>>>  }
>>
>> locking on function exit.. does not look right ;-)
>
> Yes, it looks weird.. but it's because of the change in locking.  After
> I changed perf top to use the hist_entry_iter, it needed to protect
> the whole hist_entry_iter__add() by hists->lock so the
> perf_top__record_precise_ip() should be called with the lock acquired.

Argh, it was a different lock..  But it seems still need to dance
anyway. ;-)

Thanks,
Namhyung
