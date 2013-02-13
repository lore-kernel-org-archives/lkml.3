Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965052Ab3BMWYF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 17:24:05 -0500
Received: from mail-ve0-f176.google.com ([209.85.128.176]:62002 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761031Ab3BMWYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 17:24:04 -0500
Date: Wed, 13 Feb 2013 14:23:58 -0800
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/13] workqueue: record global worker ID instead of pool
 ID in work->data when off-queue
Message-ID: <20130213222358.GD9057@htj.dyndns.org>
References: <1359657696-2767-1-git-send-email-laijs@cn.fujitsu.com>
 <1359657696-2767-14-git-send-email-laijs@cn.fujitsu.com>
 <20130207220227.GW2875@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130207220227.GW2875@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, again.

On Thu, Feb 07, 2013 at 02:02:27PM -0800, Tejun Heo wrote:
> I do like work items pointing back to workers instead of pools, so I
> think I'll try that differently.

I tried to convert work->data to point to the last worker and having
tried it I'm not too sure about it anymore.

* work->data points to cwq while queued which basically is the current
  pool + target workqueue.  Making work->data point to worker off
  queue makes the two modes further apart, which is a bit
  uncomfortable.

* Also, as it currently stands, we can't remove busy_hash because
  on-queue work->data can't point to the last worker and thus we need
  to look up busy_hash before actually executing it.  If we're gonna
  have to keep busy_hash, we might as well use it consistently.

* With pending idr changes, idr lookups become very efficient if the
  ID range is limited.  The range currently is 256 which should be
  enough to cover all the pools in most configurations.  The idr
  lookup essentially becomes if (prefix matches) return hint[offset],
  so I don't think it would save anything measureable from removing
  that look up.  Replacing the idr + busy_hash lookup with single idr
  last worker lookup could still be nicer, I think, but probably not
  by too much.

So, I'm not really seeing too much benefit in converting work->data to
point to the last worker.  If we can remove busy_hash, maybe, but
short of that, I think I'm gonna keep things the way they're now.

Thanks!

-- 
tejun
