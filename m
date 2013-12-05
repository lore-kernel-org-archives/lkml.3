Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756767Ab3LENKQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 08:10:16 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:54948 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756132Ab3LENKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 08:10:12 -0500
X-AuditID: cbfec7f4-b7f966d0000003d9-fd-52a07b32b06a
Message-id: <1386249008.17844.48.camel@buzz>
Subject: Re: [PATCH 2/2] ARM: fix framepointer check in unwind_frame
From: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
To: Jean Pihet <jean.pihet@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Will Deacon <will.deacon@arm.com>,
        Vyacheslav Tyrtov <v.tyrtov@samsung.com>
Date: Thu, 05 Dec 2013 17:10:08 +0400
In-reply-to: <CAFrcx1kCAjoMxBeqaO+iS2CGzX6omuW1reL636Lyj=bg5DB1Rg@mail.gmail.com>
References: <20131205083424.32632.51618.stgit@buzz>
 <20131205083430.32632.11103.stgit@buzz>
 <CAFrcx1kCAjoMxBeqaO+iS2CGzX6omuW1reL636Lyj=bg5DB1Rg@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.8.5-2+b1
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHLMWRmVeSWpSXmKPExsVy+t/xK7pG1QuCDD5+57DouryHxWLT42us
	Fpd3zWGzuH2Z12LqjB/sFi8/nmBxYPNYM28No0dLcw+bx51re9g8Ni+p9+jbsorR4/MmuQC2
	KC6blNSczLLUIn27BK6M0y9vsxR08FY8aVvO1MD4krOLkZNDQsBEouXhRHYIW0ziwr31bF2M
	XBxCAksZJT68fsgK4XxklJjR3cACUsUroCOxeudNJhBbWMBFYkZrF1g3m4CZxLZ9txlBbBEB
	NYl7/2cygjQzC3QxSUxffwisgUVAVeLkgxY2EJtTIFhi26KvLBAbljBKLJjxkxUkwSygLjFp
	3iJmiJvkJNZvW8MGsVlQ4sfkeywQNfISm9e8ZZ7AKDALScssJGWzkJQtYGRexSiaWppcUJyU
	nmuoV5yYW1yal66XnJ+7iRES5l92MC4+ZnWIUYCDUYmH90f+/CAh1sSy4srcQ4wSHMxKIrzC
	OQuChHhTEiurUovy44tKc1KLDzEycXBKNTDqWSy/xsDla3fRsINp0Z5Kt6CsL3vFJ16es7F8
	9qaKWtFNNveM2I8ErWSYZ95TGW1auiNzZbHCWkOV6obUBQZXfk+1UGbbaO207qafv1a2Vk1k
	8LcO58/xO+5nu+1T2mu+JHX5U4OvqUJ+DxLWcFZs8DvV6XU/lOuygs3xkkmW2xrZmpsV4pRY
	ijMSDbWYi4oTAQWYXW9RAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-12-05 at 13:45 +0100, Jean Pihet wrote:
> On 5 December 2013 09:34, Konstantin Khlebnikov
> <k.khlebnikov@samsung.com> wrote:
> > This patch fixes corner case when (fp + 4) overflows unsigned long,
> > for example: fp = 0xFFFFFFFF -> fp + 4 == 3.
> >
> > Signed-off-by: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
> > ---
> >  arch/arm/kernel/stacktrace.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/arch/arm/kernel/stacktrace.c b/arch/arm/kernel/stacktrace.c
> > index 00f79e5..af4e8c8 100644
> > --- a/arch/arm/kernel/stacktrace.c
> > +++ b/arch/arm/kernel/stacktrace.c
> > @@ -31,7 +31,7 @@ int notrace unwind_frame(struct stackframe *frame)
> >         high = ALIGN(low, THREAD_SIZE);
> >
> >         /* check current frame pointer is within bounds */
> > -       if (fp < (low + 12) || fp + 4 >= high)
> > +       if (fp < low + 12 || fp > high - 4)
> Shouldn't that use the '>=' comparison?

nope, fp == high-4 is fine:

-------------------+ 
... -5 -4 -3 -2 -1 | -0
-------------------+
        ^             ^
        +---- fp      +----- high
 
stack frame contains four 'unsigned long' values: {fp, sp, lr, pc}.
'fp' points to 'pc', so totally there are 16 bytes: fp-12..fp+3

> 
> Jean
> >                 return -EINVAL;
> >
> >         /* restore the registers from the stack frame */
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/


