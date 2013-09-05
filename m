Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760946Ab3IECRS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 22:17:18 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:1664 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609Ab3IECRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 22:17:17 -0400
Message-ID: <5227E9A0.9020802@hp.com>
Date: Wed, 04 Sep 2013 22:17:04 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH] dcache: Translating dentry into pathname without taking
 rename_lock
References: <1378321523-40893-1-git-send-email-Waiman.Long@hp.com> <CA+55aFzbzz4_YNaM+9jAP2Znkjzar42iTM2wFfRX6ySDwBAUeQ@mail.gmail.com>
In-Reply-To: <CA+55aFzbzz4_YNaM+9jAP2Znkjzar42iTM2wFfRX6ySDwBAUeQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2013 05:31 PM, Linus Torvalds wrote:
> On Wed, Sep 4, 2013 at 12:05 PM, Waiman Long<Waiman.Long@hp.com>  wrote:
>> +       rcu_read_unlock();
>> +       if (read_seqretry(&rename_lock, seq))
>> +               goto restart;
> Btw, you have this pattern twice, and while it's not necessarily
> incorrect, it's a bit worrisome for performance.

The rcu_read_unlock sequence in the middle of prepend_path() is not 
likely to executed. So it shouldn't affect performance exception for the 
conditional check.

> The rcu_read_unlock() is very possibly going to trigger an immediate
> scheduling event, so checking the sequence lock after dropping the
> read-lock sounds like it would make it much easier to hit the race
> with some rename.

I can put read_seqbegin/read_seqretry within the 
rcu_read_lock/rcu_read_unlock block. However, read_seqbegin() can spin 
for a while if a rename is in progress. So it depends on which is more 
important, a shorter RCU critical section at the expense of more retries 
or vice versa.

> I'm also a tiny bit worried about livelocking on the sequence lock in
> the presence of lots of renames, so I'm wondering if the locking
> should try to approximate what we do for the RCU lookup path: start
> off optimistically using just the RCU lock and a sequence point, but
> if that fails, fall back to taking the real lock. Maybe using a
> counter ("try twice, then get the rename lock for writing")
>
> Hmm?

Yes, I can implement a counter that switch to taking the rename_lock if 
the count reaches 0. It shouldn't be too hard. That should avoid the 
possibility of a livelock.

Longman
