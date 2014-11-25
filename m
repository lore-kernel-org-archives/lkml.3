Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751261AbaKYPVy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 10:21:54 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:60472 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbaKYPVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 10:21:53 -0500
MIME-Version: 1.0
In-Reply-To: <CA+V-a8sgWarzFQvoHhe2uxQDJ1bZ5PM4x03wss1k5vuuuvfT0Q@mail.gmail.com>
References: <1416308268-22957-1-git-send-email-prabhakar.csengg@gmail.com>
 <20141125130416.457e48b0@recife.lan> <CA+V-a8sgWarzFQvoHhe2uxQDJ1bZ5PM4x03wss1k5vuuuvfT0Q@mail.gmail.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Tue, 25 Nov 2014 15:21:21 +0000
Message-ID: <CA+V-a8vz2dPwotm24GOX+Ut6uyp81dFrqsZJeBBkL1Ykfd+9kA@mail.gmail.com>
Subject: Re: [PATCH] media: exynos-gsc: fix build warning
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>, LMML <linux-media@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Nov 25, 2014 at 3:18 PM, Prabhakar Lad
<prabhakar.csengg@gmail.com> wrote:
> Hi Mauro,
>
> On Tue, Nov 25, 2014 at 3:04 PM, Mauro Carvalho Chehab
> <mchehab@osg.samsung.com> wrote:
>> Em Tue, 18 Nov 2014 10:57:48 +0000
> [Snip]
>>
>> -static u32 get_plane_info(struct gsc_frame *frm, u32 addr, u32 *index)
>> +static int get_plane_info(struct gsc_frame *frm, u32 addr, u32 *index, u32 *ret_addr)
>>  {
>>         if (frm->addr.y == addr) {
>>                 *index = 0;
>> -               return frm->addr.y;
>> +               *ret_addr = frm->addr.y;
>>         } else if (frm->addr.cb == addr) {
>>                 *index = 1;
>> -               return frm->addr.cb;
>> +               *ret_addr = frm->addr.cb;
>>         } else if (frm->addr.cr == addr) {
>>                 *index = 2;
>> -               return frm->addr.cr;
>> +               *ret_addr = frm->addr.cr;
>>         } else {
>>                 pr_err("Plane address is wrong");
>>                 return -EINVAL;
>>         }
>> +       return 0;
> the control wont reach here! may be you can remove the complete else
> part outside ?
>
Ah my bad :(, I missread 'ret_addr' to return.

Thanks,
--Prabhakar Lad

> with that change,
>
> Reported-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>
> Thanks,
> --Prabhakar Lad
>
>>  }
>>
>>  void gsc_set_prefbuf(struct gsc_dev *gsc, struct gsc_frame *frm)
>> @@ -352,9 +353,11 @@ void gsc_set_prefbuf(struct gsc_dev *gsc, struct gsc_frame *frm)
>>                 u32 t_min, t_max;
>>
>>                 t_min = min3(frm->addr.y, frm->addr.cb, frm->addr.cr);
>> -               low_addr = get_plane_info(frm, t_min, &low_plane);
>> +               if (get_plane_info(frm, t_min, &low_plane, &low_addr))
>> +                       return;
>>                 t_max = max3(frm->addr.y, frm->addr.cb, frm->addr.cr);
>> -               high_addr = get_plane_info(frm, t_max, &high_plane);
>> +               if (get_plane_info(frm, t_max, &high_plane, &high_addr))
>> +                       return;
>>
>>                 mid_plane = 3 - (low_plane + high_plane);
>>                 if (mid_plane == 0)
