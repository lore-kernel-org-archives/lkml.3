Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245AbaAPBBY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 20:01:24 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:51264 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbaAPBBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 20:01:23 -0500
X-AuditID: 9c93016f-b7b1aae000000f15-e1-52d72f61df44
From: Namhyung Kim <namhyung@kernel.org>
To: Gaurav Jain <gjain@fb.com>
Cc: Don Zickus <dzickus@redhat.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Arun Sharma <asharma@fb.com>
Subject: Re: [PATCH] perf tools: Synthesize anon MMAP records on the heap
References: <87a9exajbg.fsf@sejong.aot.lge.com> <CEFB97C1.2CC71%gjain@fb.com>
Date: Thu, 16 Jan 2014 10:01:21 +0900
In-Reply-To: <CEFB97C1.2CC71%gjain@fb.com> (Gaurav Jain's message of "Wed, 15
	Jan 2014 06:44:39 +0000")
Message-ID: <87lhyg91um.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gaurav,

On Wed, 15 Jan 2014 06:44:39 +0000, Gaurav Jain wrote:
> Hi Namhyung,
>
>
> On 1/15/14, 12:46 AM, "Namhyung Kim" <namhyung@kernel.org> wrote:
>>Hmm.. so the point is that an executable heap mapping should have
>>/tmp/perf-XXX.map as a file name, right?  If so, does something like
>>below work well for you?
>
> Just gave it a try and it fixed the issue perfectly! Thanks for the help.
> This looks like a much better solution than treating the heap mapping as
> an anon record.

Thanks for testing!  It's good to hear it solved your problem. :)

>
> Gaurav
>
>>diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
>>index 9b9bd719aa19..d52387fe83f1 100644
>>--- a/tools/perf/util/map.c
>>+++ b/tools/perf/util/map.c
>>@@ -69,7 +69,7 @@ struct map *map__new(struct list_head *dsos__list, u64
>>start, u64 len,
>> 		map->ino = ino;
>> 		map->ino_generation = ino_gen;
>> 
>>-		if (anon) {
>>+		if (anon || (no_dso && type == MAP__FUNCTION)) {

Hmm.. I think it should check type of anon mapping too (assuming JIT
interface only provides function symbols, no?):

		if ((anon || no_dso) && type == MAP__FUNCTION)) {


>> 			snprintf(newfilename, sizeof(newfilename), "/tmp/perf-%d.map", pid);
>> 			filename = newfilename;
>> 		}
>>@@ -93,7 +93,7 @@ struct map *map__new(struct list_head *dsos__list, u64
>>start, u64 len,
>> 			 * functions still return NULL, and we avoid the
>> 			 * unnecessary map__load warning.
>> 			 */
>>-			if (no_dso)
>>+			if (no_dso && type != MAP__FUNCTION)

And it should be simply:

			if (type != MAP__FUNCTION)


>> 				dso__set_loaded(dso, map->type);
>> 		}
>> 	}

I'll update this and send a formal patch soon.  Could you please test it with
the new patch then?

Thanks,
Namhyung
