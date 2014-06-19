Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934418AbaFSU0p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 16:26:45 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:47886 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756530AbaFSU0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 16:26:43 -0400
Date: Thu, 19 Jun 2014 16:26:40 -0400
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Joe Lawrence <joe.lawrence@stratus.com>, linux-kernel@vger.kernel.org,
        Cgroups <cgroups@vger.kernel.org>
Subject: Re: docker crashes rcuos in __blkg_release_rcu
Message-ID: <20140619202640.GA9814@mtj.dyndns.org>
References: <alpine.DEB.2.02.1406081816540.17948@jlaw-desktop.mno.stratus.com>
 <20140609174708.GA31499@redhat.com>
 <20140609182728.GB31499@redhat.com>
 <20140610143906.0d2f35d0@jlaw-desktop.mno.stratus.com>
 <20140611163229.GA12974@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140611163229.GA12974@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry about the late reply.

On Wed, Jun 11, 2014 at 12:32:29PM -0400, Vivek Goyal wrote:
> Tejun, any thoughts on how to solve this issue. Delaying blkg release
> in rcu context and then expecting queue to be still present is causing
> this problem.

Heh, this is hilarious.  If you look at the comment right above
__blkg_release_rcu(), it says

 * A group is RCU protected, but having an rcu lock does not mean that one
 * can access all the fields of blkg and assume these are valid.  For
 * example, don't try to follow throtl_data and request queue links.
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

And yet the code brazenly derefs the ->q link to access the lock there
and causes oops.  This is from 2a4fd070ee85 ("blkcg: move bulk of
blkcg_gq release operations to the RCU callback").  I stupidly didn't
realize what I was doing even while moving the comment itself.

Well, the obvious solution is making blkg ref an atomic.  I was
planning to convert it to percpu_ref anyway.  We can first convert it
to atomic_t for -stable and then to percpu_ref.  Will prep a patch.

Thanks for tracking it down!

-- 
tejun
