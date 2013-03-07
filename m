Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552Ab3CGBjQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 20:39:16 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:45265 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132Ab3CGBjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 20:39:13 -0500
Message-ID: <1362620348.4392.408.camel@falcor1>
Subject: Re: IMA: How to manage user space signing policy with others
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Eric Paris <eparis@parisplace.org>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>
Date: Wed, 06 Mar 2013 20:39:08 -0500
In-Reply-To: <20130306235525.GB29229@redhat.com>
References: <20130301213329.GC3457@redhat.com>
	 <1362346944.18325.1.camel@falcor1> <20130304152919.GA15199@redhat.com>
	 <1362423581.4392.46.camel@falcor1> <20130304191546.GF15199@redhat.com>
	 <1362446491.4392.133.camel@falcor1> <20130305151829.GB4519@redhat.com>
	 <1362516018.4392.233.camel@falcor1> <20130305215300.GE4519@redhat.com>
	 <1362584551.4392.291.camel@falcor1> <20130306235525.GB29229@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13030701-3620-0000-0000-000001840042
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-06 at 18:55 -0500, Vivek Goyal wrote:
> On Wed, Mar 06, 2013 at 10:42:31AM -0500, Mimi Zohar wrote:
> 
> [..]
> > > Mimi, so you like this idea better than the other idea of keeping two 
> > > policy chains and running more restrictive rule while resolving flag
> > > conflicts between two rules?
> > > 
> > > I have written some patches to maintain two rule chains and running
> > > more restrictive rule. I can change it though.
> > 
> > Both options overload the file signature with additional meaning to
> > indicate these files need 'special' handling (eg. memory locking).
> 
> I think memory locking is not part of integrity as such. If user space
> is partially signed, then we need to lock files into memory. But if
> whole of the user space is signed, we might get away without locking
> everything in memory.
> 
> So I think we should not build the notion of memory locking into IMA.
> Caller knows whether to lock things into memory or not. IMA should
> just facilitate integrity verification (before locking and after
> locking) and it is left to the caller to decide when is the right
> time to do verification.

Great!  So define a hook, in the appropriate place, and IMA will
appraise the file based on policy.

> >  If
> > we merge rules, then all files with a signature would be processed with
> > this special handling; in the other case, the special handling is
> > limited to a particular policy.
> > 
> > The basic premise, that all files with a valid signature need this
> > special handling, is flawed.  If some other mechanism would be used to
> > identify these files requiring 'special' handling, then merging of
> > policy rules would be a non-issue.  We wouldn't even need to merge
> > rules.
> 
> I am not sure what does "special handling" mean here, but then we are
> hardcoding things in file's extended attributes. 
> 
> In this case kernel needs to decide how to handle file. (possibly based
> on a config option). Again going back to memlock example, IMA or file
> attribute should not dictate whether file should be memlocked or not.
> Whether file's appraisal result should be cached or not. Whether
> "measurement" of cache results should be cached or not. This is much
> worse hardcoding to me. 
> 
> IMHO, IMA can provide simple callable functions (like verify_signature())
> which does not assume too much and let caller figure out the thigs
> around it. This is much more simple.
> 
> > 
> > My preference would be to define some other mechanism to identify these
> > files. (Agreed, using the 'security.ima' xattr, is a kludge.)
> 
> IMO, it should not a file's attribtue. Caller knows how to handle it.
> IMA should just verify the integrity. Caller can choose to lock or not
> lock the file in memory depending on its needs and environment it is
> operating in. And I don't think this kind of information should be
> file specific.
> 
> >  With EVM
> > protection of LSM labels, you might consider defining a policy based on
> > LSM labels.  Otherwise, consider defining and using a different extended
> > attribute, or any other file metadata, for this purpose.  Once some
> > method for identifying these files, other than file signature, is
> > defined, we could then add a new policy option (eg. memlock) or even
> > action primitive (eg. appraise_memlock).
> > 
> > As the 'special' handling probably doesn't scale very well, we're better
> > off not requiring it for all signed files.  Hopefully, the affects of
> > not having this special privilege, will be limited to only what has been
> > discussed (eg. kdump).  Even this decision, will require more than my
> > agreement.
> 
> IMHO, defining directly callable IMA hooks is much simpler, and much
> more maintainable and much more scalable. Atleast we should discuss it
> again why it it is not right thing to do. Why it is right thing to
> do for security/keys or security/crypto to export callable functions
> and then let the caller decide what to do with it. But it is not right for
> security/integrity/* or security/integrity/ima*. I just don't get it.

The purpose of both /crypto and /keys is to provide a callable service
to other parts of the kernel (and expose an interface to userspace).
The original purpose of IMA was to provide a hardware rooted trusted
list of runtime measurements.  With the upstreaming of IMA-appraisal
patches, IMA now enforces file integrity as well.

Adding an IMA call to directly appraise the integrity of a file, rather
than adding a hook, prevents other integrity users from being able to
define a rule at that point.  I don't have a problem with exposing an
integrity interface, assuming there is a real need.

Mimi

