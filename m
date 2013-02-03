Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589Ab3BCPsE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 10:48:04 -0500
Received: from mail-da0-f42.google.com ([209.85.210.42]:54945 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413Ab3BCPsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 10:48:00 -0500
Date: Sun, 3 Feb 2013 07:47:55 -0800
From: Tejun Heo <tj@kernel.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, bfields@fieldses.org, skinsbursky@parallels.com,
        jmorris@namei.org, axboe@kernel.dk
Subject: Re: [PATCHSET] idr: implement idr_alloc() and convert existing users
Message-ID: <20130203154755.GA8718@mtj.dyndns.org>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
 <87a9rltszn.fsf@xmission.com>
 <CAOS58YPhSz4DQT5-hTkH-wW_P3b5LK1WuEbWiR8uyNZPZdf_Gw@mail.gmail.com>
 <87ehgxo1yc.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ehgxo1yc.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Sun, Feb 03, 2013 at 07:24:11AM -0800, Eric W. Biederman wrote:
> At least with the radix tree the pieces are core kernel pieces that get
> optimized like mad and you expect to have to think about.
>
> idr is a boring thing you use because don't want to think about the
> details.  Now you are asking people to really think about the details
> when the touch a piece of code using idr.  I think that is the wrong
> trade off.

People use it as a generic indexing thing.  It gets even used for per
storage command or per network command.  And really think about what?
Preloading disables preemption.  That's the only interface detail that
affects anything.

> > Seriously, if this gives you deep creepy feeling, you need to get on
> > with time.  It's a basic percpu technique.
> 
> But this isn't a basic percpu technique.  This is a basic percpu
> technique hidden behind the wall.
>
> Nothing about reading idr_preload() in a line of code says.  Hey look at
> me I am version of preempt disable() that puts things in percpu
> variables that you don't know about.
> 
> Nothing about idr_preload says don't you dair forget to pair me with
> preload_end().

So, is it that you are bothered that idr_preload() should be paired
with _end()?  I mean, it's clearly described so in the interface and
you would even get a nice preemption level mismatch warning pretty
quickly if you miss one unlike when you forget to handle -EAGAIN.

> >> Maybe we can have a special structure we put on the stack that has
> >> the list_head and the preload state instead.
> 
> This suggestion you didn't address at all.

And do that for what?  It's less convenient and you're gonna have to
preload it fully every single time and then destroy it.  Why do that?

> If we can't put state in the structure because of the problem of
> multiple accesses why can't we take the state out of the structure
> entirely and put it into a stack local variable?
> 
> That would reduce the cognitive load because it becomes clear how
> the pieces connect together.
> 
> That would remove the need for disabling preemption and other behind
> the scenes magic.

Really, *you* need to lower your cognitive overhead on percpu
operations.  This is fairly basic stuff.  I mean, if this is too hard
or whatever, how do you even use RCU?

> Please sit down and relook at your interface again.  People use idr
> where they need a unique number associatedand they really don't care.

The above is simply untrue.  We already have use cases where idr is
heavily depended upon in hot paths.

> Having to think about hidden percpu variables and preemption being
> disabled in the background brings with it a lot of extra work to use the
> interface.

I can't think of why but if this is somehow cognitively difficult for
someone, just dfon't think about it and use the interface as
described.  That's the whole thing about having an interface, right?

> For the sake of a saving few lines of code you are desiging an interface
> that is harder to use correctly, and harder to think about.

How the hell is it harder to use correctly?  Before, you could
theoretically get silent allocation failure very rarely without any
indication.  Now, you don't need silly looping and if you forget
preload_end(), you wlil get a preemption warning very quickly.

> I think you are making completely the wrong trade off.  I don't want the
> cognitive burden of having to think about percpu and preemption
> disabling when using a boring utitlity function like the idr code.

Eric, I don't know.  To me, you seem way out of touch on the subject.
It really is a simple thing and percpu is something widely used in the
kernel at this point.  You just need to get used to it like we all
needed to get used to with the idea of finer grained locking way back
and RCU recently.

So, if you can propose an interface which is technically better,
please do so; otherwise, I don't really think everyone should end up
with a worse interface for the supposed congitive overhead that you
have for some reason.

Thanks.

-- 
tejun
