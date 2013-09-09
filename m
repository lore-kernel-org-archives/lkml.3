Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843Ab3IIRzU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 13:55:20 -0400
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:40314 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322Ab3IIRzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 13:55:18 -0400
Message-ID: <522E0B7A.2080401@hp.com>
Date: Mon, 09 Sep 2013 13:55:06 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        George Spelvin <linux@horizon.com>, John Stoffel <john@stoffel.org>
Subject: Re: [PATCH v4 1/1] dcache: Translating dentry into pathname without
 taking rename_lock
References: <1378743493-33546-1-git-send-email-Waiman.Long@hp.com> <1378743493-33546-2-git-send-email-Waiman.Long@hp.com> <20130909172905.GN13318@ZenIV.linux.org.uk>
In-Reply-To: <20130909172905.GN13318@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2013 01:29 PM, Al Viro wrote:
> On Mon, Sep 09, 2013 at 12:18:13PM -0400, Waiman Long wrote:
>> +/**
>> + * read_seqbegin_or_lock - begin a sequence number check or locking block
>> + * lock: sequence lock
>> + * seq : sequence number to be checked
>> + *
>> + * First try it once optimistically without taking the lock. If that fails,
>> + * take the lock. The sequence number is also used as a marker for deciding
>> + * whether to be a reader (even) or writer (odd).
>> + * N.B. seq must be initialized to an even number to begin with.
>> + */
>> +static inline void read_seqbegin_or_lock(seqlock_t *lock, int *seq)
>> +{
>> +	if (!(*seq&  1)) {	/* Even */
>> +		*seq = read_seqbegin(lock);
>> +		rcu_read_lock();
>> +	} else			/* Odd */
>> +		write_seqlock(lock);
>> +}
>> +static inline int read_seqretry_or_unlock(seqlock_t *lock, int *seq)
>> +{
>> +	if (!(*seq&  1)) {	/* Even */
>> +		rcu_read_unlock();
>> +		if (read_seqretry(lock, *seq)) {
>> +			(*seq)++;	/* Take writer lock */
>> +			return 1;
>> +		}
>> +	} else			/* Odd */
>> +		write_sequnlock(lock);
>> +	return 0;
>> +}
> I'm not sure I like mixing rcu_read_lock() into that - d_path() and friends
> can do that themselves just fine (it needs to be taken when seq is even),
> and e.g. d_walk() doesn't need it at all.  Other than that, I'm OK with
> this variant.

I think rcu_read_lock() is needed to make sure that the dentry won't be 
freed as we don't take d_lock now.

-Longman
