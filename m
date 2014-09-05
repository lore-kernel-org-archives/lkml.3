Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223AbaIEQDA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 12:03:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6699 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051AbaIEQC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 12:02:59 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>, Milosz Tanski <milosz@adfin.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Volker Lendecke <Volker.Lendecke@SerNet.DE>, Tejun Heo <tj@kernel.org>,
        linux-aio@kvack.org
Subject: Re: read()/readv() only from page cache
References: <CANP1eJGE=vQBdLnMBFPcTWrvh+dUA-UCK=ugO-tc2KN4LWLPSA@mail.gmail.com>
	<20140905110927.GI17501@suse.de>
	<20140905154829.GA22956@infradead.org>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 05 Sep 2014 12:02:19 -0400
In-Reply-To: <20140905154829.GA22956@infradead.org> (Christoph Hellwig's
	message of "Fri, 5 Sep 2014 08:48:29 -0700")
Message-ID: <x49r3zqxdh0.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@infradead.org> writes:

> On Fri, Sep 05, 2014 at 12:09:27PM +0100, Mel Gorman wrote:
>> I suggest you look at the recent fincore debate. It did not progress much
>> the last time because the author wanted to push a lot of functionality in
>> there where as reviewers felt it should start simple.  The simple case is
>> likely a good fit for what you want. The primary downside is that it would
>> be race-prone in memory pressure situations as the page could be reclaimed
>> between the fincore check and the read but I expect that your application
>> is already avoiding reclaim activity.
>
> I've actually experimentally hacked up O_NONBLOCK support for regular
> files so that it only returns data from the page cache, and not
> otherwise.  Volker promised to test it with Samba, but we never made
> any progress on it, and just last week a customer told me they would
> have liked to use it if it was available.
>
> Note that we might want to also avoid blocking on locks, and I have some
> vague memory that we shouldn't actually implement O_NONBLOCK on regular
> files due to compatibility options but would have to use a new flag
> instead.

FWIW, here's a discussion from an old attempt at O_NONBLOCK for regular
files:
  http://www.gossamer-threads.com/lists/linux/kernel/477936?do=post_view_threaded#477936

I recall it blowing up in various situations, so yeah, a new flag would
be a good idea.

> Note that mincor/fincore would not help for the usual use case where you
> have a non blocking event main loop and want to offload actual blocking
> I/O to helper threads, as you it returns information that can be stale
> any time.
>
> One further consideration would be to finally implement real buffered
> I/O in kernel space by something like the above and offloading to
> workqueues in kernelspace.  I think our workqueues now are way better
> than any possible user thread pool, although we'd need to find a way to
> temporarily tie the work threads to a user address space.

Do you mean real buffered AIO?

Cheers,
Jeff
