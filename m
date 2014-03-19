Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932337AbaCSVN3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 17:13:29 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:39458 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbaCSVN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 17:13:27 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Olaf Dietsche <olaf--list.linux-kernel@olafdietsche.de>
Cc: Serge Hallyn <serge.hallyn@canonical.com>, linux-kernel@vger.kernel.org
References: <87k3bqnflm.fsf@olafdietsche.de>
Date: Wed, 19 Mar 2014 14:13:14 -0700
In-Reply-To: <87k3bqnflm.fsf@olafdietsche.de> (Olaf Dietsche's message of
	"Wed, 19 Mar 2014 20:38:45 +0100")
Message-ID: <874n2t6get.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19uUibu5lY4z9QUl8A1RValIPIcCpde+t0=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0320]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Olaf Dietsche <olaf--list.linux-kernel@olafdietsche.de>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] 3.8: access permission filesystem
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Olaf Dietsche <olaf--list.linux-kernel@olafdietsche.de> writes:

> I am in the process of catching up with the last two years or so.
> Right now, I am at the changes involving user namespaces.
>
> I have two possible implementations, both working equally well in a
> shared environment. Since I am not familiar with namespaces in general
> and user namespaces in particular, I would like you to look over the
> patches and tell me, what you think.
>
> Are the patches good so far? Are there are any things I missed and must
> consider? Maybe, I am completely off track? Anything else?
>
> I included both patches inline below. The patches are also available as
> separate branches at github 
>
> https://github.com/olafdietsche/linux-accessfs/tree/tmp-user-ns-1
> https://github.com/olafdietsche/linux-accessfs/tree/tmp-user-ns-2
>
> I am leaning toward the second patch. Although it is a little bit longer
> than the first one, it involves no user id conversions.

Using kuid's and kgid's throughout as your second patch does is best.
Conversion is only needed on normal filesystems because they have a
backing store and reside on disk.  As accessfs appears not to have
backing store, storing things with kuid's and kgid's is the preferred
method.

Your first patch is buggy as it uses current_user_ns().  Something a
filesystem in general should not care about.

I don't see anything wrong with your second patch.

>From what little I understand of accessfs, I expect you will want to
play with and come up to speed on namespaces, as namespaces change
the universe of objects you will be dealing with, in some subtle
but interesting ways.  At least assuming anyone in who uses accessfs
is going to be using more than a single container.

Eric

> diff --git a/fs/accessfs/capabilities.c b/fs/accessfs/capabilities.c
> index a8b52b3..d60b16f 100644
> --- a/fs/accessfs/capabilities.c
> +++ b/fs/accessfs/capabilities.c
> @@ -83,8 +83,8 @@ static int __init init_capabilities(void)
>  		return -ENOTDIR;
>  
>  	for (i = 0; i < ARRAY_SIZE(caps); ++i) {
> -		caps[i].uid = 0;
> -		caps[i].gid = 0;
> +		caps[i].uid = GLOBAL_ROOT_UID;
> +		caps[i].gid = GLOBAL_ROOT_GID;
>  		caps[i].mode = S_IXUSR;
>  		err = accessfs_register(dir, names[i], &caps[i]);
>  		if (err) {
> diff --git a/fs/accessfs/inode.c b/fs/accessfs/inode.c
> index e02c275..4e4867d 100644
> --- a/fs/accessfs/inode.c
> +++ b/fs/accessfs/inode.c
> @@ -115,7 +115,7 @@ static struct accessfs_direntry	accessfs_rootdir = {
>  	  LIST_HEAD_INIT(accessfs_rootdir.node.siblings), 
>  	  1, &accessfs_rootdir.attr },
>  	NULL, LIST_HEAD_INIT(accessfs_rootdir.children), 
> -	{ 0, 0, S_IFDIR | 0755 }
> +	{ GLOBAL_ROOT_UID, GLOBAL_ROOT_GID, S_IFDIR | 0755 }
>  };
>  
>  static void accessfs_init_inode(struct inode *inode, struct accessfs_entry *pe)
> @@ -174,8 +174,8 @@ static int accessfs_node_init(struct accessfs_direntry *parent,
>  	de->name[len] = 0;
>  	de->ino = ++ino;
>  	de->attr = attr;
> -	de->attr->uid = 0;
> -	de->attr->gid = 0;
> +	de->attr->uid = GLOBAL_ROOT_UID;
> +	de->attr->gid = GLOBAL_ROOT_GID;
>  	de->attr->mode = mode;
>  
>  	list_add_tail(&de->hash, &hash);
> @@ -363,7 +363,7 @@ static struct dentry *accessfs_mount(struct file_system_type *fs_type,
>  int accessfs_permitted(struct access_attr *p, int mask)
>  {
>  	mode_t mode = p->mode;
> -	if (current_fsuid() == p->uid)
> +	if (uid_eq(current_fsuid(), p->uid))
>  		mode >>= 6;
>  	else if (in_group_p(p->gid))
>  		mode >>= 3;
> diff --git a/fs/accessfs/ip.c b/fs/accessfs/ip.c
> index a6c0ee0..493a2ca 100644
> --- a/fs/accessfs/ip.c
> +++ b/fs/accessfs/ip.c
> @@ -66,8 +66,8 @@ static int __init init_ip(void)
>  
>  	for (i = 1; i < max_prot_sock; ++i) {
>  		char	buf[sizeof("65536")];
> -		bind_to_port[i].uid = 0;
> -		bind_to_port[i].gid = 0;
> +		bind_to_port[i].uid = GLOBAL_ROOT_UID;
> +		bind_to_port[i].gid = GLOBAL_ROOT_GID;
>  		bind_to_port[i].mode = i < PROT_SOCK ? S_IXUSR : S_IXUGO;
>  		sprintf(buf, "%d", i);
>  		accessfs_register(dir, buf, &bind_to_port[i]);
> diff --git a/include/linux/accessfs_fs.h b/include/linux/accessfs_fs.h
> index ecd914e..8ebc24a 100644
> --- a/include/linux/accessfs_fs.h
> +++ b/include/linux/accessfs_fs.h
> @@ -14,8 +14,8 @@
>  #include <net/sock.h>
>  
>  struct access_attr {
> -	uid_t	uid;
> -	gid_t	gid;
> +	kuid_t	uid;
> +	kgid_t	gid;
>  	mode_t	mode;
>  };
>  
