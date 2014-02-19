Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177AbaBSXVA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 18:21:00 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:41935 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbaBSXU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 18:20:58 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
References: <20140219131235.GA8731@localhost>
Date: Wed, 19 Feb 2014 15:20:48 -0800
In-Reply-To: <20140219131235.GA8731@localhost> (Fengguang Wu's message of
	"Wed, 19 Feb 2014 21:12:35 +0800")
Message-ID: <87ppmipu3z.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19/bFKPLSW7GK4glvy70pbpVFOCRR1WlLU=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0031]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.1 XMSolicitRefs_0 Weightloss drug
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Fengguang Wu <fengguang.wu@intel.com>
X-Spam-Relay-Country: 
Subject: Re: [vfs] 73c12e50a: +13349.5% softirqs.RCU
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fengguang Wu <fengguang.wu@intel.com> writes:

> Hi Eric,
>
> FYI, we noticed the below changes on commit 73c12e50af3a756137071c1e1c1e99cffcbaa835
> ("vfs: Lazily remove mounts on unlinked files and directories."):
>     
> test case: dbench
>
> 5c39777e797e7ba  73c12e50af3a756137071c1e1  
> ---------------  -------------------------  
>       6.22 ~ 0%    +195.3%      18.36 ~18%  TOTAL dbench.max_latency
>
> Note: the "~ XX%" numbers are stddev percent.
>
> test case: will-it-scale/unlink2

Interesting.

So if I read this right dbench is taking much about twice as long in the
worst case with my patch, and you have some other numbers below that
indicate other variations in the workload.  Which as I read the numbers
looks like there is generally more sleeping going on.

There is one know silliness in my patch that could certainly cause this,
Fengguag could you test the incremental patch below and tell me if it
solves the regression in your numbers.

Eric

From: "Eric W. Biederman" <ebiederm@xmission.com>
Date: Wed, 19 Feb 2014 15:00:20 -0800
Subject: [PATCH] vfs: Avoid taking the locks in detach_mounts when possible.

The common case is that there are no mounts to detach so keep
that case fast by testing d_mountpoint before taking calling
into detach_mounts and taking the namespace lock.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/mount.h     |    9 ++++++++-
 fs/namespace.c |    2 +-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/mount.h b/fs/mount.h
index 2b470f34e665..5f2579d1950c 100644
--- a/fs/mount.h
+++ b/fs/mount.h
@@ -84,7 +84,14 @@ extern struct mount *__lookup_mnt_last(struct vfsmount *, struct dentry *);
 
 extern bool legitimize_mnt(struct vfsmount *, unsigned);
 
-extern void detach_mounts(struct dentry *dentry);
+extern void __detach_mounts(struct dentry *dentry);
+
+static inline void detach_mounts(struct dentry *dentry)
+{
+	if (!d_mountpoint(dentry))
+		return;
+	__detach_mounts(dentry);
+}
 
 static inline void get_mnt_ns(struct mnt_namespace *ns)
 {
diff --git a/fs/namespace.c b/fs/namespace.c
index 7abbf722ce18..7b1466a82566 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1369,7 +1369,7 @@ static int do_umount(struct mount *mnt, int flags)
  * 
  * The caller may hold dentry->d_inode->i_mutex.
  */
-void detach_mounts(struct dentry *dentry)
+void __detach_mounts(struct dentry *dentry)
 {
 	struct mountpoint *mp;
 	struct mount *mnt;
-- 
1.7.5.4


