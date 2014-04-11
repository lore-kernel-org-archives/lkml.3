Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670AbaDKJma (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 05:42:30 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:45546 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756581AbaDKJmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 05:42:21 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Oliver Neukum <oneukum@suse.de>, Jiri Slaby <jslaby@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Xiao Jin <jin.xiao@intel.com>, david.a.cohen@linux.intel.com,
        yanmin.zhang@intel.com, Johan Hovold <jhovold@gmail.com>
Subject: [RFC 1/2] n_tty: fix dropped output characters
Date: Fri, 11 Apr 2014 11:41:24 +0200
Message-Id: <1397209285-15471-1-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <20140411093715.GA17522@localhost>
References: <20140411093715.GA17522@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix characters being dropped by n_tty_write() due to a failure to
check the return value of tty_put_char() in do_output_char().

Characters are currently being dropped by write if a tty driver claims
to have write room available, but still fails to buffer any data (e.g.
if a driver without internal buffer is run-time suspended between
write_room and write).

Note that process_output_block() handles such a failed buffer attempt,
but that the consecutive process_output() of the first character will
drop it. This could lead to the whole buffer being silently dropped
as the remainder of the buffer is processed in a loop.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/tty/n_tty.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index d15624c1b751..d22a2d8f1cb7 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -513,7 +513,9 @@ static int do_output_char(unsigned char c, struct tty_struct *tty, int space)
 		break;
 	}
 
-	tty_put_char(tty, c);
+	if (!tty_put_char(tty, c))
+		return -1;
+
 	return 1;
 }
 
-- 
1.8.3.2

