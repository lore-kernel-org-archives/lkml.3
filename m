Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796Ab3AQVwn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 16:52:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4729 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756710Ab3AQVwl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 16:52:41 -0500
Date: Thu, 17 Jan 2013 16:52:37 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Cc: "Frank Ch. Eigler" <fche@redhat.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, pjones@redhat.com, hpa@zytor.com,
        dhowells@redhat.com, jwboyer@redhat.com,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH 2/3] binfmt_elf: Verify signature of signed elf binary
Message-ID: <20130117215236.GI2237@redhat.com>
References: <20130116163453.GD29845@redhat.com>
 <1358359715.4593.146.camel@falcor1>
 <20130116182804.GF29845@redhat.com>
 <1358364290.4593.178.camel@falcor1>
 <20130116215341.GA4222@redhat.com>
 <CALLzPKam_j==PXtNfQs93NbPTrYCjqM_0+XRfnvxrJBLdOJ-vQ@mail.gmail.com>
 <20130117151825.GA12165@redhat.com>
 <y0my5frsg5w.fsf@fche.csb>
 <20130117205543.GA6133@redhat.com>
 <CALLzPKaizfTZCh3A0w8-RyAy4qwgXSyckYpHttrUawLnmYjFGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALLzPKaizfTZCh3A0w8-RyAy4qwgXSyckYpHttrUawLnmYjFGw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2013 at 11:46:57PM +0200, Kasatkin, Dmitry wrote:
> On Thu, Jan 17, 2013 at 10:55 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Thu, Jan 17, 2013 at 03:33:47PM -0500, Frank Ch. Eigler wrote:
> >> Vivek Goyal <vgoyal@redhat.com> writes:
> >>
> >> > [...]
> >> >> Can you please tell a bit more how this patch protect against direct
> >> >> writing to the blocks?
> >> >
> >> > If you have loaded all the pages from disk and locked them in memory and
> >> > verified the signature, then even if somebody modifies a block on disk
> >> > it does not matter. We will not read pages from disk anymore for this
> >> > exec(). We verified the signature of executable loaded in memory and
> >> > in-memory copy is intact.
> >>
> >> Does this imply dramatically increasing physical RAM pressure and load
> >> latency, because binaries (and presumably all their shared libraries)
> >> have to be locked & loaded?  (Else if they are paged out to
> >> encrypted-swap, is that sufficient protection against manipulation?)
> >
> > Even if you employ encrypted-swap, we still need to lock down any code
> > and data which lives in executable file on disk to avoid the case of
> > it being modified directly by writing to a block. Looks like IMA will not
> > detect that case.
> >
> 
> See my IMA patch I set today, which does locking the same way as you do.

Yes but I also mentioned that still there is little problem. Signature
verification should happen after the pages have been locked and not
before that.

Also I was thinking about encrypted swap. Any root process will have access
to encrypted swap? If yes, then it atleast does not work for the use case
I am trying to solve.

By selectively signing root executable, I am differentiating it with rest
of the root executable and not trusting root process here till it is
signed. So if another root process can get to swap and modify its contents
and it modified the address space of signed process. 

So for the use case I am trying to solve, encrypted swap is not the
solution. We have to lock down all of the process memory.

Thanks
Vivek
