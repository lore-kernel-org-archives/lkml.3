Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911AbaK1OMH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 09:12:07 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:50287 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366AbaK1OMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 09:12:05 -0500
Message-ID: <547882AD.9030801@gmail.com>
Date: Fri, 28 Nov 2014 23:11:57 +0900
From: Akira Hayakawa <ruby.wktk@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: snitzer@redhat.com
CC: dm-devel@redhat.com, gregkh@linuxfoundation.org,
        masami.hiramatsu@gmail.com, linux-kernel@vger.kernel.org,
        corbet@lwn.net
Subject: Re: dm-writeboost: About inclusion into mainline
References: <5475EB77.3050004@gmail.com> <20141126152843.GC30136@redhat.com>
In-Reply-To: <20141126152843.GC30136@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike, thanks for reply,

> But as you can see from what I've staged for 3.19 inclusion I haven't
> been sitting around idle:
> https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-for-3.19
I see.

> Though you'll note that the focus of development has been on improving
> both DM thinp and DM cache (and DM core as needed).  Those targets are
> the bread winners from my perspective (lots of consumers and need for
> enterprise stability).
It's not just improving DM thinp nor DM cache, neither bcache. In fact, they are orthogonal.
I think dm-writeboost has reason to be included to compliment dm-cache.

Other usage I have in my mind is for backup.
The logs (or bunch of side-effects) dm-writeboost generates are chronologically serialized.
Sending the logs to backup server for recovery could be a good role of my driver.

> Upstream has both dm-cache and bcache.  Please demonstrate that
> dm-writeboost offers an advantage over either of these already upstream
> caching solutions with at least _some_ convincing benchmark data.
There are two benchmark reports that I have posted. Unfortunately, both were ignored.

1) Feb, 2014
http://www.redhat.com/archives/dm-devel/2014-February/msg00000.html
The first one is comparing with bcache.
Joe mentioned that bcache is also good at write performance
(http://www.redhat.com/archives/dm-devel/2014-January/msg00102.html)
so I compare with it in terms of it.
The result is positive. dm-writeboost can perform nearly seqwrite of the cache device
when the incoming patten is random (that's because dm-writeboost is log-structured caching)
that is, 3 times faster than bcache with the same workload.
The results also shows, dm-writeboost is 5 times efficient than bcache in
CPU consumption.

2) May, 2014
http://www.redhat.com/archives/dm-devel/2014-May/msg00052.html
This time, I carried out with rather realistic benchmarks.
I sent the summary as a split post. 234-299% improvement with dbench for example.
http://www.redhat.com/archives/dm-devel/2014-May/msg00073.html

These benchmarks are included in device-mapper-test-suite so that everyone
can double-check.

For these reports, please let me know if they doesn't make sense or
you want to see with other particular tests.



By the way, I think it's good time to propose for staging again
so that not only you but also more developers can try dm-writeboost and give feedback.
I know you are busy with other reviewing and not afford to review my driver
but I want to merge my driver to main tree since I need more feedback to progress my work.
The staging will be better for this situation.
(or if you dig md/writeboost that would be appreciated)

Your comments on my first proposal for staging were on the design problems.
That was, my driver had external userland daemon and self-defined sysfs was pointed out
too immature for staging.
But for now, I think the design problems are all solved.
The tests are in device-mapper-test-suite and
the design of dmsetup commands are similar to dm-cache (which was your order, too).

I will continue to push my tests to device-mapper-test-suite so that
other guys can test my driver easily.

- Akira


On 11/27/14 12:28 AM, Mike Snitzer wrote:
> On Wed, Nov 26 2014 at 10:02am -0500,
> Akira Hayakawa <ruby.wktk@gmail.com> wrote:
> 
>> Hi,
>>
>> I am wondering what's the next step of dm-writeboost, my log-structured SSD-caching driver.
>> I want to discuss this.
>>
>> I will start from introducing my activity on dm-writeboost.
>> It was more than a year ago that I proposed my dm-writeboost for staging.
>> Mike Snitzer, a maintainer of device-mapper, rejected it because dm-writeboost at that moment wasn't even suitable for staging.
>> (http://www.redhat.com/archives/dm-devel/2013-September/msg00075.html)
>> It is clear that the comment was really right. The code was actually terrible.
>> Since then, with helps of DM guys, dm-writeboost's design and implementation has been polished.
>> And it was included into Joe's linux-2.6 where he develops his drivers.
>> (https://github.com/jthornber/linux-2.6/tree/thin-dev/drivers/md)
>> I found some bugs and fixed them after this inclusion. I am confident the quality is good enough for staging.
>>
>> Now, I can't find the way how I go over the wall.
>> It seems that third party drivers are rarely merged into the md.
>> The fact is, no third party driver (meaning proposed by other than RH) was included since I am involved with device-mapper, for 2 years.
>> I am really afraid dm-writeboost will never be into the md ever after.
>>
>> In one sense, this sounds too conservative. New features are always rejected. As a result, third party developers, including me, are losing their willingness.
> 
> You're painting with a really wide-brush here.  Both dm-verity and
> dm-switch started out as targets from 3rd party developers (Google and
> Dell/Equallogic respectively).  But while their feature was needed their
> implementation was lacking, so Mikulas rewrote them before they were
> included.
> 
> But yes, in general, I need to do better about getting to
> review/inclusion of 3rd party DM targets.  I have my hands full
> maintaining what DM targets we already have (not to mention DM core
> itself).
> 
> It isn't just full targets (like DM dedup or DM lightnvm) that need
> proper review.  It is also DM core changes like adding blk-mq support to
> request-based DM.  Those changes are very much on my TODO.  DM dedup and
> the blk-mq changes near the top!
> 
> But as you can see from what I've staged for 3.19 inclusion I haven't
> been sitting around idle:
> https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-for-3.19
> 
> Though you'll note that the focus of development has been on improving
> both DM thinp and DM cache (and DM core as needed).  Those targets are
> the bread winners from my perspective (lots of consumers and need for
> enterprise stability).
> 
> All said, I _should_ be able to dedicate time to my backlog of DM review
> tasks the first few weeks of Decemeber.  But sadly that doesn't include
> time for dm-writeboost yet.
> 
>> As you know, developing driver is a hard work and spend lot of
>> time. Actually, I spent hundreds or thousands of my private hours on
>> my driver (hoping that my driver will be included and become famous)
>> but I am almost giving up dm-writeboost if it has no hope. I know,
>> storage softwares should become safe-side but I also know that
>> willingness is the only key for non-paid development.
> 
> If you're looking for fame you're developing the wrong software.  You're
> working on a well-worn software layer.
> 
> Upstream has both dm-cache and bcache.  Please demonstrate that
> dm-writeboost offers an advantage over either of these already upstream
> caching solutions with at least _some_ convincing benchmark data.
> 
> Mike
> 

