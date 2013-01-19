Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756364Ab3ASBSX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 20:18:23 -0500
Received: from mail.kernel.org ([198.145.19.201]:56605 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756292Ab3ASBSS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 20:18:18 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Jiri Slaby <jslaby@suse.cz>, Florian Westphal <fw@strlen.de>,
        Alan Cox <alan@linux.intel.com>
Subject: [ 33/33] pty: return EINVAL for TIOCGPTN for BSD ptys
Date: Fri, 18 Jan 2013 17:16:58 -0800
Message-Id: <20130119010357.422492346@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130119010345.885772698@linuxfoundation.org>
References: <20130119010345.885772698@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Slaby <jslaby@suse.cz>

commit ded2f295a36d17838fe97e80d7b6ea83381474f8 upstream.

Commit bbb63c514a3464342967237a51a21ea8f61ab951 (drivers:tty:fix up
ENOIOCTLCMD error handling) changed the default return value from tty
ioctl to be ENOTTY and not EINVAL. This is appropriate.

But in case of TIOCGPTN for the old BSD ptys glibc started failing
because it expects EINVAL to be returned. Only then it continues to
obtain the pts name the other way around.

So fix this case by explicit return of EINVAL in this case.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Reported-by: Florian Westphal <fw@strlen.de>
Cc: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/pty.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -395,6 +395,8 @@ static int pty_bsd_ioctl(struct tty_stru
 		return pty_set_lock(tty, (int __user *) arg);
 	case TIOCSIG:    /* Send signal to other side of pty */
 		return pty_signal(tty, (int) arg);
+	case TIOCGPTN: /* TTY returns ENOTTY, but glibc expects EINVAL here */
+		return -EINVAL;
 	}
 	return -ENOIOCTLCMD;
 }


