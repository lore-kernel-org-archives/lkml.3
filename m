Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902AbaCLFeN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 01:34:13 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:43263 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386AbaCLFeM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 01:34:12 -0400
X-Original-SENDERIP: 10.186.119.201
X-Original-MAILFROM: gioh.kim@lge.com
From: "Gioh Kim" <gioh.kim@lge.com>
To: "'SeongJae Park'" <sj38.park@gmail.com>
Cc: "'Zhang Yanfei'" <zhangyanfei@cn.fujitsu.com>,
        "'Minchan Kim'" <minchan@kernel.org>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Joonsoo Kim'" <iamjoonsoo.kim@lge.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?J+ydtOqxtO2YuCc=?= <gunho.lee@lge.com>, <chanho.min@lge.com>,
        "'Johannes Weiner'" <hannes@cmpxchg.org>
References: <002701cf3c49$be67da30$3b378e90$@lge.com> <CAEjAshodkKhOJvM+8+pmAuHJMD0Za7EtNZ+pDxz9i7v_Pav1RA@mail.gmail.com>
In-Reply-To: <CAEjAshodkKhOJvM+8+pmAuHJMD0Za7EtNZ+pDxz9i7v_Pav1RA@mail.gmail.com>
Subject: RE: Subject: [PATCH] mm: use vm_map_ram for only temporal object
Date: Wed, 12 Mar 2014 14:34:09 +0900
Message-ID: <002701cf3db4$b190acd0$14b20670$@lge.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQMGPwMWWVQgCtQR13s6873ewRux9gG0n9yrmGFFGpA=
Content-Language: ko
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I got a mail from Andrew Morton that
he fixed my typo and poor English 
like this: http://ozlabs.org/~akpm/mmots/broken-out/mm-vmallocc-enhance-vm_map_ram-comment-fix.patch

Thank you for your attention.



> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of SeongJae Park
> Sent: Tuesday, March 11, 2014 8:51 PM
> To: Gioh Kim
> Cc: Zhang Yanfei; Minchan Kim; Andrew Morton; Joonsoo Kim; linux-
> mm@kvack.org; linux-kernel@vger.kernel.org; 이건호; chanho.min@lge.com;
> Johannes Weiner
> Subject: Re: Subject: [PATCH] mm: use vm_map_ram for only temporal object
> 
> Hello Gioh,
> 
> On Mon, Mar 10, 2014 at 7:16 PM, Gioh Kim <gioh.kim@lge.com> wrote:
> >
> > The vm_map_ram has fragment problem because it couldn't purge a
> > chunk(ie, 4M address space) if there is a pinning object in that
> > addresss space. So it could consume all VMALLOC address space easily.
> > We can fix the fragmentation problem with using vmap instead of
> > vm_map_ram but vmap is known to slow operation compared to vm_map_ram.
> > Minchan said vm_map_ram is 5 times faster than vmap in his experiment.
> > So I thought we should fix fragment problem of vm_map_ram because our
> > proprietary GPU driver has used it heavily.
> >
> > On second thought, it's not an easy because we should reuse freed
> > space for solving the problem and it could make more IPI and bitmap
> > operation for searching hole. It could mitigate API's goal which is very
> fast mapping.
> > And even fragmentation problem wouldn't show in 64 bit machine.
> >
> > Another option is that the user should separate long-life and
> > short-life object and use vmap for long-life but vm_map_ram for short-
> life.
> > If we inform the user about the characteristic of vm_map_ram the user
> > can choose one according to the page lifetime.
> >
> > Let's add some notice messages to user.
> >
> > Signed-off-by: Gioh Kim <gioh.kim@lge.com>
> > Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
> > ---
> >  mm/vmalloc.c |    6 ++++++
> >  1 file changed, 6 insertions(+)
> >
> > diff --git a/mm/vmalloc.c b/mm/vmalloc.c index 0fdf968..85b6687 100644
> > --- a/mm/vmalloc.c
> > +++ b/mm/vmalloc.c
> > @@ -1083,6 +1083,12 @@ EXPORT_SYMBOL(vm_unmap_ram);
> >   * @node: prefer to allocate data structures on this node
> >   * @prot: memory protection to use. PAGE_KERNEL for regular RAM
> >   *
> > + * If you use this function for below VMAP_MAX_ALLOC pages, it could
> > + be faster
> > + * than vmap so it's good. But if you mix long-life and short-life
> > + object
> > + * with vm_map_ram, it could consume lots of address space by
> > + fragmentation
> > + * (expecially, 32bit machine). You could see failure in the end.
> 
> looks like trivial typo. Shouldn't s/expecially/especially/ ?
> 
> Thanks.
> 
> > + * Please use this function for short-life object.
> > + *
> >   * Returns: a pointer to the address that has been mapped, or %NULL on
> failure
> >   */
> >  void *vm_map_ram(struct page **pages, unsigned int count, int node,
> > pgprot_t prot)
> > --
> > 1.7.9.5
> >
> >
> > --
> > To unsubscribe, send a message with 'unsubscribe linux-mm' in the body
> > to majordomo@kvack.org.  For more info on Linux MM,
> > see: http://www.linux-mm.org/ .
> > Don't email: <a hrefmailto:"dont@kvack.org"> email@kvack.org </a>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

