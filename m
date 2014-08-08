Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756381AbaHHP4j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 11:56:39 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:52974 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbaHHP4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 11:56:37 -0400
Message-ID: <53E4F332.2080407@gmail.com>
Date: Fri, 08 Aug 2014 23:56:34 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michal Simek <monstr@monstr.eu>
Subject: [PATCH] drivers/tty/nozomi.c: Use 'nozomi_setup_memory' instead of
 'setup_memory'
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several architectures (e.g. microblaze, um, and score) have already have
extern 'setup_memory', so need use 'nozomi_setup_memory' instead of, or
will cause compiling issue.

The related error (with allmodconfig for microblaze):

  CC [M]  drivers/tty/nozomi.o
drivers/tty/nozomi.c:526:13: error: conflicting types for 'setup_memory'
 static void setup_memory(struct nozomi *dc)
             ^
In file included from include/linux/mm.h:51:0,
                 from ./arch/microblaze/include/asm/io.h:17,
                 from include/linux/io.h:22,
                 from include/linux/pci.h:31,
                 from drivers/tty/nozomi.c:46:
./arch/microblaze/include/asm/pgtable.h:569:6: note: previous declaration of 'setup_memory' was here
 void setup_memory(void);
      ^

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 drivers/tty/nozomi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/nozomi.c b/drivers/tty/nozomi.c
index cd04293..74885af 100644
--- a/drivers/tty/nozomi.c
+++ b/drivers/tty/nozomi.c
@@ -523,7 +523,7 @@ static u32 write_mem32(void __iomem *mem_addr_start, const u32 *buf,
 }
 
 /* Setup pointers to different channels and also setup buffer sizes. */
-static void setup_memory(struct nozomi *dc)
+static void nozomi_setup_memory(struct nozomi *dc)
 {
 	void __iomem *offset = dc->base_addr + dc->config_table.dl_start;
 	/* The length reported is including the length field of 4 bytes,
@@ -671,7 +671,7 @@ static int nozomi_read_config_table(struct nozomi *dc)
 		int i;
 		DBG1("Second phase, configuring card");
 
-		setup_memory(dc);
+		nozomi_setup_memory(dc);
 
 		dc->port[PORT_MDM].toggle_ul = dc->config_table.toggle.mdm_ul;
 		dc->port[PORT_MDM].toggle_dl = dc->config_table.toggle.mdm_dl;
@@ -705,7 +705,7 @@ static int nozomi_read_config_table(struct nozomi *dc)
 			 dc->config_table.version);
 
 		/* Here we should disable all I/O over F32. */
-		setup_memory(dc);
+		nozomi_setup_memory(dc);
 
 		/*
 		 * We should send ALL channel pair tokens back along
-- 
1.7.11.7
