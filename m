Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751772AbaIXTRc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 15:17:32 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40563 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbaIXTRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 15:17:31 -0400
Date: Wed, 24 Sep 2014 20:17:27 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: NeilBrown <neilb@suse.de>
Cc: Tejun Heo <tj@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernfs: use stack-buf for small writes.
Message-ID: <20140924191727.GG7996@ZenIV.linux.org.uk>
References: <20140923140633.35efbe7a@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140923140633.35efbe7a@notabene.brown>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 02:06:33PM +1000, NeilBrown wrote:
> 
> For a write <= 128 characters, don't use kmalloc.
> 
> mdmon, part of mdadm, will sometimes need to write
> to a sysfs file in order to allow writes to the array
> to continue.  This is important to support RAID metadata
> types that the kernel doesn't know about.
> 
> It is important that this write doesn't block on
> memory allocation.  The safest way to ensure that is to
> use an on-stack buffer.

Is it, now?  What happens if caller of write(2) loses CPU and gets
the page it's writing from swapped out, just as it's getting to
issuing the actual syscall?  copy_from_user() will fault and cause
memory allocation for you...

> Writes are always small, typically less than 10 characters.

Translation: "but my userland code uses it _that_ way; surely, nobody
would do anything else..."
