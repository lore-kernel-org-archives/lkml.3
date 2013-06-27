Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743Ab3F0RiU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 13:38:20 -0400
Received: from mail-gh0-f172.google.com ([209.85.160.172]:48619 "EHLO
	mail-gh0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093Ab3F0RiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 13:38:18 -0400
X-Greylist: delayed 2307 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Jun 2013 13:38:17 EDT
Date: Thu, 27 Jun 2013 10:38:09 -0700
From: Tejun Heo <tj@kernel.org>
To: Tim Hockin <thockin@hockin.org>
Cc: Li Zefan <lizefan@huawei.com>,
        Containers <containers@lists.linux-foundation.org>,
        Cgroups <cgroups@vger.kernel.org>, bsingharora <bsingharora@gmail.com>,
        "dhaval.giani" <dhaval.giani@gmail.com>,
        Kay Sievers <kay.sievers@vrfy.org>, jpoimboe <jpoimboe@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        lpoetter <lpoetter@redhat.com>,
        workman-devel <workman-devel@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: cgroup: status-quo and userland efforts
Message-ID: <20130627173809.GB5599@mtj.dyndns.org>
References: <CAAAKZwvh_R2Xz--bmSLiN33fsqKanOJMq_6+6hoFWFRx38O4gA@mail.gmail.com>
 <20130422214159.GG12543@htj.dyndns.org>
 <CAAAKZwuXJwwyj7KSqb7rZ+nrTwBWEaUCWfa7kWecTBnHL8koGw@mail.gmail.com>
 <CAAAKZwvP_7wBBYMmtFuiE2hZt=ByaLrnTyiR83CZr3OMip63Gg@mail.gmail.com>
 <20130625000118.GT1918@mtj.dyndns.org>
 <CAAAKZwt09k-qUwLCnMpAQeYJ-S0XtkjXe4=bJ-G_fcrkAqEzoA@mail.gmail.com>
 <20130626212047.GB4536@htj.dyndns.org>
 <CAAAKZws1qkSik4G4pRr7z+067Jp9-jHfpx9-euqbvmdHjoN_Zg@mail.gmail.com>
 <20130627010427.GF4536@htj.dyndns.org>
 <CAAAKZwsMT7FRccyVxSn77GR8+9JsSeqmDO6oOy7ycNCY7Desnw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAAKZwsMT7FRccyVxSn77GR8+9JsSeqmDO6oOy7ycNCY7Desnw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Tim.

On Wed, Jun 26, 2013 at 08:42:21PM -0700, Tim Hockin wrote:
> OK, then what I don't know is what is the new interface?  A new cgroupfs?

It's gonna be a new mount option for cgroupfs.

> DTF and CPU and cpuset all have "default" groups for some tasks (and
> not others) in our world today.  DTF actually has default, prio, and
> "normal".  I was simplifying before.  I really wish it were as simple
> as you think it is.  But if it were, do you think I'd still be
> arguing?

How am I supposed to know when you don't communicate it but just wave
your hands saying it's all very complicated?  The cpuset / blkcg
example is pretty bad because you can enforce any cpuset rules at the
leaves.

> This really doesn't scale when I have thousands of jobs running.
> Being able to disable at some levels on some controllers probably
> helps some, but I can't say for sure without knowing the new interface

How does the number of jobs affect it?  Does each job create a new
cgroup?

> We tried it in unified hierarchy.  We had our Top People on the
> problem.  The best we could get was bad enough that we embarked on a
> LITERAL 2 year transition to make it better.

What didn't work?  What part was so bad?  I find it pretty difficult
to believe that multiple orthogonal hierarchies is the only possible
solution, so please elaborate the issues that you guys have
experienced.

The hierarchy is for organization and enforcement of dynamic
hierarchical resource distribution and that's it.  If its expressive
power is lacking, take compromise or tune the configuration according
to the workloads.  The latter is necessary in workloads which have
clear distinction of foreground and background anyway - anything which
interacts with human beings including androids.

> In other words, define a container as a set of cgroups, one under each
> each active controller type.  A TID enters the container atomically,
> joining all of the cgroups or none of the cgroups.
> 
> container C1 = { /cgroup/cpu/foo, /cgroup/memory/bar,
> /cgroup/io/default/foo/bar, /cgroup/cpuset/
> 
> This is an abstraction that we maintain in userspace (more or less)
> and we do actually have headaches from split hierarchies here
> (handling partial failures, non-atomic joins, etc)

That'd separate out task organization from controllre config
hierarchies.  Kay had a similar idea some time ago.  I think it makes
things even more complex than it is right now.  I'll continue on this
below.

> I'm still a bit fuzzy - is all of this written somewhere?

If you dig through cgroup ML, most are there.  There'll be
"cgroup.controllers" file with which you can enable / disable
controllers.  Enabling a controller in a cgroup implies that the
controller is enabled in all ancestors.

> It sounds like you're missing a layer of abstraction.  Why not add the
> abstraction you want to expose on top of powerful primitives, instead
> of dumbing down the primitives?

It sure would be possible build more and try to address the issues
we're seeing now; however, after looking at cgroups for some time now,
the underlying theme is failure to take reasonable trade-offs and
going for maximum flexibility in making each choice - the choice of
interface, multiple hierarchies, no restriction on hierarchical
behavior, splitting threads of the same process into separate cgroups,
semi-encouraging delegation through file permission without actually
pondering the consequences and so on.  And each choice probably made
sense trying to serve each immediate requirement at the time but added
up it's a giant pile of mess which developed without direction.

So, at this point, I'm very skeptical about adding more flexibility.
Once the basics are settled, we sure can look into the missing pieces
but I don't think that's what we should be doing right now.  Another
thing is that the unified hierarchy can be implemented by using most
of the constructs cgroup core already has in more controller way.
Given that we're gonna have to maintain both interfaces for quite some
time, the deviation should be kept as minimal as possible.

> But it seems vastly better to define a next-gen API that retains the
> important flexibility but adds structure where it was lacking
> previously.

I suppose that's where we disagree.  I think a lot of cgroup's
problems stem from too much flexibility.  The problem with such level
of flexibility is that, in addition to breaking fundamental constructs
and adding significantly to maintenance overhead, it blocks reasonable
trade-offs to be made at the right places, in turn requiring more
"flexibility" to address the introduced deficiencies.

Thanks.

-- 
tejun
