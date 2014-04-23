Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131AbaDWMwN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 08:52:13 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:62553 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbaDWMwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 08:52:10 -0400
MIME-Version: 1.0
In-Reply-To: <20140422204522.GN8488@redhat.com>
References: <20140421160655.GA4201@quad>
	<20140422194031.GM8488@redhat.com>
	<CABPqkBTcOT+BEd1dSrp6bz22o5g+ZvBwx5e4GZvbwft6No+Shw@mail.gmail.com>
	<20140422204522.GN8488@redhat.com>
Date: Wed, 23 Apr 2014 14:52:09 +0200
Message-ID: <CABPqkBTUV65VD3D7Qcxi4=oTqBVS_WGpbFSqo561Zuex3D9ZwQ@mail.gmail.com>
Subject: Re: [PATCH] perf tools: fix processing of pid/tid for mmap records
From: Stephane Eranian <eranian@google.com>
To: Don Zickus <dzickus@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>, Namhyung Kim <namhyung@kernel.org>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 10:45 PM, Don Zickus <dzickus@redhat.com> wrote:
> On Tue, Apr 22, 2014 at 09:50:17PM +0200, Stephane Eranian wrote:
>> On Tue, Apr 22, 2014 at 9:40 PM, Don Zickus <dzickus@redhat.com> wrote:
>> > On Mon, Apr 21, 2014 at 06:06:55PM +0200, Stephane Eranian wrote:
>> >> perf tools: fix processing of pid/tid for mmap records
>> >>
>> >> Mmaps are global to a process (always). Processing them
>> >> per-thread was causing some serious issues in case mmaps
>> >> would overlap. The overlap fixups would only occur in the
>> >> context of the thread which generated the overlapping
>> >> mmap. But that was cause issues later on when a sample
>> >> from another thread would fall into that overlapping
>> >> mmap.
>> >
>> > eh?  You are basically reverting my patch for a similar problem. :-)
>> >
>> > I was running a large multi-threading program (specjbb) and the threads
>> > were not being seperated into their own map'd areas.  So either I had to
>> > lump all threads in to the same pid space or make the change you are
>> > reverting.
>> >
>> I don't understand your problem. The address space is shared by ALL
>> threads of a process. The mmaps are always shared by all threads?
>
> Sure.
>
>
>>
>> > The problem I had with the double pid (as you propose), I would later look
>> > up samples based on pid/tid and there would be _no_ map available because
>> > it was created as a pid/pid pair.  As a result, our c2c program would drop
>> > thousands of samples on the floor (because there was no mapping for the
>> > data address to get the major/minor/inode info).
>>
>> That is your problem. You should only lookup mapping baseds on pid only
>> not pid/tid. Why do you need tid?
>
> Because the function is machine__findnew_thread not
> machine__findnew_map.  I want the thread info.  That includes the tid,
> comm and any other thread specific info.  :-)
>
But then, the two call should be separated: one to get the mapping, one to get
the thread info. What's wrong with this approach?

> The problem was the thread maps were not being shared internally, leading
> to your problem and my problem.
>
> Jiri fixed that.  So now I can request a thread struct based on a pid/tid
> and the map groups all point to the same one created by the pid.  As it
> should.
>
>
>>
>> >
>> > Now I modified our c2c program to lookup samples as pid/pid but now the
>> > maps lost tid info, and I had to hack around that by carrying the tid info
>> > in a private struct.
>> >
>> If you need the tid, then it is okay to carry it on the side. I believe mmap
>> lookups should ONLY use pid. That is how the address space of a process
>> is contructed.
>
> The tid is stored in the thread struct.  So if I have a pointer to the
> thread struct, I shouldn't have to carry the tid on the side.  That was
> the point. :-)  In fact the thread struct is inside the hist_entry which
> is referenced by struct hist.  So now I can easily sort and display tid
> without carrying anything on the side.
>
> But that only works if the pid/tid mappings are setup correctly.  Which I
> believe Jiri has done with his recent patchset.
>
> Cheers,
> Don
