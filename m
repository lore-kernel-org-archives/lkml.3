Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756745Ab3AQPSc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 10:18:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58866 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755593Ab3AQPSa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 10:18:30 -0500
Date: Thu, 17 Jan 2013 10:18:25 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, pjones@redhat.com, hpa@zytor.com,
        dhowells@redhat.com, jwboyer@redhat.com,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH 2/3] binfmt_elf: Verify signature of signed elf binary
Message-ID: <20130117151825.GA12165@redhat.com>
References: <87wqvdli1o.fsf@xmission.com>
 <1358344859.4593.66.camel@falcor1>
 <20130116144836.GB29845@redhat.com>
 <1358350391.4593.112.camel@falcor1>
 <20130116163453.GD29845@redhat.com>
 <1358359715.4593.146.camel@falcor1>
 <20130116182804.GF29845@redhat.com>
 <1358364290.4593.178.camel@falcor1>
 <20130116215341.GA4222@redhat.com>
 <CALLzPKam_j==PXtNfQs93NbPTrYCjqM_0+XRfnvxrJBLdOJ-vQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALLzPKam_j==PXtNfQs93NbPTrYCjqM_0+XRfnvxrJBLdOJ-vQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2013 at 04:58:02PM +0200, Kasatkin, Dmitry wrote:
> On Wed, Jan 16, 2013 at 11:53 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Wed, Jan 16, 2013 at 02:24:50PM -0500, Mimi Zohar wrote:
> > [..]
> >> > > Sorry, this is out of scope for IMA.  Dmitry has looked into this, but
> >> > > I'm not sure where it stands at the moment.
> >> >
> >> > Ok, so that's one reason that why I wrote these patcehs. IMA currently
> >> > is not doing following things to make sure address space of signed images
> >> > is not modified by others.
> >> >
> >> > - Protecting against modifications to pages on swap.
> >> > - Protecting against modifications by ptrace.
> >> > - Protecting against modifications which bypassed filesystem and directly
> >> >   wrote to the block.
> >> >
> >> > Locking down all the pages of signed binaries in memory hopefully should
> >> > solve above problems.
> >>
> >> Signing and verifying ELF executables goes back a long time ~2003/4,
> >> from a number of esteemed kernel developers, including Greg-KH and Serge
> >> Hallyn.
> >>
> >> IMA-appraisal isn't limited to appraising a single type of file, but is
> >> a generic mechanism for appraising all files.  If there are issues that
> >> aren't being addressed, then by all means, please help by addressing
> >> them.  Duplicating a large portion of the code is not productive.
> >
> > So do you have ideas on how to address above mentioned issues. Do they
> > fit into the realm of IMA/EVM or I just need to write separate code (which
> > I have already done).
> >
> > With above issues, IMA stuff for executable files sounds incomplete.
> >
> 
> swap is a last resort. healthy system uses swap minimally.
> It is very easy to add /etc/crypttab which allows to have encrypted swap
> 
> # <target name> <source device>         <key file>      <options>
> swap   /dev/sda6       /dev/urandom    swap
> 
> And it will eliminate plenty of possible attacks.
> Processes have also RW data, modification of those will create huge
> risk for the system...

Hm..., encrypted swap is interesting. It might have overhead too. It is
one way of doing thing, but I think it would be better if we don't rely
on user has setup encrypted swap and provide a way to lock down memory of
signed executables.

> 
> But certain locking extensions like you implemented can be added to IMA as well.

Cool. That would help. I am very new to IMA. If you have some ideas on
how to go about it, I can start looking into implementing it.

> 
> It was said about ptrace already.

Sorry, did not get what was said about ptrace already? We need to disable
ptrace for signed executables. So can IMA set a process flag upon
signature verification and exec() code can give additional capability. And
as Eric mentioned that should automatically take care of ptrace issue.

> 
> > - Protecting against modifications which bypassed filesystem and directly  wrote to the block.
> 
> Can you please tell a bit more how this patch protect against direct
> writing to the blocks?

If you have loaded all the pages from disk and locked them in memory and
verified the signature, then even if somebody modifies a block on disk
it does not matter. We will not read pages from disk anymore for this
exec(). We verified the signature of executable loaded in memory and
in-memory copy is intact.

So next time somebody tries to execute same binary it will fail (because
of modified block).

Thanks
Vivek
