Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169Ab3CET7v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 14:59:51 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:57958 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748Ab3CET7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 14:59:50 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [RFC/PATCH 0/5] Contiguous Memory Allocator and get_user_pages()
Date: Tue, 5 Mar 2013 19:59:35 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-8-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-mm@kvack.org, linaro-mm-sig@lists.linaro.org,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Michal Nazarewicz <mina86@mina86.com>,
        Minchan Kim <minchan@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
References: <1362466679-17111-1-git-send-email-m.szyprowski@samsung.com> <201303050850.26615.arnd@arndb.de> <5135F77C.9060706@samsung.com>
In-Reply-To: <5135F77C.9060706@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201303051959.35471.arnd@arndb.de>
X-Provags-ID: V02:K0:SyhrhZA9ToZhPcz2mdZhukDb8turkJGFwC9lNxb9rxT
 EZesizQTFuSpwsw91eZZ8xtUAQa2Y+81abTR6Je37sCbdG10Ls
 HFjo/EnLam21q6I3T7irRO13wGM1kLQo0/RRVeApADnrBm6B3N
 XbgLP40X4xj2D+NqBvepfwpMaSLyzIMEXv481YNMNFwrBJRMAh
 X3TFZYJ0hRZcmr9aBaVkkGH1UTDM6HyjHzKC7N1cDFDxHw7Gyz
 5H2FvfXpsORoT/aBa6guYtRHmmqNFICvUJ0ahurd/F8DYic+B6
 Jd6ZMemdggIE0pyxUI48ZIsl+TwsSfU0YpwlbJks9HatsEVWLF
 AhkB5dSe6waZY68PRGkE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 March 2013, Marek Szyprowski wrote:
> On 3/5/2013 9:50 AM, Arnd Bergmann wrote:
> > On Tuesday 05 March 2013, Marek Szyprowski wrote:
> 
> The problem is that the opposite approach is imho easier.

I can understand that, yes ;-)

> get_user_pages()
> is used in quite a lot of places (I was quite surprised when I've added some
> debug to it and saw the logs) and it seems to be easier to identify places
> where references are kept for significant amount of time. Usually such 
> places
> are in the device drivers. In our case only videobuf2 and some closed-source
> driver were causing the real migration problems, so I decided to leave the
> default approach unchanged.
> 
> If we use this workaround for every get_user_pages() call we will sooner or
> later end with most of the anonymous pages migrated to non-movable 
> pageblocks
> what make the whole CMA approach a bit pointless.

But you said that most users are in device drivers, and I would expect drivers
not to touch that many pages.

We already have two interfaces: the generic get_user_pages and the "fast" version
"get_user_pages_fast" that has a number of restrictions. We could add another
such restriction to get_user_pages_fast(), which is that it must not hold
the page reference count for an extended time because it will not migrate
pages out.

I would assume that most of the in-kernel users of get_user_pages() that
are called a lot either already use get_user_pages_fast, or can be easily
converted to it.

	Arnd
