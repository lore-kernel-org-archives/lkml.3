Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967442Ab3E3DgZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 23:36:25 -0400
Received: from intranet.asianux.com ([58.214.24.6]:45006 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966739Ab3E3DgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 23:36:16 -0400
X-Spam-Score: -100.8
Message-ID: <51A6C8FA.3080408@asianux.com>
Date: Thu, 30 May 2013 11:35:22 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Sam Ravnborg <sam@ravnborg.org>
CC: sparclinux@vger.kernel.org
Subject: [PATCH] arch: sparc: prom: looping issue, need additional length
 check in the outside looping
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When "cp >= barg_buf + BARG_LEN-2", it breaks internel looping 'while',
but outside loop 'for' still has effect, so "*cp++ = ' '" will continue
repeating which may cause memory overflow.

So need additional length check for it in the outside looping.

Also beautify the related code which found by "./scripts/checkpatch.pl"


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/sparc/prom/bootstr_32.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/sparc/prom/bootstr_32.c b/arch/sparc/prom/bootstr_32.c
index f5ec32e..d2b49d2 100644
--- a/arch/sparc/prom/bootstr_32.c
+++ b/arch/sparc/prom/bootstr_32.c
@@ -23,23 +23,25 @@ prom_getbootargs(void)
 		return barg_buf;
 	}
 
-	switch(prom_vers) {
+	switch (prom_vers) {
 	case PROM_V0:
 		cp = barg_buf;
 		/* Start from 1 and go over fd(0,0,0)kernel */
-		for(iter = 1; iter < 8; iter++) {
+		for (iter = 1; iter < 8; iter++) {
 			arg = (*(romvec->pv_v0bootargs))->argv[iter];
 			if (arg == NULL)
 				break;
-			while(*arg != 0) {
+			while (*arg != 0) {
 				/* Leave place for space and null. */
-				if(cp >= barg_buf + BARG_LEN-2){
+				if (cp >= barg_buf + BARG_LEN - 2)
 					/* We might issue a warning here. */
 					break;
-				}
 				*cp++ = *arg++;
 			}
 			*cp++ = ' ';
+			if (cp >= barg_buf + BARG_LEN - 1)
+				/* We might issue a warning here. */
+				break;
 		}
 		*cp = 0;
 		break;
-- 
1.7.7.6
