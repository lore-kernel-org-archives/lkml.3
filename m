Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751507AbaGJHIk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 03:08:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51655 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbaGJHIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 03:08:39 -0400
Date: Thu, 10 Jul 2014 00:07:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sebastien Buisson <sebastien.buisson@bull.net>
Cc: Andi Kleen <andi@firstfloor.org>, <viro@zeniv.linux.org.uk>,
        <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Allow increasing the buffer-head per-CPU LRU size
Message-Id: <20140710000745.37be4400.akpm@linux-foundation.org>
In-Reply-To: <53BE37E5.4030407@bull.net>
References: <53B667F9.90306@bull.net>
	<87y4w6sbp7.fsf@tassilo.jf.intel.com>
	<53BA772C.6040506@bull.net>
	<20140707163003.GA18735@two.firstfloor.org>
	<20140707152936.a286b0f46ae1b06aa41c1959@linux-foundation.org>
	<20140707224634.GE18735@two.firstfloor.org>
	<53BB8F7C.1060505@bull.net>
	<53BE37E5.4030407@bull.net>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jul 2014 08:51:17 +0200 Sebastien Buisson <sebastien.buisson@bull.net> wrote:

> Allow increasing the buffer-head per-CPU LRU size to allow efficient
> filesystem operations that access many blocks for each transaction.
> For example, creating a file in a large ext4 directory with quota
> enabled will accesses multiple buffer heads and will overflow the LRU
> at the default 8-block LRU size:
> 
> * parent directory inode table block (ctime, nlinks for subdirs)
> * new inode bitmap
> * inode table block
> * 2 quota blocks
> * directory leaf block (not reused, but pollutes one cache entry)
> * 2 levels htree blocks (only one is reused, other pollutes cache)
> * 2 levels indirect/index blocks (only one is reused)
> 
> The buffer-head per-CPU LRU size can be changed at config time, and its
> default value is raised to 16.

The patch is a performance optimisation but the changelog omits all
mention of the most important part: the magnitude of the performance
improvement.

> --- a/fs/Kconfig
> +++ b/fs/Kconfig
> @@ -268,4 +268,18 @@ endif # NETWORK_FILESYSTEMS
>   source "fs/nls/Kconfig"
>   source "fs/dlm/Kconfig"
> 
> +config BH_LARGE_LRU
> +      def_bool y
> +      depends on (EXT4_FS && QUOTA)
> +
> +config BH_LRU_SIZE
> +      int
> +      range 8 64
> +      default "16" if BH_LARGE_LRU
> +      default "8" if !BH_LARGE_LRU
> +      help
> +        This sets the per-CPU LRU size for buffer heads in memory.
> +        More complex filesystems may be modifying multiple blocks
> +        within a single transaction, so keeping the buffer heads in
> +        CPU-local cache speeds up modifications significantly.

This hardwires 16 if ext4&quota and 8 otherwise.  There's no way for
anyone to alter this decision if they think it will be helpful (or
harmful) in their setup.

>   endmenu
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 6024877..b83fa63 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -1255,8 +1255,7 @@ static struct buffer_head *__bread_slow(struct 
> buffer_head *bh)

Your email client is wordwrapping the patches btw.  And it replaces
tabs with spaces.

