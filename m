Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953Ab3BEUgW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 15:36:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24403 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755556Ab3BEUgU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 15:36:20 -0500
Date: Tue, 5 Feb 2013 15:36:16 -0500
From: Peter Jones <pjones@redhat.com>
To: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 2/2] initramfs with digital signature protection
Message-ID: <20130205203616.GA8228@fenchurch.internal.datastacks.com>
References: <cover.1360067333.git.dmitry.kasatkin@intel.com>
 <cc87f1242960fad1a9fb44bcec331915e14c832b.1360067333.git.dmitry.kasatkin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cc87f1242960fad1a9fb44bcec331915e14c832b.1360067333.git.dmitry.kasatkin@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2013 at 02:34:50PM +0200, Dmitry Kasatkin wrote:

> +static const char *secmnt = "/root";
> +static const char *initramfs_img = "/initramfs-sig.img";
> +
> +static int __init load_image(const char *from)
> +{
...
> +	err = sys_mount("tpmfs", (char *)secmnt, "tmpfs", MS_SILENT, NULL);
> +	if (err) {
> +		pr_err("sys_mount() = %d\n", err);
> +		goto out;
> +	}
> +
> +	sys_unshare(CLONE_FS | CLONE_FILES);
> +	sys_chdir(secmnt);
> +	sys_chroot(".");
> +	sys_setsid();
> +
> +	pr_info("unpack start\n");
> +	msg = unpack_to_rootfs(buf, offset);
...
> +}
> +
> +static int __init init_init(struct subprocess_info *info, struct cred *new)
> +{
> +	return load_image(initramfs_img);
> +}
> +
> +static void init_cleanup(struct subprocess_info *info)
> +{
> +	int err;
> +
> +	pr_info("cleanup\n");
> +
> +	err = sys_umount((char *)secmnt, MNT_DETACH);
> +	if (err)
> +		pr_err("unable to umount secmnt: %d\n", err);
> +}
> +
> +static int __init load_initramfs(void)
> +{
> +	static char *argv[] = { "pre-init", NULL, };
> +	extern char *envp_init[];
> +	int err;
> +
> +	/*
> +	 * In case that a resume from disk is carried out by linuxrc or one of
> +	 * its children, we need to tell the freezer not to wait for us.
> +	 */
> +	current->flags |= PF_FREEZER_SKIP;
> +
> +	err = call_usermodehelper_fns("/pre-init", argv, envp_init,
> +				      UMH_WAIT_PROC, init_init, init_cleanup,
> +				      NULL);
> +
> +	current->flags &= ~PF_FREEZER_SKIP;
> +
> +	pr_info("initramfs_sig /pre-init completed: %d\n", err);
> +
> +	return err;
> +}

So, there's another issue here - if you do want to run a fully-signed 
initramfs, and so there's nothing else in the container, you go through
this code and it mounts it.  In this case the wrapper initramfs which
includes the signed image is still in memory, and there's nothing e.g.
dracut can do about it.  Which means you've got two whole copies of the
initramfs in memory, and even if code later cleans up the one it sees,
you can't get rid of the other one.

(this would not be an issue without the wrapper.)

-- 
        Peter
