Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739AbaGVKev (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 06:34:51 -0400
Received: from 8bytes.org ([81.169.241.247]:52853 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885AbaGVKeu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 06:34:50 -0400
Date: Tue, 22 Jul 2014 12:34:44 +0200
From: Joerg Roedel <joro@8bytes.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6 v2] PM / Hibernate: Memory bitmap scalability
 improvements
Message-ID: <20140722103443.GV30979@8bytes.org>
References: <1405938422-21900-1-git-send-email-joro@8bytes.org>
 <20140721160346.GP30979@8bytes.org>
 <20140721230500.GA7019@amd.pavel.ucw.cz>
 <6793803.1FXN0a3O0V@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6793803.1FXN0a3O0V@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 02:41:29AM +0200, Rafael J. Wysocki wrote:
> It looks like some specific need motivated the Joerg's work, however,
> so let's just not dismiss the use case lightly without knowing it.

The motivation was to optimize the data structures for machines with
large amounts of RAM without penalizing average machines. On a 12TB
machine you are close to 100000 pages just for one bitmap. Scanning
through that linearly to find a given bit just doesnt scale anymore in
this case.

Same for the algorithm currently used in swsusp_free(). Scanning over
every pfn also doesn't scale well anymore in these ranges. I agree that
the optimizations are not noticable on average systems (see below), but
they are still measurable.

I also see how the problem could be solved differently, but what I
didn't get from the discussion yet is: What is actually *wrong* with
*this* approach?

> That said I would like to know how much time we save through this
> optimization relative to the total hibernation time on systems with
> various amounts of memory (say, 4 GB, 8 GB, 16 GB, 32 GB, more) and
> whether or not it makes hibernation slower in any case.

Okay, I tested on a 16GB system (actually 15GB, one GB is taken by the
GPU). Since the total time for hibernation depends not only on the
amount of RAM in the machine but more on the size of the hibernation
image and the speed of the disk, there is not much value in measuring a
complete resume cycle. The time needed there depends more on the system
and the work load than anything else.

So my test was to resume from a swap partition that contained no image.
Here is the result from the 16GB machine. First with a v3.16-rc6 kernel
without my changes:

kv:~/base # time perf record /usr/sbin/resume /dev/sda1
resume: libgcrypt version: 1.5.3
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.019 MB perf.data (~823 samples) ]

real    0m0.084s
user    0m0.012s
sys     0m0.064s

Here is the result with my patches on top:

kv:~/hibernate # time perf record /usr/sbin/resume /dev/sda1
resume: libgcrypt version: 1.5.3
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.014 MB perf.data (~602 samples) ]

real    0m0.032s
user    0m0.003s
sys     0m0.027s

So we save around 50ms (or 62% of time) already on this 16GB machine.

Thanks,

	Joerg

