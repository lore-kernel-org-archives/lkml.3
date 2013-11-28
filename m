Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758628Ab3K1HLh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 02:11:37 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:35978 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184Ab3K1HLe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 02:11:34 -0500
From: Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
CC: "bhe@redhat.com" <bhe@redhat.com>, "tom.vaden@hp.com" <tom.vaden@hp.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "ptesarik@suse.cz" <ptesarik@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lisa.mitchell@hp.com" <lisa.mitchell@hp.com>,
        "vgoyal@redhat.com" <vgoyal@redhat.com>,
        "anderson@redhat.com" <anderson@redhat.com>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "jingbai.ma@hp.com" <jingbai.ma@hp.com>
Subject: Re: [PATCH 0/3] makedumpfile: hugepage filtering for vmcore dump
Thread-Topic: [PATCH 0/3] makedumpfile: hugepage filtering for vmcore dump
Thread-Index: AQHO51LV1kksR0zQtUinUJVDkNQRF5o5yYDQ
Date: Thu, 28 Nov 2013 07:08:26 +0000
Message-ID: <0910DD04CBD6DE4193FCF86B9C00BE971C7EC5@BPXM01GP.gisp.nec.co.jp>
References: <20131105134532.32112.78008.stgit@k.asiapacific.hpqcorp.net>
 <20131105202631.GC4598@redhat.com>
 <0910DD04CBD6DE4193FCF86B9C00BE971BB7A9@BPXM01GP.gisp.nec.co.jp>
 <527AE4DE.3050209@jp.fujitsu.com> <528F04EB.4070109@jp.fujitsu.com>
In-Reply-To: <528F04EB.4070109@jp.fujitsu.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.21.40.240]
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/11/22 16:18:20, kexec <kexec-bounces@lists.infradead.org> wrote:
> (2013/11/07 9:54), HATAYAMA Daisuke wrote:
> > (2013/11/06 11:21), Atsushi Kumagai wrote:
> >> (2013/11/06 5:27), Vivek Goyal wrote:
> >>> On Tue, Nov 05, 2013 at 09:45:32PM +0800, Jingbai Ma wrote:
> >>>> This patch set intend to exclude unnecessary hugepages from vmcore dump file.
> >>>>
> >>>> This patch requires the kernel patch to export necessary data structures into
> >>>> vmcore: "kexec: export hugepage data structure into vmcoreinfo"
> >>>> http://lists.infradead.org/pipermail/kexec/2013-November/009997.html
> >>>>
> >>>> This patch introduce two new dump levels 32 and 64 to exclude all unused and
> >>>> active hugepages. The level to exclude all unnecessary pages will be 127 now.
> >>>
> >>> Interesting. Why hugepages should be treated any differentely than normal
> >>> pages?
> >>>
> >>> If user asked to filter out free page, then it should be filtered and
> >>> it should not matter whether it is a huge page or not?
> >>
> >> I'm making a RFC patch of hugepages filtering based on such policy.
> >>
> >> I attach the prototype version.
> >> It's able to filter out also THPs, and suitable for cyclic processing
> >> because it depends on mem_map and looking up it can be divided into
> >> cycles. This is the same idea as page_is_buddy().
> >>
> >> So I think it's better.
> >>
> >
> >> @@ -4506,14 +4583,49 @@ __exclude_unnecessary_pages(unsigned long mem_map,
> >>                && !isAnon(mapping)) {
> >>                if (clear_bit_on_2nd_bitmap_for_kernel(pfn))
> >>                    pfn_cache_private++;
> >> +            /*
> >> +             * NOTE: If THP for cache is introduced, the check for
> >> +             *       compound pages is needed here.
> >> +             */
> >>            }
> >>            /*
> >>             * Exclude the data page of the user process.
> >>             */
> >> -        else if ((info->dump_level & DL_EXCLUDE_USER_DATA)
> >> -            && isAnon(mapping)) {
> >> -            if (clear_bit_on_2nd_bitmap_for_kernel(pfn))
> >> -                pfn_user++;
> >> +        else if (info->dump_level & DL_EXCLUDE_USER_DATA) {
> >> +            /*
> >> +             * Exclude the anonnymous pages as user pages.
> >> +             */
> >> +            if (isAnon(mapping)) {
> >> +                if (clear_bit_on_2nd_bitmap_for_kernel(pfn))
> >> +                    pfn_user++;
> >> +
> >> +                /*
> >> +                 * Check the compound page
> >> +                 */
> >> +                if (page_is_hugepage(flags) && compound_order > 0) {
> >> +                    int i, nr_pages = 1 << compound_order;
> >> +
> >> +                    for (i = 1; i < nr_pages; ++i) {
> >> +                        if (clear_bit_on_2nd_bitmap_for_kernel(pfn + i))
> >> +                            pfn_user++;
> >> +                    }
> >> +                    pfn += nr_pages - 2;
> >> +                    mem_map += (nr_pages - 1) * SIZE(page);
> >> +                }
> >> +            }
> >> +            /*
> >> +             * Exclude the hugetlbfs pages as user pages.
> >> +             */
> >> +            else if (hugetlb_dtor == SYMBOL(free_huge_page)) {
> >> +                int i, nr_pages = 1 << compound_order;
> >> +
> >> +                for (i = 0; i < nr_pages; ++i) {
> >> +                    if (clear_bit_on_2nd_bitmap_for_kernel(pfn + i))
> >> +                        pfn_user++;
> >> +                }
> >> +                pfn += nr_pages - 1;
> >> +                mem_map += (nr_pages - 1) * SIZE(page);
> >> +            }
> >>            }
> >>            /*
> >>             * Exclude the hwpoison page.
> >
> > I'm concerned about the case that filtering is not performed to part of mem_map
> > entries not belonging to the current cyclic range.
> >
> > If maximum value of compound_order is larger than maximum value of
> > CONFIG_FORCE_MAX_ZONEORDER, which makedumpfile obtains by ARRAY_LENGTH(zone.free_area),
> > it's necessary to align info->bufsize_cyclic with larger one in
> > check_cyclic_buffer_overrun().
> >
> 
> ping, in case you overlooked this...

Sorry for the delayed response, I prioritize the release of v1.5.5 now.

Thanks for your advice, check_cyclic_buffer_overrun() should be fixed
as you said. In addition, I'm considering other way to address such case,
that is to bring the number of "overflowed pages" to the next cycle and
exclude them at the top of __exclude_unnecessary_pages() like below:

               /*
                * The pages which should be excluded still remain.
                */
               if (remainder >= 1) {
                       int i;
                       unsigned long tmp;
                       for (i = 0; i < remainder; ++i) {
                               if (clear_bit_on_2nd_bitmap_for_kernel(pfn + i)) {
                                       pfn_user++;
                                       tmp++;
                               }
                       }
                       pfn += tmp;
                       remainder -= tmp;
                       mem_map += (tmp - 1) * SIZE(page);
                       continue;
               }

If this way works well, then aligning info->buf_size_cyclic will be
unnecessary.


Thanks
Atsushi Kumagai

> -- 
> Thanks.
> HATAYAMA, Daisuke
> 
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec
> 
