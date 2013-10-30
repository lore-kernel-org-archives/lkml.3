Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574Ab3J3W3q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 18:29:46 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:54786 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899Ab3J3W3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 18:29:45 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20131029220939.GA23060@kroah.com>
	<8761sflhi1.fsf@tw-ebiederman.twitter.com>
	<CA+55aFwaxAoezL6GAJzw=D+7E_Oxr2sqdxvM3sFgPiO-1eh5LQ@mail.gmail.com>
	<87sivj9vi0.fsf@xmission.com> <20131030132831.GB27632@htj.dyndns.org>
	<20131030142836.GC27632@htj.dyndns.org>
Date: Wed, 30 Oct 2013 15:29:38 -0700
In-Reply-To: <20131030142836.GC27632@htj.dyndns.org> (Tejun Heo's message of
	"Wed, 30 Oct 2013 10:28:36 -0400")
Message-ID: <8761se1jfx.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX193XmRti6FnPOl8MpE3AFG0gOm1WMSYrw4=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0201]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Tejun Heo <tj@kernel.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH driver-core-next] sysfs: rename sysfs_assoc_lock and explain what it's about
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> Hey, again.
>
> How about something like the following?
>
> -	spin_lock(&sysfs_assoc_lock);
> +	/*
> +	 * In general, kboject owner is responsible for ensuring removal
> +	 * doesn't race with other operations and sysfs doesn't provide any
> +	 * protection; however, when @kobj is used as a symlink target, the
> +	 * symlinking entity usually doesn't own @kobj and thus has no
> +	 * control over removal.  @kobj->sd may be removed anytime and
> +	 * symlink code may end up dereferencing an already freed sd.

Except every time sysfs exports a restriction like that and doesn't
verify people have held up their end of it someone in the kernel
inevitably gets the code wrong.  So I don't see how a big fat comment
buried deep in the underlying abstractions that people use is going to
make the code easier to understand or maintain.  It certainly won't
prevent people from goofing up and with no warning.

> +	 *
> +	 * sysfs_symlink_target_lock synchronizes @kobj->sd disassociation
> +	 * against symlink operations so that symlink code can safely
> +	 * dereference @kobj->sd.
> +	 */
> +	spin_lock(&sysfs_symlink_target_lock);
>  	kobj->sd = NULL;
> -	spin_unlock(&sysfs_assoc_lock);
> +	spin_unlock(&sysfs_symlink_target_lock);
>  
>  	if (sd) {
>  		WARN_ON_ONCE(sysfs_type(sd) != SYSFS_DIR);
> diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
> index 22ea2f5..1a23681 100644
> --- a/fs/sysfs/symlink.c
> +++ b/fs/sysfs/symlink.c
> @@ -32,13 +32,15 @@ static int sysfs_do_create_link_sd(struct sysfs_dirent *parent_sd,
>  
>  	BUG_ON(!name || !parent_sd);
>  
> -	/* target->sd can go away beneath us but is protected with
> -	 * sysfs_assoc_lock.  Fetch target_sd from it.
> +	/*
> +	 * We don't own @target and it may be removed at any time.
> +	 * Synchronize using sysfs_symlink_target_lock.  See
> +	 * sysfs_remove_dir() for details.
>  	 */
> -	spin_lock(&sysfs_assoc_lock);
> +	spin_lock(&sysfs_symlink_target_lock);
>  	if (target->sd)
>  		target_sd = sysfs_get(target->sd);
> -	spin_unlock(&sysfs_assoc_lock);
> +	spin_unlock(&sysfs_symlink_target_lock);
>  
>  	error = -ENOENT;
>  	if (!target_sd)
> @@ -140,10 +142,16 @@ void sysfs_delete_link(struct kobject *kobj, struct kobject *targ,
>  			const char *name)
>  {
>  	const void *ns = NULL;
> -	spin_lock(&sysfs_assoc_lock);
> +
> +	/*
> +	 * We don't own @target and it may be removed at any time.
> +	 * Synchronize using sysfs_symlink_target_lock.  See
> +	 * sysfs_remove_dir() for details.
> +	 */
> +	spin_lock(&sysfs_symlink_target_lock);
>  	if (targ->sd)
>  		ns = targ->sd->s_ns;
> -	spin_unlock(&sysfs_assoc_lock);
> +	spin_unlock(&sysfs_symlink_target_lock);
>  	sysfs_hash_and_remove(kobj->sd, name, ns);
>  }
>  
> diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
> index 05d063f..e3aea92 100644
> --- a/fs/sysfs/sysfs.h
> +++ b/fs/sysfs/sysfs.h
> @@ -159,7 +159,7 @@ extern struct kmem_cache *sysfs_dir_cachep;
>   * dir.c
>   */
>  extern struct mutex sysfs_mutex;
> -extern spinlock_t sysfs_assoc_lock;
> +extern spinlock_t sysfs_symlink_target_lock;
>  extern const struct dentry_operations sysfs_dentry_ops;
>  
>  extern const struct file_operations sysfs_dir_operations;
