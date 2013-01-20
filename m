Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752401Ab3ATQgo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 11:36:44 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:47291 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309Ab3ATQgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 11:36:41 -0500
Message-ID: <1358699794.2406.78.camel@falcor1.watson.ibm.com>
Subject: Re: [PATCH 2/3] binfmt_elf: Verify signature of signed elf binary
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: James Morris <jmorris@namei.org>, Rusty Russell <rusty@rustcorp.com.au>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, pjones@redhat.com, hpa@zytor.com,
        dhowells@redhat.com, jwboyer@redhat.com,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-security-module@vger.kernel.org
Date: Sun, 20 Jan 2013 11:36:34 -0500
In-Reply-To: <20130117215236.GI2237@redhat.com>
References: <20130116163453.GD29845@redhat.com>
	 <1358359715.4593.146.camel@falcor1> <20130116182804.GF29845@redhat.com>
	 <1358364290.4593.178.camel@falcor1> <20130116215341.GA4222@redhat.com>
	 <CALLzPKam_j==PXtNfQs93NbPTrYCjqM_0+XRfnvxrJBLdOJ-vQ@mail.gmail.com>
	 <20130117151825.GA12165@redhat.com> <y0my5frsg5w.fsf@fche.csb>
	 <20130117205543.GA6133@redhat.com>
	 <CALLzPKaizfTZCh3A0w8-RyAy4qwgXSyckYpHttrUawLnmYjFGw@mail.gmail.com>
	 <20130117215236.GI2237@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012016-2876-0000-0000-0000044BAE5E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-17 at 16:52 -0500, Vivek Goyal wrote:
> On Thu, Jan 17, 2013 at 11:46:57PM +0200, Kasatkin, Dmitry wrote:
> > On Thu, Jan 17, 2013 at 10:55 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > > On Thu, Jan 17, 2013 at 03:33:47PM -0500, Frank Ch. Eigler wrote:
> > >> Vivek Goyal <vgoyal@redhat.com> writes:
> > >>
> > >> > [...]
> > >> >> Can you please tell a bit more how this patch protect against direct
> > >> >> writing to the blocks?
> > >> >
> > >> > If you have loaded all the pages from disk and locked them in memory and
> > >> > verified the signature, then even if somebody modifies a block on disk
> > >> > it does not matter. We will not read pages from disk anymore for this
> > >> > exec(). We verified the signature of executable loaded in memory and
> > >> > in-memory copy is intact.
> > >>
> > >> Does this imply dramatically increasing physical RAM pressure and load
> > >> latency, because binaries (and presumably all their shared libraries)
> > >> have to be locked & loaded?  (Else if they are paged out to
> > >> encrypted-swap, is that sufficient protection against manipulation?)
> > >
> > > Even if you employ encrypted-swap, we still need to lock down any code
> > > and data which lives in executable file on disk to avoid the case of
> > > it being modified directly by writing to a block. Looks like IMA will not
> > > detect that case.
> > >
> > 
> > See my IMA patch I set today, which does locking the same way as you do.
> 
> Yes but I also mentioned that still there is little problem. Signature
> verification should happen after the pages have been locked and not
> before that.

My initial comments mentioned this.  We can either move the existing
ima_file_mmap() or add a new hook.

> Also I was thinking about encrypted swap. Any root process will have access
> to encrypted swap? If yes, then it atleast does not work for the use case
> I am trying to solve.

Dmitry's patch example does exactly what you did, setting MAP_LOCKED
before the mmap, but does it for all ELF executables.  This could be
configurable.  I would suggest looking at the IMA policy.

> By selectively signing root executable, I am differentiating it with rest
> of the root executable and not trusting root process here till it is
> signed. So if another root process can get to swap and modify its contents
> and it modified the address space of signed process.

You're hard coding policy in the kernel and relying on userspace to only
sign specific files.

> So for the use case I am trying to solve, encrypted swap is not the
> solution. We have to lock down all of the process memory.

Like IMA-appraisal, your patches enforce integrity.  The LSM hooks were
originally defined for mandatory access control.  A parallel set of
hooks, called LIM, was proposed but were not upstreamed, as there
weren't any users other than IMA.  As a result, the IMA calls were
embedded directly into the vfs layer, except where the LSM and IMA hooks
were co-located.

James/Rusty please correct me if I'm wrong, but the new kernel module
signature verification should not be construed as a general license for
adding integrity verification in an ad-hoc manner, but was an exception
for the lack of a file descriptor.

thanks,

Mimi

