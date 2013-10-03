Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755024Ab3JCEMK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 00:12:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46896 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754337Ab3JCEMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 00:12:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [ 18/52] tty: Fix SIGTTOU not sent with tcflush()
Date: Wed,  2 Oct 2013 21:05:36 -0700
Message-Id: <20131003040523.429710719@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20131003040522.190209641@linuxfoundation.org>
References: <20131003040522.190209641@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Hurley <peter@hurleysoftware.com>

commit 5cec7bf699c61d14f0538345076480bb8c8ebfbb upstream.

Commit 'e7f3880cd9b98c5bf9391ae7acdec82b75403776'
  tty: Fix recursive deadlock in tty_perform_flush()
introduced a regression where tcflush() does not generate
SIGTTOU for background process groups.

Make sure ioctl(TCFLSH) calls tty_check_change() when
invoked from the line discipline.

Reported-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/tty_ioctl.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/tty/tty_ioctl.c
+++ b/drivers/tty/tty_ioctl.c
@@ -1201,6 +1201,9 @@ int n_tty_ioctl_helper(struct tty_struct
 		}
 		return 0;
 	case TCFLSH:
+		retval = tty_check_change(tty);
+		if (retval)
+			return retval;
 		return __tty_perform_flush(tty, arg);
 	default:
 		/* Try the mode commands */


