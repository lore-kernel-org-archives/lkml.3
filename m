Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932374AbaJXRI5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 13:08:57 -0400
Received: from resqmta-po-01v.sys.comcast.net ([96.114.154.160]:33622 "EHLO
	resqmta-po-01v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756211AbaJXRIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 13:08:55 -0400
Date: Fri, 24 Oct 2014 12:08:50 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Peter Zijlstra <peterz@infradead.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Subject: Re: [RFC][PATCH 4/6] SRCU free VMAs
In-Reply-To: <20141024155101.GE21513@worktop.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.11.1410241206001.30305@gentwo.org>
References: <20141020215633.717315139@infradead.org> <20141020222841.419869904@infradead.org> <CA+55aFwd04q+O5ejbmDL-H7_GB6DEBMiiHkn+2R1u4uWxfDO9w@mail.gmail.com> <20141021080740.GJ23531@worktop.programming.kicks-ass.net> <alpine.DEB.2.11.1410241003430.29419@gentwo.org>
 <20141024155101.GE21513@worktop.programming.kicks-ass.net>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Oct 2014, Peter Zijlstra wrote:

> The hold time isn't relevant, in fact breaking up the mmap_sem such that
> we require multiple acquisitions will just increase the cacheline
> bouncing.

Well this wont be happening anymore once you RCUify the stuff. If you go
to sleep then its best to release mmap_sem and then the bouncing wont
matter.

Dropping mmap_sem there will also expose you to races you will see later
too when you RCUify the code paths. That way those can be deal with
beforehand.

> Also I think it makes more sense to continue an entire fault operation,
> including blocking, if at all possible. Every retry will just waste more
> time.

Ok then dont retry. Just drop mmap_sem before going to sleep. When you
come back evaluate the situation and if we can proceed do so otherwise
retry.
