Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099AbaANUtR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 15:49:17 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:54528 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751537AbaANUtN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 15:49:13 -0500
From: Gaurav Jain <gjain@fb.com>
To: Don Zickus <dzickus@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Arun Sharma <asharma@fb.com>
Subject: Re: [PATCH] perf tools: Synthesize anon MMAP records on the heap
Thread-Topic: [PATCH] perf tools: Synthesize anon MMAP records on the heap
Thread-Index: AQHPD09bvhY6ouXu+ki8ciwGSba3HpqDZ8uAgAF/04A=
Date: Tue, 14 Jan 2014 20:48:23 +0000
Message-ID: <CEFB09CC.2CAAA%gjain@fb.com>
In-Reply-To: <20140113165441.GB25953@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.16.4]
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <01C0D540835B204AAA5D9851E96CE578@fb.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-01-14_08:2014-01-14,2014-01-14,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=16.2232282933482
 compositescore=0.998981209195878 urlsuspect_oldscore=0.998981209195878
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.998981209195878 spamscore=0
 recipient_to_sender_domain_totalscore=57 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1305240000
 definitions=main-1401140135
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/13/14, 11:54 AM, "Don Zickus" <dzickus@redhat.com> wrote:

>On Sat, Jan 11, 2014 at 08:32:14PM -0800, Gaurav Jain wrote:
>> Anon records usually do not have the 'execname' entry. However if they
>>are on
>> the heap, the execname shows up as '[heap]'. The fix considers any
>>executable
>> entries in the map that do not have a name or are on the heap as anon
>>records
>> and sets the name to '//anon'.
>> 
>> This fixes JIT profiling for records on the heap.
>
>I guess I don't understand the need for this fix.  It seems breaking out
>//anon vs. [heap] would be useful.  Your patch is saying otherwise.  Can
>give a description of the problem you are trying to solve?

Thank you for looking at the patch.

We generate a perf map file which includes certain JIT¹ed functions that
show up as [heap] entries. As a result, I included the executable heap
entries as anon pages so that it would be handled in
util/map.c:map__new(). The alternative would be to handle heap entries in
map__new() directly, however I wasn¹t sure if this would break something
as it seems that heap and stack entries are expected to fail all
map__find_* functions. Thus I considered executable heap entries as
//anon, but perhaps there is a better way.

>Also style issue below..
>
>> 
>> Signed-off-by: Gaurav Jain <gjain@fb.com>
>> Cc: Ingo Molnar <mingo@kernel.org>
>> Cc: Jiri Olsa <jolsa@redhat.com>
>> Cc: Paul Mackerras <paulus@samba.org>
>> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
>> Cc: Don Zickus <dzickus@redhat.com>
>> Cc: Arun Sharma <asharma@fb.com>
>> ---
>>  tools/perf/util/event.c | 5 ++---
>>  1 file changed, 2 insertions(+), 3 deletions(-)
>> 
>> diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
>> index bb788c1..ae9c55b 100644
>> --- a/tools/perf/util/event.c
>> +++ b/tools/perf/util/event.c
>> @@ -224,10 +224,9 @@ static int
>>perf_event__synthesize_mmap_events(struct perf_tool *tool,
>>  				continue;
>>  
>>  			event->header.misc |= PERF_RECORD_MISC_MMAP_DATA;
>> -		}
>> -
>> -		if (!strcmp(execname, ""))
>> +		} if (!strcmp(execname, "") || !strcmp(execname, "[heap]")) {
>
>The '} if' part should seperate the 'if' on to its own line (unless you
>meant an 'else' in there).

Bah yes, I intended 'else if'. I apologize for that. Does the fact that I
filtered anon entries to only those marked as executable break the
existing behavior?

Thanks,

Gaurav

