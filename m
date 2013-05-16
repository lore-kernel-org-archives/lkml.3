Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755042Ab3EPBRF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 21:17:05 -0400
Received: from out1.zte.com.cn ([202.103.147.172]:51578 "EHLO zte.com.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754983Ab3EPBQ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 21:16:59 -0400
In-Reply-To: <20130515142035.GD11497@suse.de>
References: <000101ce5174$1962bac0$4c283040$@com> <20130515142035.GD11497@suse.de>
Subject: Re: Re: [PATCH] futex: bugfix for futex-key conflict when futex use
 hugepage
X-KeepSent: 1450163D:E6FBE6A2-48257B6D:00048ADD;
 type=4; name=$KeepSent
To: Mel Gorman <mgorman@suse.de>
Cc: "'Darren Hart'" <dvhart@linux.intel.com>, linux-kernel@vger.kernel.org,
        "'Ingo Molnar'" <mingo@kernel.org>,
        "'Peter Zijlstra'" <peterz@infradead.org>,
        "'Thomas Gleixner'" <tglx@linutronix.de>, Zhang Yi <wetpzy@gmail.com>
X-Mailer: Lotus Notes Release 8.5.3 September 15, 2011
Message-ID: <OF1450163D.E6FBE6A2-ON48257B6D.00048ADD-48257B6D.00070A58@zte.com.cn>
From: zhang.yi20@zte.com.cn
Date: Thu, 16 May 2013 09:16:20 +0800
X-MIMETrack: Serialize by Router on notes_smtp/zte_ltd(Release 8.5.3FP1 HF212|May 23, 2012) at
 2013-05-16 09:16:14
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
X-MAIL: mse01.zte.com.cn r4G1GW60032891
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Mel Gorman <mgorman@suse.de> wrote on 2013/05/15 22:20:35:


> Re: [PATCH] futex: bugfix for futex-key conflict when futex use hugepage
>
> On Wed, May 15, 2013 at 09:57:03PM +0800, Zhang Yi wrote:
> > The futex-keys of processes share futex determined by page-offset,
> > mapping-host, and mapping-index of the user space address. User
> > appications using hugepage for futex may lead to futex-key conflict.
> >
> > Assume there are two or more futexes in diffrent normal pages of the
> > hugepage, and each futex has the same offset in its normal page,
> > causing all the futexes have the same futex-key.
> >
> > This patch adds the normal page index in the compound page into
> > the pgoff of futex-key.
> >
> > Steps to reproduce the bug:
> > 1. The 1st thread map a file of hugetlbfs, and use the return address
> > as the 1st mutex's address, and use the return address with PAGE_SIZE
> > added as the 2nd mutex's address.
> > 2. The 1st thread initialize the two mutexes with pshared attribute,
> > and lock the two mutexes.
> > 3. The 1st thread create the 2nd thread, and the 2nd thread block on
> > the 1st mutex.
> > 4. The 1st thread create the 3rd thread, and the 3rd thread block on
> > the 2nd mutex.
> > 5. The 1st thread unlock the 2nd mutex, the 3rd thread cannot take
> > the 2nd mutex, and may block forever.
> >
> >
> > Signed-off-by: Zhang Yi <zhang.yi20@zte.com.cn>
> > Tested-by: Ma Chenggong <ma.chenggong@zte.com.cn>
> > Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
> > Reviewed-by: Darren Hart <dvhart@linux.intel.com>
> > Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
> > Reviewed-by: Mel Gorman <mgorman@suse.de>
> > Reviewed-by: Liu Dong <liu.dong3@zte.com.cn>
> > Reviewed-by: Cui Yunfeng <cui.yunfeng@zte.com.cn>
> > Reviewed-by: Lu Zhongjun <lu.zhongjun@zte.com.cn>
> > Reviewed-by: Jiang Biao <jiang.biao2@zte.com.cn>
> >
>
> Did all these people really review it? I just whinged about the last
patch
> and didn't put a Reviewed-by on it. That said, I don't actually have a
> problem with this patch and I assumed it passed your testing so
>
I mistakenly think that I should list all the people here. : )
Shall I cleanup the name list and send the patch again?

> Reviewed-by: Mel Gorman <mgorman@suse.de>
>
> The others might not agree though.
>
> I note the conversion from int offset to long offset in futex_key appears
> to have gotten lost. Is that in a separate cleanup patch now?

In old patch, I add the compound index into offset, so I make the offset
from int
to long. It is unnecessary for this patch.

>
> --
> Mel Gorman
> SUSE Labs


BTW, Does anyone have other advices for the patch?

