Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933245AbaDIMEp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 08:04:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54351 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932592AbaDIMEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 08:04:43 -0400
Date: Wed, 9 Apr 2014 14:04:37 +0200
From: Jan Kara <jack@suse.cz>
To: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, willy@linux.intel.com
Subject: Re: [PATCH v7 06/22] Replace XIP read and write with DAX I/O
Message-ID: <20140409120437.GA7715@quack.suse.cz>
References: <cover.1395591795.git.matthew.r.wilcox@intel.com>
 <3ebe329d8713f7db4c105021a845316a47a29797.1395591795.git.matthew.r.wilcox@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ebe329d8713f7db4c105021a845316a47a29797.1395591795.git.matthew.r.wilcox@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  I've noticed one more thing here:

On Sun 23-03-14 15:08:32, Matthew Wilcox wrote:
....
> +ssize_t dax_do_io(int rw, struct kiocb *iocb, struct inode *inode,
> +		const struct iovec *iov, loff_t offset, unsigned nr_segs,
> +		get_block_t get_block, dio_iodone_t end_io, int flags)
> +{
...
> +	retval = dax_io(rw, inode, iov, offset, end, get_block, &bh);
> +
> +	if ((flags & DIO_LOCKING) && (rw == READ))
> +		mutex_unlock(&inode->i_mutex);
> +
> +	inode_dio_done(inode);
> +
> +	if ((retval > 0) && end_io)
> +		end_io(iocb, offset, retval, bh.b_private);
  In direct IO code, we first call end_io() callback and do
inode_dio_done() only after that. Since filesystems use i_dio_count for
protecting against different races, calling end_io() after inode_dio_done()
can open all sorts of subtle races.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
