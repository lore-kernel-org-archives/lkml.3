Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601AbaBEVHO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 16:07:14 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:54729 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754896AbaBEVHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 16:07:09 -0500
Date: Wed, 5 Feb 2014 13:07:05 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Steven Rostedt <rostedt@goodmis.org>
cc: Vladimir Davydov <vdavydov@parallels.com>, akpm@linux-foundation.org,
        penberg@kernel.org, cl@linux.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl
Subject: Re: [PATCH v3] slub: fix false-positive lockdep warning in
 free_partial()
In-Reply-To: <20140205155840.43d6b4ad@gandalf.local.home>
Message-ID: <alpine.DEB.2.02.1402051301460.14325@chino.kir.corp.google.com>
References: <52F1F25F.20402@parallels.com> <1391588133-15469-1-git-send-email-vdavydov@parallels.com> <20140205195837.GA6857@home.goodmis.org> <alpine.DEB.2.02.1402051231250.5616@chino.kir.corp.google.com> <20140205155840.43d6b4ad@gandalf.local.home>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Feb 2014, Steven Rostedt wrote:

> > There's an extremely small overhead of taking this lock, the cache has 
> > been destroyed and is the process of being torn down, there will be 
> > absolutely no contention on n->list_lock.
> 
> But why add it if it isn't necessary? You're even disabling interrupts,
> which means that you add to the response latency. That is, this change
> does affect other aspects of the kernel!
> 

The functions that manipulate the partial lists was modified by 
c65c1877bd68 ("slub: use lockdep_assert_held") which replaced commentary 
with runtime checking on debug kernels with lockdep enabled.  I'm not sure 
adding more code to do the remove_partial() and __remove_partial() variant 
is the right solution to just bypass the check; if anything, I think we 
should accept the fact that the comment should have been "requires 
n->list_lock if the slab cache can be accessed by other cpus" that makes 
it clear we don't need it for init and destroy paths.
