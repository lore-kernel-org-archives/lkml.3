Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965728AbaDJJuQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 05:50:16 -0400
Received: from infra.glanzmann.de ([88.198.249.254]:39240 "EHLO
	infra.glanzmann.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965659AbaDJJuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 05:50:03 -0400
X-Greylist: delayed 522 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Apr 2014 05:50:03 EDT
Date: Thu, 10 Apr 2014 11:41:18 +0200
From: Thomas Glanzmann <thomas@glanzmann.de>
To: andreas.noever@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>,
        nouveau <nouveau@lists.freedesktop.org>,
        dri-devel@lists.freedesktop.org, Ben Skeggs <bskeggs@redhat.com>
Subject: REGRESSION Re: [PATCH] drm/nouveau/bios: fix bug introduced in
 457e77b2
Message-ID: <20140410094118.GA21392@glanzmann.de>
Mail-Followup-To: andreas.noever@gmail.com,
	LKML <linux-kernel@vger.kernel.org>,
	nouveau <nouveau@lists.freedesktop.org>,
	dri-devel@lists.freedesktop.org, Ben Skeggs <bskeggs@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397072012-9475-1-git-send-email-andreas.noever@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andreas,
after pulling and rebooting my machine this morning, nouveau was no
longer working:

[    6.455247] nouveau  [  DEVICE][0000:02:00.0] BOOT0  : 0x0ac080b1
[    6.455312] nouveau  [  DEVICE][0000:02:00.0] Chipset: MCP79/MCP7A (NVAC)
[    6.455374] nouveau  [  DEVICE][0000:02:00.0] Family : NV50
[    6.456730] nouveau  [   VBIOS][0000:02:00.0] checking PRAMIN for image...
[    6.456796] nouveau  [   VBIOS][0000:02:00.0] ... signature not found
[    6.456858] nouveau  [   VBIOS][0000:02:00.0] checking PROM for image...
[    6.471198] nouveau  [   VBIOS][0000:02:00.0] ... signature not found
[    6.471265] nouveau  [   VBIOS][0000:02:00.0] checking ACPI for image...
[    6.471328] nouveau  [   VBIOS][0000:02:00.0] ... signature not found
[    6.471390] nouveau  [   VBIOS][0000:02:00.0] checking PCIROM for image...
[    6.477478] nouveau  [   VBIOS][0000:02:00.0] ... appears to be valid
[    6.477549] nouveau  [   VBIOS][0000:02:00.0] using image from PCIROM
[    6.477789] nouveau  [   VBIOS][0000:02:00.0] BIT signature found
[    6.477852] nouveau  [   VBIOS][0000:02:00.0] version 62.79.4e.00.01
[    6.486539] nouveau E[   VBIOS][0000:02:00.0] 0xd97c[ ]: unknown opcode 0x00
[    6.486611] nouveau E[ DEVINIT][0000:02:00.0] init failed, -22
[    6.486673] nouveau E[     DRM] failed to create 0x80000080, -22
[    6.488470] nouveau: probe of 0000:02:00.0 failed with error -22

I bisected the problem:

# bad: [39de65aa2c3eee901db020a4f1396998e09602a3] Merge branch 'i2c/for-next' of git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux
# good: [b003d7706abc5d75cb58de0c9de8f1fc77e57008] Merge branch 'kbuild' of git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild
git bisect start 'HEAD' 'v3.14-11011-gb003d77' 'drivers/gpu/drm/'
# good: [e19b9137142988bec5a76c5f8bdf12a77ea802b0] Merge remote-tracking branch 'airlied/drm-next' into drm-intel-next
git bisect good e19b9137142988bec5a76c5f8bdf12a77ea802b0
# bad: [60f2b4af1258c05e6b037af866be81abc24438f7] drm/i915: fix build warning on 32-bit (v2)
git bisect bad 60f2b4af1258c05e6b037af866be81abc24438f7
# good: [f3381dfc9745bcd8b6be676ec4f68c52e71d24f1] drm/radeon/dp: use i2c_get_adapdata rather than casting
git bisect good f3381dfc9745bcd8b6be676ec4f68c52e71d24f1
# good: [420b94697722512a2c0732970dc1530197a49adb] support for platform devices
git bisect good 420b94697722512a2c0732970dc1530197a49adb
# bad: [fc243d7f92d95d961186126efaad36197f133ab1] drm/nouveau/disp: limit dp capabilities as per dcb
git bisect bad fc243d7f92d95d961186126efaad36197f133ab1
# bad: [88e98d49a1b3e0f8103cdd4fd80d576ec33133ab] drm/gf100-/gr: split ppc state into its subunits
git bisect bad 88e98d49a1b3e0f8103cdd4fd80d576ec33133ab
# bad: [e21bfd171a192dfba4a8907f2fcc41acac0f685f] drm/gf110/gr: fixup gpc/tpc initvals lists
git bisect bad e21bfd171a192dfba4a8907f2fcc41acac0f685f
# bad: [eeb0558e074215656ae11a170059a5f2ce29963f] drm/gf104/gr: rename gf104 (nvc4), it came before gf106 (nvc3)
git bisect bad eeb0558e074215656ae11a170059a5f2ce29963f
# bad: [6acc09b99d5d8f276a4f9bffc32f0bb0f939c7ca] drm/nvc0-/graph: fix gpccs fuc stack setup
git bisect bad 6acc09b99d5d8f276a4f9bffc32f0bb0f939c7ca
# bad: [457e77b26428ab4a24998eecfb99f27fa4195397] drm/nouveau/bios: add more checks to PRAMIN image fetching
git bisect bad 457e77b26428ab4a24998eecfb99f27fa4195397

Than I saw your posting on LKML and tried your fix and your fix resolves
my problem on top of Linus tip.

Tested-by: Thomas Glanzmann <thomas@glanzmann.de>

Cheers, 
        Thomas
