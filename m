Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148Ab3LDIXH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 03:23:07 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:55715 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754588Ab3LDIXE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 03:23:04 -0500
X-AuditID: cbfee61a-b7f796d000004313-df-529ee6660107
From: Chao Yu <chao2.yu@samsung.com>
To: jaegeuk.kim@samsung.com
Cc: linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org,
        =?UTF-8?B?J+iwreWnnSc=?= <shu.tan@samsung.com>
References: <1385792739-31405-1-git-send-email-jaegeuk.kim@samsung.com>
 <1385972847.2417.113.camel@kjgkr>
 <001101cef0b6$562766e0$027634a0$@samsung.com> <1386144643.2417.148.camel@kjgkr>
In-reply-to: <1386144643.2417.148.camel@kjgkr>
Subject: RE: [f2fs-dev] [PATCH v2] f2fs: refactor bio-related operations
Date: Wed, 04 Dec 2013 16:22:12 +0800
Message-id: <001201cef0ca$0d669610$2833c230$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQGw7XbXFfvWzLj+WigF+tBDCO33/AJ1cP7KAez2bJQBxpi0LZpOb3vw
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLLMWRmVeSWpSXmKPExsVy+t9jQd20Z/OCDA79N7G4vusvk8WlRe4W
	e/aeZLG4vGsOm0XrwvPMDqweuxd8ZvLo27KK0ePzJrkA5igum5TUnMyy1CJ9uwSujEObzjMW
	nOGpuHVxDVsD42bOLkZODgkBE4lz3R+YIWwxiQv31rN1MXJxCAlMZ5S4/u06K4Tzg1Hi4Ol+
	NpAqNgEVieUd/5lAbBEBaYlZn+axgBQxC8xklGh98pUdomMvo8S2RSDtnBycAnoSx+88A+sW
	FvCQmHmlnxHEZhFQlfjcfw9sEq+ApcTWa89ZIGxBiR+T74HZzALqEpPmLWKGsLUlnry7wApx
	q4LEjrOvGSGucJPovX2cFaJGXGLjkVssExiFZiEZNQvJqFlIRs1C0rKAkWUVo2hqQXJBcVJ6
	rqFecWJucWleul5yfu4mRnAkPJPawbiyweIQowAHoxIPbwLnvCAh1sSy4srcQ4wSHMxKIrzZ
	j4FCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeQ+0WgcKCaQnlqRmp6YWpBbBZJk4OKUaGD0DfGbt
	tVt//E3EZed1V1eUPI6wUCxb8zz7lsx5WYaPSrv2sjVzzizS/iu3PyHnT6zw36kL0qLWTfsj
	duW6Jrfy54gpM6b8u/ppwcdyV6lJzfyOd9OaM2p82JTu+96N9/K/28gv9fmM1VaGbi3zx4Fu
	b99OkjSffL/LyeNVmN4sYdGrbywauZRYijMSDbWYi4oTAW2iPeyAAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk.kim@samsung.com]
> Sent: Wednesday, December 04, 2013 4:11 PM
> To: Chao Yu
> Cc: linux-kernel@vger.kernel.org; linux-f2fs-devel@lists.sourceforge.net; linux-fsdevel@vger.kernel.org; 谭姝
> Subject: RE: [f2fs-dev] [PATCH v2] f2fs: refactor bio-related operations
> 
> Hi,
> 
> > > +	if (btype == META)
> > > +		rw |= REQ_META;
> > > +
> > > +	if (is_read_io(rw)) {
> > > +		if (sync)
> > > +			rw |= READ_SYNC;
> > > +		submit_bio(rw, io->bio);
> > > +		trace_f2fs_submit_read_bio(sbi->sb, rw, type, io->bio);
> > > +		io->bio = NULL;
> > > +		return;
> > > +	}
> > > +
> > > +	if (sync)
> > > +		rw |= WRITE_SYNC;
> >
> > rw = WRITE_SYNC; ?
> 
> No, since it removes the REQ_META.
> See above.

Ah, you're right, Thanks.

> 
> >
> > > +	if (type >= META_FLUSH)
> > > +		rw |= WRITE_FLUSH_FUA;
> >
> > rw = WRITE_FLUSH_FUA; ?
> >
> > > +
> > > +	/*
> > > +	 * META_FLUSH is only from the checkpoint procedure, and we should wait
> > > +	 * this metadata bio for FS consistency.
> > > +	 */
> > > +	if (type == META_FLUSH) {
> > > +		DECLARE_COMPLETION_ONSTACK(wait);
> > > +		io->bio->bi_private = &wait;
> > > +		submit_bio(rw, io->bio);
> > > +		wait_for_completion(&wait);
> > > +	} else {
> > > +		submit_bio(rw, io->bio);
> > > +	}
> > > +	trace_f2fs_submit_write_bio(sbi->sb, rw, btype, io->bio);
> > > +	io->bio = NULL;
> > > +}
> >
> > [snip]
> >
> > Thanks,
> > Yu
> >
> 
> --
> Jaegeuk Kim
> Samsung

