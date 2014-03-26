Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726AbaCZXL1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 19:11:27 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:45683 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756545AbaCZXLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 19:11:24 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1403261532360.2190@nftneq.ynat.uz>
References: <20140326191113.GF9066@alap3.anarazel.de> <CALCETrUc1YvNc3EKb4ex579rCqBfF=84_h5bvbq49o62k2KpmA@mail.gmail.com>
 <20140326215518.GH9066@alap3.anarazel.de> <CALCETrVEjpFpKhY6=CEG-9Prm=uBDLS936imb=+hyWN4fXPjtg@mail.gmail.com>
 <alpine.DEB.2.02.1403261532360.2190@nftneq.ynat.uz>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 26 Mar 2014 16:11:02 -0700
Message-ID: <CALCETrVoiFV29P9OfsdQgN7eon6JepCnkPGTCzaAotgUa2NexA@mail.gmail.com>
Subject: Re: [Lsf] Postgresql performance problems with IO latency, especially
 during fsync()
To: David Lang <david@lang.hm>
Cc: Andres Freund <andres@2ndquadrant.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        lsf@lists.linux-foundation.org, Wu Fengguang <fengguang.wu@intel.com>,
        rhaas@anarazel.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2014 at 3:35 PM, David Lang <david@lang.hm> wrote:
> On Wed, 26 Mar 2014, Andy Lutomirski wrote:
>
>>>> I'm not sure I understand the request queue stuff, but here's an idea.
>>>>  The block core contains this little bit of code:
>>>
>>>
>>> I haven't read enough of the code yet, to comment intelligently ;)
>>
>>
>> My little patch doesn't seem to help.  I'm either changing the wrong
>> piece of code entirely or I'm penalizing readers and writers too much.
>>
>> Hopefully some real block layer people can comment as to whether a
>> refinement of this idea could work.  The behavior I want is for
>> writeback to be limited to using a smallish fraction of the total
>> request queue size -- I think that writeback should be able to enqueue
>> enough requests to get decent sorting performance but not enough
>> requests to prevent the io scheduler from doing a good job on
>> non-writeback I/O.
>
>
> The thing is that if there are no reads that are waiting, why not use every
> bit of disk I/O available to write? If you can do that reliably with only
> using part of the queue, fine, but aren't you getting fairly close to just
> having separate queues for reading and writing with such a restriction?
>

Hmm.

I wonder what the actual effect of queue length is on throughput.  I
suspect that using half the queue gives you well over half the
throughput as long as the queue isn't tiny.

I'm not so sure I'd go so far as having separate reader and writer
queues -- I think that small synchronous writes should also not get
stuck behind large writeback storms, but maybe that's something that
can be a secondary goal.  That being said, separate reader and writer
queues might solve the immediate problem.  It won't help for the case
where a small fsync blocks behind writeback, though, and that seems to
be a very common cause of Firefox freezing on my system.

Is there an easy way to do a proof-of-concept?  It would be great if
there was a ten-line patch that implemented something like this
correctly enough to see if it helps.  I don't think I'm the right
person to do it, because my knowledge of the block layer code is
essentially nil.

>
>> As an even more radical idea, what if there was a way to submit truly
>> enormous numbers of lightweight requests, such that the queue will
>> give the requester some kind of callback when the request is nearly
>> ready for submission so the requester can finish filling in the
>> request?  This would allow things like dm-crypt to get the benefit of
>> sorting without needing to encrypt hundreds of MB of data in advance
>> of having that data actually be to the backing device.  It might also
>> allow writeback to submit multiple gigabytes of writes, in arbitrarily
>> large pieces, but not to need to pin pages or do whatever expensive
>> things are needed until the IO actually happens.
>
>
> the problem with a callback is that you then need to wait for that source to
> get the CPU and finish doing it's work. What happens if that takes long
> enough for you to run out of data to write? And is it worth the extra
> context switches to bounce around when the writing process was finished with
> that block already.

dm-crypt is so context-switch heavy that I doubt the context switches
matter.  And you'd need to give the callback early enough that there's
a very good chance that the callback will finish in time.  There might
even need to be a way to let other non-callback-dependent IO pass by
the callback-dependent stuff, although in the particular case of
dm-crypt, dm-crypt is pretty much the only source of writes.  (Reads
don't have this problem for dm-crypt, I think.)

--Andy
