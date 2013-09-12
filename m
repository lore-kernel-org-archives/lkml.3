Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448Ab3ILTCK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 15:02:10 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:10048 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754867Ab3ILTCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 15:02:09 -0400
Message-ID: <52320FA3.7000908@hp.com>
Date: Thu, 12 Sep 2013 15:01:55 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Alexander Viro <viro@zeniv.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH 0/2 v2] dcache: get/release read lock in read_seqbegin_or_lock()
 & friend
References: <1378997735-22844-1-git-send-email-Waiman.Long@hp.com> <CA+55aFwsqHJE1D-z8_kU+1VEpUTB=EU57kqmKao580gYZVOjrw@mail.gmail.com> <CA+55aFy8Nq7yf9CJwFuyfSmkUzFKRHHOE6O8=4HjmaWpku3fhw@mail.gmail.com>
In-Reply-To: <CA+55aFy8Nq7yf9CJwFuyfSmkUzFKRHHOE6O8=4HjmaWpku3fhw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2013 01:30 PM, Linus Torvalds wrote:
> On Thu, Sep 12, 2013 at 9:38 AM, Linus Torvalds
> <torvalds@linux-foundation.org>  wrote:
>> On Thu, Sep 12, 2013 at 7:55 AM, Waiman Long<Waiman.Long@hp.com>  wrote:
>>> Change log
>>> ----------
>>> v1->v2:
>>>    - Rename the new seqlock primitives to read_seqexcl_lock* and
>>>      read_seqexcl_unlock*.
>> Applied.
> Btw, when I tried to benchmark this, I failed miserably.
>
> Why?

This patch is just a safety guard to prevent occasional bad performance 
because of some bad timing. It will not improve performance for many 
cases because the seqbegin/seqretry sequence succeeds without actual retry.

> If you do a threaded benchmark of "getcwd()", you end up spending all
> your time in a spinlock anyway: get_fs_root_and_pwd() takes the
> fs->lock to get the root/pwd.

I am aware that there is another spinlock bottleneck in the fs struct 
for getcwd().

> Now, AIM7 probably uses processes, not threads, so you don't see this,
> and maybe I shouldn't care. But looking at it, it annoys me
> enormously, because the whole get_fs_root_and_pwd() is just stupid.

AIM7 don't do much getcwd() calls, so it is not a real bottleneck for 
the benchmark. The lockref patch boosts the short workload performance. 
The  prepend_path patch was to fix the incorrect perf record data as 
perf makes heavy use of d_path(). The change made to getcwd() was just a 
side benefit. But then it still have other spinlock bottleneck.

> Putting it all under the RCU lock and then changing it to use
> get_fs_root_and_pwd_rcu() that just uses the fs->seq sequence
> read-lock looks absolutely trivial.

Yes, I think we can do something similar for this. I will take a look to 
see how it can be fixed.

-Longman
