Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323Ab3JHJlw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 05:41:52 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:39636 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754310Ab3JHJlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 05:41:50 -0400
Date: Tue, 8 Oct 2013 02:41:44 -0700
From: Christoph Hellwig <hch@infradead.org>
To: device-mapper development <dm-devel@redhat.com>
Cc: Akira Hayakawa <ruby.wktk@gmail.com>, devel@driverdev.osuosl.org,
        thornber@redhat.com, snitzer@redhat.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, mpatocka@redhat.com,
        dan.carpenter@oracle.com, joe@perches.com, akpm@linux-foundation.org,
        m.chehab@samsung.com, ejt@redhat.com, agk@redhat.com,
        cesarb@cesarb.net
Subject: Re: [dm-devel] Reworking dm-writeboost [was: Re: staging: Add
 dm-writeboost]
Message-ID: <20131008094144.GA10261@infradead.org>
References: <52384E66.6050101@gmail.com>
 <20130917205936.GB12001@redhat.com>
 <523E3522.2060607@gmail.com>
 <524183A2.9050301@gmail.com>
 <20130926034325.GO26872@dastard>
 <20131001082654.GA10326@debian>
 <alpine.LRH.2.02.1310021956130.22612@file01.intranet.prod.int.rdu2.redhat.com>
 <20131004020417.GF4446@dastard>
 <524FC4F4.6050401@gmail.com>
 <20131007234307.GP4446@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131007234307.GP4446@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08, 2013 at 10:43:07AM +1100, Dave Chinner wrote:
> > Maybe, writeboost should disable deferring barriers
> > if barrier_deadline_ms parameter is especially 0.
> > Linux kernel's layered architecture is obviously not always perfect
> > so there are similar cases in other boundaries
> > such as O_DIRECT to bypass the page cache.
> 
> Right - but you can't detect O_DIRECT at the dm layer. IOWs, you're
> relying on the user tweaking the corect knobs for their workload.

You can detect O_DIRECT writes by second guession a special combination
of REQ_ flags only used there, as cfg tries to treat it special:

#define WRITE_SYNC              (WRITE | REQ_SYNC | REQ_NOIDLE)
#define WRITE_ODIRECT           (WRITE | REQ_SYNC)

the lack of REQ_NOIDLE when REQ_SYNC is set gives it away.  Not related
to the FLUSH or FUA flags in any way, though.

Akira, can you explain the workloads where your delay of FLUSH or FUA
requests helps you in any way?  I very much agree with Dave's reasoning,
but if you found workloads where your hack helps we should make sure we
fix them at the place where they are issued.
