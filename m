Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757917Ab3G3ICG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 04:02:06 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:48279 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419Ab3G3ICC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 04:02:02 -0400
MIME-Version: 1.0
In-Reply-To: <20130708081919.GV23916@twins.programming.kicks-ass.net>
References: <1371824448-7306-1-git-send-email-eranian@google.com>
	<20130624084338.GI28407@twins.programming.kicks-ass.net>
	<CABPqkBRqiNVZnioV_R4sfam1QwHwXZgo36Gixxg5ALPbLbiXfw@mail.gmail.com>
	<20130625104700.GZ28407@twins.programming.kicks-ass.net>
	<20130625105123.GA13649@gmail.com>
	<20130626103303.GB28407@twins.programming.kicks-ass.net>
	<CABPqkBTETCE7unsE=zvcC5n865ZN-QTW5Y0j-meTO9x-8=BJog@mail.gmail.com>
	<20130628095828.GG29209@dyad.programming.kicks-ass.net>
	<CABPqkBSfkg+rPw4A=n8wmPg=iwn1Qf8PdYA4ycxxooOv3GrvmA@mail.gmail.com>
	<20130708081919.GV23916@twins.programming.kicks-ass.net>
Date: Tue, 30 Jul 2013 10:02:01 +0200
Message-ID: <CABPqkBSesQsfeutY2qu1n3uMka0dOFOT2tzqCWYGV=2p6F8Y9w@mail.gmail.com>
Subject: Re: [PATCH 0/8] perf: add ability to sample physical data addresses
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 8, 2013 at 10:19 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Sat, Jul 06, 2013 at 12:48:48AM +0200, Stephane Eranian wrote:
>> So, I tried on an example using shmat(). I map the same shared segment twice
>> in the same process. Then I fork(): I see  this in /proc/PID/maps:
>>
>> 7f80fce28000-7f80fce29000 rw-s 00000000 00:04 1376262
>>   /SYSV00000000 (deleted)
>> 7f80fce29000-7f80fce2a000 rw-s 00000000 00:04 1343491
>>   /SYSV00000000 (deleted)
>> 7f80fce2a000-7f80fce2b000 rw-s 00000000 00:04 1343491
>>   /SYSV00000000 (deleted)
>>
>> The segment at 1343491 is the one mapped twice. So that number (shmid)
>> can be used to identify identical mappings. It appears the same way in both
>> processes. The other 1376262 mapping is just to verify that each segment
>> gets a different number.
>
> Right, that's the inode number; I think you also need to add the
> blockdev id (00:04) in this case as inode numbers are per device, not
> global.
>
>> So it looks possible to use this approach across process to identify identical
>> physical mappings. However, this is not very practical.
>>
>> The first reason is that perf_event does not capture shmat() mappings in MMAP
>> records.
>
> oops, that would be something we'd definitely need to fix.
>
> ipc/shm.c:SYSCALL_DEFINE3(shmat)
>   do_shmat()
>     do_mmap_pgoff()
>       mmap_region()
>         perf_event_mmap()
>
> So why isn't it logging them? If its a non-exec map we need
> attr::mmap_data but I suppose you have that enabled?
>
>> The second is is that if you rely on /proc/PID/maps, you will have to
>> have the tool
>> constantly poll that file for new shared mappings. This is not how
>> perf works today,
>> not even in system-wide mode. /proc/PID/maps is swept only once when perf
>> record -a is started.
>
> Ahh. We don't put the useful bits in the mmap event; we'll need to fix
> that too then ;-)
>
> Doing so is going to be a bit of a bother since we use the tail of
> PERF_RECORD_MMAP for filenames and thus aren't particularly extensible.
>
> This would mean doing something like PERF_RECORD_MMAP2 and some means
> for userspace to requrest the new events instead of the old one.
>
Tracking mmaps even for shmat() won't cover the paging cases. When you page a
page back in, it most likely gets a different physical page. How would
we track that
case too using the same approach?
