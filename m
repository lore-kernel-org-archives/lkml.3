Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760272Ab3EXJik (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 05:38:40 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:32075 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1760205Ab3EXJh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 05:37:29 -0400
X-IronPort-AV: E=Sophos;i="4.87,734,1363104000"; 
   d="scan'208,223";a="7355226"
Message-ID: <519F3212.6050602@cn.fujitsu.com>
Date: Fri, 24 May 2013 17:25:38 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Vahram Martirosyan <vmartirosyan@gmail.com>
CC: Dave Kleikamp <shaggy@kernel.org>,
        Vahram Martirosyan <vahram.martirosyan@linuxtesting.org>,
        jfs-discussion@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        spruce-project@linuxtesting.org
Subject: Re: [PATCH 2/2] jfs: Log shutdown error in jfs_freeze() function
References: <1369385833-6852-1-git-send-email-vahram.martirosyan@linuxtesting.org> <1369385833-6852-2-git-send-email-vahram.martirosyan@linuxtesting.org>
In-Reply-To: <1369385833-6852-2-git-send-email-vahram.martirosyan@linuxtesting.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/24 17:26:36,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/24 17:36:04,
	Serialize complete at 2013/05/24 17:36:04
Content-Type: multipart/mixed;
 boundary="------------090707070902080206040309"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090707070902080206040309
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1

Hi Vahram,
   I saw the same issue in the bugzilla:
https://bugzilla.kernel.org/show_bug.cgi?id=53331,
and I sent out a patch this issue, but I've get any feedback.
In fact, I think it's the right way to fix this issue,
can you help to test it?

Thanks,
Gu


On 05/24/2013 04:57 PM, Vahram Martirosyan wrote:

> In function jfs_freeze() the log is shut down through lmLogShutdown() call.
> When the "nointegrity" mount option is enabled, the log is actually not
> initialized. As a result the freeze operation in that case brings to a
> kernel OOPS.
> 
> The solution is to check if the "nointegrity" option is enabled and if it is not
> then shut the log down. 
> 
> May be this is not the best solution, but at least it fixes the OOPS.
> 
> Found by Linux File System Verification project (linuxtesting.org)
> 
> Signed-off-by: Vahram Martirosyan <vahram.martirosyan@linuxtesting.org>
> ---
>  fs/jfs/super.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/jfs/super.c b/fs/jfs/super.c
> index a3d424d..9788970 100644
> --- a/fs/jfs/super.c
> +++ b/fs/jfs/super.c
> @@ -615,10 +615,12 @@ static int jfs_freeze(struct super_block *sb)
>  
>  	if (!(sb->s_flags & MS_RDONLY)) {
>  		txQuiesce(sb);
> -		rc = lmLogShutdown(log);
> -		if (rc != 0) {
> -			jfs_err("lmLogShutdown failed with return code %d", rc);
> -			return rc;
> +		if (!log->no_integrity) {
> +			rc = lmLogShutdown(log);
> +			if (rc != 0) {
> +				jfs_err("lmLogShutdown failed with return code %d", rc);
> +				return rc;
> +			}
>  		}
>  		rc = updateSuper(sb, FM_CLEAN);
>  		if (rc != 0) {



--------------090707070902080206040309
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
 name="0001-fs-jfs-Add-check-if-journaling-to-disk-has-been-disa.patch"
Content-Disposition: attachment;
 filename*0="0001-fs-jfs-Add-check-if-journaling-to-disk-has-been-disa.pa";
 filename*1="tch"

>From 2f1fb676cfc98602706eb8aaa1638272b8da8dfb Mon Sep 17 00:00:00 2001
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
Date: Thu, 23 May 2013 16:14:19 +0800
Subject: [PATCH] fs/jfs: Add check if journaling to disk has been disabled in
 lbmRead()


Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 fs/jfs/jfs_logmgr.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/fs/jfs/jfs_logmgr.c b/fs/jfs/jfs_logmgr.c
index c57499d..360d27c 100644
--- a/fs/jfs/jfs_logmgr.c
+++ b/fs/jfs/jfs_logmgr.c
@@ -2009,7 +2009,13 @@ static int lbmRead(struct jfs_log * log, int pn, struct lbuf ** bpp)
 
 	bio->bi_end_io = lbmIODone;
 	bio->bi_private = bp;
-	submit_bio(READ_SYNC, bio);
+	/*check if journaling to disk has been disabled*/
+	if (log->no_integrity) {
+		bio->bi_size = 0;
+		lbmIODone(bio, 0);
+	} else {
+		submit_bio(READ_SYNC, bio);
+	}
 
 	wait_event(bp->l_ioevent, (bp->l_flag != lbmREAD));
 
-- 
1.7.7


--------------090707070902080206040309--
