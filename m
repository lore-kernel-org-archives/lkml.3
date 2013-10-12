Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186Ab3JLTjM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 15:39:12 -0400
Received: from nm21-vm6.access.bullet.mail.bf1.yahoo.com ([216.109.115.133]:24732
	"EHLO nm21-vm6.access.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752648Ab3JLTjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 15:39:11 -0400
X-Yahoo-Newman-Id: 714592.22320.bm@smtp116.sbc.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: CIZl35AVM1m2xkAQM0CZntv14nmlsyo7nywWcL.YYWiOrg0
 jyggeAB7R6nHTjIbNvr0ulClvbNuMte5xOnp.ih0H9aCAVoNiWwqUV.Xsr3e
 1uXmgYDIvF2LJY0Efm_TlvWE1Mm._alHnbc8Vup7NR66tY01VgQQzew21g6D
 tXYFfkcC6TQJKdQdN4cms0M6osp8KDGy0M40j2HXpsFFKhY9FMn9KFbCt247
 Yj4__SGUGKFk1TpGnyIS052y1G0UijzORpwuCPgcgsGWGVaKz7zYqhR4lcZU
 VlrL5Qyro12X8MEfpYNB_V753pa9_1RgQy47_MfOIxADY5XQbFJ7XdvdtKFc
 SJZ1vyMQuN6G19N44j0tgkLy2tOPKwsaSQfzNViiC3cD2d60YCyXY.EFjxqW
 JwuZ.CXitYMnXNzV0VsWIen2VVmh_Qp7Mfwfx33MHma4BWxvfCy2Gmsgf.Mf
 9ZFDTp1WmqvZ9wOCRtLTsF4BkybMS5jDUzVSSWxtTZozce7pGTa1VyRmwcsn
 S3YxjngoFYam0BRW9gV6AD3kH.ta_l2CvjCbLrS8RYYMB_rkwtOgOr8Vfnwi
 2oPhm9ROx2Gc-
X-Yahoo-SMTP: rZzhDImswBA_40COIyZI42.8nAz5YXic.zo1v550XQVtX7k-
X-Rocket-Received: from segfault.sh0n.net (shawn.starr@174.112.94.49 with )
        by smtp116.sbc.mail.bf1.yahoo.com with SMTP; 12 Oct 2013 19:39:10 +0000 UTC
From: Shawn Starr <shawn.starr@rogers.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH][BUILD] Force check for rpm-build where package is not installed
Date: Sat, 12 Oct 2013 15:39:05 -0400
Message-ID: <13301057.7X5ko0dHEr@segfault.sh0n.net>
Organization: sh0n.net
User-Agent: KMail/4.11.2 (Linux/3.12.0-0.rc4.git1.2.fc21.x86_64; KDE/4.11.2; x86_64; ; )
In-Reply-To: <2492370.jKSlzuQ6pe@segfault.sh0n.net>
References: <2492370.jKSlzuQ6pe@segfault.sh0n.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, October 12, 2013 03:03:32 PM Shawn Starr wrote:
> Hello folks,
> 
> My usual approach to testing git snapshots of Linus's tree (with custom
> patches applied on top) is to make rpm and install this into my system for a
> clean add/remove of test kernels.
> 
> However,  the developers of rpm removed the --target and -ta options, so I
> can't take tarball and build into RPM anymore.
> 
> Since I last built custom RPM builds of Linus's tree was likely Fedora 18,
> it seems the option target got removed by 19.
> 
> Any ideas, fixes?
> 
> Thanks,
> Shawn

Sorry for noise,  I was missing rpm-build. That said, here's a patch to force check for rpm-build as any modern RPM distribution should be be using a newer rpm release.

Thanks,
Shawn

Signed-off-by: Shawn Starr <shawn.starr@rogers.com>
---
 scripts/package/Makefile               | 8 +++++++-
 1 files changed, 7 insertions(+), 1 deletion(-)
	
diff --git a/scripts/package/Makefile b/scripts/package/Makefile
index a4f31c9..aac24de 100644
--- a/scripts/package/Makefile
+++ b/scripts/package/Makefile
@@ -23,7 +23,7 @@
 
 # Do we have rpmbuild, otherwise fall back to the older rpm
 RPM := $(shell if [ -x "/usr/bin/rpmbuild" ]; then echo rpmbuild; \
-                  else echo rpm; fi)
+                  else echo none; fi)
 
 # Remove hyphens since they have special meaning in RPM filenames
 KERNELPATH := kernel-$(subst -,_,$(KERNELRELEASE))
@@ -51,6 +51,12 @@ rpm-pkg rpm: FORCE
        rm -f $(objtree)/.scmversion
        $(CONFIG_SHELL) $(srctree)/scripts/mkversion > $(objtree)/.tmp_version
        mv -f $(objtree)/.tmp_version $(objtree)/.version
+       @if test "$(RPM)" != "rpmbuild"; then \
+               echo "To build the kernel you must install the rpm-build package from your distri
+               echo "aborting package creation." ; \
+               false; \
+       fi
+
        $(RPM) $(RPMOPTS) --target $(UTS_MACHINE) -ta $(KERNELPATH).tar.gz
        rm $(KERNELPATH).tar.gz kernel.spec
 

