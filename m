Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491AbaAJKiA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 05:38:00 -0500
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:50147 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751364AbaAJKh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 05:37:57 -0500
Message-ID: <1389350275.2528.10.camel@x41>
Subject: [PATCH] drm/nouveau/fb: mark ramfuc_reg() noinline
From: Paul Bolle <pebolle@tiscali.nl>
To: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Date: Fri, 10 Jan 2014 11:37:55 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Jan 2014 10:37:55.0715 (UTC) FILETIME=[05C51D30:01CF0DF0]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building ramnve0.o triggers a GCC warning on 32 bits x86:
    drivers/gpu/drm/nouveau/core/subdev/fb/ramnve0.c: In function 'nve0_ram_ctor':
    drivers/gpu/drm/nouveau/core/subdev/fb/ramnve0.c:1253:1: warning: the frame size of 1496 bytes is larger than 1024 bytes [-Wframe-larger-than=]

This warning is caused by ramfuc_reg(), which is inlined 74 times in
nve0_ram_ctor(). Mark it noinline to silence this warning.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Compile tested (on 32 bits x86) only. I've no Nvidia cards at hand, so I
can't really test it.

This assumes this function - a constructor, apparently - isn't called
often, so the overhead calling of 74 functions is acceptable. (The same
goes for the similar functions in [...]/ramnva3.c and in
[...]/ramnvc0.c, though these call ramfuc_reg() not quite as often.)
Perhaps there are other downsides to not inlining this function too. So
proper testing will probably be needed.

 drivers/gpu/drm/nouveau/core/subdev/fb/ramfuc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/core/subdev/fb/ramfuc.h b/drivers/gpu/drm/nouveau/core/subdev/fb/ramfuc.h
index 0f57fcf..04e3849 100644
--- a/drivers/gpu/drm/nouveau/core/subdev/fb/ramfuc.h
+++ b/drivers/gpu/drm/nouveau/core/subdev/fb/ramfuc.h
@@ -26,7 +26,7 @@ ramfuc_reg2(u32 addr1, u32 addr2)
 	};
 }
 
-static inline struct ramfuc_reg
+static noinline struct ramfuc_reg
 ramfuc_reg(u32 addr)
 {
 	return ramfuc_reg2(addr, addr);
-- 
1.8.4.2

