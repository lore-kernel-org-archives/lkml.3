Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011Ab3I3P6o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 11:58:44 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:19086 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755546Ab3I3P6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 11:58:43 -0400
Message-ID: <52499FA5.60701@hp.com>
Date: Mon, 30 Sep 2013 11:58:29 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
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
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH] rwsem: reduce spinlock contention in wakeup code path
References: <1380308424-31011-1-git-send-email-Waiman.Long@hp.com> <CA+55aFxXeQ69B1bfrO+0QtBqm0gt688LOshx=ppNjch10JF8FQ@mail.gmail.com> <20130928074144.GA17773@gmail.com> <CA+55aFyx-Lpqd8i2tHvhXCqL+nJZPq-6SikEkb-cQZEU9ogRjA@mail.gmail.com> <20130928192123.GA8228@gmail.com> <CA+55aFyZqV_wJTpd9OVw=kM157Q45byW2F3kjhr5ML5Npz84OA@mail.gmail.com>
In-Reply-To: <CA+55aFyZqV_wJTpd9OVw=kM157Q45byW2F3kjhr5ML5Npz84OA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2013 03:33 PM, Linus Torvalds wrote:
> On Sat, Sep 28, 2013 at 12:21 PM, Ingo Molnar<mingo@kernel.org>  wrote:
>> If we do that then I suspect the next step will be queued rwlocks :-/ The
>> current rwlock_t implementation is rather primitive by modern standards.
>> (We'd probably have killed rwlock_t long ago if not for the
>> tasklist_lock.)
> Yeah, I'm not happy about or rwlocks. That's one lock that currently
> is so broken that I think we could easily argue for making that one
> queued.
>
> Waiman had a qrwlock series that looked reasonable, and I think his
> later versions were drop-in replacements (ie they automatically just
> did the RightThing(tm) wrt interrupts taking a recursive read lock - I
> objected to the first versions that required that to be stated
> explicitly).

The latest version (v3) will allow recursive read lock in interrupt 
handlers.

> I think Waiman's patches (even the later ones) made the queued rwlocks
> be a side-by-side implementation with the old rwlocks, and I think
> that was just being unnecessarily careful. It might be useful for
> testing to have a config option to switch between the two, but we
> might as well go all the way.

It is not actually a side-by-side implementation. A user can choose 
either regular rwlock or the queue one, but never both by setting a 
configuration parameter. However, I now think that maybe we should do it 
the lockref way by pre-determining it on a per-architecture level 
without user visible configuration option.

-Longman
