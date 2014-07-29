Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179AbaG2KSk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 06:18:40 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752880AbaG2KSi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 06:18:38 -0400
Message-ID: <53D774F9.3090305@nod.at>
Date: Tue, 29 Jul 2014 12:18:33 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: mike.marciniszyn@intel.com, Michal Marek <mmarek@suse.cz>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        OpenSUSE Kernel Team <opensuse-kernel@opensuse.org>
Subject: Kernel binrpm produces brokes grub2 config
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I'm not sure who to blame, but the below commit breaks the kernel binrpm target for me.
It produces a faulty grub2 config.
After installing such a kernel grub2 looks for vmlinuz-XY-rpm and initrd-XY-rpm.
These files are not existing and the machine does no longer boot.
Luckily an addition boot entry without the -rpm suffix exists, if remote access works
one can recover the machine.

My question is, why do we need these copy of vmlinuz anyway?
After calling installkernel on the -rpm variants you delete them again...

This <insert swear word here> happens on openSUSE 13.1, maybe their installkernel script needs fixing.

commit 3c9c7a14b6274074cc3af2b83d56a92547188f27
Author: Mike Marciniszyn <mike.marciniszyn@intel.com>
Date:   Mon Jun 24 10:38:22 2013 -0400

    rpm-pkg: add %post section to create initramfs and grub hooks

    /sbin/installkernel is used to insure grub hooks are
    inserted and the initramfs is created on the
    target system.

    The invokation installkernel will work with any
    kernel as long as:
    - /sbin/installkernel exists
    - the kernel and sysem map files are readable

    Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
    Signed-off-by: Michal Marek <mmarek@suse.cz>

diff --git a/scripts/package/mkspec b/scripts/package/mkspec
index fdd3fbf..0aa6a24 100755
--- a/scripts/package/mkspec
+++ b/scripts/package/mkspec
@@ -112,6 +112,15 @@ echo ""
 echo "%clean"
 echo 'rm -rf $RPM_BUILD_ROOT'
 echo ""
+echo "%post"
+echo "if [ -x /sbin/installkernel -a -r /boot/vmlinuz-$KERNELRELEASE -a -r /boot/System.map-$KERNELRELEASE ]; then"
+echo "cp /boot/vmlinuz-$KERNELRELEASE /boot/vmlinuz-$KERNELRELEASE-rpm"
+echo "cp /boot/System.map-$KERNELRELEASE /boot/System.map-$KERNELRELEASE-rpm"
+echo "rm -f /boot/vmlinuz-$KERNELRELEASE /boot/System.map-$KERNELRELEASE"
+echo "/sbin/installkernel $KERNELRELEASE /boot/vmlinuz-$KERNELRELEASE-rpm /boot/System.map-$KERNELRELEASE-rpm"
+echo "rm -f /boot/vmlinuz-$KERNELRELEASE-rpm /boot/System.map-$KERNELRELEASE-rpm"
+echo "fi"
+echo ""
 echo "%files"
 echo '%defattr (-, root, root)'
 echo "%dir /lib/modules"

Thanks,
//richard
