Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892AbaJJRRy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 13:17:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22974 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751264AbaJJRRv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 13:17:51 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: David Jeffery <djeffery@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Return short read or 0 at end of a raw device, not EIO
References: <20140929142110.GA12562@fury.redhat.com>
	<20140929190509.GA2767@infradead.org> <5429D84B.7080902@redhat.com>
	<20140930152840.GA9666@infradead.org> <542ADC33.2040804@redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 10 Oct 2014 13:17:28 -0400
In-Reply-To: <542ADC33.2040804@redhat.com> (David Jeffery's message of "Tue,
	30 Sep 2014 12:37:07 -0400")
Message-ID: <x49fvevkfo7.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Jeffery <djeffery@redhat.com> writes:

> On 09/30/2014 11:28 AM, Christoph Hellwig wrote:
>> On Mon, Sep 29, 2014 at 06:08:11PM -0400, David Jeffery wrote:
>>> On 09/29/2014 03:05 PM, Christoph Hellwig wrote:
>>>> Seems like this should be changed in the generic code, or is there some
>>>> reason why it would return EIO only for devices, but not for regular
>>>> files in this case?
>>>>
>>>
>>> Regular files shouldn't be returning EIO and don't in my tests. The file
>>> systems manage direct I/O EOF handling in their own block or direct_IO
>>> callbacks.  Block devices do not and instead do the size checks up
>>> front.  Raw devices were bypassing the block device check, so only the
>>> raw driver should be having this issue.
>> 
>> So I guess the problem is commit
>> 
>> "blkdev_aio_read(): switch to generic_file_read_iter(), get rid of iov_shorten()"
>> 
>> which removes the iov_shorten call in blkdev_aio_read?  This should be
>> mentioned in the changelog.
>> 
>> But maybe we should instead make block devices behave more similar to
>> regular files in this respect?
>
> The issue's origin should be with bbec0270bdd8 "blkdev_max_block: make
> private to fs/buffer.c".  This change intentionally removed the size
> checks from blkdev_get_block() to avoid issues with the size variables
> changing underneath the calls.  Commit 684c9aaebbb0 is the initial
> commit to add the size checks with blkdev_aio_read() since
> blkdev_get_block() no longer checks size.  As the raw driver was also
> dependent on the size checks in blkdev_get_block(), it was broken by
> bbec0270bdd8 but not fixed at all by 684c9aaebbb0.
>
>> 
>> Also did you make sure to add your regression test somewhere, e.g. ltp?
>> 
>
> No I have not.  I'll see about an ltp test.

Christoph, do you have any issues with the patch as it stands?  Whose
tree do you think this should go through?  akpm's?

Cheers,
Jeff
