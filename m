Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131AbbAWRGc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 12:06:32 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:42999 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755895AbbAWRG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 12:06:28 -0500
Date: Fri, 23 Jan 2015 09:06:27 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Andy Falanga (afalanga)" <afalanga@micron.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-scsi@vger.kernel.org, Doug Gilbert <dgilbert@interlog.com>
Subject: Re: block layer copying user io vectors
Message-ID: <20150123170627.GA8652@infradead.org>
References: <60F6FAE47D1BCE4380CC06D18F49789B952F7ED3@NTXBOIMBX02.micron.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <60F6FAE47D1BCE4380CC06D18F49789B952F7ED3@NTXBOIMBX02.micron.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 09:33:08PM +0000, Andy Falanga (afalanga) wrote:
> Please CC me directly.
> 
> I am working in kernel 2.6.32 (CentOS 6).  To increase the upper limit
> of sg from 4mb to at least 128mb in a single SCSI command.  At first I
> thought this issue was in sg, but have tracked the issue to the block
> layer.

2.6.32 is fairly old, but fortunately for you not too many things should
have changed in this area.

> 
> Thinking I could solve this issue by using scatter/gather lists, I
> increased the size from 32k to 4mb of each vector.  This did work
> until I tried to send 8mb.  When I do so, I get errno EINVAL.  After
> some tracing, I tracked the problem into bio_copy_user_iov().
> 
> This function does something that seems rather strange.  On line 859,
> a for loop determines the number of pages needed for the copying of the
> user data to kernel space.  Then the memory is allocated (line
> 886 bio_kmalloc()).  Then, strangely, on line 895, there is this
> conditional:

This is because the function can also be used with preallocated pages,
a feature only used by the sg and tape drivers.

Make sure your user memory is 4k aligned, and you should be able
to avoid the copy entirely (1).

(1) except that the sg driver disables the direct mapping of user pages
    when using readv/writev.  I can't really see why and it should be
    fixable by just removign that condition from the if in sg_start_req.
    Alternatively use the SG_IO ioctl directly on the disk device node,
    which neither has the read/writev limitation, nor does it use
    a fixed upper bound preallocated page pool.

> 
> if (map_data) {
>     nr_pages = 1 << map_data->page_order;
>     i = map_data->offset / PAGE_SIZE;
> }
> 
> This effectively ignores the number of pages counted earlier (in this
> case which applies to me), and then apparently disregards whatever
> memory may have been allocated earlier.  Thinking that this was the
> root I tried to correct this by commenting that simple branch from
> bio_copy_user_iov, but still had the same result.  Can someone
> help me understand what is happening in the block layer?
