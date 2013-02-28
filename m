Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933266Ab3B1PSx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 10:18:53 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41980 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755774Ab3B1Oqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:46:55 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Oleg Nesterov <oleg@redhat.com>, Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 028/139] tty: set_termios/set_termiox should not return -EINTR
Date: Thu, 28 Feb 2013 14:42:58 +0000
Message-Id: <1362062689-2567-29-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit 183d95cdd834381c594d3aa801c1f9f9c0c54fa9 upstream.

See https://bugzilla.redhat.com/show_bug.cgi?id=904907
read command causes bash to abort with double free or corruption (out).

A simple test-case from Roman:

	// Compile the reproducer and send sigchld ti that process.
	// EINTR occurs even if SA_RESTART flag is set.

	void handler(int sig)
	{
	}

	main()
	{
	  struct sigaction act;
	  act.sa_handler = handler;
	  act.sa_flags = SA_RESTART;
	  sigaction (SIGCHLD, &act, 0);
	  struct termio ttp;
	  ioctl(0, TCGETA, &ttp);
	  while(1)
	  {
	    if (ioctl(0, TCSETAW, ttp) < 0)
	      {
		if (errno == EINTR)
		{
		  fprintf(stderr, "BUG!"); return(1);
		}
	      }
	  }
	}

Change set_termios/set_termiox to return -ERESTARTSYS to fix this
particular problem.

I didn't dare to change other EINTR's in drivers/tty/, but they look
equally wrong.

Reported-by: Roman Rakus <rrakus@redhat.com>
Reported-by: Lingzhu Xiang <lxiang@redhat.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/tty/tty_ioctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/tty_ioctl.c b/drivers/tty/tty_ioctl.c
index a1b9a2f..f8d03da 100644
--- a/drivers/tty/tty_ioctl.c
+++ b/drivers/tty/tty_ioctl.c
@@ -617,7 +617,7 @@ static int set_termios(struct tty_struct *tty, void __user *arg, int opt)
 	if (opt & TERMIOS_WAIT) {
 		tty_wait_until_sent(tty, 0);
 		if (signal_pending(current))
-			return -EINTR;
+			return -ERESTARTSYS;
 	}
 
 	tty_set_termios(tty, &tmp_termios);
@@ -684,7 +684,7 @@ static int set_termiox(struct tty_struct *tty, void __user *arg, int opt)
 	if (opt & TERMIOS_WAIT) {
 		tty_wait_until_sent(tty, 0);
 		if (signal_pending(current))
-			return -EINTR;
+			return -ERESTARTSYS;
 	}
 
 	mutex_lock(&tty->termios_mutex);
-- 
1.8.1.2

