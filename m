Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749Ab3HUSgd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 14:36:33 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:18071 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451Ab3HUSgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 14:36:32 -0400
Date: Wed, 21 Aug 2013 14:33:51 -0400
From: Dwight Engen <dwight.engen@oracle.com>
To: Ben Myers <bpm@sgi.com>
Cc: Jeremy Kerr <jk@ozlabs.org>, cbe-oss-dev@lists.ozlabs.org,
        Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
        linux-next@vger.kernel.org, Gao feng <gaofeng@cn.fujitsu.com>,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH] powerpc/spufs: convert userns uid/gid mount options to
 kuid/kgid
Message-ID: <20130821143351.5840d556@oracle.com>
In-Reply-To: <20130821155654.GI5262@sgi.com>
References: <20130820172052.1f0d89ddf6a1a40ef70333fd@canb.auug.org.au>
	<20130820120702.000b044e@oracle.com>
	<201308202246.30869.arnd@arndb.de>
	<20130821010822.220f592a@oracle.com>
	<52145E6C.80404@ozlabs.org>
	<20130821155654.GI5262@sgi.com>
Organization: Oracle Corporation
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Jeremy Kerr <jk@ozlabs.org>
Tested-by: Jeremy Kerr <jk@ozlabs.org>
Signed-off-by: Dwight Engen <dwight.engen@oracle.com>
---
 arch/powerpc/platforms/cell/spufs/inode.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/platforms/cell/spufs/inode.c b/arch/powerpc/platforms/cell/spufs/inode.c
index f390042..87ba7cf 100644
--- a/arch/powerpc/platforms/cell/spufs/inode.c
+++ b/arch/powerpc/platforms/cell/spufs/inode.c
@@ -620,12 +620,16 @@ spufs_parse_options(struct super_block *sb, char *options, struct inode *root)
 		case Opt_uid:
 			if (match_int(&args[0], &option))
 				return 0;
-			root->i_uid = option;
+			root->i_uid = make_kuid(current_user_ns(), option);
+			if (!uid_valid(root->i_uid))
+				return 0;
 			break;
 		case Opt_gid:
 			if (match_int(&args[0], &option))
 				return 0;
-			root->i_gid = option;
+			root->i_gid = make_kgid(current_user_ns(), option);
+			if (!gid_valid(root->i_gid))
+				return 0;
 			break;
 		case Opt_mode:
 			if (match_octal(&args[0], &option))
-- 
1.8.1.4

On Wed, 21 Aug 2013 10:56:54 -0500
Ben Myers <bpm@sgi.com> wrote:

> Hey Dwight,
> 
> On Wed, Aug 21, 2013 at 02:30:04PM +0800, Jeremy Kerr wrote:
> > > Yes, I agree. The other filesystems that take an Opt_uid as well
> > > do use current_user_ns() and not init_user_ns. They also do a
> > > uid_valid() check and fail the mount (or fallback to
> > > GLOBAL_ROOT_UID). So I think that would look like this:
> > 
> > Looks good to me. Builds and mounts as expected.
> > 
> > Acked-by: Jeremy Kerr <jk@ozlabs.org>
> 
> Could you repost this patch with the right subject and a commit
> header?  Given Jeremy's Ack I think we could proceed to pull this in.

Sure, I just wanted to make sure someone had tested it first, which it
looks like Jeremy did, thanks.

> Regards,
> 	Ben

