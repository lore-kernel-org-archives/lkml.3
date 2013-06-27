Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071Ab3F0Df2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 23:35:28 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:50968 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568Ab3F0Df1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 23:35:27 -0400
Message-ID: <51CBB2F7.3050604@numascale-asia.com>
Date: Thu, 27 Jun 2013 11:35:19 +0800
From: Daniel J Blueman <daniel@numascale-asia.com>
Organization: Numascale Asia
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Mike Travis <travis@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Nathan Zimmer <nzimmer@sgi.com>, holt@sgi.com, rob@landley.net,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        yinghai@kernel.org, Greg KH <gregkh@linuxfoundation.org>,
        x86@kernel.org, linux-doc@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steffen Persvold <sp@numascale.com>
Subject: Re: [RFC] Transparent on-demand memory setup initialization embedded
 in the (GFP) buddy allocator
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 26, 2013 9:30:02 PM UTC+8, Andrew Morton wrote:
 >
 > On Wed, 26 Jun 2013 11:22:48 +0200 Ingo Molnar <mi...@kernel.org> wrote:
 >
 > > except that on 32 TB
 > > systems we don't spend ~2 hours initializing 8,589,934,592 page heads.
 >
 > That's about a million a second which is crazy slow - even my 
prehistoric desktop
 > is 100x faster than that.
 >
 > Where's all this time actually being spent?

The complexity of a directory-lookup architecture to make the 
(intrinsically unscalable) cache-coherency protocol scalable gives you a 
~1us roundtrip to remote NUMA nodes.

Probably a lot of time is spent in some memsets, and RMW cycles which 
are setting page bits, which are intrinsically synchronous, so the 
initialising core can't get to 12 or so outstanding memory transactions.

Since EFI memory ranges have a flag to state if they are zerod (which 
may be a fair assumption for memory on non-bootstrap processor NUMA 
nodes), we can probably collapse the RMWs to just writes.

A normal write will require a coherency cycle, then a fetch and a 
writeback when it's evicted from the cache. For this purpose, 
non-temporal writes would eliminate the cache line fetch and give a 
massive increase in bandwidth. We wouldn't even need a store-fence as 
the initialising core is the only one online.

Daniel
-- 
Daniel J Blueman
Principal Software Engineer, Numascale Asia
