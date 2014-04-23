Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757421AbaDWPG2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 11:06:28 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:38534 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756011AbaDWPGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 11:06:21 -0400
MIME-Version: 1.0
In-Reply-To: <20140423133000.GQ8488@redhat.com>
References: <20140421160655.GA4201@quad>
	<20140422194031.GM8488@redhat.com>
	<CABPqkBTcOT+BEd1dSrp6bz22o5g+ZvBwx5e4GZvbwft6No+Shw@mail.gmail.com>
	<20140422204522.GN8488@redhat.com>
	<CABPqkBTUV65VD3D7Qcxi4=oTqBVS_WGpbFSqo561Zuex3D9ZwQ@mail.gmail.com>
	<20140423133000.GQ8488@redhat.com>
Date: Wed, 23 Apr 2014 17:06:21 +0200
Message-ID: <CABPqkBSt9N_05Lo-74Dk==_anj5Zh4+5b=26g63ozNvsWUJLVQ@mail.gmail.com>
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

Don,

On Wed, Apr 23, 2014 at 3:30 PM, Don Zickus <dzickus@redhat.com> wrote:
> On Wed, Apr 23, 2014 at 02:52:09PM +0200, Stephane Eranian wrote:
>> On Tue, Apr 22, 2014 at 10:45 PM, Don Zickus <dzickus@redhat.com> wrote:
>> > On Tue, Apr 22, 2014 at 09:50:17PM +0200, Stephane Eranian wrote:
>> >> On Tue, Apr 22, 2014 at 9:40 PM, Don Zickus <dzickus@redhat.com> wrote:
>> >> > On Mon, Apr 21, 2014 at 06:06:55PM +0200, Stephane Eranian wrote:
>> >> >> perf tools: fix processing of pid/tid for mmap records
>> >> >>
>> >> >> Mmaps are global to a process (always). Processing them
>> >> >> per-thread was causing some serious issues in case mmaps
>> >> >> would overlap. The overlap fixups would only occur in the
>> >> >> context of the thread which generated the overlapping
>> >> >> mmap. But that was cause issues later on when a sample
>> >> >> from another thread would fall into that overlapping
>> >> >> mmap.
>> >> >
>> >> > eh?  You are basically reverting my patch for a similar problem. :-)
>> >> >
>> >> > I was running a large multi-threading program (specjbb) and the threads
>> >> > were not being seperated into their own map'd areas.  So either I had to
>> >> > lump all threads in to the same pid space or make the change you are
>> >> > reverting.
>> >> >
>> >> I don't understand your problem. The address space is shared by ALL
>> >> threads of a process. The mmaps are always shared by all threads?
>> >
>> > Sure.
>> >
>> >
>> >>
>> >> > The problem I had with the double pid (as you propose), I would later look
>> >> > up samples based on pid/tid and there would be _no_ map available because
>> >> > it was created as a pid/pid pair.  As a result, our c2c program would drop
>> >> > thousands of samples on the floor (because there was no mapping for the
>> >> > data address to get the major/minor/inode info).
>> >>
>> >> That is your problem. You should only lookup mapping baseds on pid only
>> >> not pid/tid. Why do you need tid?
>> >
>> > Because the function is machine__findnew_thread not
>> > machine__findnew_map.  I want the thread info.  That includes the tid,
>> > comm and any other thread specific info.  :-)
>> >
>> But then, the two call should be separated: one to get the mapping, one to get
>> the thread info. What's wrong with this approach?
>
> I don't agree with the two call approach as it wouldn't be an intutive
> api.
>
> What currently happens is the mmap events are generated to creating
> mappings.  Most mappings are for the pids.  Originally none were for the
> tids.  But as you said earlier, the tid mappings should share the pid
> mappings, so there should be no need to create tid mappings explicitly.
>
> But that implies the the thread struct can find the pid mappings.  Today
> it can not.  Currently, it looks to see if it has an explicit thread
> mapping created by an mmap event (which it most likely will not).
>
> As a result, the thread lookup based on tid finds a NULL mapping and in my
> case the sample is useless because I don't have major/minor/inode info.
>
> However..... with Jiri's changes, when looking up a thread struct with a
> pid/tid combo, _if_ the tid mapping is NULL, Jiri's patch attempts to
> locate the pid mapping and return a pointer to it, which the the thread
> struct saves for future reference.
>
> That is probably the behaviour we both expect.
>
> Jiri's patch takes all mmap events as pid maps and creates an initial map
> for them.  All future threads that don't have mappings will trying to use
> their pid's mapping as a fallback option.
>
> Because it is all pointer based now, updating the pid mappings
> automatically update all the thread mappings too.
>
> I believe this approach will is the right one and makes sense.  Do you
> think that works for you?
>
I just tried Jiri's 5 patches and my JIT patches, and it does work correctly.
My Java samples are correctly symbolized. So looks like we have a solution
that works for both of us though it seems complicated. But I can live with it.
Thanks Jiri.

> Cheers,
> Don
>
>>
>> > The problem was the thread maps were not being shared internally, leading
>> > to your problem and my problem.
>> >
>> > Jiri fixed that.  So now I can request a thread struct based on a pid/tid
>> > and the map groups all point to the same one created by the pid.  As it
>> > should.
>> >
>> >
>> >>
>> >> >
>> >> > Now I modified our c2c program to lookup samples as pid/pid but now the
>> >> > maps lost tid info, and I had to hack around that by carrying the tid info
>> >> > in a private struct.
>> >> >
>> >> If you need the tid, then it is okay to carry it on the side. I believe mmap
>> >> lookups should ONLY use pid. That is how the address space of a process
>> >> is contructed.
>> >
>> > The tid is stored in the thread struct.  So if I have a pointer to the
>> > thread struct, I shouldn't have to carry the tid on the side.  That was
>> > the point. :-)  In fact the thread struct is inside the hist_entry which
>> > is referenced by struct hist.  So now I can easily sort and display tid
>> > without carrying anything on the side.
>> >
>> > But that only works if the pid/tid mappings are setup correctly.  Which I
>> > believe Jiri has done with his recent patchset.
>> >
>> > Cheers,
>> > Don
