Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344AbaELUHu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 16:07:50 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:48134 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420AbaELUHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 16:07:49 -0400
Date: Mon, 12 May 2014 16:07:45 -0400
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <kmo@daterainc.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH percpu/for-3.16 2/2] percpu-refcount: implement
 percpu_ref_tryget()
Message-ID: <20140512200745.GN1421@htj.dyndns.org>
References: <20140507155511.GB26540@htj.dyndns.org>
 <20140507155647.GC26540@htj.dyndns.org>
 <20140507155810.GD26540@htj.dyndns.org>
 <20140509194020.GB2276@kmo>
 <20140509194140.GC4486@htj.dyndns.org>
 <20140509195109.GC2276@kmo>
 <20140509195522.GF4486@htj.dyndns.org>
 <20140512000619.GC10617@kmo-pixel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140512000619.GC10617@kmo-pixel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Sun, May 11, 2014 at 05:06:19PM -0700, Kent Overstreet wrote:
> On Fri, May 09, 2014 at 03:55:22PM -0400, Tejun Heo wrote:
> > Hello,
> > 
> > On Fri, May 09, 2014 at 12:51:09PM -0700, Kent Overstreet wrote:
> > > Well not so much deprecated as "bad, avoid" - IMO using tryget() almost always
> > > (I haven't seen a convincing counterexample) means you screwed up your
> > > refcounting somewhere, if you need to take a ref on something whatever made that
> > > object visible to you should have its own ref.
> > > 
> > > (I think we had this debate, but that was awhile ago...)
> > 
> > Oh sure, tryget can definitely be misunderstood but RCU protected
> > iteration is one valid use case.
> > 
> > 	rcu_read_lock();
> > 	locate the object of interest;
> > 	tryget[_live]() depending on the use case;
> > 	rcu_read_unlock();
> > 
> > 	access the object.
> 
> No, it's not needed with RCU... look at the aio code for an example (or don't,
> save your eyes instead).
> 
> Conceptually the RCU data structure should own a refcount on the things that are
> accessible via it; that ref shouldn't be dropped until after it's removed and an
> RCU barrier has happened.

You can do that if the object can disappear from iteration when its
ref gets killed.  IOW, the list visiblity is not tied to the reference
count.  cgroup_subsys_states can't do that.  They have to remain
visible to iteration until the object's last ref is dropped because
controllers need to be able to walk them while the object is being
drained.

Thanks.

-- 
tejun
