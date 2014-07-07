Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751723AbaGGW3j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 18:29:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54460 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbaGGW3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 18:29:38 -0400
Date: Mon, 7 Jul 2014 15:29:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Sebastien Buisson <sebastien.buisson@bull.net>, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Allow increasing the buffer-head per-CPU LRU size
Message-Id: <20140707152936.a286b0f46ae1b06aa41c1959@linux-foundation.org>
In-Reply-To: <20140707163003.GA18735@two.firstfloor.org>
References: <53B667F9.90306@bull.net>
	<87y4w6sbp7.fsf@tassilo.jf.intel.com>
	<53BA772C.6040506@bull.net>
	<20140707163003.GA18735@two.firstfloor.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jul 2014 18:30:03 +0200 Andi Kleen <andi@firstfloor.org> wrote:

> > diff --git a/fs/Kconfig b/fs/Kconfig
> > index c229f82..c08844c 100644
> > --- a/fs/Kconfig
> > +++ b/fs/Kconfig
> > @@ -268,4 +268,13 @@ endif # NETWORK_FILESYSTEMS
> >  source "fs/nls/Kconfig"
> >  source "fs/dlm/Kconfig"
> > 
> > +config BH_LRU_SIZE
> > +      int
> > +      range 8 64
> > +      default "16"
> 
> So who sets it then? 
> 
> You need it for ext4 and quota right? So this combination
> should set it at least. Something like (unested)
> 
> It would be also good to audit or test other file systems if they need the
> same if that's possible.
> 
> config BH_LARGE_LRU
> 	bool
> 	depends on (EXT4_FS && QUOTA)
> 
> config BH_LRU_SIZE
> ....
> 	default "16" if BH_LARGE_LRU
> 	default "8" if !BH_LARGE_LRU

Can anyone demonstrate why we shouldn't just do

--- a/fs/buffer.c~a
+++ a/fs/buffer.c
@@ -1258,7 +1258,7 @@ static struct buffer_head *__bread_slow(
  * a local interrupt disable for that.
  */
 
-#define BH_LRU_SIZE	8
+#define BH_LRU_SIZE	16
 
 struct bh_lru {
 	struct buffer_head *bhs[BH_LRU_SIZE];
_

