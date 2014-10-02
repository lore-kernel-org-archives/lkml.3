Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446AbaJBO7j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 10:59:39 -0400
Received: from mail-db3on0062.outbound.protection.outlook.com ([157.55.234.62]:46238
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752171AbaJBO7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 10:59:38 -0400
Date: Thu, 2 Oct 2014 15:38:41 +0100
From: Romeo Cane <romeo.cane.ext@coriant.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
CC: Adrian Hunter <adrian.hunter@intel.com>, Jiri Olsa <jolsa@redhat.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] tools/perf: use local variable for segment file offset
Message-ID: <20141002143824.GA3824@rcane-VirtualBox>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [217.115.69.135]
X-ClientProxiedBy: AM2PR03CA0042.eurprd03.prod.outlook.com (25.160.207.52) To
 AMXPR04MB135.eurprd04.prod.outlook.com (10.242.71.149)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:AMXPR04MB135;
X-Forefront-PRVS: 03524FBD26
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(199003)(189002)(85306004)(33716001)(86362001)(66066001)(4396001)(92726001)(31966008)(19580405001)(95666004)(77096002)(105586002)(107046002)(106356001)(97736003)(97756001)(76482002)(99396003)(23726002)(87976001)(85852003)(80022003)(46102003)(83506001)(33656002)(64706001)(101416001)(229853001)(10300001)(50466002)(21056001)(92566001)(19580395003)(120916001)(102836001)(20776003)(50986999)(46406003)(54356999)(42186005)(47776003)(107986001);DIR:OUT;SFP:1101;SCL:1;SRVR:AMXPR04MB135;H:rcane-VirtualBox;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: coriant.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The value of phdr->p_offset is stored inside a buffer that gets reallocated, so it could become corrupted if the new size isn't big enough to contain it

Signed-off-by: Romeo Cane <romeo.cane.ext@coriant.com>
---
 tools/perf/util/symbol-minimal.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/symbol-minimal.c b/tools/perf/util/symbol-minimal.c
index c9541fe..bf13e46 100644
--- a/tools/perf/util/symbol-minimal.c
+++ b/tools/perf/util/symbol-minimal.c
@@ -129,6 +129,7 @@ int filename__read_build_id(const char *filename, void *bf, size_t size)
 
 		for (i = 0, phdr = buf; i < ehdr.e_phnum; i++, phdr++) {
 			void *tmp;
+			Elf32_Off tmp_off;
 
 			if (need_swap) {
 				phdr->p_type = bswap_32(phdr->p_type);
@@ -140,12 +141,13 @@ int filename__read_build_id(const char *filename, void *bf, size_t size)
 				continue;
 
 			buf_size = phdr->p_filesz;
+			tmp_off = phdr->p_offset;
 			tmp = realloc(buf, buf_size);
 			if (tmp == NULL)
 				goto out_free;
 
 			buf = tmp;
-			fseek(fp, phdr->p_offset, SEEK_SET);
+			fseek(fp, tmp_off, SEEK_SET);
 			if (fread(buf, buf_size, 1, fp) != 1)
 				goto out_free;
 
@@ -178,6 +180,7 @@ int filename__read_build_id(const char *filename, void *bf, size_t size)
 
 		for (i = 0, phdr = buf; i < ehdr.e_phnum; i++, phdr++) {
 			void *tmp;
+			Elf64_Off tmp_off;
 
 			if (need_swap) {
 				phdr->p_type = bswap_32(phdr->p_type);
@@ -189,12 +192,13 @@ int filename__read_build_id(const char *filename, void *bf, size_t size)
 				continue;
 
 			buf_size = phdr->p_filesz;
+			tmp_off = phdr->p_offset;
 			tmp = realloc(buf, buf_size);
 			if (tmp == NULL)
 				goto out_free;
 
 			buf = tmp;
-			fseek(fp, phdr->p_offset, SEEK_SET);
+			fseek(fp, tmp_off, SEEK_SET);
 			if (fread(buf, buf_size, 1, fp) != 1)
 				goto out_free;
 
-- 
1.8.3.2

