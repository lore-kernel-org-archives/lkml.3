Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467AbaKXTmK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 14:42:10 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:60101 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbaKXTmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 14:42:06 -0500
Date: Mon, 24 Nov 2014 11:42:00 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        David Howells <dhowells@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        linux-mips <linux-mips@linux-mips.org>, linux-x86_64@vger.kernel.org,
        linux-s390 <linux-s390@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH/RFC 7/7] kernel: Force ACCESS_ONCE to work only on scalar
 types
Message-ID: <20141124194200.GR5050@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1416834210-61738-1-git-send-email-borntraeger@de.ibm.com>
 <1416834210-61738-8-git-send-email-borntraeger@de.ibm.com>
 <15567.1416835858@warthog.procyon.org.uk>
 <CAADnVQJQydX9OU_rem+BObR0eWc-jrrwirUYVKH9rnN=Z8LG6A@mail.gmail.com>
 <CA+55aFxc72VsGTw4yFdeC1Sq65RUjYLKPD1ORnXB2d18WBMzvg@mail.gmail.com>
 <547381D7.2070404@de.ibm.com>
 <CA+55aFy+dunTcdgB4-BXsYiLDk9pf8b_L74ky-dMixpbX3JQQA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFy+dunTcdgB4-BXsYiLDk9pf8b_L74ky-dMixpbX3JQQA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14112419-0025-0000-0000-0000065907BF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2014 at 11:14:42AM -0800, Linus Torvalds wrote:
> On Mon, Nov 24, 2014 at 11:07 AM, Christian Borntraeger
> <borntraeger@de.ibm.com> wrote:
> >
> > Looks really nice, but does not work with ACCESS_ONCE is on the left-hand side:
> 
> Oh, I forgot about that. And that was indeed why I had done that whole
> helper macro originally, with ACCESS_ONCE() itself just being the
> dereference of the pointer.

OK, how about the following?

It complains if the variable is too large, for example, long long on
32-bit systems or large structures.  It is OK loading from and storing
to small structures as well, which I am having a hard time thinking of
as a disadvantage.

							Thanx, Paul

------------------------------------------------------------------------

#define get_scalar_volatile_pointer(x) ({ \
	volatile typeof(x) *__vp = &(x); \
	BUILD_BUG_ON(sizeof(*__vp) != sizeof(char) && \
		     sizeof(*__vp) != sizeof(short) && \
		     sizeof(*__vp) != sizeof(int) && \
		     sizeof(*__vp) != sizeof(long)); \
	__vp; })
#define ACCESS_ONCE(x) (*get_scalar_volatile_pointer(x))

