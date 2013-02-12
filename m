Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932292Ab3BLKXI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 05:23:08 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:34404
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755677Ab3BLKXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 05:23:06 -0500
Message-ID: <1360664565.4485.13.camel@laptop>
Subject: Re: [patch v4 05/18] sched: quicker balancing on fork/exec/wake
From: Peter Zijlstra <peterz@infradead.org>
To: Alex Shi <alex.shi@intel.com>
Cc: torvalds@linux-foundation.org, mingo@redhat.com, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org
Date: Tue, 12 Feb 2013 11:22:45 +0100
In-Reply-To: <1358996820-23036-6-git-send-email-alex.shi@intel.com>
References: <1358996820-23036-1-git-send-email-alex.shi@intel.com>
	 <1358996820-23036-6-git-send-email-alex.shi@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-24 at 11:06 +0800, Alex Shi wrote:
> Guess the search cpu from bottom to up in domain tree come from
> commit 3dbd5342074a1e sched: multilevel sbe sbf, the purpose is
> balancing over tasks on all level domains.
> 
> This balancing cost too much if there has many domain/groups in a
> large system.
> 
> If we remove this code, we will get quick fork/exec/wake with a
> similar
> balancing result amony whole system.
> 
> This patch increases 10+% performance of hackbench on my 4 sockets
> SNB machines and about 3% increasing on 2 sockets servers.
> 
> 
Numbers be groovy.. still I'd like a little more on the behavioural
change. Expand on what exactly is lost by this change so that if we
later find a regression we have a better idea of what and how.

For instance, note how find_idlest_group() isn't symmetric wrt
local_group. So by not doing the domain iteration we change things.

Now, it might well be that all this is somewhat overkill as it is, but
should we then not replace all of it with a simple min search over all
eligible cpus; that would be a real clean up.
 

