Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751123AbaAOGoy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 01:44:54 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:65360 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750722AbaAOGou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 01:44:50 -0500
From: Gaurav Jain <gjain@fb.com>
To: Namhyung Kim <namhyung@kernel.org>
CC: Don Zickus <dzickus@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Arun Sharma <asharma@fb.com>
Subject: Re: [PATCH] perf tools: Synthesize anon MMAP records on the heap
Thread-Topic: [PATCH] perf tools: Synthesize anon MMAP records on the heap
Thread-Index: AQHPD09bvhY6ouXu+ki8ciwGSba3HpqDZ8uAgAF/04CAAGQLRIAAQoUA
Date: Wed, 15 Jan 2014 06:44:39 +0000
Message-ID: <CEFB97C1.2CC71%gjain@fb.com>
In-Reply-To: <87a9exajbg.fsf@sejong.aot.lge.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.16.4]
Content-Type: text/plain; charset="euc-kr"
Content-ID: <D0D2CB6B60FE9B428273552E78FFBD92@fb.com>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-01-15_02:2014-01-14,2014-01-15,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=26.6288010966121
 compositescore=0.998981209195878 urlsuspect_oldscore=0.998981209195878
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.998981209195878 spamscore=0
 recipient_to_sender_domain_totalscore=57 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1305240000
 definitions=main-1401140260
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s0F6ixWT006612

Hi Namhyung,


On 1/15/14, 12:46 AM, "Namhyung Kim" <namhyung@kernel.org> wrote:

>I'd like to take my ack back - it seems I missed some points.

No worries, looks like the patch wasn¡¯t well thought out.

>On Tue, 14 Jan 2014 20:48:23 +0000, Gaurav Jain wrote:
>> On 1/13/14, 11:54 AM, "Don Zickus" <dzickus@redhat.com> wrote:
>>
>>>On Sat, Jan 11, 2014 at 08:32:14PM -0800, Gaurav Jain wrote:
>>>> Anon records usually do not have the 'execname' entry. However if they
>>>>are on
>>>> the heap, the execname shows up as '[heap]'. The fix considers any
>>>>executable
>>>> entries in the map that do not have a name or are on the heap as anon
>>>>records
>>>> and sets the name to '//anon'.
>>>> 
>>>> This fixes JIT profiling for records on the heap.
>>>
>>>I guess I don't understand the need for this fix.  It seems breaking out
>>>//anon vs. [heap] would be useful.  Your patch is saying otherwise.  Can
>>>give a description of the problem you are trying to solve?
>>
>> Thank you for looking at the patch.
>>
>> We generate a perf map file which includes certain JIT©öed functions that
>> show up as [heap] entries. As a result, I included the executable heap
>> entries as anon pages so that it would be handled in
>> util/map.c:map__new(). The alternative would be to handle heap entries
>>in
>> map__new() directly, however I wasn©öt sure if this would break something
>> as it seems that heap and stack entries are expected to fail all
>> map__find_* functions. Thus I considered executable heap entries as
>> //anon, but perhaps there is a better way.
>
>Hmm.. so the point is that an executable heap mapping should have
>/tmp/perf-XXX.map as a file name, right?  If so, does something like
>below work well for you?

Just gave it a try and it fixed the issue perfectly! Thanks for the help.
This looks like a much better solution than treating the heap mapping as
an anon record.

Gaurav

>diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
>index 9b9bd719aa19..d52387fe83f1 100644
>--- a/tools/perf/util/map.c
>+++ b/tools/perf/util/map.c
>@@ -69,7 +69,7 @@ struct map *map__new(struct list_head *dsos__list, u64
>start, u64 len,
> 		map->ino = ino;
> 		map->ino_generation = ino_gen;
> 
>-		if (anon) {
>+		if (anon || (no_dso && type == MAP__FUNCTION)) {
> 			snprintf(newfilename, sizeof(newfilename), "/tmp/perf-%d.map", pid);
> 			filename = newfilename;
> 		}
>@@ -93,7 +93,7 @@ struct map *map__new(struct list_head *dsos__list, u64
>start, u64 len,
> 			 * functions still return NULL, and we avoid the
> 			 * unnecessary map__load warning.
> 			 */
>-			if (no_dso)
>+			if (no_dso && type != MAP__FUNCTION)
> 				dso__set_loaded(dso, map->type);
> 		}
> 	}

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
