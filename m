Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbaESM2c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 08:28:32 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34341 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631AbaESM2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 08:28:30 -0400
Message-ID: <5379F8E5.2070802@canonical.com>
Date: Mon, 19 May 2014 05:28:21 -0700
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, miklos@szeredi.hu,
        jmorris@namei.org, selinux@tycho.nsa.gov
CC: linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH (for 3.15) 3/5] AppArmor: Handle the rename flags.
References: <201404242020.FJD18726.LOOJtOQMFVFFSH@I-love.SAKURA.ne.jp>	<201405012058.JEG30273.LJFHOOFMtOFQVS@I-love.SAKURA.ne.jp>	<201405051449.GAE81222.LOOFtFJMQFOSVH@I-love.SAKURA.ne.jp>	<201405120053.HJG95368.HFLQSFMOOtOVJF@I-love.SAKURA.ne.jp>	<201405122221.DBG43278.LOQtJSOFVFFOHM@I-love.SAKURA.ne.jp> <201405122224.BJB51546.VJOtMSQOLOFFHF@I-love.SAKURA.ne.jp>
In-Reply-To: <201405122224.BJB51546.VJOtMSQOLOFFHF@I-love.SAKURA.ne.jp>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/2014 06:24 AM, Tetsuo Handa wrote:
>>From 819e94ae3a6d9235196d137a39afa4e0bbd79770 Mon Sep 17 00:00:00 2001
> From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Date: Mon, 12 May 2014 21:54:05 +0900
> Subject: [PATCH (for 3.15) 3/5] AppArmor: Handle the rename flags.
> 
> For AppArmor, the RENAME_EXCHANGE flag means "check permissions with
> reversed arguments" and "distinguish condition of source and target".
> Future patches will stop re-calculating pathnames.
> 
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

This isn't quite right. For apparmor at this point these paths need to
be still treated like they are separate. The second aa_path_perm, is
checking the permission to move old_inode to new_path.

see below

I've added an updated patch below

> ---
>  security/apparmor/lsm.c |   22 ++++++++++++++++++++--
>  1 files changed, 20 insertions(+), 2 deletions(-)
> 
> diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
> index c0b4366..9f21296 100644
> --- a/security/apparmor/lsm.c
> +++ b/security/apparmor/lsm.c
> @@ -331,7 +331,14 @@ static int apparmor_path_rename(struct path *old_dir, struct dentry *old_dentry,
>  		struct path_cond cond = { old_dentry->d_inode->i_uid,
>  					  old_dentry->d_inode->i_mode
>  		};
> +		struct path_cond new_cond = cond;
>  
> +		if (flags & RENAME_EXCHANGE) {
> +			/* Cross rename requires both inodes to exist. */
> +			new_cond.uid = new_dentry->d_inode->i_uid;
> +			new_cond.mode = new_dentry->d_inode->i_mode;
> +		}
> +retry:
>  		error = aa_path_perm(OP_RENAME_SRC, profile, &old_path, 0,
>  				     MAY_READ | AA_MAY_META_READ | MAY_WRITE |
>  				     AA_MAY_META_WRITE | AA_MAY_DELETE,
> @@ -339,7 +346,18 @@ static int apparmor_path_rename(struct path *old_dir, struct dentry *old_dentry,
>  		if (!error)
>  			error = aa_path_perm(OP_RENAME_DEST, profile, &new_path,
>  					     0, MAY_WRITE | AA_MAY_META_WRITE |
> -					     AA_MAY_CREATE, &cond);
> +					     AA_MAY_CREATE, &new_cond);
This isn't new_cond because its the permission to move old_inode to new_path

> +		if (!error && (flags & RENAME_EXCHANGE)) {
> +			struct path tmp_path = new_path;
> +			struct path_cond tmp_cond = new_cond;
> +
> +			new_path = old_path;
> +			old_path = tmp_path;
> +			new_cond = cond;
> +			cond = tmp_cond;
> +			flags = 0;
> +			goto retry;
> +		}
>  
>  	}
>  	return error;
> 

>From c07677ce007bbb5689b82bce0fab15a159f59874 Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Mon, 12 May 2014 21:54:05 +0900
Subject: [PATCH] AppArmor: Handle the rename flags.

For AppArmor, the RENAME_EXCHANGE flag means "check permissions with
reversed arguments" and "distinguish condition of source and target".
Future patches will stop re-calculating pathnames.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: John Johansen <john.johansen@canonical.com>
---
 security/apparmor/lsm.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index c0b4366..d7d92ad 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -332,6 +332,7 @@ static int apparmor_path_rename(struct path *old_dir, struct dentry *old_dentry,
 					  old_dentry->d_inode->i_mode
 		};
 
+retry:
 		error = aa_path_perm(OP_RENAME_SRC, profile, &old_path, 0,
 				     MAY_READ | AA_MAY_META_READ | MAY_WRITE |
 				     AA_MAY_META_WRITE | AA_MAY_DELETE,
@@ -340,6 +341,16 @@ static int apparmor_path_rename(struct path *old_dir, struct dentry *old_dentry,
 			error = aa_path_perm(OP_RENAME_DEST, profile, &new_path,
 					     0, MAY_WRITE | AA_MAY_META_WRITE |
 					     AA_MAY_CREATE, &cond);
+		if (!error && (flags & RENAME_EXCHANGE)) {
+			struct path tmp_path = new_path;
+			new_path = old_path;
+			old_path = tmp_path;
+			/* Cross rename requires both inodes to exist. */
+			cond.uid = new_dentry->d_inode->i_uid;
+			cond.mode = new_dentry->d_inode->i_mode;
+			flags = 0;
+			goto retry;
+		}
 
 	}
 	return error;
-- 
2.0.0.rc0

