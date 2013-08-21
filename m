Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979Ab3HUFI4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 01:08:56 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:29806 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773Ab3HUFIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 01:08:55 -0400
Date: Wed, 21 Aug 2013 01:08:22 -0400
From: Dwight Engen <dwight.engen@oracle.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: cbe-oss-dev@lists.ozlabs.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Ben Myers <bpm@sgi.com>,
        linux-next@vger.kernel.org, Gao feng <gaofeng@cn.fujitsu.com>,
        linuxppc-dev@lists.ozlabs.org, Jeremy Kerr <jk@ozlabs.org>
Subject: Re: linux-next: build failure after merge of the final tree
Message-ID: <20130821010822.220f592a@oracle.com>
In-Reply-To: <201308202246.30869.arnd@arndb.de>
References: <20130820172052.1f0d89ddf6a1a40ef70333fd@canb.auug.org.au>
	<20130820120702.000b044e@oracle.com>
	<201308202246.30869.arnd@arndb.de>
Organization: Oracle Corporation
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Aug 2013 22:46:30 +0200
Arnd Bergmann <arnd@arndb.de> wrote:

> On Tuesday 20 August 2013, Dwight Engen wrote:
> > diff --git a/arch/powerpc/platforms/cell/spufs/inode.c
> > b/arch/powerpc/platforms/cell/spufs/inode.c index f390042..90fb308
> > 100644 --- a/arch/powerpc/platforms/cell/spufs/inode.c
> > +++ b/arch/powerpc/platforms/cell/spufs/inode.c
> > @@ -620,12 +620,12 @@ spufs_parse_options(struct super_block *sb,
> > char *options, struct inode *root) case Opt_uid:
> >                         if (match_int(&args[0], &option))
> >                                 return 0;
> > -                       root->i_uid = option;
> > +                       root->i_uid = make_kuid(&init_user_ns,
> > option); break;
> >                 case Opt_gid:
> >                         if (match_int(&args[0], &option))
> >                                 return 0;
> > -                       root->i_gid = option;
> > +                       root->i_gid = make_kgid(&init_user_ns,
> > option); break;
> >                 case Opt_mode:
> >                         if (match_octal(&args[0], &option))
> 
> Doesn't this mean the uid/gid is taken from the initial namespace
> rather than from the namespace of the 'mount' process calling this? I
> think the logical choice would be to have the UID be the one that
> gets passed here in the caller's namespace.

Yes, I agree. The other filesystems that take an Opt_uid as well do use
current_user_ns() and not init_user_ns. They also do a uid_valid()
check and fail the mount (or fallback to GLOBAL_ROOT_UID). So I think
that would look like this:

diff --git a/arch/powerpc/platforms/cell/spufs/inode.c b/arch/powerpc/platforms/cell/spufs/inode.c
index f390042..87ba7cf 100644
--- a/arch/powerpc/platforms/cell/spufs/inode.c
+++ b/arch/powerpc/platforms/cell/spufs/inode.c
@@ -620,12 +620,16 @@ spufs_parse_options(struct super_block *sb, char *options, struct inode *root)
                case Opt_uid:
                        if (match_int(&args[0], &option))
                                return 0;
-                       root->i_uid = option;
+                       root->i_uid = make_kuid(current_user_ns(), option);
+                       if (!uid_valid(root->i_uid))
+                               return 0;
                        break;
                case Opt_gid:
                        if (match_int(&args[0], &option))
                                return 0;
-                       root->i_gid = option;
+                       root->i_gid = make_kgid(current_user_ns(), option);
+                       if (!gid_valid(root->i_gid))
+                               return 0;
                        break;
                case Opt_mode:
                        if (match_octal(&args[0], &option))

Again, I have not run tested this so we may just want to disable SPU_FS
with USER_NS until they can be tested together.
