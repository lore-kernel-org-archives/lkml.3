Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756371Ab3J1LbZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 07:31:25 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:51392 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755409Ab3J1LbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 07:31:24 -0400
Date: Mon, 28 Oct 2013 07:31:20 -0400
From: Tejun Heo <tj@kernel.org>
To: Wei Yang <weiyang@linux.vnet.ibm.com>
Cc: cl@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] percpu: stop the loop when a cpu belongs to a new
 group
Message-ID: <20131028113120.GB11541@mtj.dyndns.org>
References: <1382345893-6644-1-git-send-email-weiyang@linux.vnet.ibm.com>
 <20131027123008.GJ14934@mtj.dyndns.org>
 <20131028030055.GC15642@weiyang.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131028030055.GC15642@weiyang.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Oct 28, 2013 at 11:00:55AM +0800, Wei Yang wrote:
> >Does this actually matter?  If so, it'd probably make a lot more sense
> >to start inner loop at @cpu + 1 so that it becomes O(N).
> 
> One of the worst case in my mind:
> 
> CPU:        0    1    2    3    4    ...
> Group:      0    1    2    3    4    ...
> (sounds it is impossible in the real world)

I was wondering whether you had an actual case where this actually
matters or it's just something you thought of while reading the code.

> Every time, when we encounter a new CPU and try to assign it to a group, we
> found it belongs to a new group. The original logic will iterate on all old
> CPUs again, while the new logic could skip this and assign it to a new group.
> 
> Again, this is a tiny change, which doesn't matters a lot.

I think it *could* matter because the current implementation is O(N^2)
where N is the number of CPUs.  On machines, say, with 4k CPU, it's
gonna loop 16M times but then again even that takes only a few
millisecs on modern machines.

> BTW, I don't get your point for "start inner loop at @cpu+1".
> 
> The original logic is:
> 	loop 1:   0 - nr_cpus
> 	loop 2:      0 - (cpu - 1)
> 
> If you found one better approach to improve the logic, I believe all the users
> will appreciate your efforts :-)

Ooh, right, I forgot about the break and then I thought somehow that
would make it O(N).  Sorry about that.  I blame jetlag. :)

Yeah, I don't know.  The function is quite hairy which makes me keep
things simpler and reluctant to make changes unless it actually makes
non-trivial difference.  The change looks okay to me but it seems
neither necessary or substantially beneficial and if my experience is
anything to go by, *any* change involves some risk of brekage no
matter how innocent it may look, so given the circumstances, I'd like
to keep things the way they are.

Thanks a lot!

-- 
tejun
