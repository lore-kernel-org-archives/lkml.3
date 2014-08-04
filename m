Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843AbaHDPCj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 11:02:39 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:52504 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860AbaHDPCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 11:02:37 -0400
MIME-Version: 1.0
In-Reply-To: <20140804104826.GA494@debian>
References: <53DD97B0.8040001@gmail.com> <CAJhHMCCFz5qpxocMbF1POBbFs6zPVaoM_j-52bw5vwpm1MV9aw@mail.gmail.com>
 <53DDAD9F.6010306@iki.fi> <CAJhHMCC8hDVzeYM1OL1VhTEw=+RrpVK_fQYCbKpnJvBUEP3LyQ@mail.gmail.com>
 <20140804104826.GA494@debian>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Mon, 4 Aug 2014 11:02:05 -0400
Message-ID: <CAJhHMCAskizhfCN5SLk7cd5QY3FNoz6fN+YTWOMWH4ezTw0Lww@mail.gmail.com>
Subject: Re: [PATCH] dm cache: fix race affecting dirty block count
To: Pranith Kumar <bobby.prani@gmail.com>,
        Anssi Hannula <anssi.hannula@iki.fi>, ejt@redhat.com,
        snitzer@redhat.com, LKML <linux-kernel@vger.kernel.org>,
        torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 4, 2014 at 6:48 AM, Joe Thornber <thornber@redhat.com> wrote:
> On Sun, Aug 03, 2014 at 12:01:17AM -0400, Pranith Kumar wrote:
>> Also dm_cblock_t is uint32_t, but atomic_t changes that to int. You
>> should correct that to atomic64_t to preserve original semantics.
>
> atomic_t used to have only 24 bits of range due to the Sparc
> implementation holding a lock in one of the bytes.  I understand this
> limitation was removed during 2.6 and the full 32 bits are now
> available.
>

I meant to point out that atomic_t is a signed integer (int) type
using the full 32 bits with signed operations. dm_cblock_t is unsgined
int.

>
>> These increments and decrements will still be lost if you do not use
>> barriers in presence of concurrent accesses. Please see
>> Documentation/memory-barriers.txt.
>
> You do not need to use barriers for plain atomic_inc/dec().
>
>     https://github.com/jthornber/linux-2.6/blob/thin-dev/Documentation/atomic_ops.txt#L187

That talks about implementation of atomic_inc/dec() for arch porters.
Users of atomic_inc/dec() should use memory barriers.

>
> You _do_ need to use a memory barrier for the ops that return a value
> (such as atomic_dec_and_test()), But only if there's some other state
> that needs synchronising.  See the nice example in atomic_ops.txt:
>
>     https://github.com/jthornber/linux-2.6/blob/thin-dev/Documentation/atomic_ops.txt#L321

Again when it says it needs explicit memory barriers, it is for the
arch porters. So atomic_dec_and_test(), atomic_dec_return() etc., have
implicit memory barriers.

>
> We just trigger a stateless event when the counter hits zero, so the
> patch is fine.
>

Your use of atomic_dec_return() is what is fixing the race issue here
I guess , as it has implicit memory barriers. But I suggest checking
out if you need barriers for atomic_inc() and atomic_set() too.

-- 
Pranith
