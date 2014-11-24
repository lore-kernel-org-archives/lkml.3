Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751297AbaKXUsQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 15:48:16 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:39238 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbaKXUsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 15:48:11 -0500
Date: Mon, 24 Nov 2014 12:48:05 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
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
Message-ID: <20141124204805.GV5050@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CAADnVQJ6eXGiasoQwyAzuejLncEHdy6MOf+m3AHnpjgn0h3+OQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQJ6eXGiasoQwyAzuejLncEHdy6MOf+m3AHnpjgn0h3+OQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14112420-0025-0000-0000-000006598DAD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2014 at 12:29:07PM -0800, Alexei Starovoitov wrote:
> On Mon, Nov 24, 2014 at 11:07 AM, Christian Borntraeger
> <borntraeger@de.ibm.com> wrote:
> >
> > Anyone with a new propopal? ;-)                                        ^
> 
> one more proposal :)
> #define __ACCESS_ONCE(x) ({ typeof(x) __var = 0; (volatile typeof(x) *)&(x); })
> #define ACCESS_ONCE(x) (*__ACCESS_ONCE(x))
> 
> works as lvalue...
> the basic idea is the same:
> constant zero can be used to initialize any scalar
> (including pointers), but unions and structs will fail to compile as:
> "error: invalid initializer"
> 
> If I'm reading pr58145 gcc bug report correctly, it
> miscompiles only structs, so we can let ACCESS_ONCE
> to work on unions. Then the following will rejects structs only:
> #define __ACCESS_ONCE(x) ({ (typeof(x))0; (volatile typeof(x) *)&(x); })
> #define ACCESS_ONCE(x) (*__ACCESS_ONCE(x))

You beat me to it.  ;-)

However, your approach would allow an ACCESS_ONCE() of a long long
to compile on 32-bit systems where it has to be broken up into a
pair of 32-bit accesses.

							Thanx, Paul

