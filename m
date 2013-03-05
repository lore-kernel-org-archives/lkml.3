Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603Ab3CEG61 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 01:58:27 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:56455 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099Ab3CEG60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 01:58:26 -0500
X-AuditID: cbfee61b-b7fb06d000000f28-99-51359790868c
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-mm@kvack.org, linaro-mm-sig@lists.linaro.org,
        linux-kernel@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Michal Nazarewicz <mina86@mina86.com>,
        Minchan Kim <minchan@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [RFC/PATCH 0/5] Contiguous Memory Allocator and get_user_pages()
Date: Tue, 05 Mar 2013 07:57:54 +0100
Message-id: <1362466679-17111-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrILMWRmVeSWpSXmKPExsVy+t9jQd2J000DDT7dZbaYs34Nm8XfScfY
	LTbOWM9qcbbpDbvFlysPmSwu75rDZnFvzX9Wi7VH7rJb/D7YyW6x4HgLq8Wyr+/ZHbg9fv+a
	xOjRu/crq8emVZ1sHps+TWL3ODHjN4vH7X+PmT3W/XnF5NG3ZRWjx+dNcgGcUVw2Kak5mWWp
	Rfp2CVwZL1f9ZS94LVKxcdYGtgbG6/xdjJwcEgImEj8+dTFD2GISF+6tZwOxhQSmM0psv6LY
	xcgFZLczSUze/hKsiE3AUKLrbRdYkYhAmMSfxm2sIEXMAseZJP5cXAuWEBbwlOj5do+xi5GD
	g0VAVWJBqxeIySvgITF3nj+IKSGgIDFnks0ERu4FjAyrGEVTC5ILipPSc430ihNzi0vz0vWS
	83M3MYID7pn0DsZVDRaHGAU4GJV4eBmOmgQKsSaWFVfmHmKU4GBWEuEVqzMNFOJNSaysSi3K
	jy8qzUktPsQozcGiJM7LeOpJgJBAemJJanZqakFqEUyWiYNTqoExKMLD/Wv5tF/xCeI7ltms
	5/u7OvC+v7HEvvV7Dlr653wvsXfnWvjCdtcmRQdLq12rmLXfKymZ+P70mtrC6egq9STG1FTy
	8gupFdMvFbgvu5+n3rpf+WbMjP1LrtjuLJ16Tao02r+jfs1DUen5PI98xDz05glMS+pmdpL7
	odDQ33KZoVXAu1WJpTgj0VCLuag4EQBsNMwGNAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Contiguous Memory Allocator is very sensitive about migration failures
of the individual pages. A single page, which causes permanent migration
failure can break large conitguous allocations and cause the failure of
a multimedia device driver.

One of the known issues with migration of CMA pages are the problems of
migrating the anonymous user pages, for which the others called
get_user_pages(). This takes a reference to the given user pages to let
kernel to operate directly on the page content. This is usually used for
preventing swaping out the page contents and doing direct DMA to/from
userspace.

To solving this issue requires preventing locking of the pages, which
are placed in CMA regions, for a long time. Our idea is to migrate
anonymous page content before locking the page in get_user_pages(). This
cannot be done automatically, as get_user_pages() interface is used very
often for various operations, which usually last for a short period of
time (like for example exec syscall). We have added a new flag
indicating that the given get_user_space() call will grab pages for a
long time, thus it is suitable to use the migration workaround in such
cases.

The proposed extensions is used by V4L2/VideoBuf2
(drivers/media/v4l2-core/videobuf2-dma-contig.c), but that is not the
only place which might benefit from it, like any driver which use DMA to
userspace with get_user_pages(). This one is provided to demonstrate the
use case.

I would like to hear some comments on the presented approach. What do
you think about it? Is there a chance to get such workaround merged at
some point to mainline?

Best regards
Marek Szyprowski
Samsung Poland R&D Center


Patch summary:

Marek Szyprowski (5):
  mm: introduce migrate_replace_page() for migrating page to the given
    target
  mm: get_user_pages: use static inline
  mm: get_user_pages: use NON-MOVABLE pages when FOLL_DURABLE flag is
    set
  mm: get_user_pages: migrate out CMA pages when FOLL_DURABLE flag is
    set
  media: vb2: use FOLL_DURABLE and __get_user_pages() to avoid CMA
    migration issues

 drivers/media/v4l2-core/videobuf2-dma-contig.c |    8 +-
 include/linux/highmem.h                        |   12 ++-
 include/linux/migrate.h                        |    5 +
 include/linux/mm.h                             |   76 ++++++++++++-
 mm/internal.h                                  |   12 +++
 mm/memory.c                                    |  136 +++++++++++-------------
 mm/migrate.c                                   |   59 ++++++++++
 7 files changed, 225 insertions(+), 83 deletions(-)

-- 
1.7.9.5

