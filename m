Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584AbaGGBZS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 21:25:18 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:44645 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219AbaGGBZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 21:25:15 -0400
X-AuditID: cbfee61a-f79e46d00000134f-2d-53b9f6f84800
From: Chao Yu <chao2.yu@samsung.com>
To: "'Jaegeuk Kim'" <jaegeuk@kernel.org>
Cc: "'Changman Lee'" <cm224.lee@samsung.com>,
        linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <000001cf95b5$eac71ad0$c0555070$@samsung.com>
 <20140705064313.GA35795@jmac.local>
In-reply-to: <20140705064313.GA35795@jmac.local>
Subject: RE: [f2fs-dev][PATCH 1/2] f2fs: check name_len of dir entry to prevent
 from deadloop
Date: Mon, 07 Jul 2014 09:24:05 +0800
Message-id: <005f01cf9982$4b8920f0$e29b62d0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQKymfVu0+WUXrYrr8JlZT05gEW09QJiWoK9mbg+YsA=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrILMWRmVeSWpSXmKPExsVy+t9jAd2f33YGG8z+wGpxbV8jk8WT9bOY
	LS4tcrfYs/cki8XlXXPYHFg9Nq3qZPPYveAzk0ffllWMHp83yQWwRHHZpKTmZJalFunbJXBl
	XLn0hq1gjlDFymkXWRoYl/N1MXJySAiYSMy5+ZoRwhaTuHBvPVsXIxeHkMAiRonrB8+xQjg/
	GCXaehazgFSxCahILO/4zwRiiwioSfTum8IEUsQsMJlRYlbfXbCEkEC8xO4t89lAbE4BA4mZ
	05+ArRAGit+Yex/MZhFQldg77RtYPa+ApcSp9unMELagxI/J98CWMQtoSazfeZwJwpaX2Lzm
	LTPEqQoSO85CnC0iYCWx6cAnVogacYmNR26xTGAUmoVk1Cwko2YhGTULScsCRpZVjKKpBckF
	xUnpuYZ6xYm5xaV56XrJ+bmbGMER8UxqB+PKBotDjAIcjEo8vAdW7QwWYk0sK67MPcQowcGs
	JMJ7xg0oxJuSWFmVWpQfX1Sak1p8iFGag0VJnPdAq3WgkEB6YklqdmpqQWoRTJaJg1OqgbF3
	2QZ2MXau5RNdjD6sb8ytP7dAWOZqTXSUPcuSOHVhZRm34AT2oxlhbV+NYr3eOpY0PDm58/IE
	4YavvP1/rBzjo5ZsXhZqX53F6xuXsWj5XYaPlzd518il75i1LIDXZdaRk7HbnI4YTPnPY/Lj
	oRmjLuusSU+UWuu5gj9y9No5ZtbHLWG2VGIpzkg01GIuKk4EALOflrOEAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jaegeuk,

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> Sent: Saturday, July 05, 2014 2:43 PM
> To: Chao Yu
> Cc: Changman Lee; linux-f2fs-devel@lists.sourceforge.net; linux-fsdevel@vger.kernel.org;
> linux-kernel@vger.kernel.org
> Subject: Re: [f2fs-dev][PATCH 1/2] f2fs: check name_len of dir entry to prevent from deadloop
> 
> Hi Chao,
> 
> On Wed, Jul 02, 2014 at 01:23:47PM +0800, Chao Yu wrote:
> > We assume that modification of some special application could result in zeroed
> > name_len, or it is consciously made by somebody. We will deadloop in
> > find_in_block when name_len of dir entry is zero.
> 
> Could you explain this a little bit more?
> I'm not sure how it can happen.

IMO,
On one hand, programs like mkfs/fsck/img2simg and f2fs could directly operate
the raw device, so bugs of these software may be triggered to generate the
corrupt data such as zeroed name_len.
On the other hand, it' could be treated as a potential security problem, because
user could crafted such a malicious image include zeroed name_len for hacking purpose.
Once such special image is being mounted, deadloop could be triggered, finally will
result in effecting on linux system's running.

Thanks,
Yu

> I think the zeroed name_len would cause some problems in f2fs_add_link.
> 
> Thanks,
> 
> >
> > This patch is added for preventing deadloop in above scenario.
> >
> > Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> > ---
> >  fs/f2fs/dir.c |   10 ++++++++++
> >  1 file changed, 10 insertions(+)
> >
> > diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
> > index be8c7af..4316ec5 100644
> > --- a/fs/f2fs/dir.c
> > +++ b/fs/f2fs/dir.c
> > @@ -121,6 +121,16 @@ static struct f2fs_dir_entry *find_in_block(struct page *dentry_page,
> >  			}
> >  		}
> >
> > +		/* check name_len to prevent from deadloop here */
> > +		if (unlikely(de->name_len == 0)) {
> > +			struct inode *inode = dentry_page->mapping->host;
> > +
> > +			f2fs_msg(inode->i_sb, KERN_ERR,
> > +				"zero-length dir entry, ino = %lu, name = %s",
> > +				(unsigned long)inode->i_ino, name->name);
> > +			break;
> > +		}
> > +
> >  		bit_start = bit_pos
> >  				+ GET_DENTRY_SLOTS(le16_to_cpu(de->name_len));
> >  	}
> > --
> > 1.7.9.5
> 
> --
> Jaegeuk Kim

