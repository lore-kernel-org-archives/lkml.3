Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328Ab3KKPRO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 10:17:14 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:41582 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753598Ab3KKPRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 10:17:07 -0500
Date: Mon, 11 Nov 2013 15:17:04 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Thomas Hellstrom <thellstrom@vmware.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC RESEND] dma-buf/fs Add
 get_[file|dma_buf]_unless_doomed
Message-ID: <20131111151704.GX13318@ZenIV.linux.org.uk>
References: <1384160267-3389-1-git-send-email-thellstrom@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384160267-3389-1-git-send-email-thellstrom@vmware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 11, 2013 at 12:57:47AM -0800, Thomas Hellstrom wrote:
> Resending since it appears this RFC never got to the dri-devel lkml lists.
> 
> In this context, a "doomed" object is an object whose refcount has reached
> zero, but that has not yet been freed.
> 
> To avoid mutual refcounting vmwgfx need to have a non-refcounted pointer to
> a dma-buf in a lookup structure. The pointer is removed in the dma-buf
> destructor. To allow lookup-structure private locks we need
> get_dma_buf_unless_doomed(). This common refcounting scenario is described
> with examples in detail in the kref documentaion.
> The solution with local locks is under kref_get_unless_zero().
> See also kobject_get_unless_zero() and its commit message.
> Since dma-bufs are using the attached file for refcounting,
> get_dma_buf_unless_doomed maps directly to a get_file_unless_doomed.

NAK for struct file.  This kind of stuff is for implementing primitives,
not as a public API.  BTW, as for dmabuf...  dma_buf_fd() calling conventions
are seriously misguided - we are trying to transfer the reference we hold
into something (in this case - descriptor table), so the failure exit
should be dropping the reference, not leaving that to caller.
