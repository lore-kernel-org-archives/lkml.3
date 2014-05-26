Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751935AbaEZUtM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 16:49:12 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:41436 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552AbaEZUtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 16:49:09 -0400
MIME-Version: 1.0
In-Reply-To: <20140526203232.GC5444@laptop.programming.kicks-ass.net>
References: <20140526145605.016140154@infradead.org>
	<CALYGNiMG1NVBUS4TJrYJMr92yWGZHSdGUdCGtBJDHoUMMhE+Wg@mail.gmail.com>
	<20140526203232.GC5444@laptop.programming.kicks-ass.net>
Date: Tue, 27 May 2014 00:49:08 +0400
Message-ID: <CALYGNiO8FNKjtETQMRSqgiArjfQ9nRAALUg9GGdNYbpKru=Sjw@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/5] VM_PINNED
From: Konstantin Khlebnikov <koct9i@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Mel Gorman <mgorman@suse.de>,
        Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Mike Marciniszyn <infinipath@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 12:32 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, May 27, 2014 at 12:19:16AM +0400, Konstantin Khlebnikov wrote:
>> On Mon, May 26, 2014 at 6:56 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> > Hi all,
>> >
>> > I mentioned at LSF/MM that I wanted to revive this, and at the time there were
>> > no disagreements.
>> >
>> > I finally got around to refreshing the patch(es) so here goes.
>> >
>> > These patches introduce VM_PINNED infrastructure, vma tracking of persistent
>> > 'pinned' page ranges. Pinned is anything that has a fixed phys address (as
>> > required for say IO DMA engines) and thus cannot use the weaker VM_LOCKED. One
>> > popular way to pin pages is through get_user_pages() but that not nessecarily
>> > the only way.
>>
>> Lol, this looks like resurrection of VM_RESERVED which I've removed
>> not so long time ago.

That was swap-out prevention from 2.4 era, something between VM_IO and
VM_LOCKED with various side effects.

>
> Not sure what VM_RESERVED did, but there might be a similarity.
>
>> Maybe single-bit state isn't flexible enought?
>
> Not sure what you mean, the one bit is perfectly fine for what I want it
> to do.
>
>> This supposed to supports pinning only by one user and only in its own mm?
>
> Pretty much, that's adequate for all users I'm aware of and mirrors the
> mlock semantics.

Ok, fine. Because get_user_pages is used sometimes for pinning pages
from different mm.

Another suggestion. VM_RESERVED is stronger than VM_LOCKED and extends
its functionality.
Maybe it's easier to add VM_DONTMIGRATE and use it together with VM_LOCKED.
This will make accounting easier. No?

>
>> This might be done as extension of existing memory-policy engine.
>> It allows to keep vm_area_struct slim in normal cases and change
>> behaviour when needed.
>> memory-policy might hold reference-counter of "pinners", track
>> ownership and so on.
>
> That all sounds like raping the mempolicy code and massive over
> engineering.
>
