Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557Ab3GYPbc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 11:31:32 -0400
Received: from mail-yh0-f52.google.com ([209.85.213.52]:49206 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755892Ab3GYPb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 11:31:27 -0400
Date: Thu, 25 Jul 2013 11:31:21 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] workqueue: clear workers of a pool after the CPU is
 offline
Message-ID: <20130725153121.GF26107@mtj.dyndns.org>
References: <1374749531-16423-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374749531-16423-1-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Lai.

On Thu, Jul 25, 2013 at 06:52:02PM +0800, Lai Jiangshan wrote:
> The unbound pools and their workers can be destroyed/cleared
> when their refcnt become zero. But the cpu pool can't be destroyed
> due to they are always referenced, their refcnt are always > 0.
> 
> We don't want to destroy the cpu pools, but we want to destroy
> the workers of the pool when the pool is full idle after the cpu
> is offline. This is the default behavior in old days until
> we removed the trustee_thread().
> 
> We need to find a new way to restore this behavior,
> We add offline_pool() and POOL_OFFLINE flag to do so.

Hmmm... if I'm not confused, now the cpu pools just behave like a
normal unbound pool when the cpu goes down, which means that the idle
cpu workers will exit once idle timeout is reached, right?  I really
don't think it'd be worthwhile to add extra logic to accelerate the
process.

Note that there actually are benefits to doing it asynchronously as
CPUs go up and down very frequently on mobile platforms and destroying
idle workers as soon as possible would just mean that we'd be doing a
lot of work which isn't necessary.  I mean, we even grew an explicit
mechanism to park kthreads to avoid repeatedly creating and destroying
per-cpu kthreads as cpus go up and down.  I don't see any point in
adding code to go the other direction.

Thanks.

-- 
tejun
