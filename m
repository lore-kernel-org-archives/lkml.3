Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932842AbaGYIy7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 04:54:59 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:20182 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759966AbaGYIyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 04:54:55 -0400
X-AuditID: cbfee61b-f79f86d00000144c-cb-53d21b5d041f
From: Chao Yu <chao2.yu@samsung.com>
To: "'Anton Altaparmakov'" <anton@tuxera.com>
Cc: linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        "'Anton Altaparmakov'" <aia21@hermes.cam.ac.uk>
References: <002901cfa7af$c2024dc0$4606e940$@samsung.com>
 <30788489-8F1D-416B-AF88-A547F2B66330@tuxera.com>
In-reply-to: <30788489-8F1D-416B-AF88-A547F2B66330@tuxera.com>
Subject: RE: [PATCH] ntfs: avoid incorrectly release for root inode in
 fill_super
Date: Fri, 25 Jul 2014 16:54:05 +0800
Message-id: <000601cfa7e6$19acb7a0$4d0626e0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQMBt9kvqc6a6VAjwuR9Zwecpob9+AMBfqvtmTRHKBA=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFLMWRmVeSWpSXmKPExsVy+t9jAd1Y6UvBBpt3G1ss/nGexWLnpi2s
	Fpd3zWGzaO+Yw+jA4nH67iJWj90LPjN5rFj5nsnj8ya5AJYoLpuU1JzMstQifbsEroyz5xuY
	Cl4JVNz8tY25gXElbxcjJ4eEgInEi6lnWCFsMYkL99azdTFycQgJLGKUOH7jKyuE84NR4svD
	FmaQKjYBFYnlHf+ZQGwRAW2JFXN2sIDYzALlEl8PzwKzhQRyJRZ3z2PsYuTg4BSwk/jzVRXE
	FBYIlrjy0g2kgkVAVeL4m2/sIDavgKXE+xXnmCFsQYkfk+9BTdSSWL/zOBOELS+xec1bZog7
	FSR2nH3NCHGBlcT65e+gasQlNh65xTKBUWgWklGzkIyahWTULCQtCxhZVjGKphYkFxQnpeca
	6RUn5haX5qXrJefnbmIEx8Az6R2MqxosDjEKcDAq8fB21F8MFmJNLCuuzD3EKMHBrCTCO1Pi
	UrAQb0piZVVqUX58UWlOavEhRmkOFiVx3oOt1oFCAumJJanZqakFqUUwWSYOTqkGxvm9P7cs
	Ddl39hVH1lm1ea1h7KIrU+1XN/G6SR/5rWr+TG/5q8Lj72OMRX4uunG1fK763vvv2s+tVP7y
	6R9XCeOMao3rx1p2/XDdoCLxTo+tRmKVbo/UjEWHU9Ze7os49f7nWt53mnKxzefmrX1hJXf3
	m0ujnEyZgEBbn1n+XL/IqY8iT/1Nv6rEUpyRaKjFXFScCADEZ79jfQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> -----Original Message-----
> From: Anton Altaparmakov [mailto:aia21@hermes.cam.ac.uk] On Behalf Of Anton Altaparmakov
> Sent: Friday, July 25, 2014 3:47 PM
> To: Chao Yu
> Cc: linux-ntfs-dev@lists.sourceforge.net; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] ntfs: avoid incorrectly release for root inode in fill_super
> 
> Hi,
> 
> NAK
> 
> This patch is incorrect.  Perhaps you failed to see the ihold() above the d_make_root() call?
> That means we hold two references on the inode - one from the load_system_files()::ntfs_iget()
> and one from the ihold() before d_make_root().
> 
> Thus in the error code path d_make_root() does iput() which releases one reference and then
> we do iput() in the error handling path of ntfs_fill_super() which releases the second reference.

Yes, you're right. It's my mistaken to missing the code ihold(), sorry about that.
Thank you for correcting me, and please ignore this patch.

> 
> Best regards,
> 
> 	Anton
> 
> On 25 Jul 2014, at 03:25, Chao Yu <chao2.yu@samsung.com> wrote:
> 
> > In d_make_root, when we fail to allocate dentry for root inode, we will iput
> > root inode in this function.
> > So we do not need to release this inode again at d_make_root's caller.
> >
> > Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> > ---
> > fs/ntfs/super.c | 6 +++++-
> > 1 file changed, 5 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/ntfs/super.c b/fs/ntfs/super.c
> > index 6c3296e..99c5cc6 100644
> > --- a/fs/ntfs/super.c
> > +++ b/fs/ntfs/super.c
> > @@ -2975,7 +2975,11 @@ static int ntfs_fill_super(struct super_block *sb, void *opt, const
> int silent)
> > 			vol->secure_ino = NULL;
> > 		}
> > 	}
> > -	iput(vol->root_ino);
> > +
> > +	/*
> > +	 * Just set NULL value here because we have already iput root_ino
> > +	 * in d_make_root.
> > +	 */
> > 	vol->root_ino = NULL;
> > 	iput(vol->lcnbmp_ino);
> > 	vol->lcnbmp_ino = NULL;
> 
> --
> Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
> University of Cambridge Information Services, Roger Needham Building
> 7 JJ Thomson Avenue, Cambridge, CB3 0RB, UK

