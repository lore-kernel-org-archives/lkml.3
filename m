Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751445Ab3JEHv1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 03:51:27 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:33135 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273Ab3JEHv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 03:51:26 -0400
Message-ID: <524FC4F4.6050401@gmail.com>
Date: Sat, 05 Oct 2013 16:51:16 +0900
From: Akira Hayakawa <ruby.wktk@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: david@fromorbit.com
CC: mpatocka@redhat.com, thornber@redhat.com, devel@driverdev.osuosl.org,
        snitzer@redhat.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com, agk@redhat.com,
        joe@perches.com, akpm@linux-foundation.org, dan.carpenter@oracle.com,
        ejt@redhat.com, cesarb@cesarb.net, m.chehab@samsung.com,
        ruby.wktk@gmail.com
Subject: Re: [dm-devel] Reworking dm-writeboost [was: Re: staging: Add dm-writeboost]
References: <5223208D.4000008@gmail.com> <20130916215357.GA5015@redhat.com> <52384E66.6050101@gmail.com> <20130917205936.GB12001@redhat.com> <523E3522.2060607@gmail.com> <524183A2.9050301@gmail.com> <20130926034325.GO26872@dastard> <20131001082654.GA10326@debian> <alpine.LRH.2.02.1310021956130.22612@file01.intranet.prod.int.rdu2.redhat.com> <20131004020417.GF4446@dastard>
In-Reply-To: <20131004020417.GF4446@dastard>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave,

> That's where arbitrary delays in the storage stack below XFS cause
> problems - if the first FUA log write is delayed, the next log
> buffer will get filled, issued and delayed, and when we run out of
> log buffers (there are 8 maximum) the entire log subsystem will
> stall, stopping *all* log commit operations until log buffer
> IOs complete and become free again. i.e. it can stall modifications
> across the entire filesystem while we wait for batch timeouts to
> expire and issue and complete FUA requests.
To me, this sounds like design failure in XFS log subsystem.
Or just the limitation of metadata journal.

> IMNSHO, REQ_FUA/REQ_FLUSH optimisations should be done at the
> point where they are issued - any attempt to further optimise them
> by adding delays down in the stack to aggregate FUA operations will
> only increase latency of the operations that the issuer want to have
> complete as fast as possible....
That lower layer stack attempts to optimize further
can benefit any filesystems.
So, your opinion is not always correct although
it is always correct in error handling or memory management.

I have proposed future plan of using persistent memory.
I believe with this leap forward
filesystems are free from doing such optimization
relevant to write barriers. For more detail, please see my post.
https://lkml.org/lkml/2013/10/4/186

However,
I think I should leave option to disable the optimization
in case the upper layer doesn't like it.
Maybe, writeboost should disable deferring barriers
if barrier_deadline_ms parameter is especially 0.
Linux kernel's layered architecture is obviously not always perfect
so there are similar cases in other boundaries
such as O_DIRECT to bypass the page cache.

Maybe, dm-thin and dm-cache should add such switch.

Akira
