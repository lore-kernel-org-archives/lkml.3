Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036AbaIVMsI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 08:48:08 -0400
Received: from mail-yh0-f52.google.com ([209.85.213.52]:65053 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753915AbaIVMsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 08:48:06 -0400
MIME-Version: 1.0
Date: Mon, 22 Sep 2014 13:48:04 +0100
Message-ID: <CALyZvKwTK8tnChw4-=9+e__D49btN+pScp__vkvwe3qOa436Gw@mail.gmail.com>
Subject: how to build kernel-firmware and kernel-doc RPMs from Red Hat EL6
 kernel.spec files ?
From: Jason Vas Dias <jason.vas.dias@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for this newbie question, but its been a while since I built the
kernel from the Red Hat source RPMs,  and there appears to be no way to
build the kernel-firmware-*.noarch.rpm RPM package without
modifying the spec file, which contains :
<quote>
l# we don't want a .config file when building firmware: it just
confuses the build system
%define build_firmware \
   mv .config .config.firmware_save \
   make INSTALL_FW_PATH=$RPM_BUILD_ROOT/lib/firmware firmware_install \
   mv .config.firmware_save .config
</quote>

When intending to build the kernel-doc and kernel-firmware noarch
RPMs, after the
x86_64 RPMs have successfully built,  with:
   $ rpmbuild --target=noarch --rebuild $path_to_kernel_srpm --define
      '_with_docs 1' --define '_with_firmware 1' --define '_without_perf 1'  ...
 this fails :
<quote>
+ cd ${BUILDROOT}/lib/modules/
+ ln -s kabi-rhel65 kabi-current
+ mv .config .config.firmware_save
+ make INSTALL_FW_PATH=${BUILDROOT}/lib/firmware firmware_install
scripts/kconfig/conf -s arch/x86/Kconfig
***
*** You have not yet configured your kernel!
*** (missing kernel config file ".config")
***
*** Please run some configurator (e.g. "make oldconfig" or
*** "make menuconfig" or "make xconfig").
***
${BUILD}/scripts/kconfig/Makefile:30: recipe for target 'silentoldconfig' failed
make[2]: *** [silentoldconfig] Error 1
${BUILD}/Makefile:484: recipe for target 'silentoldconfig' failed
make[1]: *** [silentoldconfig] Error 2
  IHEX    firmware/iwlwifi-105-6.ucode
make[1]: *** No rule to make target '${BUILDROOT}/lib/firmware/./',
needed by '${BUILDROOT}/lib/firmware/iwlwifi-105-6.ucode'.  Stop.
Makefile:1112: recipe for target 'firmware_install' failed
make: *** [firmware_install] Error 2
error: Bad exit status from /var/tmp/rpm-tmp.3a7tvf (%install)
</quote>
(with the $BUILD and $BUILDROOT strings representing actual paths).

So I have to edit that bit of the .spec file to be:
<quote>
%define build_firmware \
   make INSTALL_FW_PATH=$RPM_BUILD_ROOT/lib/firmware firmware_install
</quote>
and then I can 'rpmbuild --target -ba $path_to_modified_spec_file'  OK and
the firmware and documentation RPMs are produced OK .

Has anyone found a way of avoiding having to edit the Red Hat RPM spec file
in this manner to enable building noarch kernel-doc and kernel-firmware RPMs ?
This happens with every RHEL-6.4 kernel I've built so far :
   kernel-2.6.32-431.23.3.el6.src.rpm
   kernel-2.6.32-431.29.2.el6.src.rpm

Incidentally, anyone found a way to build the Red Hat RPMs without
  "--define '_with_perf 0'" ?
It seems this causes the build to look for libunwind and the Android
SDK headers,
which are not part of the kernel's BuildRequires .

Thanks in advance for any helpful replies, best Regards,
Jason Vas Dias
