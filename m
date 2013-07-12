Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932555Ab3GLCEG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 22:04:06 -0400
Received: from relay3.sgi.com ([192.48.152.1]:49191 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932414Ab3GLCEF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 22:04:05 -0400
From: Robin Holt <holt@sgi.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>
Cc: Robin Holt <holt@sgi.com>, Nate Zimmer <nzimmer@sgi.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>, Rob Landley <rob@landley.net>,
        Mike Travis <travis@sgi.com>,
        Daniel J Blueman <daniel@numascale-asia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>, Yinghai Lu <yinghai@kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [RFC 0/4] Transparent on-demand struct page initialization embedded in the buddy allocator
Date: Thu, 11 Jul 2013 21:03:51 -0500
Message-Id: <1373594635-131067-1-git-send-email-holt@sgi.com>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have been working on this since we returned from shutdown and have
something to discuss now.  We restricted ourselves to 2MiB initialization
to keep the patch set a little smaller and more clear.

First, I think I want to propose getting rid of the page flag.  If I knew
of a concrete way to determine that the page has not been initialized,
this patch series would look different.  If there is no definitive
way to determine that the struct page has been initialized aside from
checking the entire page struct is zero, then I think I would suggest
we change the page flag to indicate the page has been initialized.

The heart of the problem as I see it comes from expand().  We nearly
always see a first reference to a struct page which is in the middle
of the 2MiB region.  Due to that access, the unlikely() check that was
originally proposed really ends up referencing a different page entirely.
We actually did not introduce an unlikely and refactor the patches to
make that unlikely inside a static inline function.  Also, given the
strong warning at the head of expand(), we did not feel experienced
enough to refactor it to make things always reference the 2MiB page
first.

With this patch, we did boot a 16TiB machine.  Without the patches,
the v3.10 kernel with the same configuration took 407 seconds for
free_all_bootmem.  With the patches and operating on 2MiB pages instead
of 1GiB, it took 26 seconds so performance was improved.  I have no feel
for how the 1GiB chunk size will perform.

I am on vacation for the next three days so I am sorry in advance for
my infrequent or non-existant responses.


Signed-off-by: Robin Holt <holt@sgi.com>
Signed-off-by: Nate Zimmer <nzimmer@sgi.com>
To: "H. Peter Anvin" <hpa@zytor.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Linux MM <linux-mm@kvack.org>
Cc: Rob Landley <rob@landley.net>
Cc: Mike Travis <travis@sgi.com>
Cc: Daniel J Blueman <daniel@numascale-asia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
