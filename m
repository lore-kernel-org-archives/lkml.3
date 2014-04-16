Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755113AbaDPSGs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 14:06:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17563 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753870AbaDPSGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 14:06:46 -0400
Date: Wed, 16 Apr 2014 14:06:42 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Simo Sorce <ssorce@redhat.com>, David Miller <davem@davemloft.net>,
        Tejun Heo <tj@kernel.org>, Daniel Walsh <dwalsh@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        lpoetter@redhat.com, cgroups@vger.kernel.org, kay@redhat.com,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [PATCH 2/2] net: Implement SO_PASSCGROUP to enable passing
 cgroup path
Message-ID: <20140416180642.GG31074@redhat.com>
References: <CALCETrURHNmLyccRiF_W8o2ozRMR4AaCjUE=_PU8z1+Pq6X2jQ@mail.gmail.com>
 <20140416002010.GA5035@redhat.com>
 <CALCETrWzHYN3kKcmDTFDfGhZqE4u9+6XDtiOu5nncbK_7KKH0g@mail.gmail.com>
 <20140416.085743.1614257692560892039.davem@davemloft.net>
 <CALCETrVv8SPM5xjOVGy7qO2aq3FKtG2uG57J49nO7Wy0-gg0Ew@mail.gmail.com>
 <1397664837.19767.410.camel@willson.li.ssimo.org>
 <CALCETrXn7b6UuALpGUVoyQYfR2uzk5tj2ABV=dkvtFNgqM5sxQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXn7b6UuALpGUVoyQYfR2uzk5tj2ABV=dkvtFNgqM5sxQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2014 at 09:31:25AM -0700, Andy Lutomirski wrote:
> On Wed, Apr 16, 2014 at 9:13 AM, Simo Sorce <ssorce@redhat.com> wrote:
> > On Wed, 2014-04-16 at 07:37 -0700, Andy Lutomirski wrote:
> >> On Wed, Apr 16, 2014 at 5:57 AM, David Miller <davem@davemloft.net> wrote:
> >> >
> >> > Please, just stop.
> >>
> >> No.
> >>
> >> This thread is proposing an ABI.  This means that, if the ABI ends up
> >> in Linus's kernel, then it has to be supported forever.  Now is the
> >> time to find and fix any issues with it before they become much harder
> >> to fix.
> >
> > Ok, but so far I haven't seen a single objection from you that has solid
> > grounds.
> 
> CVE-2013-1959 was caused by a new kernel feature causing a call to
> write(2) to behave as though the caller was authenticating itself to
> something else where, in previous kernels, write(2) did not
> authenticate.
> 
> Admittedly cgroups aren't currently as important as uid, but if this
> changes, then SO_PASSCGROUP, as currently written, will have *exactly*
> the same problem.

I am not sure how same issue with happen with cgroups. In the case of
socket example, you are forcing a setuid program to write to standard
output and that setuid program will run in same cgroup as caller and
will have same cgroup as caller. So even if somebody was using cgroup
information for authentication, atleast in this particular case it
will not be a problem. Both unpriviliged and priviliged programs has
same cgroups.

> 
> >
> > The only one that *may* be reasonable is the "secret" cgroup name one,
> > however nobody seem to come up with a reason why it is legitimate to
> > allow to keep cgroup names secret.
> >
> > And if you can come up with such a good reason the SO_NOPASSCGROUP
> > option seem the right solution.
> >
> >> This ABI is especially tricky because programs will use it even if
> >> they don't explicitly try to.  So just adding the ABI may break
> >> existing assumptions that are relevant to security or correctness.
> >
> > It's not clear to me what you mean by this, either you explicitly use
> > SO_PASSCGROUP or not, it's not like you can involuntarily add a flag ...
> >
> 
> The issue here is that the receiver sets SO_(PASS|PEER)CGROUP, forcing
> the sender to identify or authenticate itself.  The sender might not
> want to identify itself.  Even if you don't buy any secrecy arguments,
> the sender might not intend to authenticate.  Certainly no existing
> callers of connect or write intend to authenticate using their cgroup,
> since current kernels don't have those semantics.

Ok, so passing cgroup information is not necessarily a problem as long
as it is not used for authentication. So say somebody is just logging
all the client request and which cgroup client was in, that should not
be a problem.

I agree that before somebody uses cgroup information for authentication
purposes, may be there needs to be a bigger debate whether this info
can be used safely for authentication purposes or not and in what
circumstances it is safe to use for authentication.

But that does not mean that API to pass the cgroup information around is
wrong.

Thanks
Vivek
