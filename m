Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935589AbaH0R4I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 13:56:08 -0400
Received: from tetsuo.zabbo.net ([50.193.208.193]:42501 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751081AbaH0R4G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 13:56:06 -0400
Date: Wed, 27 Aug 2014 10:56:05 -0700
From: Zach Brown <zab@zabbo.net>
To: Maxim Patlasov <mpatlasov@parallels.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>, Ming Lei <ming.lei@canonical.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Kent Overstreet <kmo@daterainc.com>,
        open list:
	AIO <linux-aio@kvack.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>, ;
Illegal-Object: Syntax error in Cc: address found on vger.kernel.org:
	Cc:	;
			^-missing semicolon to end mail group, extraneous tokens in mailbox, missing end of mailbox
Subject: Re: [PATCH v1 5/9] block: loop: convert to blk-mq
Message-ID: <20140827175605.GE12827@lenny.home.zabbo.net>
References: <53EE3966.60609@kernel.dk>
 <CACVXFVO+3SHy0=zESJqG3ZB68AZaeK5_QK2CVmZWzZ7oBWDGwg@mail.gmail.com>
 <53F0EAEC.9040505@kernel.dk>
 <CACVXFVO3CrD2CoHiBOZ8GNMXrT2pJ=t2BzmAHksqRTmgrpsaaQ@mail.gmail.com>
 <CACVXFVN6W-AAQ6g4LXHOyvMzU+EAmj_YYBEuYRnoSB+VqCJg8A@mail.gmail.com>
 <53F3B89D.6070703@kernel.dk>
 <CACVXFVOR0mzMWo+iPtU8jUvYgH+non=hQ0XaP0Z1Fu0qiSbJNA@mail.gmail.com>
 <53FE029B.1030200@parallels.com>
 <20140827162955.GF4827@kvack.org>
 <53FE1328.2040607@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53FE1328.2040607@parallels.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2014 at 09:19:36PM +0400, Maxim Patlasov wrote:
> On 08/27/2014 08:29 PM, Benjamin LaHaise wrote:
> >On Wed, Aug 27, 2014 at 08:08:59PM +0400, Maxim Patlasov wrote:
> >...
> >>1) /dev/loop0 of 3.17.0-rc1 with Ming's patches applied -- 11K iops
> >>2) the same as above, but call loop_queue_work() directly from
> >>loop_queue_rq() -- 270K iops
> >>3) /dev/nullb0 of 3.17.0-rc1 -- 380K iops
> >>
> >>Taking into account so big difference (11K vs. 270K), would it be worthy
> >>to implement pure non-blocking version of aio_kernel_submit() returning
> >>error if blocking needed? Then loop driver (or any other in-kernel user)
> >>might firstly try that non-blocking submit as fast-path, and, only if
> >>it's failed, fall back to queueing.
> >What filesystem is the backing file for loop0 on?  O_DIRECT access as
> >Ming's patches use should be non-blocking, and if not, that's something
> >to fix.
> 
> I used loop0 directly on top of null_blk driver (because my goal was to
> measure the overhead of processing requests in a separate thread).

The relative overhead while doing nothing else.  While zooming way down
in to micro benchmarks is fun and all, testing on an fs on brd might be
more representitive and so more compelling.

(And you might start to stumble into the terrifying territory of
stacking fs write paths under fs write paths.. turn on lockdep! :))

> In case of real-life filesystems, e.g. ext4, aio_kernel_submit() may easily
> block on something like bh_submit_read(), when fs reads file metadata to
> calculate the offset on block device by position in the file.

Yeah, there are a lot of rare potential blocking points throughout the
fs aio submission paths.   In practice (aio+dio+block fs), I think
submission tends to block waiting for congested block queues most often.

- z
