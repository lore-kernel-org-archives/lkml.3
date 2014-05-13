Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761026AbaEMLTM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 07:19:12 -0400
Received: from 1wt.eu ([62.212.114.60]:35030 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760733AbaEMLTJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 07:19:09 -0400
Date: Tue, 13 May 2014 13:18:56 +0200
From: Willy Tarreau <w@1wt.eu>
To: Luis Henriques <luis.henriques@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>, Ben Myers <bpm@sgi.com>,
        dannf@debian.org, jmm@inutil.org
Subject: Re: [ 137/143] xfs: underflow bug in xfs_attrlist_by_handle()
Message-ID: <20140513111856.GG30843@1wt.eu>
References: <f07e5fe6d87f172fc73580b9c86ba9a2@local> <20140512003206.396224510@1wt.eu> <20140513110812.GA4006@hercules>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="qMm9M+Fa2AknHoGS"
Content-Disposition: inline
In-Reply-To: <20140513110812.GA4006@hercules>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Luis,

On Tue, May 13, 2014 at 12:08:12PM +0100, Luis Henriques wrote:
> > diff --git a/fs/xfs/linux-2.6/xfs_ioctl32.c b/fs/xfs/linux-2.6/xfs_ioctl32.c
> > index bad485a..782d03d 100644
> > --- a/fs/xfs/linux-2.6/xfs_ioctl32.c
> > +++ b/fs/xfs/linux-2.6/xfs_ioctl32.c
> > @@ -361,8 +361,8 @@ xfs_compat_attrlist_by_handle(
> >  	if (copy_from_user(&al_hreq, arg,
> >  			   sizeof(compat_xfs_fsop_attrlist_handlereq_t)))
> >  		return -XFS_ERROR(EFAULT);
> > -	if (al_hreq.buflen > XATTR_LIST_MAX)
> > -		return -XFS_ERROR(EINVAL);
> 
> Am I missing something or was the above return statement deleted by
> mistake?
>
> > +	if (al_hreq.buflen < sizeof(struct attrlist) ||
> > +	    al_hreq.buflen > XATTR_LIST_MAX)

Ouch! You're absolutely right, thanks a lot for spotting this!

Here's an updated patch. Dann, Moritz, you want to use this one
as well instead!

thanks,
Willy


--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-xfs-underflow-bug-in-xfs_attrlist_by_handle.patch"

>From 2282cff50cb9c2205d92b31257d894a4eda4ed86 Mon Sep 17 00:00:00 2001
From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Thu, 31 Oct 2013 21:00:10 +0300
Subject: xfs: underflow bug in xfs_attrlist_by_handle()

If we allocate less than sizeof(struct attrlist) then we end up
corrupting memory or doing a ZERO_PTR_SIZE dereference.

This can only be triggered with CAP_SYS_ADMIN.

Reported-by: Nico Golde <nico@ngolde.de>
Reported-by: Fabian Yamaguchi <fabs@goesec.de>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Ben Myers <bpm@sgi.com>

(cherry picked from commit 071c529eb672648ee8ca3f90944bcbcc730b4c06)
[dannf: backported to Debian's 2.6.32]
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 fs/xfs/linux-2.6/xfs_ioctl.c   | 3 ++-
 fs/xfs/linux-2.6/xfs_ioctl32.c | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_ioctl.c b/fs/xfs/linux-2.6/xfs_ioctl.c
index 942362f..5663351 100644
--- a/fs/xfs/linux-2.6/xfs_ioctl.c
+++ b/fs/xfs/linux-2.6/xfs_ioctl.c
@@ -410,7 +410,8 @@ xfs_attrlist_by_handle(
 		return -XFS_ERROR(EPERM);
 	if (copy_from_user(&al_hreq, arg, sizeof(xfs_fsop_attrlist_handlereq_t)))
 		return -XFS_ERROR(EFAULT);
-	if (al_hreq.buflen > XATTR_LIST_MAX)
+	if (al_hreq.buflen < sizeof(struct attrlist) ||
+	    al_hreq.buflen > XATTR_LIST_MAX)
 		return -XFS_ERROR(EINVAL);
 
 	/*
diff --git a/fs/xfs/linux-2.6/xfs_ioctl32.c b/fs/xfs/linux-2.6/xfs_ioctl32.c
index bad485a..e671047 100644
--- a/fs/xfs/linux-2.6/xfs_ioctl32.c
+++ b/fs/xfs/linux-2.6/xfs_ioctl32.c
@@ -361,7 +361,8 @@ xfs_compat_attrlist_by_handle(
 	if (copy_from_user(&al_hreq, arg,
 			   sizeof(compat_xfs_fsop_attrlist_handlereq_t)))
 		return -XFS_ERROR(EFAULT);
-	if (al_hreq.buflen > XATTR_LIST_MAX)
+	if (al_hreq.buflen < sizeof(struct attrlist) ||
+	    al_hreq.buflen > XATTR_LIST_MAX)
 		return -XFS_ERROR(EINVAL);
 
 	/*
-- 
1.7.12.2.21.g234cd45.dirty


--qMm9M+Fa2AknHoGS--
