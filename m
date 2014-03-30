Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385AbaCaASp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 20:18:45 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36363 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752992AbaC3XZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:25:01 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Jan Moskyto Matejka" <mq@suse.cz>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.630982433@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 097/200] Modpost: fixed USB alias generation for
 ranges including 0x9 and 0xA
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 scripts/mod/file2alias.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -130,8 +130,8 @@ static void do_usb_entry(struct usb_devi
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

