Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751543AbaKDIGp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 03:06:45 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:45306 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbaKDIGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 03:06:40 -0500
Message-ID: <54588905.7040002@linux.vnet.ibm.com>
Date: Tue, 04 Nov 2014 13:36:29 +0530
From: Hemant Kumar <hemant@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, oleg@redhat.com, hegdevasant@linux.vnet.ibm.com,
        mingo@redhat.com, anton@redhat.com, systemtap@sourceware.org,
        masami.hiramatsu.pt@hitachi.com, aravinda@linux.vnet.ibm.com,
        penberg@iki.fi
Subject: Re: [PATCH v4 5/5] perf/sdt: Add support to perf record to trace
 SDT events
References: <20141102105006.21708.28734.stgit@hemant-fedora> <20141102105557.21708.19032.stgit@hemant-fedora> <87lhnr5sbl.fsf@sejong.aot.lge.com>
In-Reply-To: <87lhnr5sbl.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14110408-0021-0000-0000-00000205C02D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Namhyung,

On 11/04/2014 01:08 PM, Namhyung Kim wrote:
> Hi Hemant,
>
> As you know, you need to keep an eye on how (kprobes) event cache
> patchset from Masami settles down.  For those who aren't CC'ed, please
> see the link below:
>
>    https://lkml.org/lkml/2014/10/31/207
>
> On Sun, 02 Nov 2014 16:26:28 +0530, Hemant Kumar wrote:
>> This patch adds support to perf to record SDT events. When invoked,
>> the SDT event is looked up in the sdt-cache. If its found, an entry is
>> made silently to uprobe_events file and then recording is invoked, and
>> then the entry for the SDT event in uprobe_events is silently discarded.
>>
>> The SDT events are already stored in a cache file
>> (/var/cache/perf/perf-sdt-file.cache).
>> Although the file_hash table helps in addition or deletion of SDT events
>> from the cache, its not of much use when it comes to probing the actual
>> SDT event, because the key to this hash list is a file name and not the
>> SDT event name (which is given as an argument to perf record). So, we
>> won't be able to hash into it.
> It likely to be ended up with per-file or per-buildid cache files under
> ~/.debug directory.  In this case we also need to have the (central)
> event-to-cache table anyway IMHO.
>
>
>> To avoid this problem, we can create another hash list "event_hash" list
>> which will be maintained along with the file_hash list.
>> Whenever a user invokes 'perf record -e %provider:event, perf should
>> initialize the event_hash list and the file_hash list.
>> The key to event_hash list is calculated from the event name and its
>> provider name.
> Isn't it enough just to use provide name?  I guess the provider names
> are (should be?) unique among a system although there's no absolute
> guarantee for that.
>

Yes, there is no guarantee for the provider names to be unique.
If we use only provider name with "perf record", then, what if a user 
wants to trace
only a specific SDT event (not all the events for that provider)?
What do you think?

>>              event_hash       sdt_note
>>              |---------|   ----------------
>>              |         |   |   file_ptr   |==> container file_sdt_ent
>> key = 129 =>| hlist ==|===|=> event_list=|==> to sdt notes hashed to
>>         	    |         |   |   name       |    same entry
>>              |---------|   |   provider   |
>>              |	      |   |   note_list==|==> to other notes in the
>> key = 130 =>| hlist   |   ---------------     same file
>>              |---------|
>>
>> The entry at that key in event_hash contains a list of SDT notes hashed to
>> the same entry. It compares the name and provider to see if that is the SDT
>> note we are looking for. If yes, find out the file that contains this SDT
>> note. There is a file_ptr pointer embedded in this note which points to the
>> struct file_sdt_ent contained in the file_hash. From "file_sdt_ent" we will
>> find out the file name.
>> Convert this sdt note into a perf event and then write this into
>> uprobe_events file to be able to record the event.
>> Then, corresponding entries are added to uprobe_events file for
>> the SDT events.
>> After recording is done, these events are silently deleted from uprobe_events
>> file. The uprobe_events file is present in debugfs/tracing directory.
>>
>> To support the addition and deletion of SDT events to/from uprobe_events
>> file, a record_sdt struct is maintained which has the event data.
>>
>> An example usage:
>>
>> # perf record -e %libc:setjmp -aR sleep 10
>> [ perf record: Woken up 1 times to write data ]
>> [ perf record: Captured and wrote 0.277 MB perf.data (~12103 samples) ]
>>
>> # perf report --stdio
>> # To display the perf.data header info, please use --header/--header-only
>> #
>> # Samples: 1  of event 'libc:setjmp'
>> # Event count (approx.): 1
>> #
>> # Overhead  Command  Shared Object  Symbol
>> # ........  .......  .............  ...............
>> #
>>     100.00%  sleep    libc-2.16.so   [.] __sigsetjmp
>>
>>
>> Signed-off-by: Hemant Kumar <hemant@linux.vnet.ibm.com>
>
> [SNIP]
>> +/* Session specific to SDT tracing */
>> +struct record_sdt {
>> +	bool    sdt;    /* is this SDT event tracing? */
>> +	char    *str;   /* hold the event name */
>> +} rec_sdt;
>> +
>> +int trace_sdt_event(const char *str)
>> +{
>> +	int ret = 0;
>> +
>> +	rec_sdt.sdt = true;
>> +	rec_sdt.str = strdup(str);
>> +	if (!rec_sdt.str)
>> +		return -ENOMEM;
>> +	ret = event_hash_list__lookup(str);
>> +	return ret;
>> +}
> Hmm.. does it support multiple SDT events recorded in a session like:
>
>    # perf record -e %libc:setjmp -e %libc:longjmp -aR sleep 10
>
> ?

Yes, it supports multiple SDT events recorded in a session :

# ./perf record -e %libc:lll_lock_wait_private -e %libc:setjmp -aR sleep 10
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.264 MB perf.data (~11526 samples) ]

> [SNIP]
>> +/* Parse an SDT event */
>> +static int parse_perf_sdt_event(struct perf_sdt_event *sev,
>> +				struct perf_probe_event *pev)
>> +{
>> +	struct perf_probe_point *pp = &pev->point;
>> +
>> +	pev->uprobes = true;
>> +	pev->sdt = true;
>> +	pev->event = strdup(sev->note->name);
>> +	if (pev->event == NULL)
>> +		return -ENOMEM;
>> +	pev->group = strdup(sev->note->provider);
>> +	if (pev->event == NULL)
> s/event/group/

Will fix that.

>> +		return -ENOMEM;
>> +
>> +	pp->file = strdup(sev->file_name);
>> +	if (pp->file == NULL)
>> +		return -ENOMEM;
>> +
>> +	pp->function = strdup(sev->note->name);
> Missing NULL check.  Also you need to free prior allocations in case of
> error.

Yes, will do that.

> Thanks,
> Namhyung
>
>
>> +	pp->offset = sev->note->addr.a64[0];
>> +	return 0;
>> +}

-- 
Thanks,
Hemant Kumar

