Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964977Ab3DJPq2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 11:46:28 -0400
Received: from mail-ve0-f178.google.com ([209.85.128.178]:54433 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933709Ab3DJPqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 11:46:25 -0400
MIME-Version: 1.0
In-Reply-To: <20130410140925.GD3672@sgi.com>
References: <1365087258-7169-1-git-send-email-Waiman.Long@hp.com>
	<1365087258-7169-2-git-send-email-Waiman.Long@hp.com>
	<20130408124223.GA10093@gmail.com>
	<CA+55aFztAtpiGK9e_Ed=Kk4jAWNTahv9OEb0+fgp52Api1s7Mw@mail.gmail.com>
	<20130410140925.GD3672@sgi.com>
Date: Wed, 10 Apr 2013 08:46:24 -0700
X-Google-Sender-Auth: rFR3hQdHsKwTwcituqsfgW3boqw
Message-ID: <CA+55aFwrC-yKfpnJxA7RUoooR94-KJsuXHt03Mez0FiP9VBc4g@mail.gmail.com>
Subject: Re: [PATCH RFC 1/3] mutex: Make more scalable by doing less atomic operations
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Robin Holt <holt@sgi.com>
Cc: Ingo Molnar <mingo@kernel.org>, Waiman Long <Waiman.Long@hp.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 7:09 AM, Robin Holt <holt@sgi.com> wrote:
> On Mon, Apr 08, 2013 at 07:38:39AM -0700, Linus Torvalds wrote:
>>
>> I forget where we saw the case where we should *not* read the initial
>> value, though. Anybody remember?
>
> I think you might be remembering ia64.  Fairly early on, I recall there
> being a change in the spinlocks where we did not check them before just
> trying to acquire.

No, I think I found the one I was thinking of. It was the x86-32
version of atomic64_xchg() and atomic64_add_return(). We used to
actually read the old value in order to make the cmpxchg succeed on
the first try most of the time, but when it was cold in the cache that
actually hurt us. We were better off just picking a random value as
our first one, even if it resulted in the loop triggering, because for
the cold-cache case that avoids the unnecessary "bring in in shared
for the read, just to write to it later".

Commits 3a8d1788b37435baf6c296f4ea8beb4fa4955f44 and in particular
824975ef190e7dcb77718d1cc2cb53769b16d918.

Of course, a good OoO CPU would see the write happening later to the
same address, and bring things in for exclusive access immediately.
And it's possible that newer CPU's do that, but we did see this as
being an issue.

            Linus
