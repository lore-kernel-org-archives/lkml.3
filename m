Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287AbaIPDG0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 23:06:26 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:54660 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118AbaIPDGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 23:06:24 -0400
X-AuditID: cbfee61b-f79f86d00000144c-58-5417a92e47da
From: Chao Yu <chao2.yu@samsung.com>
To: "'Gu Zheng'" <guz.fnst@cn.fujitsu.com>
Cc: "'Jaegeuk Kim'" <jaegeuk@kernel.org>,
        "'Changman Lee'" <cm224.lee@samsung.com>,
        linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <003001cfd0cc$96f9e8e0$c4edbaa0$@samsung.com>
 <54179768.2010708@cn.fujitsu.com>
In-reply-to: <54179768.2010708@cn.fujitsu.com>
Subject: RE: [f2fs-dev][PATCH 4/5] f2fs: fix to clean previous mount option
 when remount_fs
Date: Tue, 16 Sep 2014 11:05:30 +0800
Message-id: <00a001cfd15b$30bdadc0$92390940$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQGo/V1HCxlBVfpNDkrgwiX/xV5zkACZNAKcnEvqOAA=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKLMWRmVeSWpSXmKPExsVy+t9jQV29leIhBq9vSllc29fIZPG8/QCz
	xZP1s5gtLi1yt7i8aw6bA6vH/4OTmD02repk89i94DOTR9+WVYwenzfJBbBGcdmkpOZklqUW
	6dslcGX8anrCUnBDsOLZ6YQGxga+LkZODgkBE4k3N5+xQdhiEhfurQeyuTiEBKYzSrzYPYEJ
	wvnBKPHs/3RGkCo2ARWJ5R3/mUBsEQENiWlT94MVMQtMY5SY/fshWEJIIFZi3bpXYA2cAnoS
	s1cuZQexhYHid5d1gMVZBFQlvr8/yAxi8wpYSnxZ/ZcdwhaU+DH5HguIzSygJbF+53EmCFte
	YvOat8wQpypI7Dj7mhHiCCuJqQvXM0LUiEtsPHKLZQKj0Cwko2YhGTULyahZSFoWMLKsYhRN
	LUguKE5KzzXSK07MLS7NS9dLzs/dxAiOjGfSOxhXNVgcYhTgYFTi4S3sEwsRYk0sK67MPcQo
	wcGsJMLrXCIeIsSbklhZlVqUH19UmpNafIhRmoNFSZz3YKt1oJBAemJJanZqakFqEUyWiYNT
	qoFRPz+wcf5KHX75PRu6ev/3z3PP8DNy2jF9pmv8jwa771ar6x3DXX8skbD/Z8v/0f6sVUcP
	32zZiu9/ihyflV6ad22r6aVFmieW37Gd1eN08fQURe1rIWJrFdaa/p0UuXCOeFf+s68Ppn5v
	Ffzv3Cvz4pBvkPQKia3/90vdajdS6DJ0ublG79NqJZbijERDLeai4kQA8LPUSYgCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gu,

> -----Original Message-----
> From: Gu Zheng [mailto:guz.fnst@cn.fujitsu.com]
> Sent: Tuesday, September 16, 2014 9:51 AM
> To: Chao Yu
> Cc: Jaegeuk Kim; Changman Lee; linux-f2fs-devel@lists.sourceforge.net;
> linux-kernel@vger.kernel.org
> Subject: Re: [f2fs-dev][PATCH 4/5] f2fs: fix to clean previous mount option when remount_fs
> 
> Hi Yu,
> On 09/15/2014 06:04 PM, Chao Yu wrote:
> 
> > In manual of mount, we descript remount as below:
> >
> > "mount -o remount,rw /dev/foo /dir
> > After  this call all old mount options are replaced and arbitrary stuff from
> > fstab is ignored, except the loop= option which is internally generated and
> > maintained by the mount command."
> >
> > Previously f2fs do not clear up old mount options when remount_fs, so we have no
> > chance of disabling previous option (e.g. flush_merge). Fix it.
> 
> Please don't.
> "Remount" should just change what you specified and keep others unchanged.

Actually, there are two kinds of different 'remount', they are all specified in
manual of mount.
1) mount -o remount,rw /dev/foo /dir
2) mount -o remount,rw  /dir

I think 'remount' in your description is the second kind, being different from the
first kind in description of this patch, for the second kind remount, 'mount' command
can keep old options by loading them from mtab/fstab then merge them with new
specified options.

Thanks,
Yu

> The problem here is that we need to provide mount opts for disable/enable
> some features, but we missed it. So the right way is adding these opts if
> we really need them.
> 
> Thanks,
> Gu
> 
> >
> > Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> > ---
> >  fs/f2fs/super.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
> > index 54444bb..90fcbe0 100644
> > --- a/fs/f2fs/super.c
> > +++ b/fs/f2fs/super.c
> > @@ -616,6 +616,9 @@ static int f2fs_remount(struct super_block *sb, int *flags, char *data)
> >  	org_mount_opt = sbi->mount_opt;
> >  	active_logs = sbi->active_logs;
> >
> > +	sbi->mount_opt.opt = 0;
> > +	sbi->active_logs = NR_CURSEG_TYPE;
> > +
> >  	/* parse mount options */
> >  	err = parse_options(sb, data);
> >  	if (err)


