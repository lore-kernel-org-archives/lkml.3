Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813AbaBUBKA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 20:10:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45277 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753991AbaBTXua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 18:50:30 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jan Moskyto Matejka <mq@suse.cz>
Subject: [PATCH 3.4 17/25] Modpost: fixed USB alias generation for ranges including 0x9 and 0xA
Date: Thu, 20 Feb 2014 15:51:33 -0800
Message-Id: <20140220234842.964474113@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140220234842.483343851@linuxfoundation.org>
References: <20140220234842.483343851@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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

---
 scripts/mod/file2alias.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -186,8 +186,8 @@ static void do_usb_entry(struct usb_devi
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


