Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619Ab3KDXgk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 18:36:40 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:33828 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451Ab3KDXgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 18:36:38 -0500
From: Kent Overstreet <kmo@daterainc.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Cc: axboe@kernel.dk, hch@infradead.org
Subject: [PATCH] Block layer stuff/DIO rewrite prep for 3.14
Date: Mon,  4 Nov 2013 15:36:18 -0800
Message-Id: <1383608187-27368-1-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.8.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that immutable biovecs is in, these are the remaining patches required for
my DIO rewrite, along with some related cleanup/refactoring.

The key enabler is patch 4 - making generic_make_request() handle arbitary sized
bios. This takes what was once bio_add_page()'s responsibility and pushes it
down; long term plan is to hopefully push this down to the driver level, which
should simplify a lot of code (a lot of it very fragile code!) and improve
performance at the same time.

The DIO rewrite needs some more work before it'll be ready, but I wanted to get
this patch series out because this stuff should all be ready and it's useful for
other reasons - I think this stuff will make it a lot easier for the btrfs
people to do what they need with their DIO code.

Other stuff enabled by this:

 * With this and the bio_split() rewrite already in, we can just delete
   merge_bvec_fn. I have patches for this, but they'll need more testing.

 * Multipage bvecs - bvecs pointing to an arbitrary amount of contiguous
   physical memory. I have this working but it'll need more testing and code
   auditing - this is what lets us kill bi_seg_front_size and bi_seg_back_size
   though.

Patch series is based on Jens' for-next tree, and it's available in my git
repository - git://evilpiepirate.org/~kent/linux-bcache.git for-jens

