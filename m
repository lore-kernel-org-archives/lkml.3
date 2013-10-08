Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865Ab3JHKho (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 06:37:44 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:38429 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149Ab3JHKhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 06:37:43 -0400
Message-ID: <5253E06C.6040101@gmail.com>
Date: Tue, 08 Oct 2013 19:37:32 +0900
From: Akira Hayakawa <ruby.wktk@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: hch@infradead.org
CC: dm-devel@redhat.com, devel@driverdev.osuosl.org, thornber@redhat.com,
        snitzer@redhat.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, mpatocka@redhat.com,
        dan.carpenter@oracle.com, joe@perches.com, akpm@linux-foundation.org,
        m.chehab@samsung.com, ejt@redhat.com, agk@redhat.com,
        cesarb@cesarb.net, ruby.wktk@gmail.com
Subject: Re: [dm-devel] Reworking dm-writeboost [was: Re: staging: Add dm-writeboost]
References: <52384E66.6050101@gmail.com> <20130917205936.GB12001@redhat.com> <523E3522.2060607@gmail.com> <524183A2.9050301@gmail.com> <20130926034325.GO26872@dastard> <20131001082654.GA10326@debian> <alpine.LRH.2.02.1310021956130.22612@file01.intranet.prod.int.rdu2.redhat.com> <20131004020417.GF4446@dastard> <524FC4F4.6050401@gmail.com> <20131007234307.GP4446@dastard> <20131008094144.GA10261@infradead.org>
In-Reply-To: <20131008094144.GA10261@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph,

> You can detect O_DIRECT writes by second guession a special combination
> of REQ_ flags only used there, as cfg tries to treat it special:
> 
> #define WRITE_SYNC              (WRITE | REQ_SYNC | REQ_NOIDLE)
> #define WRITE_ODIRECT           (WRITE | REQ_SYNC)
> 
> the lack of REQ_NOIDLE when REQ_SYNC is set gives it away.  Not related
> to the FLUSH or FUA flags in any way, though.
Thanks.
But, our problem is to detect the bio may or may not be deferred.
The flag REQ_NOIDLE is the one?

> Akira, can you explain the workloads where your delay of FLUSH or FUA
> requests helps you in any way?  I very much agree with Dave's reasoning,
> but if you found workloads where your hack helps we should make sure we
> fix them at the place where they are issued.
One of the examples is a fileserver accessed by multiple users.
A barrier is submitted when a user closes a file for example.

As I said in my previous post
https://lkml.org/lkml/2013/10/4/186
writeboost has RAM buffer and we want one to be
fulfilled with writes and then flushed to the cache device
that takes all the barriers away with the completion.
In that case we pay the minimum penalty for the barriers.
Interestingly, writeboost is happy with a lot of writes.

By deferring these barriers (FLUSH and FUA)
multiple barriers are likely to be merged on a RAM buffer
and then processed by replacing with only one FLUSH.

Merging the barriers and replacing it with a single FLUSH
by accepting a lot of writes
is the reason for deferring barriers in writeboost.
If you want to know further I recommend you to
look at the source code to see
how queue_barrier_io() is used and
how the barriers are kidnapped in queue_flushing().

Akira
