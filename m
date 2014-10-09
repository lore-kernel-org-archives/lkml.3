Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757261AbaJINyP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 09:54:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29335 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751975AbaJINyG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 09:54:06 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Jens Axboe <axboe@kernel.dk>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Ming Lei <ming.lei@canonical.com>
Subject: Re: [PATCH] block: copy bi_vcnt in __bio_clone_fast
References: <5435C093.5070405@suse.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 09 Oct 2014 09:53:58 -0400
In-Reply-To: <5435C093.5070405@suse.com> (Jeff Mahoney's message of "Wed, 08
	Oct 2014 18:54:11 -0400")
Message-ID: <x4938axz6vd.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Mahoney <jeffm@suse.com> writes:

> Commit 05f1dd53152173 (block: add queue flag for disabling SG merging) uses
> bi_vcnt to assign bio->bi_phys_segments if sg merging is disabled. When
> using device mapper on top of a blk-mq device (virtio_blk in my test),
> we'd end up overflowing the scatterlist in __blk_bios_map_sg.
>
> __bio_clone_fast copies bi_iter and bi_io_vec but not bi_vcnt, so
> blk_recount_segments would report bi_phys_segments as 0. Since
> rq->nr_phys_segments is 0 as well, the checks to ensure that we don't
> exceed the queue's segment limit end up allowing more bios (and segments) to
> attach the a request until we finally map it. That also means we
> pass the BUG_ON at the beginning of virtio_queue_rq, ultimately causing
> memory corruption and a crash.
>
> If we copy bi_vcnt in __bio_clone_fast, the bios and requests properly
> report the number of segments and everything works as expected.
>
> Originally reported at http://bugzilla.opensuse.org/show_bug.cgi?id=888259

Hi, Jeff,

Did you manage to reproduce this problem with commit 0738854 (blk-merge:
fix blk_recount_segments) applied?  Or perhaps with commit 200612e (dm
table: propagate QUEUE_FLAG_NO_SG_MERGE)?

Cheers,
Jeff
