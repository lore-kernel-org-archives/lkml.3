Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751802AbaLPPFY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 10:05:24 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:47600 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764AbaLPPFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 10:05:21 -0500
Date: Tue, 16 Dec 2014 15:05:18 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jeremiah Mahler <jmmahler@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [BUG, linux-next] spawn PID 1 without CLONE_FS, wireless inop
Message-ID: <20141216150518.GD22149@ZenIV.linux.org.uk>
References: <20141216115537.GA1259@hudson.localdomain>
 <20141216125615.GZ22149@ZenIV.linux.org.uk>
 <20141216132821.GA22149@ZenIV.linux.org.uk>
 <20141216140952.GA1224@hudson.localdomain>
 <20141216142542.GC22149@ZenIV.linux.org.uk>
 <20141216144610.GA1219@hudson.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141216144610.GA1219@hudson.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 06:46:10AM -0800, Jeremiah Mahler wrote:
> --- a/init/main.c
> +++ b/init/main.c
> @@ -1026,16 +1026,17 @@ static noinline void __init kernel_init_freeable(void)
>         if (sys_access((const char __user *) ramdisk_execute_command, 0) != 0) {
>                 ramdisk_execute_command = NULL;
>                 prepare_namespace();
> -               {
> -               /* HACK */
> -                       struct path old, new;
> -                       get_fs_root(current->fs, &new);
> -                       get_fs_root(&init_fs, &old);
> -                       chroot_fs_refs(&old, &new);
> -                       path_put(&old);
> -                       path_put(&new);
> -               }
>         }
> +       {
> +       /* HACK */
> +               struct path old, new;
> +               get_fs_root(current->fs, &new);
> +               get_fs_root(&init_fs, &old);
> +               chroot_fs_refs(&old, &new);
> +               path_put(&old);
> +               path_put(&new);
> +       }
> +
>  
>         /*
>          * Ok, we have completed the initial bootup, and
> 
> 
> And it still behaves the same.  Below is the dmesg output.

> [    2.281438] iwlwifi 0000:03:00.0: Direct firmware load for iwlwifi-6000g2a-6.ucode failed with error -2
> [    2.281451] iwlwifi 0000:03:00.0: Direct firmware load for iwlwifi-6000g2a-5.ucode failed with error -2
> [    2.281453] iwlwifi 0000:03:00.0: request for firmware file 'iwlwifi-6000g2a-5.ucode' failed.
> [    2.281521] iwlwifi 0000:03:00.0: no suitable firmware found!

No such errors happen on the normal boot, presumably?

> [    2.392117] EXT4-fs (sda5): mounting ext2 file system using the ext4 subsystem
> [    2.393920] EXT4-fs (sda5): mounted filesystem without journal. Opts: (null)

Wait a minute. So that happens _before_ /dev/sda5 mount?  Could you post dmesg
from the normal boot (e.g. just prior to the buggy commit)?

I really don't get it - there's nothing for init_fs.root to point to other
than initramfs by that point, CLONE_FS or no CLONE_FS.  We simply don't
have anything else mounted yet.  Do you get another failing bunch of
request_firmware later?  And what does dmesg look like on the working
kernel - either you have that firmware on initramfs image (in which case
it ought to have been picked by both kernels), or you do not, in which case
neither kernel would've managed to load it until after mounting the real
root...
