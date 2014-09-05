Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756887AbaIELJc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 07:09:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46947 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756552AbaIELJa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 07:09:30 -0400
Date: Fri, 5 Sep 2014 12:09:27 +0100
From: Mel Gorman <mgorman@suse.de>
To: Milosz Tanski <milosz@adfin.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: read()/readv() only from page cache
Message-ID: <20140905110927.GI17501@suse.de>
References: <CANP1eJGE=vQBdLnMBFPcTWrvh+dUA-UCK=ugO-tc2KN4LWLPSA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <CANP1eJGE=vQBdLnMBFPcTWrvh+dUA-UCK=ugO-tc2KN4LWLPSA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 10:36:33PM -0400, Milosz Tanski wrote:
> After spending some time of my own fighting similar problems I figured
> I'd reach out to see if there's something that can be done that can
> make my use case easier. I was wondering if there is a read family
> syscall that allows me to read from a file descriptor only if the data
> is in the page cache (or only the portion of the data is in the page
> cache).
> 

I suggest you look at the recent fincore debate. It did not progress much
the last time because the author wanted to push a lot of functionality in
there where as reviewers felt it should start simple.  The simple case is
likely a good fit for what you want. The primary downside is that it would
be race-prone in memory pressure situations as the page could be reclaimed
between the fincore check and the read but I expect that your application
is already avoiding reclaim activity.

Depending on your application, fincore is far cheaper than mincore because
mincore requires the file be mapped first which in a threaded application
will crucify performance if called regularly.

Technically nothing would prevent the implementation of an fcntl operation
that returned failure from read() when the page is not in the page
cache. However, the use-case is so specific and Linux-specific that it
would encounter resistance being merged. The likely feedback would be to
implement fincore or explain in detail why fincore is not sufficient which
would be a tough argument to win. You'll get beaten with the "interfaces
are forever and your use case is too specific" stick.

The argument that fincore is an extra syscall is not likely to get much
traction as it'll be pointed out that you are already incurring IPC and
synchronisation overhead. Relative to that, the cost of fincore should
be negligible.

-- 
Mel Gorman
SUSE Labs
