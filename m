Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034AbaGKOeQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 10:34:16 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:47511 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385AbaGKOeM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 10:34:12 -0400
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
To: Christoph Hellwig <hch@infradead.org>
CC: Jeff Moyer <jmoyer@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        "dgilbert@interlog.com" <dgilbert@interlog.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Bart Van Assche <bvanassche@fusionio.com>,
        Benjamin LaHaise <bcrl@kvack.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: scsi-mq V2
Thread-Topic: scsi-mq V2
Thread-Index: AQHPnHMrpCazJa2BBk+bOfxdnvD3mpuZzE1ggACP5JCAAAm1gIAAiJyA
Date: Fri, 11 Jul 2014 14:33:12 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958B98323@G9W0745.americas.hpqcorp.net>
References: <53BD9A24.7010203@kernel.dk>
 <94D0CD8314A33A4D9D801C0FE68B402958B9628B@G9W0745.americas.hpqcorp.net>
 <20140710062040.GB20146@infradead.org>
 <94D0CD8314A33A4D9D801C0FE68B402958B96E3B@G9W0745.americas.hpqcorp.net>
 <20140710160422.GA13728@infradead.org>
 <20140710161438.GA30792@infradead.org>
 <94D0CD8314A33A4D9D801C0FE68B402958B971BB@G9W0745.americas.hpqcorp.net>
 <x497g3l10x6.fsf@segfault.boston.devel.redhat.com>
 <94D0CD8314A33A4D9D801C0FE68B402958B9742E@G9W0745.americas.hpqcorp.net>
 <94D0CD8314A33A4D9D801C0FE68B402958B979E6@G9W0745.americas.hpqcorp.net>
 <20140711061441.GA29629@infradead.org>
In-Reply-To: <20140711061441.GA29629@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.210.48.37]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Friday, 11 July, 2014 1:15 AM
> To: Elliott, Robert (Server Storage)
> Cc: Jeff Moyer; Christoph Hellwig; Jens Axboe; dgilbert@interlog.com; James
> Bottomley; Bart Van Assche; Benjamin LaHaise; linux-scsi@vger.kernel.org;
> linux-kernel@vger.kernel.org
> Subject: Re: scsi-mq V2
> 
> On Fri, Jul 11, 2014 at 06:02:03AM +0000, Elliott, Robert (Server Storage)
> wrote:
> > Allowing longer run times before declaring success, the problem
> > does appear in all of the bisect trees.  I just let fio
> > continue to run for many minutes - no ^Cs necessary.
> >
> > no-rebase: good for > 45 minutes (I will leave that running for
> >   8 more hours)
> 
> Ok, thanks.  If it's still running tomorrow morning let's look into the
> aio reverts again.

That ran 9 total hours with no problem.

Rather than revert in the bisect trees, I added just this single additional
patch to the no-rebase tree, and the problem appeared:


48a2e94154177286b3bcbed25ea802232527fa7c
aio: fix aio request leak when events are reaped by userspace

diff --git a/fs/aio.c b/fs/aio.c
index 4f078c0..e59bba8 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1021,6 +1021,7 @@ void aio_complete(struct kiocb *iocb, long res, long res2)

        /* everything turned out well, dispose of the aiocb. */
        kiocb_free(iocb);
+       put_reqs_available(ctx, 1);     /* added by patch f8567 */

        /*
         * We have to order our ring_info tail store above and test
@@ -1101,7 +1102,7 @@ static long aio_read_events_ring(struct kioctx *ctx,

        pr_debug("%li  h%u t%u\n", ret, head, tail);

-       put_reqs_available(ctx, ret);
+       /* put_reqs_available(ctx, ret); removed by patch f8567 */
 out:
        mutex_unlock(&ctx->ring_lock);


---
Rob Elliott    HP Server Storage



