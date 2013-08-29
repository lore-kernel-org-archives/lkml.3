Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965Ab3H2PlN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 11:41:13 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:39256 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754814Ab3H2PlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 11:41:11 -0400
Date: Thu, 29 Aug 2013 17:41:10 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: Maxim Patlasov <MPatlasov@parallels.com>
Cc: fuse-devel@lists.sourceforge.net, bfoster@redhat.com, xemul@parallels.com,
        linux-kernel@vger.kernel.org, devel@openvz.org
Subject: Re: [PATCH 2/2] fuse: wait for writeback in fuse_file_fallocate() -v2
Message-ID: <20130829154110.GB19636@tucsk.piliscsaba.szeredi.hu>
References: <20130812163935.10366.88320.stgit@maximpc.sw.ru>
 <20130816112854.5630.1907.stgit@maximpc.sw.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130816112854.5630.1907.stgit@maximpc.sw.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 16, 2013 at 03:30:27PM +0400, Maxim Patlasov wrote:
> The patch fixes a race between mmap-ed write and fallocate(PUNCH_HOLE):
> 
> 1) An user makes a page dirty via mmap-ed write.
> 2) The user performs fallocate(2) with mode == PUNCH_HOLE|KEEP_SIZE
>    and <offset, size> covering the page.
> 3) Before truncate_pagecache_range call from fuse_file_fallocate,
>    the page goes to write-back. The page is fully processed by fuse_writepage
>    (including end_page_writeback on the page), but fuse_flush_writepages did
>    nothing because fi->writectr < 0.
> 4) truncate_pagecache_range is called and fuse_file_fallocate is finishing
>    by calling fuse_release_nowrite. The latter triggers processing queued
>    write-back request which will write stale data to the hole soon.
> 
> Changed in v2 (thanks to Brian for suggestion):
>  - Do not truncate page cache until FUSE_FALLOCATE succeeded. Otherwise,
>    we can end up in returning -ENOTSUPP while user data is already punched
>    from page cache. Use filemap_write_and_wait_range() instead.

The problem with fuse_wait_on_writeback() is starvation.  You could have the
page range continually being dirtied and written back and fallocate() livelocked
in fuse_wait_on_writeback() for ever AFAICS.

So having a barrier like FUSE_NOWRITE is good but then we need to take care of
throwing away the truncated part of the queue.  But that should be doable by
passing the truncated range explicitly to fuse_release_nowrite().

Thanks,
Miklos
