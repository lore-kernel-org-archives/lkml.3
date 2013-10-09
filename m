Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757363Ab3JIRgZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 13:36:25 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:33996 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059Ab3JIRgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 13:36:21 -0400
Date: Wed, 9 Oct 2013 18:36:16 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH v2 1/2] anon_inodes: allow external inode allocations
Message-ID: <20131009173616.GI13318@ZenIV.linux.org.uk>
References: <1380713066-32519-1-git-send-email-dh.herrmann@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380713066-32519-1-git-send-email-dh.herrmann@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 02, 2013 at 01:24:25PM +0200, David Herrmann wrote:
> DRM core shares a single address_space across all inodes that belong to
> the same DRM device. This allows efficient unmapping of user-space
> mappings during buffer eviction. However, there is no easy way to get a
> shared address_space for DRM devices during initialization. Therefore, we
> currently delay this step until the first ->open() and save the given
> inode for future use.
> 
> This causes ugly delayed initialization throughout the DRM core. TTM
> devices end up without a dev_mapping pointer and we have to carefully
> respect any underlying filesystem implementation so we don't corrupt the
> inode->i_mapping and inode->i_data fields.
> 
> We can avoid this if we were allowed to allocate an anonymous inode for
> each DRM device. We only have to set file->f_mapping during ->open()
> and no longer need to adjust inode mappings. As fs/anon_inodes.c already
> provides a minimal internal FS mount, we extend it to also provide
> anonymous inodes for use in drivers like DRM.
> 
> Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
> Wanted-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Told-to-stop-abusing-anon_inodes-by: Al Viro <viro@zeniv.linux.org.uk>

Note that anon_inode_getfile_private() is not going to survive - for exact
same reasons.  It's already removed in vfs.git#experimental, shortly in
#for-next as well.  Do NOT extend fs/anon_inodes.c; if you need a minimal
internal fs mount, just do what fs/aio.c does in the same branch.
