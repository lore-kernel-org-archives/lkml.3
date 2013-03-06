Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757860Ab3CFX4c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 18:56:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43284 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755128Ab3CFX43 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 18:56:29 -0500
Date: Wed, 6 Mar 2013 18:55:25 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Eric Paris <eparis@parisplace.org>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>
Subject: Re: IMA: How to manage user space signing policy with others
Message-ID: <20130306235525.GB29229@redhat.com>
References: <20130301213329.GC3457@redhat.com>
 <1362346944.18325.1.camel@falcor1>
 <20130304152919.GA15199@redhat.com>
 <1362423581.4392.46.camel@falcor1>
 <20130304191546.GF15199@redhat.com>
 <1362446491.4392.133.camel@falcor1>
 <20130305151829.GB4519@redhat.com>
 <1362516018.4392.233.camel@falcor1>
 <20130305215300.GE4519@redhat.com>
 <1362584551.4392.291.camel@falcor1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362584551.4392.291.camel@falcor1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 06, 2013 at 10:42:31AM -0500, Mimi Zohar wrote:

[..]
> > Mimi, so you like this idea better than the other idea of keeping two 
> > policy chains and running more restrictive rule while resolving flag
> > conflicts between two rules?
> > 
> > I have written some patches to maintain two rule chains and running
> > more restrictive rule. I can change it though.
> 
> Both options overload the file signature with additional meaning to
> indicate these files need 'special' handling (eg. memory locking).

I think memory locking is not part of integrity as such. If user space
is partially signed, then we need to lock files into memory. But if
whole of the user space is signed, we might get away without locking
everything in memory.

So I think we should not build the notion of memory locking into IMA.
Caller knows whether to lock things into memory or not. IMA should
just facilitate integrity verification (before locking and after
locking) and it is left to the caller to decide when is the right
time to do verification.

>  If
> we merge rules, then all files with a signature would be processed with
> this special handling; in the other case, the special handling is
> limited to a particular policy.
> 
> The basic premise, that all files with a valid signature need this
> special handling, is flawed.  If some other mechanism would be used to
> identify these files requiring 'special' handling, then merging of
> policy rules would be a non-issue.  We wouldn't even need to merge
> rules.

I am not sure what does "special handling" mean here, but then we are
hardcoding things in file's extended attributes. 

In this case kernel needs to decide how to handle file. (possibly based
on a config option). Again going back to memlock example, IMA or file
attribute should not dictate whether file should be memlocked or not.
Whether file's appraisal result should be cached or not. Whether
"measurement" of cache results should be cached or not. This is much
worse hardcoding to me. 

IMHO, IMA can provide simple callable functions (like verify_signature())
which does not assume too much and let caller figure out the thigs
around it. This is much more simple.

> 
> My preference would be to define some other mechanism to identify these
> files. (Agreed, using the 'security.ima' xattr, is a kludge.)

IMO, it should not a file's attribtue. Caller knows how to handle it.
IMA should just verify the integrity. Caller can choose to lock or not
lock the file in memory depending on its needs and environment it is
operating in. And I don't think this kind of information should be
file specific.

>  With EVM
> protection of LSM labels, you might consider defining a policy based on
> LSM labels.  Otherwise, consider defining and using a different extended
> attribute, or any other file metadata, for this purpose.  Once some
> method for identifying these files, other than file signature, is
> defined, we could then add a new policy option (eg. memlock) or even
> action primitive (eg. appraise_memlock).
> 
> As the 'special' handling probably doesn't scale very well, we're better
> off not requiring it for all signed files.  Hopefully, the affects of
> not having this special privilege, will be limited to only what has been
> discussed (eg. kdump).  Even this decision, will require more than my
> agreement.

IMHO, defining directly callable IMA hooks is much simpler, and much
more maintainable and much more scalable. Atleast we should discuss it
again why it it is not right thing to do. Why it is right thing to
do for security/keys or security/crypto to export callable functions
and then let the caller decide what to do with it. But it is not right for
security/integrity/* or security/integrity/ima*. I just don't get it.

Thanks
Vivek
