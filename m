Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758606AbaELOq3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 10:46:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55300 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751839AbaELOq1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 10:46:27 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Jens Axboe <axboe@fb.com>
Cc: <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, <linux-mm@kvack.org>
Subject: Re: [PATCH] Avoid always dirtying mapping->flags on O_DIRECT
References: <20140509213907.GA20698@kernel.dk>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 12 May 2014 10:46:19 -0400
In-Reply-To: <20140509213907.GA20698@kernel.dk> (Jens Axboe's message of "Fri,
	9 May 2014 15:39:07 -0600")
Message-ID: <x49r43z837o.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <axboe@fb.com> writes:

> Hi,
>
> In some testing I ran today, we end up spending 40% of the time in
> filemap_check_errors(). That smells fishy. Looking further, this is
> basically what happens:
>
> blkdev_aio_read()
>     generic_file_aio_read()
>         filemap_write_and_wait_range()
>             if (!mapping->nr_pages)
>                 filemap_check_errors()
>
> and filemap_check_errors() always attempts two test_and_clear_bit() on
> the mapping flags, thus dirtying it for every single invocation. The
> patch below tests each of these bits before clearing them, avoiding this
> issue. In my test case (4-socket box), performance went from 1.7M IOPS
> to 4.0M IOPS.

It might help to use the word cacheline somewhere in here.  ;-) Out of
curiosity, what workload were you running?

Acked-by: Jeff Moyer <jmoyer@redhat.com>
