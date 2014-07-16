Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965356AbaGPPT0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 11:19:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26695 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965284AbaGPPTW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 11:19:22 -0400
Date: Wed, 16 Jul 2014 11:19:15 -0400
From: Don Zickus <dzickus@redhat.com>
To: JBeulich@suse.com, mmarek@suse.cz
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: genksyms: separating public headers from private header files
Message-ID: <20140716151915.GS7959@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan, Michal,

I am not sure who maintains genksyms officially, so I am sending this
question to the two of you as folks who seemed to have contributed to the
tool. :-)

I noticed with genksyms that a symbol is opaquely defined in a
public header file (on purpose) and then fully defined in a private
header.  This is normal practice.  Further, symbol checksumming is done on
EXPORT_SYMBOLs in a private c file that includes the private header
files.

As a result, even though a struct symbol is intentionally opaquely defined
in a public header file consumed by a third party module, the symbol
checksumming still includes the full definition (because the private c
file with the actual export symbol has the full definition).  This has
made it difficult to modify the private header file struct because it
breaks the symbol checksumming.

For example, let's consider

block/blk-core.c:EXPORT_SYMBOL(blk_put_queue);

blk_put_queue will eventually depend on struct blkcq_gq.

Now publicly blkcg_gq is defined opaquely in 

include/linux/blkdev.h

and privately in

block/block-cgroup.h

Now when we checksum blk_put_queue both include/linux/blkdev.h and
block/block-cgroup.h are included in block/blk-core.c, so blkcg_gq is
fully defined for checksumming.

Later if we modify blkcq_gq in block/block-cgroup.h the checksum changes,
even though it can debated that block-cgroup.h is a private header file
and it should not impact kabi for third party modules.

Have either of you run into this?  Or is the argument that private files
should not impact the checksum not as strong as I might think?  Or is it a
technical problem of how to separate the public includes from the private
includes in the preprocessed file?

Thanks!

Cheers,
Don

