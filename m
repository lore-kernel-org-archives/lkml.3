Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389AbaKENCz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 08:02:55 -0500
Received: from mail-qa0-f50.google.com ([209.85.216.50]:47679 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754394AbaKENCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 08:02:53 -0500
Date: Wed, 5 Nov 2014 08:02:47 -0500
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        David Rientjes <rientjes@google.com>, Oleg Nesterov <oleg@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH 3/4] OOM, PM: OOM killed task shouldn't escape PM suspend
Message-ID: <20141105130247.GA14386@htj.dyndns.org>
References: <1413876435-11720-1-git-send-email-mhocko@suse.cz>
 <2156351.pWp6MNRoWm@vostro.rjw.lan>
 <20141021141159.GE9415@dhcp22.suse.cz>
 <4766859.KSKPTm3b0x@vostro.rjw.lan>
 <20141021142939.GG9415@dhcp22.suse.cz>
 <20141104192705.GA22163@htj.dyndns.org>
 <20141105124620.GB4527@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141105124620.GB4527@dhcp22.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Michal.

On Wed, Nov 05, 2014 at 01:46:20PM +0100, Michal Hocko wrote:
> As I've said I wasn't entirely happy with this half solution but it helped
> the current situation at the time. The full solution would require to

I don't think this helps the situation.  It just makes the bug more
obscure and the race window while reduced is still pretty big and
there seems to be an actual not too low chance of the bug triggering
out in the wild.  How does this level of obscuring help anything?  In
addition to making the bug more difficult to reproduce, it also adds a
bunch of code which *pretends* to address the issue but ultimately
just lowers visibility into what's going on and hinders tracking down
the issue when something actually goes wrong.  This is *NOT* making
the situation better.  The patch is net negative.

> I think the patch below should be safe. Would you prefer this solution
> instead? It is race free but there is the risk that exposing a lock which

Yes, this is an a lot saner approach in general.

> completely blocks OOM killer from the allocation path will kick us
> later.

Can you please spell it out?  How would it kick us?  We already have
oom_killer_disable/enable(), how is this any different in terms of
correctness from them?  Also, why isn't this part of
oom_killer_disable/enable()?  The way they're implemented is really
silly now.  It just sets a flag and returns whether there's a
currently running instance or not.  How were these even useful?  Why
can't you just make disable/enable to what they were supposed to do
from the beginning?

Thanks.

-- 
tejun
