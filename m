Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751219AbaKYRuo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 12:50:44 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:35424 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbaKYRum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 12:50:42 -0500
Date: Tue, 25 Nov 2014 09:50:36 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCHv2 02/10] kernel: Provide READ_ONCE and ASSIGN_ONCE
Message-ID: <20141125175036.GH5050@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1416919117-50652-1-git-send-email-borntraeger@de.ibm.com>
 <1416919117-50652-3-git-send-email-borntraeger@de.ibm.com>
 <20141125155943.GB5050@linux.vnet.ibm.com>
 <CA+55aFzY_LSLM8R2cbt=sZe8UeDtUZdX8zO6Bzf52EBg3H30qw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzY_LSLM8R2cbt=sZe8UeDtUZdX8zO6Bzf52EBg3H30qw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14112517-0009-0000-0000-0000069A6DDD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 09:28:33AM -0800, Linus Torvalds wrote:
> On Tue, Nov 25, 2014 at 7:59 AM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> >
> > We really need something like this to catch invalid sizes:
> >
> >         default: invoke_nonexistent_function();
> 
> Actually, I wonder if we should make the default: case actually just
> do something like
> 
>    barrier();
>    memcpy(res, p, size);
>    barrier();
> 
> which in no way guarantees that it's an _atomic_ access, but it does
> guarantee the semantics that you get one particular value and it won't
> get reloaded later..
> 
> That would solve the crazy sparc pte issue too.

I would be really worried about confusion due to load/store tearing,
where a READ_ONCE() reads part of its value from one ASSIGN_ONCE()
and the other part from some other ASSIGN_ONCE().  Don't get me wrong,
there are cases where the load/store tearing is harmless, it is just
that in my experience that these cases are anything but the common case.

That said, I do not claim to be familiar with more than a microscopic
fraction of the Linux kernel.

Of course, one way to resolve this would be to have one variant that did
the memcpy() and another that threw a build error, maybe READ_ONCE_FORCE()
and ASSIGN_ONCE_FORC() or some such.  I would -really- like to be informed
if I do READ_ONCE() of a long long on a 32-bit system.  ;-)

/me goes off to see if there are any ACCESS_ONCE() of long longs in RCU...

							Thanx, Paul

