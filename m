Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004AbaANULI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 15:11:08 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:33526 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957AbaANULE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 15:11:04 -0500
Message-ID: <52D599CC.5050300@canonical.com>
Date: Tue, 14 Jan 2014 12:10:52 -0800
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, miklos@szeredi.hu
CC: mszeredi@suse.cz, linux-security-module@vger.kernel.org,
        viro@zeniv.linux.org.uk, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, akpm@linux-foundation.org, dhowells@redhat.com,
        zab@redhat.com, jack@suse.cz, luto@amacapital.net
Subject: Re: [PATCH 00/11] cross rename v3
References: <1389219015-10980-1-git-send-email-miklos@szeredi.hu>	<201401132146.BAF65659.QJSOFVOtFHMOFL@I-love.SAKURA.ne.jp>	<1389632933.16290.15.camel@tucsk.piliscsaba.szeredi.hu>	<201401140703.ICH21836.HMJStQVFOFOLOF@I-love.SAKURA.ne.jp>	<CAJfpegs6kzkmJ8NFCuwEBGFgW5toM4X9RC+8JzJPX1V1rMmsow@mail.gmail.com> <201401142203.IDB17653.LHVJtFFOSOMQFO@I-love.SAKURA.ne.jp>
In-Reply-To: <201401142203.IDB17653.LHVJtFFOSOMQFO@I-love.SAKURA.ne.jp>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2014 05:03 AM, Tetsuo Handa wrote:
> Miklos Szeredi wrote:
>> On Mon, Jan 13, 2014 at 11:03 PM, Tetsuo Handa
>> <penguin-kernel@i-love.sakura.ne.jp> wrote:
>>> Miklos Szeredi wrote:
>>>> Cross rename (A, B) is equivalent to plain rename(A, B) + plain rename
>>>> (B, A) done as a single atomic operation.  If security module allows
>>>> both then cross rename is allowed.  If at least one is denied then the
>>>> cross rename is denied.
>>>
>>> Yes, the functionality itself is fine. The problem is how LSM users check
>>> their permissions for the functionality.
>>>
>>>>
>>>> This is prepared for in "[PATCH 06/11] security: add flags to rename
>>>> hooks" and actually done in "[PATCH 07/11] vfs: add cross-rename".
>>>>
>>>> Security people are free to implement a explicit security check for
>>>> cross rename, but I don't think that is in the scope of this patchset.
>>>>
>>> I don't know how their permissions are checked, but I think that
>>> swapping /A/B and /C/D should check not only
>>>
>>>   Remove a name from directory A
>>>   Add a name to directory C
>>>
>>> but also
>>>
>>>   Add a name to directory A
>>>   Remove a name from directory C
>>>
>>> using their security labels.
>>>
>>> Without making changes to security/*/ directory, SELinux/SMACK/TOMOYO/AppArmor
>>> might fail to check the latter permissions.
>>
>> Those permissions will be checked.   Please see security/security.c in
>> patch 07/11 of the series.
>>
> Oh, I see. But I think that 07/11 is wasteful for security_path_rename() users.
> Why bother to re-calculate /A/B and /C/D using d_absolute_path()?
> 
> I prefer flags argument passed to tomoyo_path_rename(). Untested patch follows.
> John, what about AppArmor?

Right policy wise it doesn't make a difference but not having to re-calculate
the paths would be more efficient.

I'd re-factor the apparmor bit of the patch differently so that the paths aren't
recomputed, what is in the patch looks like it should work. In fact I would want
to do the apparmor refactor as a separate patch so that the internal changes
needed to take advantage of the LSM change are separate from the LSM change
it self.

I've only given the patch a quick once over and not tested it yet, but it looks
good, so far.



> ----------
>>From 4344f31e40b908ab1a6dba9121018d7f37130393 Mon Sep 17 00:00:00 2001
> From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Date: Tue, 14 Jan 2014 21:55:48 +0900
> Subject: [PATCH] LSM: Pass flags argument to security_path_rename hook users.
> 
> Passing flags argument can save TOMOYO from recalculating pathnames
> when cross rename operation is requested.
> 
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> ---
>  include/linux/security.h |    4 +++-
>  security/apparmor/lsm.c  |   17 ++++++++++++++---
>  security/capability.c    |    3 ++-
>  security/security.c      |    9 +--------
>  security/tomoyo/common.c |    1 +
>  security/tomoyo/common.h |    5 ++++-
>  security/tomoyo/file.c   |   10 +++++++++-
>  security/tomoyo/tomoyo.c |    8 ++++++--
>  security/tomoyo/util.c   |    1 +
>  9 files changed, 41 insertions(+), 17 deletions(-)
> 
> diff --git a/include/linux/security.h b/include/linux/security.h
> index 95cfccc..ba8ee7a 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -453,6 +453,7 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
>   *	@old_dentry contains the dentry structure of the old link.
>   *	@new_dir contains the path structure for parent of the new link.
>   *	@new_dentry contains the dentry structure of the new link.
> + *	@flags contains rename flags.
>   *	Return 0 if permission is granted.
>   * @path_chmod:
>   *	Check for permission to change DAC's permission of a file or directory.
> @@ -1491,7 +1492,8 @@ struct security_operations {
>  	int (*path_link) (struct dentry *old_dentry, struct path *new_dir,
>  			  struct dentry *new_dentry);
>  	int (*path_rename) (struct path *old_dir, struct dentry *old_dentry,
> -			    struct path *new_dir, struct dentry *new_dentry);
> +			    struct path *new_dir, struct dentry *new_dentry,
> +			    unsigned int flags);
>  	int (*path_chmod) (struct path *path, umode_t mode);
>  	int (*path_chown) (struct path *path, kuid_t uid, kgid_t gid);
>  	int (*path_chroot) (struct path *path);
> diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
> index 4257b7e..f5d4704 100644
> --- a/security/apparmor/lsm.c
> +++ b/security/apparmor/lsm.c
> @@ -315,7 +315,8 @@ static int apparmor_path_link(struct dentry *old_dentry, struct path *new_dir,
>  }
>  
>  static int apparmor_path_rename(struct path *old_dir, struct dentry *old_dentry,
> -				struct path *new_dir, struct dentry *new_dentry)
> +				struct path *new_dir, struct dentry *new_dentry,
> +				unsigned int flags)
>  {
>  	struct aa_profile *profile;
>  	int error = 0;
> @@ -330,7 +331,7 @@ static int apparmor_path_rename(struct path *old_dir, struct dentry *old_dentry,
>  		struct path_cond cond = { old_dentry->d_inode->i_uid,
>  					  old_dentry->d_inode->i_mode
>  		};
> -
> +retry:
>  		error = aa_path_perm(OP_RENAME_SRC, profile, &old_path, 0,
>  				     MAY_READ | AA_MAY_META_READ | MAY_WRITE |
>  				     AA_MAY_META_WRITE | AA_MAY_DELETE,
> @@ -339,7 +340,17 @@ static int apparmor_path_rename(struct path *old_dir, struct dentry *old_dentry,
>  			error = aa_path_perm(OP_RENAME_DEST, profile, &new_path,
>  					     0, MAY_WRITE | AA_MAY_META_WRITE |
>  					     AA_MAY_CREATE, &cond);
> -
> +		if (!error && (flags & RENAME_EXCHANGE)) {
> +			/* Cross rename requires both inodes to exist. */
> +			old_path.mnt = new_dir->mnt;
> +			old_path.dentry = new_dentry;
> +			new_path.mnt = old_dir->mnt;
> +			new_path.dentry = old_dentry;
> +			cond.uid = new_dentry->d_inode->i_uid;
> +			cond.mode = new_dentry->d_inode->i_mode;
> +			flags = 0;
> +			goto retry;
> +		}
>  	}
>  	return error;
>  }
> diff --git a/security/capability.c b/security/capability.c
> index 8b4f24a..cb67fe2 100644
> --- a/security/capability.c
> +++ b/security/capability.c
> @@ -280,7 +280,8 @@ static int cap_path_link(struct dentry *old_dentry, struct path *new_dir,
>  }
>  
>  static int cap_path_rename(struct path *old_path, struct dentry *old_dentry,
> -			   struct path *new_path, struct dentry *new_dentry)
> +			   struct path *new_path, struct dentry *new_dentry,
> +			   unsigned int flags)
>  {
>  	return 0;
>  }
> diff --git a/security/security.c b/security/security.c
> index 3dd2258..b14574e 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -440,15 +440,8 @@ int security_path_rename(struct path *old_dir, struct dentry *old_dentry,
>  		     (new_dentry->d_inode && IS_PRIVATE(new_dentry->d_inode))))
>  		return 0;
>  
> -	if (flags & RENAME_EXCHANGE) {
> -		int err = security_ops->path_rename(new_dir, new_dentry,
> -						    old_dir, old_dentry);
> -		if (err)
> -			return err;
> -	}
> -
>  	return security_ops->path_rename(old_dir, old_dentry, new_dir,
> -					 new_dentry);
> +					 new_dentry, flags);
>  }
>  EXPORT_SYMBOL(security_path_rename);
>  
> diff --git a/security/tomoyo/common.c b/security/tomoyo/common.c
> index 283862a..86747a7 100644
> --- a/security/tomoyo/common.c
> +++ b/security/tomoyo/common.c
> @@ -36,6 +36,7 @@ const char * const tomoyo_mac_keywords[TOMOYO_MAX_MAC_INDEX
>  	[TOMOYO_MAC_FILE_MKCHAR]     = "mkchar",
>  	[TOMOYO_MAC_FILE_LINK]       = "link",
>  	[TOMOYO_MAC_FILE_RENAME]     = "rename",
> +	[TOMOYO_MAC_FILE_SWAPNAME]   = "swapname",
>  	[TOMOYO_MAC_FILE_CHMOD]      = "chmod",
>  	[TOMOYO_MAC_FILE_CHOWN]      = "chown",
>  	[TOMOYO_MAC_FILE_CHGRP]      = "chgrp",
> diff --git a/security/tomoyo/common.h b/security/tomoyo/common.h
> index b897d48..0349ae9 100644
> --- a/security/tomoyo/common.h
> +++ b/security/tomoyo/common.h
> @@ -276,6 +276,7 @@ enum tomoyo_network_acl_index {
>  enum tomoyo_path2_acl_index {
>  	TOMOYO_TYPE_LINK,
>  	TOMOYO_TYPE_RENAME,
> +	TOMOYO_TYPE_SWAPNAME,
>  	TOMOYO_TYPE_PIVOT_ROOT,
>  	TOMOYO_MAX_PATH2_OPERATION
>  };
> @@ -335,6 +336,7 @@ enum tomoyo_mac_index {
>  	TOMOYO_MAC_FILE_MKCHAR,
>  	TOMOYO_MAC_FILE_LINK,
>  	TOMOYO_MAC_FILE_RENAME,
> +	TOMOYO_MAC_FILE_SWAPNAME,
>  	TOMOYO_MAC_FILE_CHMOD,
>  	TOMOYO_MAC_FILE_CHOWN,
>  	TOMOYO_MAC_FILE_CHGRP,
> @@ -730,7 +732,8 @@ struct tomoyo_mkdev_acl {
>  };
>  
>  /*
> - * Structure for "file rename", "file link" and "file pivot_root" directive.
> + * Structure for "file rename", "file swapname", "file link" and
> + * "file pivot_root" directive.
>   */
>  struct tomoyo_path2_acl {
>  	struct tomoyo_acl_info head; /* type = TOMOYO_TYPE_PATH2_ACL */
> diff --git a/security/tomoyo/file.c b/security/tomoyo/file.c
> index 4003907..c7d9546 100644
> --- a/security/tomoyo/file.c
> +++ b/security/tomoyo/file.c
> @@ -38,6 +38,7 @@ const u8 tomoyo_pnnn2mac[TOMOYO_MAX_MKDEV_OPERATION] = {
>  const u8 tomoyo_pp2mac[TOMOYO_MAX_PATH2_OPERATION] = {
>  	[TOMOYO_TYPE_LINK]       = TOMOYO_MAC_FILE_LINK,
>  	[TOMOYO_TYPE_RENAME]     = TOMOYO_MAC_FILE_RENAME,
> +	[TOMOYO_TYPE_SWAPNAME]   = TOMOYO_MAC_FILE_SWAPNAME,
>  	[TOMOYO_TYPE_PIVOT_ROOT] = TOMOYO_MAC_FILE_PIVOT_ROOT,
>  };
>  
> @@ -874,7 +875,7 @@ int tomoyo_mkdev_perm(const u8 operation, struct path *path,
>  }
>  
>  /**
> - * tomoyo_path2_perm - Check permission for "rename", "link" and "pivot_root".
> + * tomoyo_path2_perm - Check permission for "rename", "swapname", "link" and "pivot_root".
>   *
>   * @operation: Type of operation.
>   * @path1:      Pointer to "struct path".
> @@ -916,6 +917,13 @@ int tomoyo_path2_perm(const u8 operation, struct path *path1,
>  		tomoyo_add_slash(&buf1);
>  		tomoyo_add_slash(&buf2);
>  		break;
> +	case TOMOYO_TYPE_SWAPNAME:
> +		/* Cross rename requires both inodes to exist. */
> +		if (S_ISDIR(path1->dentry->d_inode->i_mode))
> +			tomoyo_add_slash(&buf1);
> +		if (S_ISDIR(path2->dentry->d_inode->i_mode))
> +			tomoyo_add_slash(&buf2);
> +		break;
>  	}
>  	r.obj = &obj;
>  	r.param_type = TOMOYO_TYPE_PATH2_ACL;
> diff --git a/security/tomoyo/tomoyo.c b/security/tomoyo/tomoyo.c
> index f0b756e..8e9fb4a 100644
> --- a/security/tomoyo/tomoyo.c
> +++ b/security/tomoyo/tomoyo.c
> @@ -287,17 +287,21 @@ static int tomoyo_path_link(struct dentry *old_dentry, struct path *new_dir,
>   * @old_dentry: Pointer to "struct dentry".
>   * @new_parent: Pointer to "struct path".
>   * @new_dentry: Pointer to "struct dentry".
> + * @flags:      Rename flags.
>   *
>   * Returns 0 on success, negative value otherwise.
>   */
>  static int tomoyo_path_rename(struct path *old_parent,
>  			      struct dentry *old_dentry,
>  			      struct path *new_parent,
> -			      struct dentry *new_dentry)
> +			      struct dentry *new_dentry,
> +			      unsigned int flags)
>  {
>  	struct path path1 = { old_parent->mnt, old_dentry };
>  	struct path path2 = { new_parent->mnt, new_dentry };
> -	return tomoyo_path2_perm(TOMOYO_TYPE_RENAME, &path1, &path2);
> +	return tomoyo_path2_perm((flags & RENAME_EXCHANGE) ?
> +				 TOMOYO_TYPE_SWAPNAME : TOMOYO_TYPE_RENAME,
> +				 &path1, &path2);
>  }
>  
>  /**
> diff --git a/security/tomoyo/util.c b/security/tomoyo/util.c
> index 2952ba5..f0ac0be 100644
> --- a/security/tomoyo/util.c
> +++ b/security/tomoyo/util.c
> @@ -34,6 +34,7 @@ const u8 tomoyo_index2category[TOMOYO_MAX_MAC_INDEX] = {
>  	[TOMOYO_MAC_FILE_MKCHAR]     = TOMOYO_MAC_CATEGORY_FILE,
>  	[TOMOYO_MAC_FILE_LINK]       = TOMOYO_MAC_CATEGORY_FILE,
>  	[TOMOYO_MAC_FILE_RENAME]     = TOMOYO_MAC_CATEGORY_FILE,
> +	[TOMOYO_MAC_FILE_SWAPNAME]   = TOMOYO_MAC_CATEGORY_FILE,
>  	[TOMOYO_MAC_FILE_CHMOD]      = TOMOYO_MAC_CATEGORY_FILE,
>  	[TOMOYO_MAC_FILE_CHOWN]      = TOMOYO_MAC_CATEGORY_FILE,
>  	[TOMOYO_MAC_FILE_CHGRP]      = TOMOYO_MAC_CATEGORY_FILE,
> 

