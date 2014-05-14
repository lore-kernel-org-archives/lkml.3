Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755536AbaENNH2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 09:07:28 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:64368 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755317AbaENNHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 09:07:25 -0400
Date: Wed, 14 May 2014 09:07:22 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, hannes@cmpxchg.org
Subject: Re: [PATCHSET cgroup/for-3.16] cgroup: iterate cgroup_subsys_states
 directly
Message-ID: <20140514130722.GE28815@htj.dyndns.org>
References: <1399671091-23867-1-git-send-email-tj@kernel.org>
 <5372EF45.8060701@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5372EF45.8060701@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Li.

On Wed, May 14, 2014 at 12:21:25PM +0800, Li Zefan wrote:
> > There are now use cases where controllers need to iterate through
> > csses regardless of their online state as long as they have positive
> 
> What use cases are we talking about here?

memcg wants to be able to iterate all csses whose refcnts haven't
reached zero yet so that it can treat offline csses the same way as
online ones in terms of memory reclaim.  They don't contain new tasks
so new charges won't be created but offlining won't try to transfer
all charges to the parent but just leave the offline child attached
until all charges are eventually reclaimed from the pressure from the
parent.

I'm not too familiar with the details but this makes sense in generic
sense too.  Offline marks an object starting its draining phase and
release marks the actual destruction point.  For controllers with
persistent states like memcg, it's a lot more natural to deal offlined
csses as "active but draining following the usual hierarchical
operation" rather than trying to explicitly update the states from
offline to move them to the parent especially as the effort there
essentially is a waste as most of those moved charges aren't gonna be
used in the parent and will be released eventually.

Guaranteeing iteration of offline but not-released csses allow
controllers to treat the draining stage between offline and release
more or less identically to online state which in turn can make
->css_offline() significantly simpler and lighter.

Thanks.

-- 
tejun
