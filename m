Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758061Ab3DQTIV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 15:08:21 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:51496 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756580Ab3DQTIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 15:08:18 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <20130409222808.GC20739@home.goodmis.org>
References: <20130228102452.15191.22673.stgit@patser>
	<20130228102502.15191.14146.stgit@patser>
	<1364900432.18374.24.camel@laptop>
	<515AF1C1.7080508@canonical.com>
	<1364921954.20640.22.camel@laptop>
	<1365076908.2609.94.camel@laptop>
	<20130404133123.GW2228@phenom.ffwll.local>
	<1365093662.2609.111.camel@laptop>
	<20130409222808.GC20739@home.goodmis.org>
Date: Wed, 17 Apr 2013 21:08:17 +0200
Message-ID: <CAKMK7uHst+s9x0u4J04Qck26EeeUDOORM_SgYovmjV4c+mKP0w@mail.gmail.com>
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

On Wed, Apr 10, 2013 at 12:28 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Thu, Apr 04, 2013 at 06:41:02PM +0200, Peter Zijlstra wrote:
>> On Thu, 2013-04-04 at 15:31 +0200, Daniel Vetter wrote:
>> > The thing is now that you're not expected to hold these locks for a
>> > long
>> > time - if you need to synchronously stall while holding a lock
>> > performance
>> > will go down the gutters anyway. And since most current
>> > gpus/co-processors
>> > still can't really preempt fairness isn't that high a priority,
>> > either.
>> > So we didn't think too much about that.
>>
>> Yeah but you're proposing a new synchronization primitive for the core
>> kernel.. all such 'fun' details need to be considered, not only those
>> few that bear on the one usecase.
>
> Which bares the question, what other use cases are there?

Just stumbled over one I think: If we have a big graph of connected
things (happens really often for video pipelines). And we want
multiple users to use them in parallel. But sometimes a configuration
change could take way too long and so would unduly stall a 2nd thread
with just a global mutex, then per-object ww_mutexes would be a fit:
You'd start with grabbing all the locks for the objects you want to
change anything with, then grab anything in the graph that you also
need to check. Thanks to loop detection and self-recursion this would
all nicely work out, even for cyclic graphs of objects.
-Daniel
--
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
