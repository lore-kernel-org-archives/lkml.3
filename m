Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936128Ab3DPRYl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 13:24:41 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:36474 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936025Ab3DPRYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 13:24:31 -0400
Date: Tue, 16 Apr 2013 10:24:27 -0700
From: Tejun Heo <tj@kernel.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Mike Snitzer <snitzer@redhat.com>, Milan Broz <gmazyland@gmail.com>,
        dm-devel@redhat.com, Andi Kleen <andi@firstfloor.org>,
        dm-crypt@saout.de, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Christian Schmidt <schmidt@digadd.de>,
        "Alasdair G. Kergon" <agk@redhat.com>
Subject: Re: [PATCH v2] make dm and dm-crypt forward cgroup context (was:
 dm-crypt parallelization patches)
Message-ID: <20130416172418.GB2874@mtj.dyndns.org>
References: <Pine.LNX.4.64.1304091710150.24735@file.rdu.redhat.com>
 <20130410192427.GA14911@redhat.com>
 <Pine.LNX.4.64.1304101938280.24258@file.rdu.redhat.com>
 <20130410235009.GI17641@mtj.dyndns.org>
 <Pine.LNX.4.64.1304111544050.32536@file.rdu.redhat.com>
 <20130411195203.GA11956@mtj.dyndns.org>
 <20130411200005.GB11956@mtj.dyndns.org>
 <Pine.LNX.4.64.1304121340350.3359@file.rdu.redhat.com>
 <20130412182941.GF11956@mtj.dyndns.org>
 <Pine.LNX.4.64.1304150827480.1859@file.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1304150827480.1859@file.rdu.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Mon, Apr 15, 2013 at 09:02:06AM -0400, Mikulas Patocka wrote:
> The patch is not bug-prone, because we already must make sure that the 
> cloned bio has shorter lifetime than the master bio - so the patch doesn't 
> introduce any new possibilities to make bugs.

The whole world isn't composed of only your code.  As I said
repeatedly, you're introducing an API which is misleading and can
easily cause subtle bugs which are very difficult to reproduce.

Imagine it being used to tag a metatdata or checksum update bio being
sent down while processing another bio and used to "clone" the context
of the original bio.  It'll work most of the time even if the original
bio gets completed first but it'll break when it gets really unlucky -
e.g. racing with other operations which can put the base css ref, and
it'll be hellish to reproduce and everyone would have to pay for your
silly hack.

> > Do the two really look the same to you?  The page refs are much more
> > expensive, mostly contained in and the main focus of dm.  ioc/css refs
> > aren't that expensive to begin with, css refcnting is widely scattered
> 
> ioc is per-task, so it is likely to be cached (but there are processors 
> that have slow atomic operations even on cached data - on Pentium 4 it 
> takes about 100 cycles). But css is shared between tasks and produces the 
> cache ping-pong effect.

For $DIETY's sake, how many times do I have to tell you to use per-cpu
reference count?  Why do I have to repeat the same story over and over
again?  What part of "make the reference count per-cpu" don't you get?
It's not a complicated message.

At this point, I can't even understand why or what the hell you're
arguing.  There's a clearly better way to do it and you're just
repeating yourself like a broken record that your hack in itself isn't
broken.

So, if you wanna continue that way for whatever reason, you have my
firm nack and I'm outta this thread.

Bye bye.

-- 
tejun
