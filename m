Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751430AbaKFQ24 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 11:28:56 -0500
Received: from mail-qg0-f45.google.com ([209.85.192.45]:41763 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbaKFQ2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 11:28:49 -0500
Date: Thu, 6 Nov 2014 11:28:45 -0500
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        David Rientjes <rientjes@google.com>, Oleg Nesterov <oleg@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH 3/4] OOM, PM: OOM killed task shouldn't escape PM suspend
Message-ID: <20141106162845.GD25642@htj.dyndns.org>
References: <20141105154436.GB14386@htj.dyndns.org>
 <20141105160115.GA28226@dhcp22.suse.cz>
 <20141105162929.GD14386@htj.dyndns.org>
 <20141105163956.GD28226@dhcp22.suse.cz>
 <20141105165428.GF14386@htj.dyndns.org>
 <20141105174609.GE28226@dhcp22.suse.cz>
 <20141105175527.GH14386@htj.dyndns.org>
 <20141106124953.GD7202@dhcp22.suse.cz>
 <20141106150121.GA25642@htj.dyndns.org>
 <20141106160223.GJ7202@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141106160223.GJ7202@dhcp22.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 05:02:23PM +0100, Michal Hocko wrote:
> > Why would PM freezing make OOM killing fail?  That doesn't make much
> > sense.  Sure, it can block it for a finite duration for sync purposes
> > but making OOM killing fail seems the wrong way around.  
> 
> We cannot block in the allocation path because the request might come
> from the freezer path itself (e.g. when suspending devices etc.).
> At least this is my understanding why the original oom disable approach
> was implemented.

I was saying that it could temporarily block either direction to
implement proper synchronization while guaranteeing forward progress.

> > We're doing one thing for non-PM freezing and the other way around for
> > PM freezing, which indicates one of the two directions is wrong.
> 
> Because those two paths are quite different in their requirements. The
> cgroup freezer only cares about freezing tasks and it doesn't have to
> care about tasks accessing a possibly half suspended device on their way
> out.

I don't think the fundamental relationship between freezing and oom
killing are different between the two and the failure to recognize
that is what's leading to these weird issues.

> > Shouldn't it be that OOM killing happening while PM freezing is in
> > progress cancels PM freezing rather than the other way around?  Find a
> > point in PM suspend/hibernation operation where everything must be
> > stable, disable OOM killing there and check whether OOM killing
> > happened inbetween and if so back out. 
> 
> This is freeze_processes AFAIU. I might be wrong of course but this is
> the time since when nobody should be waking processes up because they
> could access half suspended devices.

No, you're doing it before freezing starts.  The system is in no way
in a quiescent state at that point.

> > It seems rather obvious to me that OOM killing has to have precedence
> > over PM freezing.
> > 
> > Sure, once the system reaches a point where the whole system must be
> > in a stable state for snapshotting or whatever, disabling OOM killing
> > is fine but at that point the system is in a very limited execution
> > mode and sure won't be processing page faults from userland for
> > example and we can actually disable OOM killing knowing that anything
> > afterwards is ready to handle memory allocation failures.
> 
> I am really confused now. This is basically what the final patch does
> actually.  Here is the what I have currently just to make the further
> discussion easier.

Please see above.

-- 
tejun
