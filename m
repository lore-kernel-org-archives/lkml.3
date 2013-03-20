Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932875Ab3CTSkR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 14:40:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5211 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755882Ab3CTSkO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 14:40:14 -0400
Date: Wed, 20 Mar 2013 14:39:53 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        dmitry.kasatkin@intel.com, akpm@linux-foundation.org,
        ebiederm@xmission.com, Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 4/4] binfmt_elf: Elf executable signature verification
Message-ID: <20130320183953.GF2273@redhat.com>
References: <1363379758-10071-1-git-send-email-vgoyal@redhat.com>
 <1363379758-10071-5-git-send-email-vgoyal@redhat.com>
 <1363703941.2532.27.camel@falcor1>
 <20130320152134.GA2273@redhat.com>
 <1363801290.2580.44.camel@falcor1.watson.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363801290.2580.44.camel@falcor1.watson.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 01:41:30PM -0400, Mimi Zohar wrote:

[..]
> Defining another Kconfig option will either memlock all signed
> executables or none.  If a distro ships with this new Kconfig enabled,
> then the 'ima_appraise_tcb' boot command line option would result in all
> executables, owned by root, being memlocked.

ima_appraise_tcb and elf signing + memlock are offering two
different features. ima_appraise_tcb is offering only disk integrity
of file while elf signing + memlock is offering in memory integrity
of executable file (even if there are root unsigned executables).

So distributrions which support ima_appraise_tcb, can ship with elf
signing and memlock feature disabled. (assuming they don't need 
in memory integrity of executable).

If they do need in-memory integrity of executable (like booting on
secureboot platform), then they do need to enable this feautre and
live with the cost because they do need this feature.

I think one area of optimization is more interesting and that is what
if those distributions are booting on a platform with secureboot disabled.
How about defining a command line option to disable memlock behavior
(only when secureboot is disabled).

> Giving of privileges based
> on the existence of a signature, does not scale.

If an application is signed by right keys, one should be able to
trust it and give priviliges. Agreed locking down executable in memory
inhibits scalability. But in general we don't want to sign whole of the
user space. And for signing selected executables this seems to be only
option (to make things foolproof).

Do you have other ideas on how to achieve in-memory integrity of file without
locking down executable in a selectively signed user space.

> Again, do not hard
> code policy in the kernel.

Do you have suggestions on how to do this while we don't trust root.

Given the fact that it is a config option and possibly a command line
option to disable it, it is not exactly hard-coded.

As per this argument, signature verification can be called though of a as a
policy too and should be configurable.  Then all the module signature code
should be modified to enable module signature only if root configures so
using a command line option. I am sure I can find other things which can be
called policy but are in kernel. I think we also need to look at what is
easy to use and what makes sense given the constraints.

> 
> > > 
> > > Lastly, adding 'VM_LOCKED' here seems to change existing, expected
> > > behavior.  According to the mlock(2) man pages, "Memory locks are not
> > > inherited by a child created via fork(2) and are automatically removed
> > > (unlocked) during an execve(2) or when the process terminates."  Someone
> > > else needs to comment on this sort of change.  Andrew?  Al?
> > 
> > I will read more about it. I know that some more work is needed here. For
> > example, one can say munlock()/munlockall() on already locked pages. I
> > was thinkingof defining a new flag say VM_LOCKED_PERM. So any pages which
> > have been locked by kernel are permanent and can not be unlocked by user
> > space until and unless process exits.
> > 
> > I just need to spend more time in this memory locking area to cover all
> > the corner cases and make sure kernel mlocked pages are not unlocked.
> 
> Vivek, there must be a good reason that execve intentionally,
> automatically unlocks the memory. 

Once a process has called execve, it gets new vma and has no
correlation to old vmas and its locks. So it think it makes sense that
newly setup vmas don't have any locks. But again, I am not an expert
in that area either. So if an expert can provide some insights here, that
would help a lot.

Thanks
Vivek
