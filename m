Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759775AbaGYIKm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 04:10:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:46472 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330AbaGYIKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 04:10:39 -0400
Date: Fri, 25 Jul 2014 10:10:33 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org
Subject: Re: [PATCH v3 6/9] perf, x86: handle multiple records in PEBS buffer
Message-ID: <20140725081033.GV3935@laptop>
References: <1406016602-31845-1-git-send-email-zheng.z.yan@intel.com>
 <1406016602-31845-7-git-send-email-zheng.z.yan@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406016602-31845-7-git-send-email-zheng.z.yan@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 04:09:59PM +0800, Yan, Zheng wrote:
> One corner case needs to mention is that the PEBS hardware doesn't
> deal well with collisions, when PEBS events happen near to each
> other. The records for the events can be collapsed into a single
> one. However in practice collisions are extremely rare, as long as
> different events are used. The periods are typically very large,
> so any collision is unlikely. When collision happens, we can either
> drop the PEBS record or use the record to serve multiple events.
> This patch chooses the later approach.

You can't.. the events might have different security context.

Remember, the overflow bit is set from the overflow until the PEBS
event is generated, this is quite a long time. So if another PEBS event
gets generated while the other is still pending it will have both bits
set. Even though the second bit is for another (unrelated) counter.

The unrelated counter might not have privilege to observe the data of
the generated event.

I think you can unwind and fully correct this trainwreck. But simply
delivering an even with multiple bits set to all relevant events is
wrong and might leak sensitive information.
