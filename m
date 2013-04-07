Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934500Ab3DGWzt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 18:55:49 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46309 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934447Ab3DGWzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 18:55:46 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Geert Uytterhoeven" <geert@linux-m68k.org>,
        "Jiri Kosina" <jkosina@suse.cz>, "Jiri Slaby" <jslaby@suse.cz>
Date: Sun, 07 Apr 2013 23:45:43 +0100
Message-ID: <lsq.1365374743.250578417@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [74/74] HID: microsoft: do not use compound literal - fix build
In-Reply-To: <lsq.1365374742.214522651@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:b4b3:7e2a:e2d0:3478
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.43-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Slaby <jslaby@suse.cz>

commit 6b90466cfec2a2fe027187d675d8d14217c12d82 upstream.

In patch "HID: microsoft: fix invalid rdesc for 3k kbd" I fixed
support for MS 3k keyboards. However the added check using memcmp and
a compound statement breaks build on architectures where memcmp is a
macro with parameters.

hid-microsoft.c:51:18: error: macro "memcmp" passed 6 arguments, but takes just 3

On x86_64, memcmp is a function, so I did not see the error.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/hid/hid-microsoft.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/hid/hid-microsoft.c
+++ b/drivers/hid/hid-microsoft.c
@@ -47,9 +47,9 @@ static __u8 *ms_report_fixup(struct hid_
 		rdesc[559] = 0x45;
 	}
 	/* the same as above (s/usage/physical/) */
-	if ((quirks & MS_RDESC_3K) && *rsize == 106 &&
-			!memcmp((char []){ 0x19, 0x00, 0x29, 0xff },
-				&rdesc[94], 4)) {
+	if ((quirks & MS_RDESC_3K) && *rsize == 106 && rdesc[94] == 0x19 &&
+			rdesc[95] == 0x00 && rdesc[96] == 0x29 &&
+			rdesc[97] == 0xff) {
 		rdesc[94] = 0x35;
 		rdesc[96] = 0x45;
 	}

