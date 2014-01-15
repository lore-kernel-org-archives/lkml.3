Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750933AbaAOFqb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 00:46:31 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:60212 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbaAOFq3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 00:46:29 -0500
X-AuditID: 9c93017d-b7b51ae000000e33-d7-52d620b37448
From: Namhyung Kim <namhyung@kernel.org>
To: Gaurav Jain <gjain@fb.com>
Cc: Don Zickus <dzickus@redhat.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Arun Sharma <asharma@fb.com>
Subject: Re: [PATCH] perf tools: Synthesize anon MMAP records on the heap
References: <20140113165441.GB25953@redhat.com> <CEFB09CC.2CAAA%gjain@fb.com>
Date: Wed, 15 Jan 2014 14:46:27 +0900
In-Reply-To: <CEFB09CC.2CAAA%gjain@fb.com> (Gaurav Jain's message of "Tue, 14
	Jan 2014 20:48:23 +0000")
Message-ID: <87a9exajbg.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gaurav,

I'd like to take my ack back - it seems I missed some points.


On Tue, 14 Jan 2014 20:48:23 +0000, Gaurav Jain wrote:
> On 1/13/14, 11:54 AM, "Don Zickus" <dzickus@redhat.com> wrote:
>
>>On Sat, Jan 11, 2014 at 08:32:14PM -0800, Gaurav Jain wrote:
>>> Anon records usually do not have the 'execname' entry. However if they
>>>are on
>>> the heap, the execname shows up as '[heap]'. The fix considers any
>>>executable
>>> entries in the map that do not have a name or are on the heap as anon
>>>records
>>> and sets the name to '//anon'.
>>> 
>>> This fixes JIT profiling for records on the heap.
>>
>>I guess I don't understand the need for this fix.  It seems breaking out
>>//anon vs. [heap] would be useful.  Your patch is saying otherwise.  Can
>>give a description of the problem you are trying to solve?
>
> Thank you for looking at the patch.
>
> We generate a perf map file which includes certain JIT¹ed functions that
> show up as [heap] entries. As a result, I included the executable heap
> entries as anon pages so that it would be handled in
> util/map.c:map__new(). The alternative would be to handle heap entries in
> map__new() directly, however I wasn¹t sure if this would break something
> as it seems that heap and stack entries are expected to fail all
> map__find_* functions. Thus I considered executable heap entries as
> //anon, but perhaps there is a better way.

Hmm.. so the point is that an executable heap mapping should have
/tmp/perf-XXX.map as a file name, right?  If so, does something like
below work well for you?

Thanks,
Namhyung


diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 9b9bd719aa19..d52387fe83f1 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -69,7 +69,7 @@ struct map *map__new(struct list_head *dsos__list, u64 start, u64 len,
 		map->ino = ino;
 		map->ino_generation = ino_gen;
 
-		if (anon) {
+		if (anon || (no_dso && type == MAP__FUNCTION)) {
 			snprintf(newfilename, sizeof(newfilename), "/tmp/perf-%d.map", pid);
 			filename = newfilename;
 		}
@@ -93,7 +93,7 @@ struct map *map__new(struct list_head *dsos__list, u64 start, u64 len,
 			 * functions still return NULL, and we avoid the
 			 * unnecessary map__load warning.
 			 */
-			if (no_dso)
+			if (no_dso && type != MAP__FUNCTION)
 				dso__set_loaded(dso, map->type);
 		}
 	}
