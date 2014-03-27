Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871AbaC0PAo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 11:00:44 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:44756 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755244AbaC0PAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 11:00:43 -0400
Date: Thu, 27 Mar 2014 11:00:38 -0400
From: Tejun Heo <tj@kernel.org>
To: Jianyu Zhan <nasa4836@gmail.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, cl@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm/percpu.c: don't bother to re-walk the pcpu_slot
 list if nobody free space since we last drop pcpu_lock.
Message-ID: <20140327150038.GD18503@htj.dyndns.org>
References: <1395918363-6823-1-git-send-email-nasa4836@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395918363-6823-1-git-send-email-nasa4836@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2014 at 07:06:03PM +0800, Jianyu Zhan wrote:
> Presently, after we fail the first try to walk the pcpu_slot list
> to find a chunk for allocating, we just drop the pcpu_lock spinlock,
> and go allocating a new chunk. Then we re-gain the pcpu_lock and
> anchoring our hope on that during this period, some guys might have
> freed space for us(we still hold the pcpu_alloc_mutex during this
> period, so only freeing or reclaiming could happen), we do a fully
> rewalk of the pcpu_slot list.
> 
> However if nobody free space, this fully rewalk may seem too silly,
> and we would eventually fall back to the new chunk.
> 
> And since we hold pcpu_alloc_mutex, only freeing or reclaiming path
> could touch the pcpu_slot(which just need holding a pcpu_lock), we
> could maintain a pcpu_slot_stat bitmap to record that during the period
> we don't have the pcpu_lock, if anybody free space to any slot we
> interest in. If so, we just just go inside these slots for a try;
> if not, we just do allocation using the newly-allocated fully-free
> new chunk.

The patch probably needs to be refreshed on top of percpu/for-3.15.
Hmmm... I'm not sure whether the added complexity is worthwhile.  It's
a fairly cold path.  Can you show how helpful this optimization is?

Thanks.

-- 
tejun
