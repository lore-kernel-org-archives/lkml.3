Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751159AbaLPN2Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 08:28:25 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:47390 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbaLPN2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 08:28:24 -0500
Date: Tue, 16 Dec 2014 13:28:21 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jeremiah Mahler <jmmahler@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [BUG, linux-next] spawn PID 1 without CLONE_FS, wireless inop
Message-ID: <20141216132821.GA22149@ZenIV.linux.org.uk>
References: <20141216115537.GA1259@hudson.localdomain>
 <20141216125615.GZ22149@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141216125615.GZ22149@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 12:56:15PM +0000, Al Viro wrote:
> On Tue, Dec 16, 2014 at 03:55:37AM -0800, Jeremiah Mahler wrote:
> > all,
> > 
> > The wireless network interface has become inoperative when running
> > linux-next 20141216 on a Lenovo Carbon X1.  It is completely
> > non-existent and `ip addr` doesn't show it.  A bisect has found that
> > the bug was introduced by the following commit.
> 
> Very interesting.  What userland are you running?  I take it, the root
> filesystem is mounted and system boot except for that interface not
> coming up, right?
> 
> Your card is normally handled by what, iwlwifi?  What happens upon
> modprobe iwlwifi (or whatever module you see loaded on the normal
> boot)?  Another interesting question is whether it manages to load
> the firmware...  What happens if you boot with debug in kernel command
> line, with working and with non-working kernels resp.?

Hmm...  OK, I think I see what might be going on.  On the testbox here
I've got pivot_root(2) done from /init on initramfs.  And that triggers
chroot_fs_refs(), which switches init_fs.{root,pwd} to the final rootfs.
In your case it apparently isn't triggered (different userland or setup,
perhaps) and init_fs is left behind on initramfs.  With some files
(firmware?) not being there...  Could you check if the following kludge
helps?  It's not intended as a solution, I just want to verify that guess
about the mechanism of the problem...

diff --git a/init/main.c b/init/main.c
index 3a169a2..36c29d6 100644
--- a/init/main.c
+++ b/init/main.c
@@ -80,6 +80,8 @@
 #include <linux/list.h>
 #include <linux/proc_ns.h>
 #include <linux/fs_struct.h>
+#include "../fs/internal.h" // HACK
+#include <linux/init_task.h> // HACK
 
 #include <asm/io.h>
 #include <asm/bugs.h>
@@ -1024,6 +1026,15 @@ static noinline void __init kernel_init_freeable(void)
 	if (sys_access((const char __user *) ramdisk_execute_command, 0) != 0) {
 		ramdisk_execute_command = NULL;
 		prepare_namespace();
+		{
+		/* HACK */
+			struct path old, new;
+			get_fs_root(current->fs, &new);
+			get_fs_root(&init_fs, &old);
+			chroot_fs_refs(&old, &new);
+			path_put(&old);
+			path_put(&new);
+		}
 	}
 
 	/*
