Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758Ab3AKCBU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 21:01:20 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34002 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594Ab3AKCBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 21:01:19 -0500
Subject: Re: 3.8-rc2/rc3 write() blocked on CLOSE_WAIT TCP socket
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Eric Wong <normalperson@yhbt.net>
Cc: netdev@vger.kernel.org, Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20130111004915.GA15415@dcvr.yhbt.net>
References: <20130111004915.GA15415@dcvr.yhbt.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Jan 2013 18:01:15 -0800
Message-ID: <1357869675.27446.2962.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-01-11 at 00:49 +0000, Eric Wong wrote:
> The below Ruby script reproduces the issue for me with write()
> getting stuck, usually with a few iterations (sometimes up to 100).
> 
> I've reproduced this with 3.8-rc2 and rc3, even with Mel's partial
> revert patch in <20130110194212.GJ13304@suse.de> applied.
> 
> I can not reproduce this with 3.7.1+
>    stable-queue 2afd72f59c518da18853192ceeebead670ced5ea
> So this seems to be a new bug from the 3.8 cycle...
> 
> Fortunately, this bug far easier for me to reproduce than the ppoll+send
> (toosleepy) failures.
> 
> Both socat and ruby (Ruby 1.8, 1.9, 2.0 should all work), along with
> common shell tools (dd, sh, cat) are required for testing this:
> 
> 	# 100 iterations, raise/lower the number if needed
> 	ruby the_script_below.rb 100
> 
> lsof -p 15236 reveals this:
> ruby    15236   ew    5u  IPv4  23066      0t0     TCP localhost:33728->localhost:38658 (CLOSE_WAIT)

Hmm, it might be commit c3ae62af8e755ea68380fb5ce682e60079a4c388
tcp: should drop incoming frames without ACK flag set

It seems RST should be allowed to not have ACK set.

I'll send a fix, thanks !





