Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747AbaHSXb5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 19:31:57 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:57261 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbaHSXbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 19:31:55 -0400
X-Original-SENDERIP: 10.177.222.156
X-Original-MAILFROM: minchan@kernel.org
Date: Wed, 20 Aug 2014 08:32:25 +0900
From: Minchan Kim <minchan@kernel.org>
To: Marc Dietrich <marvin24@gmx.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Jerome Marchand <jmarchan@redhat.com>, juno.choi@lge.com,
        seungho1.park@lge.com, Luigi Semenzato <semenzato@google.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjennings@variantweb.net>,
        Dan Streetman <ddstreet@ieee.org>, ds2horner@gmail.com
Subject: Re: [PATCH v2 3/4] zram: zram memory size limitation
Message-ID: <20140819233225.GA32620@bbox>
References: <1408434887-16387-1-git-send-email-minchan@kernel.org>
 <1408434887-16387-4-git-send-email-minchan@kernel.org>
 <7959928.Exbvf4HrNB@fb07-iapwap2>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7959928.Exbvf4HrNB@fb07-iapwap2>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Aug 19, 2014 at 10:06:22AM +0200, Marc Dietrich wrote:
> Am Dienstag, 19. August 2014, 16:54:46 schrieb Minchan Kim:
> > Since zram has no control feature to limit memory usage,
> > it makes hard to manage system memrory.
> > 
> > This patch adds new knob "mem_limit" via sysfs to set up the
> > a limit so that zram could fail allocation once it reaches
> > the limit.
> 
> Sorry to jump in late with a probably silly question, but I couldn't find the 
> answer easily. What's the difference between disksize and mem_limit?

No need to say sorry.
It was totally my fault because zram documentation sucks.

The disksize means the size point of view upper layer from block subsystem
so filesystem based on zram or blockdevice itself(ie, zram0) seen by admin
will have the disksize size but keep in mind that it's virtual size,
not compressed. As you know already, zram is backed on volatile storage
(ie, DRAM) with *compressed form*, not permanent storage.

The point of this patchset is that anybody cannot expect exact memory
usage of zram in advance. Acutally, zram folks have estimated it by several
experiment and assuming zram compression ratio(ex, 2:1 or 3:1) before
releasing product. But thesedays, embedded platforms have varios workloads
which cannot be expected when the product was released so compression
ratio expectation could be wrong sometime so zram could consume lots of
memory than expected once compression ratio is low.

It makes admin trouble to manage memeory on the product because there
is no way to release memory zram is using so that one of the way is
to limit memory usage of zram from the beginning.

> I assume the former is uncompressed size (virtual size) and the latter is 
> compressed size (real memory usage)? Maybe the difference should be made 

Right.

> clearer in the documentation.

Okay.

> If disksize is the uncompressed size, why would we want to set this at all?

For example, we have 500M disksize of zram0 because we assumed 2:1
compression ratio so that we could guess zram will consume 250M physical memory
in the end. But our guessing could be wrong so if real compression ratio
is 4:1, we use up 125M phsyical memory to store 500M uncompressed pages.
It's good but admin want to use up more memory for zram because we saved
100% than expected zram memory but we couldn't becuase upper layer point of view
from zram, zram is already full by 500M and if zram is used for swap,
we will encounter OOM. :(

So, it would be better to increase disksize to 1000M but in this case,
if compression ratio becomes 4:1 by something(ex, workload change),
zram can consume 500M physical memory, which is above we expected
and admin don't want zram to use up system memory too much.

In summary, we couldn't control exact zram memory usage with only disksize
by compression ratio.

> 
> Marc
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Kind regards,
Minchan Kim
