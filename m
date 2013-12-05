Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224Ab3LEXPn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 18:15:43 -0500
Received: from smtp2-g21.free.fr ([212.27.42.2]:47774 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751507Ab3LEXPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 18:15:41 -0500
Message-ID: <1386285331.18074.47.camel@localhost.localdomain>
Subject: Re: [PATCH v2] net: handle error more gracefully in socketpair()
From: Yann Droneaud <ydroneaud@opteya.com>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk
Date: Fri, 06 Dec 2013 00:15:31 +0100
In-Reply-To: <20131205.162333.1525865133149454763.davem@davemloft.net>
References: <1385977019-12282-1-git-send-email-ydroneaud@opteya.com>
	 <1385979146-13825-1-git-send-email-ydroneaud@opteya.com>
	 <20131205.162333.1525865133149454763.davem@davemloft.net>
Organization: OPTEYA
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.2 (3.10.2-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Le jeudi 05 décembre 2013 à 16:23 -0500, David Miller a écrit :
> From: Yann Droneaud <ydroneaud@opteya.com>
> Date: Mon,  2 Dec 2013 11:12:26 +0100
> 
> > socketpair() error paths can be simplified to not call
> > heavy-weight sys_close().
> > 
> > This patch makes socketpair() use of error paths which do not
> > rely on heavy-weight call to sys_lose(): it's better to try
> > to push the file descriptor to userspace before installing
> > the socket file to the file descriptor, so that errors are
> > catched earlier and being easier to handle.
> > 
> > Three distinct error paths are needed since calling fput()
> > on file structure returned by sock_alloc_file() will
> > implicitly call sock_release() on the associated socket
> > structure.
> > 
> > Cc: David S. Miller <davem@davemloft.net>
> > Cc: Al Viro <viro@zeniv.linux.org.uk>
> > Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
> > Link: http://marc.info/?i=1385977019-12282-1-git-send-email-ydroneaud@opteya.com
> 
> I know that sys_close() is expensive, _but_ erroring out on
> the put_user() is extremely rare and logically it makes
> a ton more sense to fully install a file descriptor before
> writing it's numeric value into userspace.
> 
> Sorry, I think the current code is fine and I'm not going
> to apply this, thanks.

Thanks for the review.

AFAIK, using sys_close() seems to be the exception, and writing the file
descriptor before installing it is the more or less the norm.

I've made a review of each subsystem using get_unused_fd{,_flags} and
anon_inode_get{fd,file}: most of the time, error handling involve fput()
and put_unused_fd() and not sys_close().

Looking at the places where sys_close() is used make it pretty obvious:

- autofs_dev_ioctl_closemount(), dev-ioctl.c:298 [1]
  [just a "fancy" way of doing close() through an ioctl]
- load_misc_binary(),            binfmt_misc.c:208 [2]
  [could probably made use fput(),put_unused_fd()]
- change_floppy(),               do_mounts.c:490,501 [3]
- handle_initrd(),               do_mounts_initrd.c:113 [4]
- md_setup_drive(),              do_mounts_md.c:193,245,249 [5]
- autodetect_raid(),             do_mounts_md.c:299 [6]
- rd_load_image(),               do_mounts_rd.c:266,292,294 [7]
- do_copy(),                     initramfs.c:350 [8]
- clean_rootfs(),                initramfs.c:549,577 [9]
- populate_rootfs(),             initramfs.c:607 [10]
- socketpair(),                  socket.c:1486,1487 [11]
  [our target]

The majority of sys_close() users are in init code, which is code
behaving like userspace code.

This make socketpair() usage of sys_close() quite unusual.

It deserve to be replaced by the more common pattern of fput() /
put_unused_fd().

Regards.

Links:

[1]
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/fs/autofs4/dev-ioctl.c?id=v3.13-rc2#n298

[2]
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/fs/binfmt_misc.c?id=v3.13-rc2#n208

[3]
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/init/do_mounts.c?id=v3.13-rc2#n490

http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/init/do_mounts.c?id=v3.13-rc2#n501

[4]
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/init/do_mounts_initrd.c?id=v3.13-rc2#n113

[5]
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/init/do_mounts_md.c?id=v3.13-rc2#n193

http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/init/do_mounts_md.c?id=v3.13-rc2#n245

http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/init/do_mounts_md.c?id=v3.13-rc2#n249

[6]
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/init/do_mounts_md.c?id=v3.13-rc2#n299

[7]
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/init/do_mounts_rd.c?id=v3.13-rc2#n266

http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/init/do_mounts_rd.c?id=v3.13-rc2#n292

http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/init/do_mounts_rd.c?id=v3.13-rc2#n294

[8]
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/init/initramfs.c?id=v3.13-rc2#n350

[9]
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/init/initramfs.c?id=v3.13-rc2#n549

http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/init/initramfs.c?id=v3.13-rc2#n577

[10]
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/init/initramfs.c?id=v3.13-rc2#n607

[11]
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/net/socket.c?id=v3.13-rc2#n1486

http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/net/socket.c?id=v3.13-rc2#n1487


Aside: I will submit "soon" a patchset that add some sys_close() in
error paths of code relying on anon_inode_getfd() or using some layer 
which call get_unused_fd{,flags}()/fd_install() deep in the call chain,
mostly in kvm, drm, iio.

Regards.

-- 
Yann Droneaud
OPTEYA


