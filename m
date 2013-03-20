Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757368Ab3CTSav (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 14:30:51 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:61434 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755297Ab3CTSau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 14:30:50 -0400
Date: Wed, 20 Mar 2013 11:30:37 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/21] workqueue: cleanups and better locking for recent
 changes
Message-ID: <20130320183037.GE30484@htj.dyndns.org>
References: <1363721306-2030-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363721306-2030-1-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So, overall,

On Wed, Mar 20, 2013 at 03:28:00AM +0800, Lai Jiangshan wrote:
...
> In this list, we can find that:
> 1) wq_mutex protects too much different kind of things.

I don't agree with this and unless you can come up with a much better
reason, won't be splitting wq_mutex further.  Also, I'm not gonna
rename it to wqs_mutex.

> 2) workqueue->pwqs are protected by both wq->flush_mutex and pwq_lock,
>    but in many read sites, they are protected by both wq->flush_mutex and pwq_lock,
>    in some other read sites, they are protected by pwq_lock, but can be converted
>    to wq->flush_mutex. it means pwq_lock and wq->flush_mutex are redundancy here.
> 3) pwq_lock is global lock, but it protects only workqueue instance fields.

A global lock protecting different instances is perfectly fine unless
it actually causes contention in some paths.  It often actually is
better to have a single global lock for cold paths as it pollutes less
amount of cache, so please don't split locks for that reason.

That said, I like the fact that wq->flush_mutex can be transformed
into wq->mutex and replaces pwq_lock making it go away, so, yeah, for
that reason, I like pwq_lock removal, so yeah, let's replace pwq_lock
with wq->mutex.

I applied the ones I can apply at this point.  I'll rebase the NUMA
patchset on top of the applied ones.  Please update the rest on top.

Thanks.

-- 
tejun
