Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756288Ab3C1MyQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 08:54:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42569 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756263Ab3C1MyN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 08:54:13 -0400
Message-ID: <51543D70.8040808@redhat.com>
Date: Thu, 28 Mar 2013 08:54:08 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH 0/8] Move ntp state to be protected by timekeeping lock
References: <1364242098-5977-1-git-send-email-john.stultz@linaro.org>
In-Reply-To: <1364242098-5977-1-git-send-email-john.stultz@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 03/25/2013 04:08 PM, John Stultz wrote:

> 
> The problem of course, is that the new asynchronous behavior the
> shadow updates breaks some of the assumptions on how the NTP state
> is used. Thus to correct this, we really need to serialize the ntp
> state updates along with the timekeeping state. With the added side
> benefit that of reducing lock acquisitions.
> 
> The downside is that the timekeeping state has been cleaned up to
> live nicely in the timekeeper struct, which nicely bounded what the
> timekeeping lock protected. Where as 99% of the NTP state was all
> static to ntp.c, and was protected by the ntp.c static ntp_lock, so
> it was all nicely encapsulated as well. 

> 
> This patchset makes the lock ownership lines less obvious, but I've
> been sure to keep the ntp state static to ntp.c and instead provided
> some accessors via ntp-internal.h that timekeping code can use to
> make changes.  The only really ugly part is that do_adjtimex() has
> to split some of the logic between timekeeping.c and ntp.c in order
> to really get the locking done correctly.


John, I have no technical objection to the patch ... but after reviewing the
changes I think you've significantly changed the way the locking works in the
NTP code, and IMO, some note should be made in the code about the timekeeper
lock and its impact to ntp.  It's not trivial reading this code and I think the
dropping of the ntp lock will confuse the casual viewer.

IMO of course.

> 
> I may try to rework the code in the future so that the timekeeper
> holds the ntp state and passes it to the ntp.c functions to be
> modified, but that is a much deeper rework then I'd like to do right
> now, and causes fruther complexity to the shadow-state updates, since
> we'd end up unnecessarily copying the ntp state back and forth every
> time.
> 
> This applies on top of my fortglx/3.10/time queue here:
> git://git.linaro.org/people/jstultz/linux.git fortglx/3.10/time
> 
> If you want to see this entire set (along with Thomas' shadow-update
> work) it can be found here:
> git://git.linaro.org/people/jstultz/linux.git dev/tglx-shadowtime
> or 
> http://git.linaro.org/gitweb?p=people/jstultz/linux.git;a=shortlog;h=refs/heads/dev/tglx-shadowtime
> 

Beyond the above comment, a quick test shows that ntp does work AFAICT (at least
on F18 + your git tree.  I'll try and do a heavier test next week.

So for now ...

Acked-by: Prarit Bhargava <prarit@redhat.com>

P.
