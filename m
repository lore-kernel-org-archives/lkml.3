Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822Ab3CXG4K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 02:56:10 -0400
Received: from dcvr.yhbt.net ([64.71.152.64]:45380 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752713Ab3CXG4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 02:56:07 -0400
Date: Sun, 24 Mar 2013 06:56:06 +0000
From: Eric Wong <normalperson@yhbt.net>
To: Fredrik Tolf <fredrik@dolda2000.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: I/O blocked while dirty pages are being flushed
Message-ID: <20130324065605.GA19984@dcvr.yhbt.net>
References: <alpine.DEB.2.02.1303240543280.4028@shack.dolda2000.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1303240543280.4028@shack.dolda2000.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fredrik Tolf <fredrik@dolda2000.com> wrote:
> It is worth noting, also, that this seems to be a situation
> introduced somewhere between 2.6.26 and 2.6.32, because I started
> noticing it when I upgraded from Debian 5.0 to 6.0. I've since tried
> it on 3.2.0, 3.5.4 and 3.7.1, and it appears in every version.
> However, I can't easily go back and bisect, because the new init
> scripts don't support kernels older than 2.6.32, unfortunately.

I'm not sure about Debian-specific changes to the kernel, but
in the stock kernel, the dirty*ratios changes could affect you:

before 2.6.22  dirty_ratio=40 dirty_background_ratio=10
2.6.22-2.6.29  dirty_ratio=10 dirty_background_ratio=5
2.6.30-...     dirty_ratio=20 dirty_background_ratio=10

So try lowering these sysctls to 2.6.26 levels (or lower) and see if
that helps.

Fwiw, I usually use dirty_ratio=2 dirty_background_ratio=1 on servers
with a few gigs of RAM (or appropriately low dirty*bytes values).

Lowering dirty*ratio helps servers get more consistent performance under
constant I/O pressure and aggressively throttles processes before a
large amount of dirty pages becomes a problem (as you've noticed).

High dirty*ratio is good for some bursty desktop workloads and some
benchmarks, though...

ref: commit 07db59bd6b0f279c31044cba6787344f63be87ea
ref: commit 1b5e62b42b55c509eea04c3c0f25e42c8b35b564


Heck, on a particularly bad server (2.6.18, pre-dirty_*bytes sysctl)
with lots of RAM and horrible disk throughput (~10M/s), I set both
dirty_writeback_centisecs and dirty_expire_centisecs to 100 to get
acceptable performance for writing HTTP access logs.
