Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751217AbaKESYG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 13:24:06 -0500
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:48984 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbaKESYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 13:24:02 -0500
Message-ID: <545A6B3A.9000903@linux.vnet.ibm.com>
Date: Wed, 05 Nov 2014 23:53:54 +0530
From: Hemant Kumar <hemant@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, oleg@redhat.com, hegdevasant@linux.vnet.ibm.com,
        mingo@redhat.com, anton@redhat.com, systemtap@sourceware.org,
        aravinda@linux.vnet.ibm.com, penberg@iki.fi
Subject: Re: [PATCH v4 5/5] perf/sdt: Add support to perf record to trace
 SDT events
References: <20141102105006.21708.28734.stgit@hemant-fedora> <20141102105557.21708.19032.stgit@hemant-fedora> <87lhnr5sbl.fsf@sejong.aot.lge.com>	<54588905.7040002@linux.vnet.ibm.com> <5458CD15.4010101@hitachi.com> <874muew2hk.fsf@sejong.aot.lge.com>
In-Reply-To: <874muew2hk.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14110518-0009-0000-0000-000002061BCE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 11/05/2014 12:36 PM, Namhyung Kim wrote:
> On Tue, 04 Nov 2014 21:56:53 +0900, Masami Hiramatsu wrote:
>> Hi,
>>
>> (2014/11/04 17:06), Hemant Kumar wrote:
>>> Hi Namhyung,
>>>
>>> On 11/04/2014 01:08 PM, Namhyung Kim wrote:
>>>> Hi Hemant,
>>>>
>>>> As you know, you need to keep an eye on how (kprobes) event cache
>>>> patchset from Masami settles down.  For those who aren't CC'ed, please
>>>> see the link below:
>>>>
>>>>     https://lkml.org/lkml/2014/10/31/207
>>>>
>>>> On Sun, 02 Nov 2014 16:26:28 +0530, Hemant Kumar wrote:
>>>>> This patch adds support to perf to record SDT events. When invoked,
>>>>> the SDT event is looked up in the sdt-cache. If its found, an entry is
>>>>> made silently to uprobe_events file and then recording is invoked, and
>>>>> then the entry for the SDT event in uprobe_events is silently discarded.
>>>>>
>>>>> The SDT events are already stored in a cache file
>>>>> (/var/cache/perf/perf-sdt-file.cache).
>>>>> Although the file_hash table helps in addition or deletion of SDT events
>>>>> from the cache, its not of much use when it comes to probing the actual
>>>>> SDT event, because the key to this hash list is a file name and not the
>>>>> SDT event name (which is given as an argument to perf record). So, we
>>>>> won't be able to hash into it.
>>>> It likely to be ended up with per-file or per-buildid cache files under
>>>> ~/.debug directory.  In this case we also need to have the (central)
>>>> event-to-cache table anyway IMHO.
>> What we are talking is to make a new caching file with buildid under
>> .debug/.
>> We already has ~/.debug/.build-id/<build-id> for string the binary
>> symbol maps.
> ??
>
> The ~/.debug/.build-id/<build-id> (actually first 2 hexdigits are used
> for directory name) is a symlink to a cached binary.
>
>    $ file .debug/.build-id/00/08a6c4028b3826f8905324c770e7aa450e5d3b
>    .debug/.build-id/00/08a6c4028b3826f8905324c770e7aa450e5d3b: symbolic link to `../../usr/lib64/libgtk-3.so.0.400.4/0008a6c4028b3826f8905324c770e7aa450e5d3b'
>
>    $ file .debug/usr/lib64/libgtk-3.so.0.400.4/0008a6c4028b3826f8905324c770e7aa450e5d3b
>    .debug/usr/lib64/libgtk-3.so.0.400.4/0008a6c4028b3826f8905324c770e7aa450e5d3b: ELF 64-bit LSB shared object, x86-64, version 1 (SYSV), dynamically linked, BuildID[sha1]=0xc4a6080026388b02245390f8aae770c73b5d0e45, stripped
>
>
> Hmm.. it seems the file utility prints the build-id as a sequence of 4
> byte little-endian integers.
>
>
>> I think there are 2 options, one is expanding the current
>> build-id file format to include sdt and probe-event caches. The other is
>> to add ~/.debug/.build-id/<build-id>.probe and
>> ~/.debug/.build-id/<build-id>.sdt for caching probe/sdt information.
> I think a single .probe file is enough for this, no?
>
>
>> And also, user interface is a discussion point. This series defines new
>> sdt-cache command, and we already have buildid-cache command. We should
>> have probe-cache command too? or consolidate those cache managing commands?
>> This question should be involving your series too.
>>
>>>>> To avoid this problem, we can create another hash list "event_hash" list
>>>>> which will be maintained along with the file_hash list.
>>>>> Whenever a user invokes 'perf record -e %provider:event, perf should
>>>>> initialize the event_hash list and the file_hash list.
>>>>> The key to event_hash list is calculated from the event name and its
>>>>> provider name.
>>>> Isn't it enough just to use provide name?  I guess the provider names
>>>> are (should be?) unique among a system although there's no absolute
>>>> guarantee for that.
>>>>
>>> Yes, there is no guarantee for the provider names to be unique.
>>> If we use only provider name with "perf record", then, what if a user
>>> wants to trace
>>> only a specific SDT event (not all the events for that provider)?
>>> What do you think?
> What I'm saying is for managing cache not the usage of the cached
> events.  IIUC you keep hash entry for all events to find matching file,
> but I think it can be managed in provider level as events in a single
> provider will live in a single binary.

Oh! I see.
So, the events should be mapped to their respective files based on only 
the provider names. And in case of any ambiguity, it should fail and ask 
for the binary path as Masami suggested below.
Yeah, that's a nice idea. :)

> Btw, I think we should support such multiple events to like
>
>    # perf record -e %provider_xxx:* -e %provider_yyy:prefix_*
>
>
>> How about failing if the provider name is not unique unless user
>> gives the actual binary path?
> It looks like a possible option. :)

Agreed.


-- 
Thanks,
Hemant Kumar

