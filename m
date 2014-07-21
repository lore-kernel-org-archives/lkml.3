Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630AbaGUMCZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 08:02:25 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:62666 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954AbaGUMCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 08:02:24 -0400
Date: Mon, 21 Jul 2014 08:02:19 -0400
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Vladimir Davydov <vdavydov@parallels.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, Hugh Dickins <hughd@google.com>,
        Greg Thelen <gthelen@google.com>, Glauber Costa <glommer@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC PATCH] memcg: export knobs for the defaul cgroup hierarchy
Message-ID: <20140721120219.GA12921@htj.dyndns.org>
References: <1405521578-19988-1-git-send-email-mhocko@suse.cz>
 <20140716155814.GZ29639@cmpxchg.org>
 <20140718154443.GM27940@esperanza>
 <20140721090724.GA8393@dhcp22.suse.cz>
 <20140721114655.GB8393@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140721114655.GB8393@dhcp22.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Jul 21, 2014 at 01:46:55PM +0200, Michal Hocko wrote:
> Even then, I do not see how would this fork-bomb prevention work without
> causing OOMs and killing other processes within the group. The danger
> would be still contained in the group and prevent from the system wide
> disruption. Do we really want only such a narrow usecase?

Does that really matter?  I don't buy the usefulness of the various
suggested partial failure modes.  For example, is fork-bomb actually
something isolatable by not granting more forks?  Doing so is likely
to cripple the cgroup anyway, which apparently needed forking to
operate.  Such partial failure mode would only be useful iff the
culprit is mostly isolated even in the cgroup, stops forking once it
starts to fail, the already forked excess processes can be identified
and killed somehow without requiring forking in the cgroup, and fork
failures in other parts of the cgroup hopefully hasn't broken the
service provided by the cgroup yet.

In the long term, we should have per-cgroup OOM killing and terminate
the cgroups which fail to behave.  I think the value is in the ability
to contain such failures, not in the partial failure modes that may or
may not be salvageable without any way to systematically determine
which way the situation is.  Short of being able to detect which
specific process are fork bombing and take them out, which I don't
think can or should, I believe that fork bomb protection should be
dealt as an integral part of generic memcg operation.

Thanks.

-- 
tejun
