Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956AbaA1IwO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 03:52:14 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:55248 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754674AbaA1IwL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 03:52:11 -0500
X-AuditID: cbfee61a-b7fb26d00000724f-6e-52e76fb92b91
From: Chao Yu <chao2.yu@samsung.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
References: <000101cf1bd0$d1f6be70$75e43b50$@samsung.com>
 <1390888811.25542.54.camel@kjgkr>
In-reply-to: <1390888811.25542.54.camel@kjgkr>
Subject: RE: [f2fs-dev] [PATCH] f2fs: use inode mutex to keep atomicity of
 f2fs_falloc
Date: Tue, 28 Jan 2014 16:51:13 +0800
Message-id: <000001cf1c06$3ac9a9f0$b05cfdd0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQLn+/8NyoY1LRC/kHMBJ/XOIJINvgIZpkFfmFcZ1dA=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMLMWRmVeSWpSXmKPExsVy+t9jQd1d+c+DDF6qWFzf9ZfJ4tIid4s9
	e0+yWFzeNYfNgcVj94LPTB59W1YxenzeJBfAHMVlk5Kak1mWWqRvl8CV0fyssGCBQMXbfz/Y
	Gxh/83QxcnJICJhIdC1+xQhhi0lcuLeerYuRi0NIYDqjxJML+1kgnB+MEhs/nGYDqWITUJFY
	3vGfCcQWEZCWmPVpHguIzSyQKTHn9WRWEFtIIFZi5dM1YDangJ7E/v272bsYOTiEBSIkdi6t
	AAmzCKhK/NuyEKyVV8BSouXzFyhbUOLH5HtQI9UlJs1bxAxha0s8eXeBFeJQBYkdZ18zQpxg
	JdH6/DBUjbjExiO3WCYwCs1CMmoWklGzkIyahaRlASPLKkbR1ILkguKk9FxDveLE3OLSvHS9
	5PzcTYzgoH8mtYNxZYPFIUYBDkYlHt6OzmdBQqyJZcWVuYcYJTiYlUR4g/OeBwnxpiRWVqUW
	5ccXleakFh9ilOZgURLnPdBqHSgkkJ5YkpqdmlqQWgSTZeLglGpgTDS7quJaxLvnw3FeK5n2
	vsyQHE/H+ffZbqxKEHt49Ejwsf32l8WtUpfKN+yeePJzQfeX/V1BTo3Pls4vMHzZrXvs03uN
	FRl+U9gMMvwi6n66Se3M3psY79ndpiy3pfqb7fa+Fj7J6Gmnly95nlYkUNOpfvq6sM/Mf832
	yo/Knf+eEX8yc0aqEktxRqKhFnNRcSIAc+1p/3YCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk.kim@samsung.com]
> Sent: Tuesday, January 28, 2014 2:00 PM
> To: Chao Yu
> Cc: linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org;
> linux-f2fs-devel@lists.sourceforge.net
> Subject: Re: [f2fs-dev] [PATCH] f2fs: use inode mutex to keep atomicity of f2fs_falloc
> 
> Hi,
> 
> 2014-01-28 (화), 10:29 +0800, Chao Yu:
> > Previously without protection of inode mutex, f2fs_falloc and other data
> > correlated operations will interfere with each other.
> 
> Could you explain a little bit more what kind of scenarios wrt this?

1. Without protection of i_mutex, status(e.g. i_size) of inode could be changed
by other operation(e.g. vfs_write()/vfs_truncate()) when we fallocate a file, it
may cause us walk into wrong branch code after we check these status of inode,
and vice versa.
2. i_size_write()/inode_newsize_ok() is called in f2fs_fallocate(), usually we
use i_mutex to protect these functions.

> 
> 
> > So let's use inode mutex to keep atomicity of f2fs_falloc.
> >
> > Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> > ---
> >  fs/f2fs/file.c |    5 +++++
> >  1 file changed, 5 insertions(+)
> >
> > diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
> > index 85e91ca..ece380f 100644
> > --- a/fs/f2fs/file.c
> > +++ b/fs/f2fs/file.c
> > @@ -559,6 +559,8 @@ static long f2fs_fallocate(struct file *file, int mode,
> >  	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
> >  		return -EOPNOTSUPP;
> >
> > +	mutex_lock(&inode->i_mutex);
> > +
> >  	if (mode & FALLOC_FL_PUNCH_HOLE)
> >  		ret = punch_hole(inode, offset, len);
> >  	else
> > @@ -568,6 +570,9 @@ static long f2fs_fallocate(struct file *file, int mode,
> >  		inode->i_mtime = inode->i_ctime = CURRENT_TIME;
> >  		mark_inode_dirty(inode);
> >  	}
> > +
> > +	mutex_unlock(&inode->i_mutex);
> > +
> >  	trace_f2fs_fallocate(inode, mode, offset, len, ret);
> >  	return ret;
> >  }
> 
> --
> Jaegeuk Kim
> Samsung

