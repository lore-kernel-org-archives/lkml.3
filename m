Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751107AbaDRF2d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 01:28:33 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:54860 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbaDRF23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 01:28:29 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <1397773919.2556.22.camel@buesod1.americas.hpqcorp.net>
References: <1397272942.2686.4.camel@buesod1.americas.hpqcorp.net>
 <CAHO5Pa3BOgJGCm7NvE4xbm3O1WbRLRBS0pgvErPudypP_iiZ3g@mail.gmail.com>
 <534FFFC2.6050601@colorfullife.com> <CAKgNAkjCenvWr9A69-=j-55nyW1EM1Fy+=rSDWSxXvq5qFtGTw@mail.gmail.com>
 <1397773919.2556.22.camel@buesod1.americas.hpqcorp.net>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Fri, 18 Apr 2014 07:28:09 +0200
Message-ID: <CAKgNAkh5s+U4hYhpCwMcFpKmxen9ztd8aAPoyGQOWyadTMYfOw@mail.gmail.com>
Subject: Re: [PATCH v2] ipc,shm: disable shmmax and shmall by default
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Manfred Spraul <manfred@colorfullife.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Greg Thelen <gthelen@google.com>, aswin@hp.com,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Davidlohr,

On Fri, Apr 18, 2014 at 12:31 AM, Davidlohr Bueso <davidlohr@hp.com> wrote:
> On Thu, 2014-04-17 at 22:23 +0200, Michael Kerrisk (man-pages) wrote:
>> Hi Manfred!
>>
>> On Thu, Apr 17, 2014 at 6:22 PM, Manfred Spraul
>> <manfred@colorfullife.com> wrote:
>> > Hi Michael,
>> >
>> >
>> > On 04/17/2014 12:53 PM, Michael Kerrisk wrote:
>> >>
>> >> On Sat, Apr 12, 2014 at 5:22 AM, Davidlohr Bueso <davidlohr@hp.com> wrote:

[...]

>> >> Of the two proposed approaches (the other being
>> >> marc.info/?l=linux-kernel&m=139730332306185), this looks preferable to
>> >> me, since it allows strange users to maintain historical behavior
>> >> (i.e., the ability to set a limit) if they really want it, so:
>> >>
>> >> Acked-by: Michael Kerrisk <mtk.manpages@gmail.com>
>> >>
>> >> One or two comments below, that you might consider for your v3 patch.
>> >
>> > I don't understand what you mean.
>>
>> As noted in the other mail, you don't understand, because I was being
>> dense (and misled a little by the commit message).
>>
>> > After a
>> >     # echo 33554432 > /proc/sys/kernel/shmmax
>> >     # echo 2097152 > /proc/sys/kernel/shmmax
>> >
>> > both patches behave exactly identical.
>>
>> Yes.
>>
>> > There are only two differences:
>> > - Davidlohr's patch handles
>> >     # echo <really huge number that doesn't fit into 64-bit> >
>> > /proc/sys/kernel/shmmax
>> >    With my patch, shmmax would end up as 0 and all allocations fail.
>> >
>> > - My patch handles the case if some startup code/installer checks
>> >    shmmax and complains if it is below the requirement of the application.
>>
>> Thanks for that clarification. I withdraw my Ack.
>
> :(
>
>> In fact, maybe I
>> even like your approach a little more, because of that last point.
>
> And it is a fair point. However, this is my counter argument: if users
> are checking shmmax then they sure better be checking shmmin as well! So
> if my patch causes shmctl(,IPC_INFO,) to return shminfo.shmmax = 0 and a
> user only checks this value and breaks the application, then *he's*
> doing it wrong. Checking shmmin is just as important...  0 value is
> *bogus*,

That counter-argument sounds bogus. On all systems that I know/knew
of, SHMIN always defaulted to 1. (Stevens APUE 1e documents this as
the typical default even as far back as 1992.) Furthermore, the limit
was always 1 on Linux, and as far as I know it has always been
immutable. I very much doubt any sysadmin ever changed SHMMIN (why
would they?), even on those systems where it was possible (and both
SHMMIN and SHMMAX seem to have been obsolete on Solaris for some time
now), or that any application ever checked the limit.

Probably the only thing that matters in this discussion is the Linux
behavior (set-up scripts will in any case be tailored to different
OSes): SHMMIN has always been fixed at 1, and so, likely ignored by
apps and install scripts. Thus, it seems difficult to argue that
checking SHMMIN is just as important as checking SHMMAX.

> heck it even says so in shmctl's manpage.

All it says in the man page is that the limit is (always) 1. A 0 value
isn't bogus; it's merely impossible.

>
>>  Did
>> one of you not yet manage to persuade the other to his point of view
>> yet?
>
> I think we've left that up to akpm.

Well, I mean, it's not like Andrew needs the extra work, right? It's a
small thing, but it makes Andrew's life a little easier when you can
give him an agreed solution, rather than asking him to make a
decision.

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
