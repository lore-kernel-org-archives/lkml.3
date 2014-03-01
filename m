Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525AbaCACgf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 21:36:35 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:58274 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915AbaCACgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 21:36:33 -0500
X-AuditID: cbfee61a-b7fb26d00000724f-27-531147ac02ab
From: Chao Yu <chao2.yu@samsung.com>
To: "'Dave Chinner'" <david@fromorbit.com>
Cc: "'???'" <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
References: <000001cf342a$95864830$c092d890$@samsung.com>
 <20140301002643.GL30131@dastard>
In-reply-to: <20140301002643.GL30131@dastard>
Subject: RE: [f2fs-dev] [PATCH] f2fs: fix dirty page accounting when redirty
Date: Sat, 01 Mar 2014 10:35:29 +0800
Message-id: <000201cf34f7$05e676f0$11b364d0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIuhz+PxNz8d/X2mivcuF8lRpQeqgKPpGOImfha+vA=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDLMWRmVeSWpSXmKPExsVy+t9jQd017oLBBg2/jC22HLvHaHF9118m
	i0uL3C327D3JYnF51xw2B1aPU4skPHYv+Mzk0bdlFaPH501yASxRXDYpqTmZZalF+nYJXBnX
	ds1kLfjAX3Hw6k6mBsYHPF2MnBwSAiYSP1fsY4WwxSQu3FvPBmILCUxnlLhwxr6LkQvI/sEo
	MX3NLEaQBJuAisTyjv9MILaIgIbEtL1HmEGKmAW6GCWWHloE1R0j8eN7K1ADBwengK5EZ1MB
	SFhYwEfi5svpLCA2i4CqxKLHx8FKeAUsJR6sSAcJ8woISvyYfA+shFlAS2L9zuNMELa8xOY1
	b5kh7lSQ2HH2NViriICVxNIOfogScYmNR26xTGAUmoVk0iwkk2YhmTQLScsCRpZVjKKpBckF
	xUnpuYZ6xYm5xaV56XrJ+bmbGMFx8ExqB+PKBotDjAIcjEo8vBKLBIKFWBPLiitzDzFKcDAr
	ifBOuA4U4k1JrKxKLcqPLyrNSS0+xCjNwaIkznug1TpQSCA9sSQ1OzW1ILUIJsvEwSnVwMh2
	6P020a5wxjVXNxx9W1ihfnPCp5obWSKdSmquy9uuZggYMlt9m3Ntu8Cnn0f9NVatjC2cLfrs
	ruGq5Nob2nqvM14scDn7bRNTYN3jSxlL5UXXn6w/6pNZ9Ojoprpg+WPTTTy0WT+l9XsXspru
	961USVV/v+jCdS+5jEliHgZXN6to6z88cEmJpTgj0VCLuag4EQByA2HsfwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> -----Original Message-----
> From: Dave Chinner [mailto:david@fromorbit.com]
> Sent: Saturday, March 01, 2014 8:27 AM
> To: Chao Yu
> Cc: ???; linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org;
> linux-f2fs-devel@lists.sourceforge.net
> Subject: Re: [f2fs-dev] [PATCH] f2fs: fix dirty page accounting when redirty
> 
> On Fri, Feb 28, 2014 at 10:12:05AM +0800, Chao Yu wrote:
> > We should de-account dirty counters for page when redirty in ->writepage().
> >
> > Wu Fengguang described in 'commit 971767caf632190f77a40b4011c19948232eed75':
> > "writeback: fix dirtied pages accounting on redirty
> > De-account the accumulative dirty counters on page redirty.
> >
> > Page redirties (very common in ext4) will introduce mismatch between
> > counters (a) and (b)
> >
> > a) NR_DIRTIED, BDI_DIRTIED, tsk->nr_dirtied
> > b) NR_WRITTEN, BDI_WRITTEN
> >
> > This will introduce systematic errors in balanced_rate and result in
> > dirty page position errors (ie. the dirty pages are no longer balanced
> > around the global/bdi setpoints)."
> >
> > Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> > ---
> >  fs/f2fs/checkpoint.c |    1 +
> >  fs/f2fs/data.c       |    1 +
> >  fs/f2fs/node.c       |    1 +
> >  3 files changed, 3 insertions(+)
> >
> > diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
> > index c8516ee..f069249 100644
> > --- a/fs/f2fs/checkpoint.c
> > +++ b/fs/f2fs/checkpoint.c
> > @@ -178,6 +178,7 @@ no_write:
> >  redirty_out:
> >  	dec_page_count(sbi, F2FS_DIRTY_META);
> >  	wbc->pages_skipped++;
> > +	account_page_redirty(page);
> >  	set_page_dirty(page);
> >  	return AOP_WRITEPAGE_ACTIVATE;
> 
> redirty_page_for_writepage()?

set_page_dirty() in a_ops of f2fs not only call __set_page_dirty_nobuffers(),
but also set some private data of page and print trace info.
So it seems we could not easily replace with redirty_page_for_writepage().

Thanks.

> 
> Cheers,
> 
> Dave.
> --
> Dave Chinner
> david@fromorbit.com

