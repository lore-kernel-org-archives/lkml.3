Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409AbaAVI12 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 03:27:28 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58423 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753955AbaAVI10 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 03:27:26 -0500
Date: Wed, 22 Jan 2014 09:27:23 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Greg Thelen <gthelen@google.com>,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm 2/2] memcg: fix css reference leak and endless loop
 in mem_cgroup_iter
Message-ID: <20140122082723.GB18154@dhcp22.suse.cz>
References: <20140121083454.GA1894@dhcp22.suse.cz>
 <1390301143-9541-1-git-send-email-mhocko@suse.cz>
 <1390301143-9541-2-git-send-email-mhocko@suse.cz>
 <20140121114219.8c34256dfbe7c2470b36ced8@linux-foundation.org>
 <alpine.LSU.2.11.1401211218010.5688@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1401211218010.5688@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 21-01-14 13:18:42, Hugh Dickins wrote:
[...]
> We do have a confusing situation.  The hang goes back to 3.10 but takes
> two different forms, because of intervening changes: in 3.10 and 3.11
> mem_cgroup_iter repeatedly returns root memcg to its caller, in 3.12 and
> 3.13 mem_cgroup_iter repeatedly gets NULL memcg from mem_cgroup_iter_next
> and cannot return to its caller.
> 
> Patch 1/2 is what's needed to fix 3.10 and 3.11 (and applies correctly
> to 3.11, but will have to be rediffed for 3.10 because of rearrangement
> in between). 

I will backport it when it reaches stable queue.

> Patch 2/2 is what's needed to fix 3.12 and 3.13 (but applies
> correctly to neither of them because it's diffed on top of my CSS_ONLINE
> fix).  Patch 1/2 is correct but unnecessary in 3.12 and 3.13: I'm unclear
> whether Michal is claiming that it would also fix the hang in 3.12 and
> 3.13 if we didn't have 2/2: I doubt that, and haven't tested that.

Actually both patches are needed. If we had only 2/2 then we wouldn't
endless loop inside mem_cgroup_iter but we could still return root to
caller all the time because mem_cgroup_iter_load would return NULL on
css_tryget failure on the cached root. Or am I missing something that
would prevent that?

> Given how Michal has diffed this patch on top of my CSS_ONLINE one
> (mm-memcg-iteration-skip-memcgs-not-yet-fully-initialized.patch),
> it would be helpful if you could mark that one also for stable 3.12+,
> to save us from having to rediff this one for stable.  We don't have
> a concrete example of a problem it solves in the vanilla kernel, but
> it makes more sense to include it than to exclude it.

Yes, I think it makes sense to queue it for 3.12+ as well because it is
non intrusive and potential issues would be really subtle.

> (You would be right to point out that the CSS_ONLINE one fixes
> something that goes back to 3.10: I'm saying 3.12+ because I'm not
> motivated to rediff it for 3.10 and 3.11 when there's nothing to
> go on top; but that's not a very good reason to lie - overrule me.)
> 
> Hugh

-- 
Michal Hocko
SUSE Labs
