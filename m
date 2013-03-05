Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919Ab3CENrq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 08:47:46 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:23988 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467Ab3CENrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 08:47:45 -0500
X-AuditID: cbfec7f4-b7f4c6d0000018de-3d-5135f77ebdf6
Message-id: <5135F77C.9060706@samsung.com>
Date: Tue, 05 Mar 2013 14:47:40 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130215
 Thunderbird/17.0.3
MIME-version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-mm@kvack.org, linaro-mm-sig@lists.linaro.org,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Michal Nazarewicz <mina86@mina86.com>,
        Minchan Kim <minchan@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [RFC/PATCH 0/5] Contiguous Memory Allocator and get_user_pages()
References: <1362466679-17111-1-git-send-email-m.szyprowski@samsung.com>
 <201303050850.26615.arnd@arndb.de>
In-reply-to: <201303050850.26615.arnd@arndb.de>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphluLIzCtJLcpLzFFi42I5/e/4Nd2676aBBhOPa1pc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MO52H2Asu8FbMWWvXwPiZq4uRk0NCwETi78ujbBC2mMSFe+uB
	bC4OIYGljBKPPsxlh3CWMElMerecFaSKV0BLYsW++ewgNouAqsSWb6vB4mwChhJdb7vAJokK
	hEo8er2dEaJeUOLH5HssILaIgKLE1BfPmEGGMgucZZKYvL4NbJCwgK/ErSvbmUBsIYFciRs/
	28EGcQroS7z/sBVsAbOAmcSjlnXMELa8xOY1b5knMArMQrJjFpKyWUjKFjAyr2IUTS1NLihO
	Ss811CtOzC0uzUvXS87P3cQICcEvOxgXH7M6xCjAwajEw8tw1CRQiDWxrLgy9xCjBAezkghv
	6AfTQCHelMTKqtSi/Pii0pzU4kOMTBycUg2MTrUTv75I+FC8487ThdGqC2uYn8m922xxIJnz
	ntW3lp5Q/WiFrB5l95lh/kWRs7hZnsa8C7LNzs2un+w6bV7XAuPk5uosG/2upW1TVr1L3ODp
	pXYmsvI6/zk/vrm+Qv/45M7cvZ95fN5RxZMrQtcqnmQMfODAWbbEKTlsAZfHdqsSV9u4OU+V
	WIozEg21mIuKEwHj2NCJHwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 3/5/2013 9:50 AM, Arnd Bergmann wrote:
> On Tuesday 05 March 2013, Marek Szyprowski wrote:
> > To solving this issue requires preventing locking of the pages, which
> > are placed in CMA regions, for a long time. Our idea is to migrate
> > anonymous page content before locking the page in get_user_pages(). This
> > cannot be done automatically, as get_user_pages() interface is used very
> > often for various operations, which usually last for a short period of
> > time (like for example exec syscall). We have added a new flag
> > indicating that the given get_user_space() call will grab pages for a
> > long time, thus it is suitable to use the migration workaround in such
> > cases.
>
> Can you explain the tradeoff here? I would have expected that the default
> should be to migrate pages out, and annotate the instances that we know
> are performance critical and short-lived. That would at least appear
> more reliable to me.

The problem is that the opposite approach is imho easier. get_user_pages()
is used in quite a lot of places (I was quite surprised when I've added some
debug to it and saw the logs) and it seems to be easier to identify places
where references are kept for significant amount of time. Usually such 
places
are in the device drivers. In our case only videobuf2 and some closed-source
driver were causing the real migration problems, so I decided to leave the
default approach unchanged.

If we use this workaround for every get_user_pages() call we will sooner or
later end with most of the anonymous pages migrated to non-movable 
pageblocks
what make the whole CMA approach a bit pointless.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


