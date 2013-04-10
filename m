Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964871Ab3DJI1t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 04:27:49 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:63910 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935049Ab3DJI1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 04:27:45 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <20130409222707.GB20739@home.goodmis.org>
References: <20130228102452.15191.22673.stgit@patser>
	<20130228102502.15191.14146.stgit@patser>
	<1364900432.18374.24.camel@laptop>
	<515AF1C1.7080508@canonical.com>
	<1364921954.20640.22.camel@laptop>
	<1365076908.2609.94.camel@laptop>
	<20130404133123.GW2228@phenom.ffwll.local>
	<1365093516.2609.109.camel@laptop>
	<20130409222707.GB20739@home.goodmis.org>
Date: Wed, 10 Apr 2013 10:27:44 +0200
Message-ID: <CAKMK7uH7mW9HK6_ZO8OhwQLBUJE3LBizweth1cvZdjVBzOGa=Q@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] mutex: add support for reservation style locks, v2
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        linux-arch@vger.kernel.org, x86@kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        rob clark <robclark@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 12:27 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Thu, Apr 04, 2013 at 06:38:36PM +0200, Peter Zijlstra wrote:
>> On Thu, 2013-04-04 at 15:31 +0200, Daniel Vetter wrote:
>> > Hm, I guess your aim with the TASK_DEADLOCK wakeup is to bound the
>> > wait
>> > times of older task.
>>
>> No, imagine the following:
>>
>> struct ww_mutex A, B;
>> struct mutex C;
>>
>>       task-O  task-Y  task-X
>>               A
>>               B
>>                       C
>>               C
>>       B
>>
>> At this point O finds that Y owns B and thus we want to make Y 'yield'
>> B to make allow B progress. Since Y is blocked, we'll send a wakeup.
>> However Y is blocked on a different locking primitive; one that doesn't
>> collaborate in the -EDEADLK scheme therefore we don't want the wakeup to
>> succeed.
>
> I'm confused to why the above is a problem. Task-X will eventually
> release C, and then Y will release B and O will get to continue. Do we
> have to drop them once the owner is blocked? Can't we follow the chain
> like the PI code does?

Just waiting until every task already holding a lock completes and
unlucks it is indeed a viable solution - it's the currently
implemented algorithm in ttm and Maarten's current patches.

The nice thing with Peter's wakeup idea on top is:
- It bounds blocked times.
- And (at least I think so) it's the key thing making PI boosting
possible without any ugly PI inversion deadlocks happening. See

Message-ID: <CAKMK7uEUdtiDDCRPwpiumkrST6suFY7YuQcPAXR_nJ0XHKzsAw@mail.gmail.com>

for my current reasoning about this (I have not yet managed to poke a
hole into it).
-Daniel
--
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
