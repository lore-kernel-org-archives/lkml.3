Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805Ab3CPNag (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 09:30:36 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:50795 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755697Ab3CPNaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 09:30:35 -0400
MIME-Version: 1.0
In-Reply-To: <CAJd=RBAQ9hxY64R7bn_3-jJ2ey8hMGa+Tm2hQVAosgLdRRtd9g@mail.gmail.com>
References: <20130307052854.GA23745@redhat.com>
	<20130307060230.GA31738@kroah.com>
	<20130307062626.GA25095@redhat.com>
	<51429D7A.30906@gmail.com>
	<5142ABD3.4040106@gmail.com>
	<CAJd=RBAQ9hxY64R7bn_3-jJ2ey8hMGa+Tm2hQVAosgLdRRtd9g@mail.gmail.com>
Date: Sat, 16 Mar 2013 21:30:34 +0800
Message-ID: <CACVXFVN5GOa3wLsVgNu2hyymgMtB9aWMPyKzNsAV+9c8=fxM7A@mail.gmail.com>
Subject: Re: use after free in sysfs_find_dirent
From: Ming Lei <tom.leiming@gmail.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: Sasha Levin <levinsasha928@gmail.com>, Dave Jones <davej@redhat.com>,
        Greg Kroah-Hartman <greg@kroah.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 16, 2013 at 8:39 PM, Hillf Danton <dhillf@gmail.com> wrote:
> init rb node before use due to empty node checked by rb_next().
>
> --- a/fs/sysfs/dir.c    Sat Mar 16 20:12:16 2013
> +++ b/fs/sysfs/dir.c    Sat Mar 16 20:37:10 2013
> @@ -396,6 +396,7 @@ struct sysfs_dirent *sysfs_new_dirent(co
>
>         atomic_set(&sd->s_count, 1);
>         atomic_set(&sd->s_active, 0);
> +       rb_init_node(&sd->s_rb);

Looks there is no the symbol in linus tree, and not necessary since
rb_link_node() may initialize the node correctly.

Also I can't reproduce the problem on my Pandaboard with trinity, maybe
the below debug code can find the name of the affected node if anyone
would like to test it.

--
diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 2fbdff6..9aa11c7 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -281,6 +281,10 @@ void release_sysfs_dirent(struct sysfs_dirent * sd)
 	 */
 	parent_sd = sd->s_parent;

+	if(!(sd->s_flags & SYSFS_FLAG_REMOVED))
+		printk("%s sysfs_dirent use after free: %s-%s\n",
+			__func__, parent_sd->s_name, sd->s_name);
+
 	if (sysfs_type(sd) == SYSFS_KOBJ_LINK)
 		sysfs_put(sd->s_symlink.target_sd);
 	if (sysfs_type(sd) & SYSFS_COPY_NAME)
@@ -962,6 +966,9 @@ static struct sysfs_dirent *sysfs_dir_pos(const void *ns,
 		int valid = !(pos->s_flags & SYSFS_FLAG_REMOVED) &&
 			pos->s_parent == parent_sd &&
 			hash == pos->s_hash;
+		if (valid && (atomic_read(&pos->s_count) <= 1))
+			printk("%s sysfs_dirent use after free: %s-%s\n",
+				__func__, parent_sd->s_name, pos->s_name);
 		sysfs_put(pos);
 		if (!valid)
 			pos = NULL;


Thanks,
-- 
Ming Lei
