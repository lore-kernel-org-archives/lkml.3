Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967556AbaFTMXk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 08:23:40 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:54013 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966074AbaFTMXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 08:23:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Greg KH <greg@kroah.com>, dann frazier <dann.frazier@canonical.com>,
        devel@driverdev.osuosl.org, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging/lustre: disable virtual block device for 64K pages
Date: Fri, 20 Jun 2014 14:23:28 +0200
Message-ID: <4592947.kMtdJTsB2U@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140619191051.GA26573@kroah.com>
References: <20140619183321.GA23200@fluid.dannf> <20140619191051.GA26573@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:9NWdcB4zaZgfC4vw+Tz6Q7bO1suTfM5XLon853BCVnN
 qEl28qpA5NNl/YEiHPeMVk+TsS3POAnKKzxfrzQ7QWdaPVy+Nj
 zELi43yrUXpIUNyBftHJOQmM5mdbpi6HnR5kgquN/LphJVdjmu
 LVHwovKjgsH8GrqhUlvQIg4uokbO14gSNCxp94DBbrStjQjzvQ
 ciUu9REfNswEdJSA+7YQvDbbKcponOovNxu6a4WKmpLCsOeFGr
 ESZB/sysposl2Ox0wTfMlr04fhDG4OozLh/mqKEk6RglzeuwfZ
 JAokW+bK5oQXrKeQLhyH+W+/NgE8Ry6YguKe7FNa5Nk0SbtRw8
 KwOqIc/dxRu1ZCtTGmEY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The lustre virtual block device cannot handle 64K pages and fails at compile
time. To avoid running into this error, let's disable the Kconfig option
for this driver in cases it doesn't support.

Reported-by: Dann Frazier <dann.frazier@canonical.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>

---
On Thursday 19 June 2014 12:10:51 Greg KH wrote:
> On Thu, Jun 19, 2014 at 12:33:21PM -0600, dann frazier wrote:
> > drivers/staging/lustre/lustre/llite/lloop.c:523:18: error: previously used here
> >   CLASSERT(PAGE_CACHE_SIZE < (1 << (sizeof(unsigned short) * 8)));
> >                   ^
> 
> Looks like lustre can't handle 64K page sizes, so it refuses to build :(
> 
> I sugest turning this code off, you really don't want to be running it
> anyway...

something like this?

diff --git a/drivers/staging/lustre/lustre/Kconfig b/drivers/staging/lustre/lustre/Kconfig
index 209e4c7..4f65ba1 100644
--- a/drivers/staging/lustre/lustre/Kconfig
+++ b/drivers/staging/lustre/lustre/Kconfig
@@ -57,4 +57,5 @@ config LUSTRE_TRANSLATE_ERRNOS
 config LUSTRE_LLITE_LLOOP
 	tristate "Lustre virtual block device"
 	depends on LUSTRE_FS && BLOCK
+	depends on !PPC_64K_PAGES && !ARM64_64K_PAGES
 	default m

