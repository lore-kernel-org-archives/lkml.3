Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751007Ab3KFFMN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 00:12:13 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:27815 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab3KFFML convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 00:12:11 -0500
X-AuditID: cbfee61b-b7fd56d000001fc6-54-5279cfa4bc88
From: Chao Yu <chao2.yu@samsung.com>
To: "'Gu Zheng'" <guz.fnst@cn.fujitsu.com>
Cc: "'???'" <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        =?gb2312?B?J8y35q0n?= <shu.tan@samsung.com>
References: <000001ceda8d$5b185bd0$11491370$@samsung.com>
 <5279BA67.4040906@cn.fujitsu.com>
In-reply-to: <5279BA67.4040906@cn.fujitsu.com>
Subject: RE: [f2fs-dev] [PATCH] f2fs: avoid to use a NULL point in
 destroy_segment_manager
Date: Wed, 06 Nov 2013 13:10:58 +0800
Message-id: <000101cedaae$bb7ed820$327c8860$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=gb2312
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQECxHgARzzGwNztGb8VlYqYPj89CQHEf8cam6Gr2uA=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKLMWRmVeSWpSXmKPExsVy+t9jQd2l5yuDDCZMYrF43n6A2eL6rr9M
	FpcWuVvs2XuSxeLyrjlsFq0LzzM7sHn8PziJ2WP3gs9MHn1bVjF6fN4kF8ASxWWTkpqTWZZa
	pG+XwJXRfbeTtaCZr2L7rpUsDYybubsYOTkkBEwkHi1uZYewxSQu3FvP1sXIxSEkMJ1R4tzW
	hcwQzg9GiYWNK1lBqtgEVCSWd/xnArFFBDQkpk3dzwRSxCywk1Fi9/otYEVCArES849PACvi
	FNCTmL3nJJDNwSEsECOx7b4ASJhFQFWiaf59FhCbV8BS4vCcJiYIW1Dix+R7YHFmoPn9izaw
	QdjaEk/eXWCFuFRBYsfZ14wQN1hJrJv/iwmiRlxi45FbLBMYhWYhGTULyahZSEbNQtKygJFl
	FaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZwZDyT3sG4qsHiEKMAB6MSD2+CfGWQEGtiWXFl
	7iFGCQ5mJRHeDfuAQrwpiZVVqUX58UWlOanFhxilOViUxHkPtloHCgmkJ5akZqemFqQWwWSZ
	ODilGhiDXukdtX0aZ6ev+6NznvED7p1rEt/Ey6SY9t2PbtgT4czWl1jWtOHI75qqAMX4nQlr
	DA+pTLmcL1gyw3mT1o+zYoeK61Plw9QFFn1Z5SX/R3jHFuvyX/PUrtpbL75iXmbYlVTmMWnC
	7ZqlhpG3zRIYeB4c8ohvCZRcfOt4g8LphokRV5nnLlBiKc5INNRiLipOBAAK6oBciAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gu,

> -----Original Message-----
> From: Gu Zheng [mailto:guz.fnst@cn.fujitsu.com]
> Sent: Wednesday, November 06, 2013 11:41 AM
> To: Chao Yu
> Cc: ???; linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org; linux-f2fs-devel@lists.sourceforge.net; Ì·æ­
> Subject: Re: [f2fs-dev] [PATCH] f2fs: avoid to use a NULL point in destroy_segment_manager
> 
> On 11/06/2013 09:12 AM, Chao Yu wrote:
> 
> > A NULL point should avoid to be used in destroy_segment_manager after allocating memory fail for f2fs_sm_info.
> 
> Though without this patch it still can work well, because if it failed
> to allocate f2fs_sm_info, the sit_info, free_info... all were NULL, and
> the destory path(e.g. destroy_dirty_segmap) can deal with them well.

I think it could not work well. Without this patch we may got a segment 
fault in DIRTY_I(sbi) at the following code if it failed to allocate 
f2fs_sm_info memory(sbi->sm_info). Right?

static void destroy_dirty_segmap(struct f2fs_sb_info *sbi)
{
	struct dirty_seglist_info *dirty_i = DIRTY_I(sbi);

> IMO, this patch is still a good catch.
> 
> Regards,
> Gu
> 
> >
> > Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> > ---
> >  fs/f2fs/segment.c |    2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
> > index 3d4d5fc..ff363e6
> > --- a/fs/f2fs/segment.c
> > +++ b/fs/f2fs/segment.c
> > @@ -1744,6 +1744,8 @@ static void destroy_sit_info(struct f2fs_sb_info *sbi)
> >  void destroy_segment_manager(struct f2fs_sb_info *sbi)
> >  {
> >  	struct f2fs_sm_info *sm_info = SM_I(sbi);
> > +	if (!sm_info)
> > +		return;
> >  	destroy_dirty_segmap(sbi);
> >  	destroy_curseg(sbi);
> >  	destroy_free_segmap(sbi);


