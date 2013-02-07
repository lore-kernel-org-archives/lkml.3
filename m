Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759087Ab3BGRFq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 12:05:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30618 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758867Ab3BGRFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 12:05:45 -0500
Date: Thu, 7 Feb 2013 12:05:43 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 2/2] initramfs with digital signature protection
Message-ID: <20130207170542.GF6462@redhat.com>
References: <cover.1360067333.git.dmitry.kasatkin@intel.com>
 <cc87f1242960fad1a9fb44bcec331915e14c832b.1360067333.git.dmitry.kasatkin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc87f1242960fad1a9fb44bcec331915e14c832b.1360067333.git.dmitry.kasatkin@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2013 at 02:34:50PM +0200, Dmitry Kasatkin wrote:

[..]
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

Dmitry, 

How do we make sure that this is the first call to user mode helpers. I
see that we first unpacked unsigned initramfs. Then after a while we 
unpacked signed initramfs on /root and did a chroot. But now there is
a window before chroot, where kernel might call into /sbin/hotplug or
/sbin/modprobe from unsigned initramfs?

Specifically, I put some printk and I am seeing calls to /sbin/hotplug
before we even unpacked signed initramfs.

Thanks
Vivek
