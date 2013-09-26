Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727Ab3IZANl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 20:13:41 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:58839 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab3IZANj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 20:13:39 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        codonell <codonell@redhat.com>, Eduard Benes <ebenes@redhat.com>,
        Karel Srot <ksrot@redhat.com>, Matt Newsome <mnewsome@redhat.com>,
        linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>,
        stable@vger.kernel.org
Subject: [PATCH] tty: Fix SIGTTOU not sent with tcflush()
Date: Wed, 25 Sep 2013 20:13:04 -0400
Message-Id: <1380154395-4232-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <52437AA2.5040907@hurleysoftware.com>
References: <52437AA2.5040907@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 'e7f3880cd9b98c5bf9391ae7acdec82b75403776'
  tty: Fix recursive deadlock in tty_perform_flush()
introduced a regression where tcflush() does not generate
SIGTTOU for background process groups.

Make sure ioctl(TCFLSH) calls tty_check_change() when
invoked from the line discipline.

Cc: stable@vger.kernel.org # v3.10+
Reported-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_ioctl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/tty/tty_ioctl.c b/drivers/tty/tty_ioctl.c
index 3500d41..088b4ca 100644
--- a/drivers/tty/tty_ioctl.c
+++ b/drivers/tty/tty_ioctl.c
@@ -1201,6 +1201,9 @@ int n_tty_ioctl_helper(struct tty_struct *tty, struct file *file,
 		}
 		return 0;
 	case TCFLSH:
+		retval = tty_check_change(tty);
+		if (retval)
+			return retval;
 		return __tty_perform_flush(tty, arg);
 	default:
 		/* Try the mode commands */
-- 
1.8.1.2

