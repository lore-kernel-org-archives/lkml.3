Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483Ab3BKLDc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 06:03:32 -0500
Received: from mail-vb0-f41.google.com ([209.85.212.41]:40107 "EHLO
	mail-vb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754967Ab3BKLDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 06:03:31 -0500
MIME-Version: 1.0
In-Reply-To: <20130211102730.GA5318@quack.suse.cz>
References: <1359668994-13433-1-git-send-email-jack@suse.cz>
	<1359668994-13433-2-git-send-email-jack@suse.cz>
	<CANN689ExHJjXvAdYM=eYP_hZFT78SHZb1AbJv6743Q=KjohBVQ@mail.gmail.com>
	<20130211102730.GA5318@quack.suse.cz>
Date: Mon, 11 Feb 2013 03:03:30 -0800
Message-ID: <CANN689G8f2QuROecapFcbcNUggGWv9bTuHSV+k4KBLj=_E7uFg@mail.gmail.com>
Subject: Re: [PATCH 1/6] lib: Implement range locks
From: Michel Lespinasse <walken@google.com>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2013 at 2:27 AM, Jan Kara <jack@suse.cz> wrote:
> On Sun 10-02-13 21:42:32, Michel Lespinasse wrote:
>> On Thu, Jan 31, 2013 at 1:49 PM, Jan Kara <jack@suse.cz> wrote:
>> > +void range_lock_init(struct range_lock *lock, unsigned long start,
>> > +                    unsigned long end);
>> > +void range_lock(struct range_lock_tree *tree, struct range_lock *lock);
>> > +void range_unlock(struct range_lock_tree *tree, struct range_lock *lock);
>>
>> Is there a point to separating the init and lock stages ? maybe the API could be
>> void range_lock(struct range_lock_tree *tree, struct range_lock *lock,
>> unsigned long start, unsigned long last);
>> void range_unlock(struct range_lock_tree *tree, struct range_lock *lock);
>   I was thinking about this as well. Currently I don't have a place which
> would make it beneficial to separate _init and _lock but I can imagine such
> uses (where you don't want to pass the interval information down the stack
> and it's easier to pass the whole lock structure). Also it looks a bit
> confusing to pass (tree, lock, start, last) to the locking functon. So I
> left it there.
>
> OTOH I had to somewhat change the API so that the locking phase is now
> separated in "lock_prep" phase which inserts the node into the tree and
> counts blocking ranges and "wait" phase which waits for the blocking ranges
> to unlock. The reason for this split is that while "lock_prep" needs to
> happen under some lock synchronizing operations on the tree, "wait" phase
> can be easily lockless. So this allows me to remove the knowledge of how
> operations on the tree are synchronized from range locking code itself.
> That further allowed me to use mapping->tree_lock for synchronization and
> basically reduce the cost of mapping range locking close to 0 for buffered
> IO (just a single tree lookup in the tree in the fast path).

Ah yes, being able to externalize the lock is good.

I think in this case, it makes the most sense for lock_prep phase to
also initialize the lock node, though.

>> Reviewed-by: Michel Lespinasse <walken@google.com>
>   I actually didn't add this because there are some differences in the
> current version...

Did I miss another posting of yours, or is that coming up ?

Cheers,

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
