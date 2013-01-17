Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194Ab3AQRgv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 12:36:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26950 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755655Ab3AQRgs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 12:36:48 -0500
Date: Thu, 17 Jan 2013 12:36:05 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com, pjones@redhat.com,
        hpa@zytor.com, dhowells@redhat.com, jwboyer@redhat.com
Subject: Re: [PATCH 2/3] binfmt_elf: Verify signature of signed elf binary
Message-ID: <20130117173605.GB2237@redhat.com>
References: <1358285695-26173-1-git-send-email-vgoyal@redhat.com>
 <1358285695-26173-3-git-send-email-vgoyal@redhat.com>
 <1358437021.2689.52.camel@falcor1>
 <20130117155154.GC12165@redhat.com>
 <1358440365.2689.72.camel@falcor1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358440365.2689.72.camel@falcor1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2013 at 11:32:45AM -0500, Mimi Zohar wrote:

[..]
> > > At this point, why would you want yet another method for signing files?
> > 
> > Are you saying that append signature instead of putting them in a section
> > or are you saying that just use IMA.
> > 
> > - For the first, I am fine with appending too if that works better. So
> >   what's wrong with current implementation. Just because we append the
> >   signatures in case of modules, we should follow the same thing for
> >   executables too?
> 
> No, I was saying that if this patch set were to be upstreamed, then the
> signature verification, at least for ELF modules and ELF executables,
> should be the same.  The patch would then be a lot smaller.

I don't think that patch is lot smaller. Initially I had written code
where signatures were appended. Parsing the signature is little different
from module. In case of modules, whole file is already in memory and
in case of executables, we are reading selected portions of file in
buffer. 

So we don't share code while parsing, hence there is no significant
code bloat when .signature section is added as opposed to appending
signature.

> 
> > - If above comment is w.r.t use of IMA, then I have no issues in using
> >   IMA as long as it can meet all the requirements. Looks like there is
> >   a long TODO list before we get there. In fact for some things its not
> >   even clear whether they fit in IMA or somehwere else.
> > 
> >   - Make sure IMA/EVM stuff chains into secureboot chain of trust.
> 
> For sure.
> 
> >   - Sort out all the memory locking related issues I mentioned in
> >     other mail. You seemed to be of opinion that it is out of scope
> >     for IMA, but I think it probably is nice extenstion.
> 
> Yes, it would be, but I'm not sure that your method of mmaping a file
> with MAP_LOCKED is scalable, when all executables are signed.  If it is,
> then why not do it in general?  Otherwise there needs to be a more
> scalable solution.

It is like running without swap enabled. There is definitely a cost
involved and I think that justfies that to begin with why not everything
should be signed. Probably a overkill.

And hence the idea of signing only very selected files on need basis.

Those who want to lock down full user space, they can happily sign full
user space and pay the penalty. But for general case, it might not make
sense.

Encrypted swap is one workaround. Which probably is more scalable then
locking down all user space in memory. But that question arises only
if we want to sign full user space in general case. And I think we 
agree that it does not make much sense.

> 
> >     Or somehow a way needs to be found to make sure nobody can modify
> >     process address space without processe's knowledge.
> 
> I'm not sure I understand.  Does your patch already address this?

Well, I was repeating the same thing in ohter words. So if we do
following.

	- No shared libaries
	- No ptrace
	- Lock down current and future mappings so nothing is swapped out.

Will it not make sure that a process address space is not modified without
process knowledge. I think my patch has little bug. I might not have
enabled a flag to lock down future mappings.

> 
> >   - Once all this works, then one needs to figure out all the RPM stuff
> >     and plugins to make sure files can be singed on build server and
> >     installed properly on target system.
> 
> Yes, we need the distros involvment in this to sign all files.
> Immutable files should be signed with digital signatures.

So you still think that I should take IMA path to solve my use case or it
is reasonable to sign executable directly and I continue down my path.

Thanks
Vivek
