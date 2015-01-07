Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932126AbbAGV3A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 16:29:00 -0500
Received: from peace.netnation.com ([204.174.223.2]:54745 "EHLO
	peace.netnation.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932098AbbAGV27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 16:28:59 -0500
Date: Wed, 7 Jan 2015 13:28:58 -0800
From: Simon Kirby <sim@hostway.ca>
To: Holger Hoffst?tte <holger.hoffstaette@googlemail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: Dirty pages underflow on 3.14.23
Message-ID: <20150107212858.GA6664@hostway.ca>
References: <alpine.LRH.2.02.1501051744020.5119@file01.intranet.prod.int.rdu2.redhat.com>
 <20150106150250.GA26895@phnom.home.cmpxchg.org>
 <alpine.LRH.2.02.1501061246400.16437@file01.intranet.prod.int.rdu2.redhat.com>
 <pan.2015.01.07.10.57.46@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <pan.2015.01.07.10.57.46@googlemail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2015 at 10:57:46AM +0000, Holger Hoffst?tte wrote:

> On Tue, 06 Jan 2015 12:54:43 -0500, Mikulas Patocka wrote:
> 
> > I can't reprodce it. It happened just once.
> > 
> > That patch is supposed to fix an occasional underflow by a single page -
> > while my meminfo showed underflow by 22952KiB (5738 pages).
> 
> You are probably looking for:
> commit 835f252c6debd204fcd607c79975089b1ecd3472
> "aio: fix uncorrent dirty pages accouting when truncating AIO ring buffer"
> 
> It definitely went into 3.14.26, don't know about 3.16.x.

I can confirm that a MySQL shutdown/restart triggers it for me, even
immediately following a fresh boot:

# uname -a ; grep '^nr_dirty ' /proc/vmstat; /etc/init.d/mysql restart; \
             grep '^nr_dirty ' /proc/vmstat
Linux blue 3.16.6-blue #51 Mon Oct 20 14:00:47 PDT 2014 i686 GNU/Linux
nr_dirty 13
[ ok ] Stopping MySQL database server: mysqld.
[ ok ] Starting MySQL database server: mysqld . ..
[info] Checking for tables which need an upgrade, are corrupt or were not closed cleanly..
nr_dirty 4294967245

Hmm...A possibly-related issue...Before trying this, after a fresh boot,
/proc/vmstat showed:

nr_alloc_batch 4294541205

and after the restart, it shows:

nr_alloc_batch 161

...anyway, git cherry-pick ce4b66be6cd964e84363afd4a603633dd061b3b8 on
3.16.6 tree does seem to fix nr_dirty from underflowing...Yay!

Still, nr_alloc_batch reads as 4294254379 after MySQL restart, and now
seems to stay up there.

Simon-
