Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134Ab3KSUGh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 15:06:37 -0500
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:56114 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751821Ab3KSUGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 15:06:36 -0500
From: Thomas Hellstrom <thellstrom@vmware.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: linux-graphics-maintainer@vmware.com
Subject: [PATCH RFC 0/3] Add dirty-tracking infrastructure for non-page-backed address spaces
Date: Tue, 19 Nov 2013 12:06:13 -0800
Message-Id: <1384891576-7851-1-git-send-email-thellstrom@vmware.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Before going any further with this I'd like to check whether this is an
acceptable way to go.
Background:
GPU buffer objects in general and vmware svga GPU buffers in
particular are mapped by user-space using MIXEDMAP or PFNMAP. Sometimes the
address space is backed by a set of pages, sometimes it's backed by PCI memory.
In the latter case in particular, there is no way to track dirty regions
using page_mkwrite() and page_mkclean(), other than allocating a bounce
buffer and perform dirty tracking on it, and then copy data to the real GPU
buffer. This comes with a big memory- and performance overhead.

So I'd like to add the following infrastructure with a callback pfn_mkwrite()
and a function mkclean_mapping_range(). Typically we will be cleaning a range
of ptes rather than random ptes in a vma.
This comes with the extra benefit of being usable when the backing memory of
the GPU buffer is not coherent with the GPU itself, and where we either need
to flush caches or move data to synchronize.

So this is a RFC for
1) The API. Is it acceptable? Any other suggestions if not?
2) Modifying apply_to_page_range(). Better to make a standalone
non-populating version?
3) tlb- mmu- and cache-flushing calls. I've looked at unmap_mapping_range()
and page_mkclean_one() to try to get it right, but still unsure.

Thanks,
Thomas Hellström
