Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751557AbaLPIfu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 03:35:50 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:35885 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaLPIfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 03:35:48 -0500
Date: Tue, 16 Dec 2014 00:35:43 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Omar Sandoval <osandov@osandov.com>
Cc: Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        David Sterba <dsterba@suse.cz>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] swap: lock i_mutex for swap_writepage direct_IO
Message-ID: <20141216083543.GA32425@infradead.org>
References: <cover.1418618044.git.osandov@osandov.com>
 <a59510f4552a5d3557958cdb0ce1b23b3abfc75b.1418618044.git.osandov@osandov.com>
 <20141215162705.GA23887@quack.suse.cz>
 <20141215165615.GA19041@infradead.org>
 <20141215221100.GA4637@mew>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141215221100.GA4637@mew>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2014 at 02:11:00PM -0800, Omar Sandoval wrote:
> Ok, I got the swap code working with ->read_iter/->write_iter without
> too much trouble. I wanted to double check before I submit if there's
> any gotchas involved with adding the O_DIRECT flag to a file pointer
> after it has been opened -- swapon opens the swapfile before we know if
> we're using the SWP_FILE infrastructure, and we need to add O_DIRECT so
> ->{read,write}_iter use direct I/O, but we can't add O_DIRECT to the
> original open without excluding filesystems that support the old bmap
> path but not direct I/O.

In general just adding O_DIRECT is a problem.  However given that the
swap file is locked against any other access while in use it seems ok
in this particular case.  Just make sure to clear it on swapoff, and
write a detailed comment explaining the situation.
