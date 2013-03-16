Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950Ab3CPP6g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 11:58:36 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:42484 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841Ab3CPP6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 11:58:35 -0400
MIME-Version: 1.0
In-Reply-To: <CACVXFVNDSRnG4avn7YdMQFXbQ7B_ONo79jmhWVGzjqEWGTMWYg@mail.gmail.com>
References: <20130307052854.GA23745@redhat.com>
	<20130307060230.GA31738@kroah.com>
	<20130307062626.GA25095@redhat.com>
	<51429D7A.30906@gmail.com>
	<5142ABD3.4040106@gmail.com>
	<CAJd=RBAQ9hxY64R7bn_3-jJ2ey8hMGa+Tm2hQVAosgLdRRtd9g@mail.gmail.com>
	<CACVXFVN5GOa3wLsVgNu2hyymgMtB9aWMPyKzNsAV+9c8=fxM7A@mail.gmail.com>
	<51448AC9.7080105@gmail.com>
	<CACVXFVNDSRnG4avn7YdMQFXbQ7B_ONo79jmhWVGzjqEWGTMWYg@mail.gmail.com>
Date: Sat, 16 Mar 2013 23:58:34 +0800
Message-ID: <CACVXFVNCGBAYLbbpE1sBiXFNkJpRxVzY44y3Vok+GA9C0MKr3w@mail.gmail.com>
Subject: Re: use after free in sysfs_find_dirent
From: Ming Lei <tom.leiming@gmail.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Hillf Danton <dhillf@gmail.com>, Dave Jones <davej@redhat.com>,
        Greg Kroah-Hartman <greg@kroah.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 16, 2013 at 11:22 PM, Ming Lei <tom.leiming@gmail.com> wrote:
> On Sat, Mar 16, 2013 at 11:07 PM, Sasha Levin <levinsasha928@gmail.com> wrote:
>>
>> Hi Ming,
>>
>> With your patch:
>>
>>
>> [ 1525.874312] release_sysfs_dirent sysfs_dirent use after free: ptysb-uevent
>
> Sasha, thanks for your test.
>
> So is the oops always triggered on this node of 'ptysb-uevent' or the node name
> is changed every time?

Also, we may dump stack on the release path with the below patch to see who
did the ugly free.

--
diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 2fbdff6..993671d 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -281,6 +281,12 @@ void release_sysfs_dirent(struct sysfs_dirent * sd)
 	 */
 	parent_sd = sd->s_parent;

+	if(!(sd->s_flags & SYSFS_FLAG_REMOVED)) {
+		printk("%s sysfs_dirent use after free: %s-%s\n",
+			__func__, parent_sd->s_name, sd->s_name);
+		dump_stack();
+	}
+
 	if (sysfs_type(sd) == SYSFS_KOBJ_LINK)
 		sysfs_put(sd->s_symlink.target_sd);
 	if (sysfs_type(sd) & SYSFS_COPY_NAME)
@@ -962,6 +968,9 @@ static struct sysfs_dirent *sysfs_dir_pos(const void *ns,
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
