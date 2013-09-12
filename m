Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932089Ab3ILSYV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 14:24:21 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:48060 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755448Ab3ILSYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 14:24:19 -0400
Message-ID: <1379010250.9796.118.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH 00/16] [RFC PATCH] Signed kexec support
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Greg KH <greg@kroah.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, kexec@lists.infradead.org,
        akpm@linux-foundation.org, d.kasatkin@samsung.com,
        ebiederm@xmission.com, hpa@zytor.com, matthew.garrett@nebula.com
Date: Thu, 12 Sep 2013 14:24:10 -0400
In-Reply-To: <20130912161705.GA2650@kroah.com>
References: <1378849471-10521-1-git-send-email-vgoyal@redhat.com>
	 <20130912034023.GA10877@kroah.com> <20130912114336.GA28500@redhat.com>
	 <20130912161705.GA2650@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091218-0928-0000-0000-0000018A048C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-09-12 at 09:17 -0700, Greg KH wrote:
> On Thu, Sep 12, 2013 at 07:43:36AM -0400, Vivek Goyal wrote:
> > On Wed, Sep 11, 2013 at 08:40:23PM -0700, Greg KH wrote:
> > > On Tue, Sep 10, 2013 at 05:44:15PM -0400, Vivek Goyal wrote:
> > > > Hi,
> > > > 
> > > > Matthew has been posting patches to lock down kernel either due to
> > > > secureboot requirements or because of signed modules with signing
> > > > enforced. In kernel lock down mode, kexec will be disabled and that
> > > > means kdump will not work either.
> > > > 
> > > > These patches sign /sbin/kexec and kernel verifies the signature
> > > > and allows loading a kernel if signature verification is successful.
> > > > IOW, trust is extended to validly signed user space.
> > > > 
> > > > Currently it works only for statically linked applications.
> > > 
> > > That's a really big restriction, pretty much making it not workable for
> > > distros at the moment to use.

> > It is a big restriction for general use case of signed user space but in
> > this case I am planning to build /sbin/kexec statically and solve the
> > kexec/kdump issue.
> > 
> > I have posted kexec-tools patches here.
> > 
> > https://lists.fedoraproject.org/pipermail/kernel/2013-September/004469.html
> > 
> > Once kernel patches get in, I plan to upstream kexec-tools patches too
> > and then distros should be able to build /sbin/kexec statically and
> > this should work.
> > 
> > Do you forsee a problem with that?
> 
> Your paranoia is admirable in these patches.  If they are accepted, that
> is a good first step, but what about the other kexec variants out there?
> 
> > > Any chance to change this in the future?
> > 
> > It might but currently I don't have any plans. I see atleast two issues
> > with that.
> > 
> > - If we allow dynamic linking for signed binaries, then dynamic libraries
> >   will have to be signed too. I suspect in that case pretty much whole of
> >   the user space will have to be signed. I am not sure if distros are
> >   willing to do that.
> > 
> > - Currently a shared library can be written on disk (unlike executables)
> >   while it is mapped. That means after signature verification a root just
> >   has to open and write to shared library and modify code and defeat the
> >   purpose of signature verfication.
> 
> Then the existing signature verification logic is broken if this is
> possible.
> 
> > Probably these issues can be addressed if there is a need. Just that I
> > have not looked into it.
> > 
> > > Or just rely on the existing
> > > "signed binaries" functionality we have in the kernel today for the
> > > kexec binary as well?  Wouldn't that be simpler?
> > 
> > Which signed binary mechanism are you referring to? Are you referring to
> > using IMA for signature verification? If yes, there are some issues with
> > that.
> 
> Yes, IMA.
> 
> > - IMA does not lock down signed binaries in memory. That means after
> >   signature verification files can potentially be swapped out and be
> >   attacked there and modified code then can be swapped back in.
> 
> How can you do that?  If this is the case, then IMA is pointless and
> should be fixed.
> 
> > - IMA caches the signature appraisal resutls and reappraises the things
> >   based on if file has been modified or not. But this does not detect any
> >   raw writes to disk. So after signature verification root should be able
> >   to do some raw writes to disk and IMA will think file signature are
> >   just fine.
> 
> IMA should be fixed for this problem.
> 
> > - IMA does not have mechanism to keep track of signed applications and
> >   a mechanism to disallow ptrace() by unsigned applications. That means
> >   after signature verification root can just ptrace() signed binary and
> >   modify its code/data.
> 
> Then IMA should be fixed.
> 
> > - IMA provides mechanism for file based signature verificaiton.
> >   kexec-tools also needs to verify signature of new kernel being loaded.
> >   Using IMA on bzImage file has same pitfalls where a file can be modified
> >   after signature verification.
> > 
> >   That's why I have extended keyctl() so that signature verification can
> >   be done on user space buffer. An application can first read a file in
> >   buffer and then ask kernel to verify signature. And now root should not
> >   be able to attack it.
> > 
> > So existing IMA does not seem to have been written for an environment
> > where all the user space is not signed we don't trust root and root can
> > attack a signed binary. And my patches try to fill that gap. 
> 
> It sounds like your changes should go into the IMA core code to resolve
> the issues there, as I'm sure they want to also protect from the issues
> you have pointed out here.  Have you talked to those developers about
> this?

IMA assumes a different threat model and performance tradeoffs.  The
solutions suggested for the kexec, single userspace application threat
model, presumably wouldn't scale very well.
 
Unlike the syscalls to load kernel modules, which either pass a buffer,
containing the file data and appended signature, or a file descriptor,
kexec doesn't pass either.  To get around this problem, Vivek's patches
extend the keyctl syscall to verify the userspace buffer containing the
filedata and signature.

Separating the file data signature verification from the existing kexec
syscall, even if the signature verification is done by the kernel,
results in needing to trust the application actually verified the
signature.  For this reason, Vivek's patches need to verify the
integrity of a single userspace application.

Mimi


