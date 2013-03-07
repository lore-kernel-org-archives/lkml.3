Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932636Ab3CGOgv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 09:36:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4156 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755185Ab3CGOgs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 09:36:48 -0500
Date: Thu, 7 Mar 2013 09:36:43 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Eric Paris <eparis@parisplace.org>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>
Subject: Re: IMA: How to manage user space signing policy with others
Message-ID: <20130307143643.GA2790@redhat.com>
References: <20130304152919.GA15199@redhat.com>
 <1362423581.4392.46.camel@falcor1>
 <20130304191546.GF15199@redhat.com>
 <1362446491.4392.133.camel@falcor1>
 <20130305151829.GB4519@redhat.com>
 <1362516018.4392.233.camel@falcor1>
 <20130305215300.GE4519@redhat.com>
 <1362584551.4392.291.camel@falcor1>
 <20130306235525.GB29229@redhat.com>
 <1362620348.4392.408.camel@falcor1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362620348.4392.408.camel@falcor1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 06, 2013 at 08:39:08PM -0500, Mimi Zohar wrote:
> On Wed, 2013-03-06 at 18:55 -0500, Vivek Goyal wrote:
> > On Wed, Mar 06, 2013 at 10:42:31AM -0500, Mimi Zohar wrote:
> > 
> > [..]
> > > > Mimi, so you like this idea better than the other idea of keeping two 
> > > > policy chains and running more restrictive rule while resolving flag
> > > > conflicts between two rules?
> > > > 
> > > > I have written some patches to maintain two rule chains and running
> > > > more restrictive rule. I can change it though.
> > > 
> > > Both options overload the file signature with additional meaning to
> > > indicate these files need 'special' handling (eg. memory locking).
> > 
> > I think memory locking is not part of integrity as such. If user space
> > is partially signed, then we need to lock files into memory. But if
> > whole of the user space is signed, we might get away without locking
> > everything in memory.
> > 
> > So I think we should not build the notion of memory locking into IMA.
> > Caller knows whether to lock things into memory or not. IMA should
> > just facilitate integrity verification (before locking and after
> > locking) and it is left to the caller to decide when is the right
> > time to do verification.
> 
> Great!  So define a hook, in the appropriate place, and IMA will
> appraise the file based on policy.

As I mentioned, current hooks have issues. They don't guarantee anything.
Caller can't conclude anything based on success because caller does not
know if any rule has been executed.

So far it worked because caller did not have to know anything more. But
now based on integrity results, caller has to take additional decision.

So if a process is given extra capability (because it was signed), hook
returning success does not tell the caller whether process executable
was signed or not.

So just defining hook is not sufficient. Similarly in the above case of
verifying signature of a file after mmap(). Calling a hook does not tell
whether file signature verification was successful or not.

Think of following hypothetical scenario. Say I have defined a flag
in mmap() system call which will verify the integrity of file otherwise
mmap() fails.

mmap(MAP_VERIFY_POST)

Now just defining another hook is not sufficient. Once hook returns
mmap() implementation need to know whether integrity of file was
verified or not. Whether the actual rule was configured or not. Otherwise
bad things willl happen. On success mmap() will say integrity of file
verified and user space will believe that mmaped file's signature are
valid. But that's  not the case.

So defining a hook only calls into IMA subsystem. Caller can't deduce much
from the success code. Things worked because I can't see any of the caller
relying on integrity results. But in new use cases we need to know whether
a particular integrity rule was executed or not and then take the
decision. Current hooks are opaque and don't export that info to caller.
And that's why I think defining more hooks or policies is not the right
way to solve this problem.
 
[..]
> > >  With EVM
> > > protection of LSM labels, you might consider defining a policy based on
> > > LSM labels.  Otherwise, consider defining and using a different extended
> > > attribute, or any other file metadata, for this purpose.  Once some
> > > method for identifying these files, other than file signature, is
> > > defined, we could then add a new policy option (eg. memlock) or even
> > > action primitive (eg. appraise_memlock).
> > > 
> > > As the 'special' handling probably doesn't scale very well, we're better
> > > off not requiring it for all signed files.  Hopefully, the affects of
> > > not having this special privilege, will be limited to only what has been
> > > discussed (eg. kdump).  Even this decision, will require more than my
> > > agreement.
> > 
> > IMHO, defining directly callable IMA hooks is much simpler, and much
> > more maintainable and much more scalable. Atleast we should discuss it
> > again why it it is not right thing to do. Why it is right thing to
> > do for security/keys or security/crypto to export callable functions
> > and then let the caller decide what to do with it. But it is not right for
> > security/integrity/* or security/integrity/ima*. I just don't get it.
> 
> The purpose of both /crypto and /keys is to provide a callable service
> to other parts of the kernel (and expose an interface to userspace).

And like crypto and keys, IMA can a callable service too. Why not. In fact
IMA calls will be just a wrapper around  request_key() and
verify_signature(). With the addition of how to retrieve signatuer. As
IMA knows where signature are stored in what format. 

> The original purpose of IMA was to provide a hardware rooted trusted
> list of runtime measurements.  With the upstreaming of IMA-appraisal
> patches, IMA now enforces file integrity as well.

IMA file integrity goes only so far. It just makes sure file has not been
modified on disk. But it does not guarantee that file has not been
modified after signature verification. And by the time user uses the
file, it might have been modified.

By exposing IMA functions, a caller can manage this situation well. Based
on need, caller can first load the file in memory and then call IMA. Again
calling hook will not solve problem because it does not guarantee that
file appraisal actually happened. But a simple function will do a small
defined job and return code from it will tell caller whether appraisal
happened or not.

> 
> Adding an IMA call to directly appraise the integrity of a file, rather
> than adding a hook, prevents other integrity users from being able to
> define a rule at that point.

We already have security hooks in exec() code and mmap(). And current
integrity callers are happy with it.

Just because somebody calls integrity functions in exec() and mmap(),
why would other integrity users be worried about it. They just
wanted to make sure that in exec() and mmap() file integrity is verified
and that will still happen.

If another caller called into IMA functions to verify file integrity
in a specific way after the file has been loaded, then other existing
integrity users are not affected by it.

Thanks
Vivek
