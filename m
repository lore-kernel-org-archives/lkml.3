Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079AbaATKZf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 05:25:35 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:28768 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbaATKZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 05:25:31 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-ee-52dcf98c8b50
Message-id: <52DCF98B.8000900@samsung.com>
Date: Mon, 20 Jan 2014 11:25:15 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
MIME-version: 1.0
To: Andy Whitcroft <apw@canonical.com>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, stable@vger.kernel.org
Subject: Re: [PATCH] x86: dma-mapping: fix GFP_ATOMIC macro usage
References: <1389948399-26344-1-git-send-email-m.szyprowski@samsung.com>
 <CAAq6er2UNBibzKE==fQLROgFZDfdqZhJudcK=JtEYj_iA3sfnQ@mail.gmail.com>
In-reply-to: <CAAq6er2UNBibzKE==fQLROgFZDfdqZhJudcK=JtEYj_iA3sfnQ@mail.gmail.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrALMWRmVeSWpSXmKPExsVy+t/xq7o9P+8EGfxqkrX4sFbDYtpGcYvL
	u+awWVw6sIDJYsHGR4wWmzdNZbb4seExqwO7x6yGXjaPTas62TzenTvH7vF+31U2j8+b5DxO
	tHxhDWCL4rJJSc3JLEst0rdL4MqYcS2y4J9AxcXVUg2Mm3m7GDk5JARMJKZs6WKCsMUkLtxb
	z9bFyMUhJLCUUeL3tetQzidGibcfF7J3MXJw8ApoSZw8pA/SwCKgKrF4+TdGEJtNwFCi620X
	G4gtKhAqsefjabA4r4CgxI/J91hAbBEBNYm7Z7qZQWYyC+xmlLh37SZYg7CAo8Ts9lZGiGX9
	jBLf/p8F6+YUCJb4dn4P2HnMAmYSj1rWMUPY8hKb17xlnsAoMAvJkllIymYhKVvAyLyKUTS1
	NLmgOCk911CvODG3uDQvXS85P3cTIyTUv+xgXHzM6hCjAAejEg9vh8edICHWxLLiytxDjBIc
	zEoivKGfgUK8KYmVValF+fFFpTmpxYcYmTg4gUHJwbQ0YjrDlPJFyYZtZxOYk6+0Rlq/T+eo
	kmGM+faX+62ZW2WevUQPT/9ntlsGIrJ61vtZOjXsrDqTiv9OzPdxTrt03vS2NvMN4Yq38/cJ
	zNcJP3Hf3q0m6GnB4Y9sEyse/vq9puFo5nwRTd/3+ue+aUuWaIcnHWturbV3CZLwOmRusP0H
	sxJLcUaioRZzUXEiAFIjCsdTAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2014-01-17 11:49, Andy Whitcroft wrote:
> On Fri, Jan 17, 2014 at 8:46 AM, Marek Szyprowski
> <m.szyprowski@samsung.com> wrote:
> > GFP_ATOMIC is not a single gfp flag, but a macro which expands to the other
> > flags and LACK of __GFP_WAIT flag. To check if caller wanted to perform an
> > atomic allocation, the code must test __GFP_WAIT flag presence. This patch
> > fixes the issue introduced in v3.5-rc1
> >
> > CC: stable@vger.kernel.org
> > Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> > ---
> >  arch/x86/kernel/pci-dma.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
> > index 872079a..32a81c9 100644
> > --- a/arch/x86/kernel/pci-dma.c
> > +++ b/arch/x86/kernel/pci-dma.c
> > @@ -100,7 +100,7 @@ void *dma_generic_alloc_coherent(struct device *dev, size_t size,
> >         flag |= __GFP_ZERO;
> >  again:
> >         page = NULL;
> > -       if (!(flag & GFP_ATOMIC))
> > +       if (flag & __GFP_WAIT)
>
> >From that description should this not actually be:
>
>      if (!(flag & (GFP_ATOMIC|__GFP_WAIT) == GFP_ATOMIC))
>
> Else we will start using this pool for more than __GFP_HIGH allocations?
>
> That said, it is possible this is right and the intent was to allow
> __GFP_HIGH allocations (in general) to use this contigious pool, but I
> will let someone more intimate with the code comment to that.  I would
> have hoped the code would have been as below in that case:
>
>      if (!(flag & __GFP_HIGH))
>
> Either way once this is resolved a nice comment should be added to
> make it really clear:

Exactly in this case, the GFP_ATOMIC check was (incorrectly) added by me in
commit 0a2b9a6ea936 ("X86: integrate CMA with DMA-mapping subsystem"). My
intention was to use CMA only if caller use other allocation flags than
GFP_ATOMIC, because CMA cannot be used from atomic context. The pool is not
aimed for __GFP_HIGH alocations. I will add additional comment to make clear
why __GFP_WAIT flag is being checked.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

