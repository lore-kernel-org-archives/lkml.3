Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913Ab3I1TXA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 15:23:00 -0400
Received: from mail-ve0-f175.google.com ([209.85.128.175]:47069 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482Ab3I1TW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 15:22:57 -0400
MIME-Version: 1.0
In-Reply-To: <20130928191339.GP18242@two.firstfloor.org>
References: <1380308424-31011-1-git-send-email-Waiman.Long@hp.com>
	<CA+55aFxXeQ69B1bfrO+0QtBqm0gt688LOshx=ppNjch10JF8FQ@mail.gmail.com>
	<20130928074144.GA17773@gmail.com>
	<CA+55aFyx-Lpqd8i2tHvhXCqL+nJZPq-6SikEkb-cQZEU9ogRjA@mail.gmail.com>
	<20130928191339.GP18242@two.firstfloor.org>
Date: Sat, 28 Sep 2013 12:22:56 -0700
X-Google-Sender-Auth: RbjGAVWRUcDWywy4WVCq1cy6H5U
Message-ID: <CA+55aFwCxRWbNr-LyvuVBZrXrnEWvfisKY4TMbk01UDrXZQz0A@mail.gmail.com>
Subject: Re: [PATCH] rwsem: reduce spinlock contention in wakeup code path
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@kernel.org>, Waiman Long <Waiman.Long@hp.com>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Alex Shi <alex.shi@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Michel Lespinasse <walken@google.com>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 28, 2013 at 12:13 PM, Andi Kleen <andi@firstfloor.org> wrote:
>
> And afaik anon_vma is usually hold short.

Yes.

But the problem with anon_vma is that the "usually" may be the 99.9%
case, but then there are some insane loads that do tons of forking
without execve, and they really make some of the rmap code work very
very hard. And then they all not only share that one root vma, but the
mm/rmap.c code ends up having to walk all their VM's because there
could be a page in there somewhere.

These loads aren't necessarily very realistic and very much not
common, but I think AIM7 actually has one of those cases, iirc.

Our anon_vma locking really is some of the more complex parts of the
kernel. Not because of the lock itself, but because of the subtle
rules about the whole anon_vma chain and how we have to lock the root
of the chain etc etc. And under all _normal_ behavior it's not a
problem at all. But I personally dread looking at some of that code,
because if we get anything wrong there (and it's happened), it's too
painful for words.

                  Linus
