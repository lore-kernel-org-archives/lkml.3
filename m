Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756936AbaIOV70 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 17:59:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50524 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755099AbaIOV7Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 17:59:24 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Milosz Tanski <milosz@adfin.com>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>,
        michael.kerrisk@gmail.com
Subject: Re: [RFC PATCH 0/7] Non-blockling buffered fs read (page cache only)
References: <cover.1410810247.git.milosz@adfin.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 15 Sep 2014 17:58:44 -0400
In-Reply-To: <cover.1410810247.git.milosz@adfin.com> (Milosz Tanski's message
	of "Mon, 15 Sep 2014 16:20:01 -0400")
Message-ID: <x49d2awr1ez.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Milosz,

I CC'd Michael Kerrisk, in case he has any opinions on the matter.

Milosz Tanski <milosz@adfin.com> writes:

> This patcheset introduces an ability to perform a non-blocking read from 
> regular files in buffered IO mode. This works by only for those filesystems
> that have data in the page cache.
>
> It does this by introducing new syscalls new syscalls readv2/writev2 and
> preadv2/pwritev2. These new syscalls behave like the network sendmsg, recvmsg
> syscalls that accept an extra flag argument (O_NONBLOCK).

I thought you were going to introduce a new flag instead of using
O_NONBLOCK for this.  I dug up an old email that suggested that enabling
O_NONBLOCK for regular files (well, a device node in this case) broke a
cd ripping or burning application.  I also found this old bugzilla,
which states that squid would fail to start, and that gqview was also
broken:
  https://bugzilla.redhat.com/show_bug.cgi?id=136057

More generally, do you expect the open(2) of a regular file with
O_NONBLOCK to perform the same way as a pipe, fifo, or device (namely,
that the open itself won't block)?  Should O_NONBLOCK affect writes to
regular files?  What do you think the return value from poll and friends
should be when a file is opened in this manner (probably not important,
as poll always returns data ready on regular files)?  Also consider
whether you want the O_NONBLOCK behaviour for mandatory file locks in
your use case (or any other, for that matter).  If you issue a read and
it returns -EAGAIN, should it be up to the application to kick off I/O
to ensure it makes progress?

I don't think O_NONBLOCK is the right flag.  What you're really
specifying is a flag that prevents I/O in the read path, and nowhere
else.  As such, I'd feel much better about this if we defined a new flag
(O_NONBLOCK_READ maybe?  No, that's too verbose.).

In summary, I like the idea, but I worry about overloading O_NONBLOCK.

Cheers,
Jeff
