Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751583Ab3KDSyB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 13:54:01 -0500
Received: from mga11.intel.com ([192.55.52.93]:10944 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750719Ab3KDSyA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 13:54:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,634,1378882800"; 
   d="scan'208";a="427775070"
From: Andi Kleen <andi@firstfloor.org>
To: Anatol Pomozov <anatol.pomozov@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Solving M produces N consumers scalability problem
References: <CAOMFOmWzERR7MDe65YHo--GdbO+QfnxZK=uWd7d3vCZ6ca97fw@mail.gmail.com>
Date: Mon, 04 Nov 2013 10:53:59 -0800
In-Reply-To: <CAOMFOmWzERR7MDe65YHo--GdbO+QfnxZK=uWd7d3vCZ6ca97fw@mail.gmail.com>
	(Anatol Pomozov's message of "Fri, 1 Nov 2013 13:48:10 -0700")
Message-ID: <87wqkovvzs.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anatol Pomozov <anatol.pomozov@gmail.com> writes:
>
> One idea is not to use the spin_lock. It is the 'fair spin_lock' that
> has scalability problems
> http://pdos.csail.mit.edu/papers/linux:lock.pdf Maybe lockless
> datastructures can help here?

The standard spin lock is already improved.
But better locks just give you a small advantage, they don't
solve the real scaling problem.

>
> Another idea is avoid global datasctructures but I have a few
> questions here. Let's say we want to use per-CPU lists. But the
> problem is that producers/consumers are not distributed across all
> CPUs. Some CPU might have too many producers, some other might not
> have consumers at all. So we need some kind of migration from hot CPU
> to the cold one. What is the best way to achieve it? Are there any
> examples how to do this? Any other ideas?

per cpu is the standard approach, but usually overkill. Also
requires complex code to drain etc.

Some older patches also use per node, but that works very poorly 
these days (nodes are far too big) 

One way I like is to simply use a global (allocated) array of queues,
sized by total number of possible cpus (but significantly smaller) and
use the cpu number as a hash into the array.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
