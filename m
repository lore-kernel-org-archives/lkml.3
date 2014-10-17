Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751589AbaJQJik (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 05:38:40 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:60123 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbaJQJij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 05:38:39 -0400
Date: Fri, 17 Oct 2014 02:38:36 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Josh Boyer <jwboyer@fedoraproject.org>, linux-fsdevel@vger.kernel.org,
        Eric Sandeen <sandeen@redhat.com>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        viro@ZenIV.linux.org.uk, xfs@oss.sgi.com
Subject: Re: splice read/write pipe lock ordering issues (was Re: XFS lockdep
 with Linux v3.17-5503-g35a9ad8af0bb)
Message-ID: <20141017093836.GB9146@infradead.org>
References: <CA+5PVA4FqAUXbtTtC-hZnAaw=869kfrAjM1vRrqcP=zgveAKJg@mail.gmail.com>
 <20141016221434.GF7169@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141016221434.GF7169@dastard>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2014 at 09:14:34AM +1100, Dave Chinner wrote:
> That smells like a splice architecture bug. splice write puts the
> pipe lock outside the inode locks, but splice read puts the pipes
> locks *inside* the inode locks.
> 
> The recent commit 8d02076 "(->splice_write() via ->write_iter()")
> which went into 3.16 will be what is causing this. It replaced a
> long standing splice lock inversion problem (XFS iolock vs i_mutex
> http://oss.sgi.com/archives/xfs/2011-08/msg00122.html) by moving
> to a ->write_iter call under the pipe_lock.
> 
> Only XFS reports this issue because XFS is the only filesystem that
> serialises splice reads against truncate, concurrent writes into the
> same region, extent manipulation functions via fallocate() (e.g.
> hole punch), etc. and it does so via the inode iolock that it takes
> in shared (read) mode during xfs_file_splice_read().

Actually ocfs2 and nfs will have the same issue.

