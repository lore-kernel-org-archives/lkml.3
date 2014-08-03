Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751545AbaHCEBu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 00:01:50 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:33427 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbaHCEBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 00:01:49 -0400
MIME-Version: 1.0
In-Reply-To: <53DDAD9F.6010306@iki.fi>
References: <53DD97B0.8040001@gmail.com> <CAJhHMCCFz5qpxocMbF1POBbFs6zPVaoM_j-52bw5vwpm1MV9aw@mail.gmail.com>
 <53DDAD9F.6010306@iki.fi>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Sun, 3 Aug 2014 00:01:17 -0400
Message-ID: <CAJhHMCC8hDVzeYM1OL1VhTEw=+RrpVK_fQYCbKpnJvBUEP3LyQ@mail.gmail.com>
Subject: Re: [PATCH] dm cache: fix race affecting dirty block count
To: Anssi Hannula <anssi.hannula@iki.fi>
Cc: ejt@redhat.com, snitzer@redhat.com, LKML <linux-kernel@vger.kernel.org>,
        torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 2, 2014 at 11:33 PM, Anssi Hannula <anssi.hannula@iki.fi> wrote:
> 03.08.2014, 05:10, Pranith Kumar kirjoitti:
>> Corrently adding Anssi this time.
>>
>> On Sat, Aug 2, 2014 at 10:00 PM, Pranith Kumar <bobby.prani@gmail.com> wrote:
>>> Hello Anssi, Joe, Mike,
>
> Hi,
>
>>> I just found your patch in the latest rc and wanted to ask a few
>>> questions. I am not sure how this patch helps at all other than luck in
>>> that dm_cblock_t type is of type int32_t, which should guarantee that it
>>> is atomic on most platforms. Which begs the question, what platform did
>>> you encounter this problem?
>
> On x86_64. Regular integer increment/decrement/addition/subtraction are
> not atomic on x86(_64).
>

You are right. Only loads/stores are atomic for an integer. My point
was more about barriers after atomic_inc/dec.

Also dm_cblock_t is uint32_t, but atomic_t changes that to int. You
should correct that to atomic64_t to preserve original semantics.

>>> The patch purports to solve a race condition by making use of atomic_t.
>>> I am not sure that is enough. If indeed there is a race you need to use
>>> smp_mb__{before/after}_atomic() for both your uses of atomic_inc() and
>>> atomic_set().
>
> The issue was only about concurrent increments/decrements getting lost
> completely from time to time, which atomic_inc/dec will prevent without
> any explicit barriers.
>

These increments and decrements will still be lost if you do not use
barriers in presence of concurrent accesses. Please see
Documentation/memory-barriers.txt.

>>> Also I have a concern about why this mail was not CC'ed on LKML. I had
>>> to go to some difficulty in finding this patch. So please CC LKML for
>>> such patches.
>
> I don't usually CC LKML if there is a subsystem-specific mailing list
> unless there is a specific reason to CC LKML as well. I thought this was
> standard practice, but I'm happy to spam LKML as well from now on if
> that is preferred by others as well.
>

I guess it is always a good idea to CC LKML in case of patches in
addition to sub-system mailing lists. For one, it is easy to forward a
message from lkml and then reply to that in case there is something to
discuss.


-- 
Pranith
