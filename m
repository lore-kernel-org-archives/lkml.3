Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757226AbaFYWQl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 18:16:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48473 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756043AbaFYWQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 18:16:39 -0400
Date: Wed, 25 Jun 2014 15:16:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sebastien Buisson <sebastien.buisson@bull.net>
Cc: <rob@landley.net>, <viro@zeniv.linux.org.uk>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] Allow increasing the buffer-head per-CPU LRU size
Message-Id: <20140625151638.00b7c2aa29f79f63dce7ae56@linux-foundation.org>
In-Reply-To: <53A99EA0.3010800@bull.net>
References: <53A99EA0.3010800@bull.net>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jun 2014 17:52:00 +0200 Sebastien Buisson <sebastien.buisson@bull.net> wrote:

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
> Make this tuning be a kernel parameter 'bh_lru_size'.

I don't think it's a great idea to make this a boot-time tunable.  It's
going to take a ton of work by each and every kernel
user/installer/distributor to work out what is the best setting for
them.  And the differences will be pretty small anyway.  And we didn't
provide them with any documentation to help them even get started with
the project.

Other approaches: 

- Perform some boot-time auto-sizing, perhaps based on memory size,
  cpu counts, etc.

  None of which will be very successful, because the LRU miss rate is
  dependent on filesystem type and usage, not on system size.

- Perform some runtime resizing: if the miss rate gets "too high"
  then increase the LRU size.  Maybe decrease it as well, or maybe not.

  This will get more complex and we'd require decent improvements to
  justify the change.

- Just increase BH_LRU_SIZE to 16!

I think the third option should be the first choice.  It doesn't get
simpler than that and any more complex option would need additional
testing-based justification on top of this simplest approach.


I'm amused that my dopey-but-simple LRU management code has survived
these 12-odd years.  I suspect that if the LRUs get much larger, we'll
be needing something less dopey and simple in there.

It's good to see (indirect) evidence that the LRUs are actually doing
something useful.
