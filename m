Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109AbaI3P2p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 11:28:45 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:35088 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975AbaI3P2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 11:28:44 -0400
Date: Tue, 30 Sep 2014 08:28:40 -0700
From: Christoph Hellwig <hch@infradead.org>
To: David Jeffery <djeffery@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Return short read or 0 at end of a raw device, not EIO
Message-ID: <20140930152840.GA9666@infradead.org>
References: <20140929142110.GA12562@fury.redhat.com>
 <20140929190509.GA2767@infradead.org>
 <5429D84B.7080902@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5429D84B.7080902@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 06:08:11PM -0400, David Jeffery wrote:
> On 09/29/2014 03:05 PM, Christoph Hellwig wrote:
> > Seems like this should be changed in the generic code, or is there some
> > reason why it would return EIO only for devices, but not for regular
> > files in this case?
> > 
> 
> Regular files shouldn't be returning EIO and don't in my tests. The file
> systems manage direct I/O EOF handling in their own block or direct_IO
> callbacks.  Block devices do not and instead do the size checks up
> front.  Raw devices were bypassing the block device check, so only the
> raw driver should be having this issue.

So I guess the problem is commit

"blkdev_aio_read(): switch to generic_file_read_iter(), get rid of iov_shorten()"

which removes the iov_shorten call in blkdev_aio_read?  This should be
mentioned in the changelog.

But maybe we should instead make block devices behave more similar to
regular files in this respect?

Also did you make sure to add your regression test somewhere, e.g. ltp?
