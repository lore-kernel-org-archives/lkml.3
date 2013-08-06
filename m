Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842Ab3HFDDi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 23:03:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:16498 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502Ab3HFDDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 23:03:37 -0400
X-Authority-Analysis: v=2.0 cv=KJ7Y/S5o c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=pFOAptgLnqcA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=pvQ05lsfB1wA:10 a=lTR-N-7owPxt2Q4exCgA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1375758215.25420.19.camel@gandalf.local.home>
Subject: Re: [RFC] gcc feature request: Moving blocks into sections
From: Steven Rostedt <rostedt@goodmis.org>
To: Jason Baron <jbaron@akamai.com>
Cc: Richard Henderson <rth@twiddle.net>, Marek Polacek <polacek@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, gcc <gcc@gcc.gnu.org>,
        Ingo Molnar <mingo@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Daney <ddaney.cavm@gmail.com>,
        Behan Webster <behanw@converseincode.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Date: Mon, 05 Aug 2013 23:03:35 -0400
In-Reply-To: <52005EB8.7050907@akamai.com>
References: <1375721715.22073.80.camel@gandalf.local.home>
	 <CA+55aFw_o=D-j_SRn=Y4LhHm-tEyuP1Je5ZHVTYxbVyLyDcLEg@mail.gmail.com>
	 <1375725328.22073.101.camel@gandalf.local.home>
	 <CA+55aFwRHpL-3YObZfw6NxxDxMqQbiwp0=NnpotGj2RHDNF3iw@mail.gmail.com>
	 <CA+55aFw=OX3Zz_PJc7NUGwFLAE1RYUsPe9Dn8qHDN0nZeW2R5A@mail.gmail.com>
	 <CA+55aFyzmGzv3C9gy5Xi=pSmAOzpYMNAqrrrZmsvNbt4LdrorQ@mail.gmail.com>
	 <20130805194009.GZ17022@redhat.com> <520003B8.8090503@akamai.com>
	 <52000C76.3060601@twiddle.net> <52005EB8.7050907@akamai.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-08-05 at 22:26 -0400, Jason Baron wrote:

> I think if the 'cold' attribute on the default disabled static_key 
> branch moved the text completely out-of-line, it would satisfy your 
> requirement here?
> 
> If you like this approach, perhaps we can make something like this work 
> within gcc. As its already supported, but doesn't quite go far enough 
> for our purposes.

It may not be too bad to use.

> 
> Also, if we go down this path, it means the 2-byte jump sequence is 
> probably not going to be too useful.

Don't count us out yet :-)


static inline bool arch_static_branch(struct static_key *key)
{
	asm goto("1:"
		[...]
		: : "i" (key) : : l_yes);
	return false;
l_yes:
	goto __l_yes;
__l_yes: __attribute__((cold));
	return false;
}

Or put that logic in the caller of arch_static_branch(). Basically, we
may be able to do a short jump to the place that will do a long jump to
the real work.

I'll have to play with this and see what gcc does with the output.

-- Steve


