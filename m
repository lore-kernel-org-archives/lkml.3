Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932332Ab3CPQLs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 12:11:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29445 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755868Ab3CPQLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 12:11:37 -0400
X-Authority-Analysis: v=2.0 cv=BZhaI8R2 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=2s8qfAZQTSAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=rUnzm6ZD3sEA:10 a=fEJfqa3HAKIpWj7Fv_gA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1363450295.25967.89.camel@gandalf.local.home>
Subject: Re: [RFC PATCH] seq_file: Use seq_puts when seq_printf has only a
 format with no args
From: Steven Rostedt <rostedt@goodmis.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Joe Perches <joe@perches.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Sat, 16 Mar 2013 12:11:35 -0400
In-Reply-To: <CAErSpo4xN9K+aasX-3v-1PeAJpF+3Vg1WrxFaAKNUA43N3bWBw@mail.gmail.com>
References: <1363441844.2023.17.camel@joe-AO722>
	 <CAErSpo4xN9K+aasX-3v-1PeAJpF+3Vg1WrxFaAKNUA43N3bWBw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-03-16 at 09:43 -0600, Bjorn Helgaas wrote:

> This is certainly a neat trick.

Thank you ;-)

> 
> But I don't really like the fact that it complicates things for every
> future code reader, especially when a trivial change in the caller
> would accomplish the same thing.  Do you have any idea how much
> performance we would gain in exchange for the complication?

Yeah, it does complicate things a little, but that's what comments are
for. With the comment above the code explaining *exactly* what is
happening, it shouldn't make it difficult for future readers. It may
even inspire them.

It is a trivial change to fix seq_printf("fmt") to seq_puts("fmt"), but
also a maintenance burden. I also find reading "printf" much easier to
read in code than seeing "puts". Imagine:

	seq_printf(m "Format this %s\n", fmt);
	seq_puts(m, "for the following line\n");
	seq_printf(m, "followed by this %d\n", cnt);

It makes it rather ugly to read in the code. Having all users just
default to seq_printf() actually makes the code *easier* to read and to
understand.

Yes, it is complex in one little location that seldom ever changes, and
people seldom even look at. But the result of this change can make it
much more readable throughout the rest of the kernel. When you include
all of the kernel, I think the balance is towards the macro in making
the code easier to read and review. 

I always say, add more complexity in a location that is self contained
and seldom changes, to make things that are all over the place and
changes constantly, less complex.

That was my philosophy for TRACE_EVENT() and my NMI handling. Two very
complex pieces of code, but both self contained, and seldom change.

Also, gcc does this conversion too in userspace. Compile the following
program:

#include <stdio.h>
int main() {
	printf("hello world\n");
	return 0;
}

and do an objdump on it:

  4004c4:       55                      push   %rbp
  4004c5:       48 89 e5                mov    %rsp,%rbp
  4004c8:       48 83 ec 10             sub    $0x10,%rsp
  4004cc:       89 7d fc                mov    %edi,-0x4(%rbp)
  4004cf:       48 89 75 f0             mov    %rsi,-0x10(%rbp)
  4004d3:       bf e8 05 40 00          mov    $0x4005e8,%edi
  4004d8:       e8 db fe ff ff          callq  4003b8 <puts@plt>
  4004dd:       b8 00 00 00 00          mov    $0x0,%eax
  4004e2:       c9                      leaveq 
  4004e3:       c3                      retq   

It converts it to puts!

-- Steve


