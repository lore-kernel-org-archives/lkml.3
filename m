Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171Ab3GEWsw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 18:48:52 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:50699 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019Ab3GEWsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 18:48:50 -0400
MIME-Version: 1.0
In-Reply-To: <20130628095828.GG29209@dyad.programming.kicks-ass.net>
References: <1371824448-7306-1-git-send-email-eranian@google.com>
	<20130624084338.GI28407@twins.programming.kicks-ass.net>
	<CABPqkBRqiNVZnioV_R4sfam1QwHwXZgo36Gixxg5ALPbLbiXfw@mail.gmail.com>
	<20130625104700.GZ28407@twins.programming.kicks-ass.net>
	<20130625105123.GA13649@gmail.com>
	<20130626103303.GB28407@twins.programming.kicks-ass.net>
	<CABPqkBTETCE7unsE=zvcC5n865ZN-QTW5Y0j-meTO9x-8=BJog@mail.gmail.com>
	<20130628095828.GG29209@dyad.programming.kicks-ass.net>
Date: Sat, 6 Jul 2013 00:48:48 +0200
Message-ID: <CABPqkBSfkg+rPw4A=n8wmPg=iwn1Qf8PdYA4ycxxooOv3GrvmA@mail.gmail.com>
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

Peter,

On Fri, Jun 28, 2013 at 11:58 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, Jun 26, 2013 at 09:10:50PM +0200, Stephane Eranian wrote:
>> After more investigation with the author of the false sharing
>> detection tool, I think
>> that if the mapping changes, it is okay. The tool can detect this and
>> drop the analysis
>> at that address. So as long as we can flag the mapping change, we are
>> okay. Hopefully,
>> it does not occur frequently. If so, then I think there are bigger
>> issues to fix on the system
>> than false sharing.
>
> But if you index everything using dev:inode:offset it doesn't matter if the
> mapping changes; you're invariant to map placement.
>
> And the thing is; we already compute most of that anyway in order to find the
> code in DSOs, except there we use filename instead of dev:inode. However if
> there were means to open files using dev:inode that might actually be more
> reliable than using the filename.

So, I tried on an example using shmat(). I map the same shared segment twice
in the same process. Then I fork(): I see  this in /proc/PID/maps:

7f80fce28000-7f80fce29000 rw-s 00000000 00:04 1376262
  /SYSV00000000 (deleted)
7f80fce29000-7f80fce2a000 rw-s 00000000 00:04 1343491
  /SYSV00000000 (deleted)
7f80fce2a000-7f80fce2b000 rw-s 00000000 00:04 1343491
  /SYSV00000000 (deleted)

The segment at 1343491 is the one mapped twice. So that number (shmid)
can be used to identify identical mappings. It appears the same way in both
processes. The other 1376262 mapping is just to verify that each segment
gets a different number.

So it looks possible to use this approach across process to identify identical
physical mappings. However, this is not very practical.

The first reason is that perf_event does not capture shmat() mappings in MMAP
records.

The second is is that if you rely on /proc/PID/maps, you will have to
have the tool
constantly poll that file for new shared mappings. This is not how
perf works today,
not even in system-wide mode. /proc/PID/maps is swept only once when perf
record -a is started.

Ingo is proposing a ioctl() to flush the mappings. But then, when is a
good time to do this
from the tool?

So my approach with PERF_SAMPLE_PHYS_ADDR looks easier on the tools which
if I recall is the philosophy behind perf_events.

Any more comments?
