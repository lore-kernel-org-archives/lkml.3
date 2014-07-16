Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760050AbaGPHS5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 03:18:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37752 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751091AbaGPHSu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 03:18:50 -0400
Message-ID: <53C62757.9080501@suse.cz>
Date: Wed, 16 Jul 2014 09:18:47 +0200
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michel Lespinasse <walken@google.com>,
        Lukas Czerner <lczerner@redhat.com>, Dave Jones <davej@redhat.com>,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] shmem: fix faulting into a hole, not taking i_mutex
References: <alpine.LSU.2.11.1407150247540.2584@eggly.anvils> <alpine.LSU.2.11.1407150329250.2584@eggly.anvils> <53C551A8.2040400@suse.cz> <alpine.LSU.2.11.1407151156110.3571@eggly.anvils>
In-Reply-To: <alpine.LSU.2.11.1407151156110.3571@eggly.anvils>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2014 09:26 PM, Hugh Dickins wrote:
>> 
>> > @@ -760,7 +760,7 @@ static int shmem_writepage(struct page *
>> >   			spin_lock(&inode->i_lock);
>> >   			shmem_falloc = inode->i_private;
>> 
>> Without ACCESS_ONCE, can shmem_falloc potentially become an alias on
>> inode->i_private and later become re-read outside of the lock?
> 
> No, it could be re-read inside the locked section (which is okay since
> the locking ensures the same value would be re-read each time), but it
> cannot be re-read after the unlock.  The unlock guarantees that (whereas
> an assignment after the unlock might be moved up before the unlock).
> 
> I searched for a simple example (preferably not in code written by me!)
> to convince you.  I thought it would be easy to find an example of
> 
> 	spin_lock(&lock);
> 	thing_to_free = whatever;
> 	spin_unlock(&lock);
> 	if (thing_to_free)
> 		free(thing_to_free);
> 
> but everything I hit upon was actually a little more complicated than
> than that (e.g. involving whatever(), or setting whatever = NULL after),
> and therefore less convincing.  Please hunt around to convince yourself.

Yeah, I thought myself on the way home that this is probably the case. I guess
some recent bugs made me too paranoid. Sorry for the noise and time you spent
explaining this :/

>> 
>> > -		if (!shmem_falloc ||
>> > -		    shmem_falloc->mode != FALLOC_FL_PUNCH_HOLE ||
>> > -		    vmf->pgoff < shmem_falloc->start ||
>> > -		    vmf->pgoff >= shmem_falloc->next)
>> > -			shmem_falloc = NULL;
>> > -		spin_unlock(&inode->i_lock);
>> > -		/*
>> > -		 * i_lock has protected us from taking shmem_falloc seriously
>> > -		 * once return from shmem_fallocate() went back up that
>> > stack.
>> > -		 * i_lock does not serialize with i_mutex at all, but it does
>> > -		 * not matter if sometimes we wait unnecessarily, or
>> > sometimes
>> > -		 * miss out on waiting: we just need to make those cases
>> > rare.
>> > -		 */
>> > -		if (shmem_falloc) {
>> > +		if (shmem_falloc &&
>> > +		    shmem_falloc->waitq &&
>> 
>> Here it's operating outside of lock.
> 
> No, it's inside the lock: just easier to see from the patched source
> than from the patch itself.

Ah, right :/

> Hugh
> 

