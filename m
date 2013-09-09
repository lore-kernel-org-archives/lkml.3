Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779Ab3IIObw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 10:31:52 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:14654 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237Ab3IIObt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 10:31:49 -0400
Message-ID: <522DDBC8.8020201@hp.com>
Date: Mon, 09 Sep 2013 10:31:36 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        George Spelvin <linux@horizon.com>, John Stoffel <john@stoffel.org>
Subject: Re: [PATCH v3 1/1] dcache: Translating dentry into pathname without
 taking rename_lock
References: <1378483738-10129-1-git-send-email-Waiman.Long@hp.com> <1378483738-10129-2-git-send-email-Waiman.Long@hp.com> <CA+55aFw8UuEmKsSdGZPUmcekZheNimEt4U81i7Bz0LipGzsFmg@mail.gmail.com> <20130906210546.GW13318@ZenIV.linux.org.uk> <CA+55aFzf-reQNSQt_fhHfUe_tB19n2qEa=Rd=wFEBJEVALmezA@mail.gmail.com> <20130907000044.GX13318@ZenIV.linux.org.uk> <CA+55aFwy_x65HaLOgKuK7AyQayraU4M6q78L_hnAvLg1NSgTpw@mail.gmail.com> <CA+55aFzwederWB135Ch+PjijjrN-kz9UKw+obC4+M_+xq648PA@mail.gmail.com> <20130907030110.GY13318@ZenIV.linux.org.uk> <CA+55aFyJ8CvfYzh8LFRY_6tx+GgzVfps1hSwJeSUz=G=FrsgkQ@mail.gmail.com> <20130907180724.GE13318@ZenIV.linux.org.uk>
In-Reply-To: <20130907180724.GE13318@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/2013 02:07 PM, Al Viro wrote:
> On Sat, Sep 07, 2013 at 10:52:02AM -0700, Linus Torvalds wrote:
>
>> So I think we could make a more complicated data structure that looks
>> something like this:
>>
>>     struct seqlock_retry {
>>        unsigned int seq_no;
>>        int state;
>>     };
>>
>> and pass that around. Gcc should do pretty well, especially if we
>> inline things (but even if not, small structures that fit in 64 bytes
>> generate reasonable code even on 32-bit targets, because gcc knows
>> about using two registers for passing data around)..
>>
>> Then you can make "state" have a retry counter in it, and have a
>> negative value mean "I hold the lock for writing". Add a couple of
>> helper functions, and you can fairly easily handle the mixed "try for
>> reading first, then fall back to writing".
>>
>> That said, __d_lookup() still shows up as very performance-critical on
>> some loads (symlinks in particular cause us to fall out of the RCU
>> cases) so I'd like to keep that using the simple pure read case. I
>> don't believe you can livelock it, as mentioned. But the other ones
>> might well be worth moving to a "fall back to write-locking after<n>
>> tries" model. They might all traverse user-specified paths of fairly
>> arbitrary depth, no?
>>
>> So this "seqlock_retry" thing wouldn't _replace_ bare seqlocks, it
>> would just be a helper thing for this kind of behavior where we want
>> to normally do things with just the read-lock, but want to guarantee
>> that we don't live-lock.
>>
>> Sounds reasonable?
> More or less; I just wonder if we are overdesigning here - if we don't
> do "repeat more than once", we can simply use the lower bit of seq -
> read_seqlock() always returns an even value.  So we could do something
> like seqretry_and_lock(lock,&seq):
> 	if ((*seq&  1) || !read_seqretry(lock, *seq))
> 		return true;
> 	*seq |= 1;
> 	write_seqlock(lock);
> 	return false;
> and seqretry_done(lock, seq):
> 	if (seq&  1)
> 		write_sequnlock(lock);
> with these loops turning into
> 	seq = read_seqlock(&rename_lock);
> 	...
> 	if (!seqretry_and_lock(&rename_lock,&seq))
> 		goto again;
> 	...
> 	seqretry_done(&rename_lock);

I am fine with try it once and then lock instead of trying it a few 
times. Now are you planning to have these helper functions for the 
dcache layer only or as part of the seqlock infrastructure? If we are 
going to touch the seqlock layer, I would suggest adding a blocking 
reader that takes the lock, but won't update the sequence number so that 
it won't block other sequence readers as my original seqlock patch was 
doing.

-Longman
