Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933299AbaBUNCn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 08:02:43 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47812 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932788AbaBUNCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 08:02:37 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jan Moskyto Matejka <mq@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 48/60] Modpost: fixed USB alias generation for ranges including 0x9 and 0xA
Date: Fri, 21 Feb 2014 13:01:15 +0000
Message-Id: <1392987687-15367-49-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392987687-15367-1-git-send-email-luis.henriques@canonical.com>
References: <1392987687-15367-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.31 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Moskyto Matejka <mq@suse.cz>

commit 03b56329f9bb5a1cb73d7dc659d529a9a9bf3acc upstream.

Commit afe2dab4f6 ("USB: add hex/bcd detection to usb modalias generation")
changed the routine that generates alias ranges. Before that change, only
digits 0-9 were supported; the commit tried to fix the case when the range
includes higher values than 0x9.

Unfortunately, the commit didn't fix the case when the range includes both
0x9 and 0xA, meaning that the final range must look like [x-9A-y] where
x <= 0x9 and y >= 0xA -- instead the [x-9A-x] range was produced.

Modprobe doesn't complain as it sees no difference between no-match and
bad-pattern results of fnmatch().

Fixing this simple bug to fix the aliases.
Also changing the hardcoded beginning of the range to uppercase as all the
other letters are also uppercase in the device version numbers.

Fortunately, this affects only the dvb-usb-dib0700 module, AFAIK.

Signed-off-by: Jan Moskyto Matejka <mq@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 scripts/mod/file2alias.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index 5759751..73ca97a 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -186,8 +186,8 @@ static void do_usb_entry(struct usb_device_id *id,
 				range_lo < 0x9 ? "[%X-9" : "[%X",
 				range_lo);
 			sprintf(alias + strlen(alias),
-				range_hi > 0xA ? "a-%X]" : "%X]",
-				range_lo);
+				range_hi > 0xA ? "A-%X]" : "%X]",
+				range_hi);
 		}
 	}
 	if (bcdDevice_initial_digits < (sizeof(id->bcdDevice_lo) * 2 - 1))
-- 
1.9.0

