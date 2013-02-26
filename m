Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933451Ab3BZX7D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 18:59:03 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42412 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933342Ab3BZX6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:58:53 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Roman Rakus <rrakus@redhat.com>, Lingzhu Xiang <lxiang@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [ 09/53] tty: set_termios/set_termiox should not return -EINTR
Date: Tue, 26 Feb 2013 15:57:38 -0800
Message-Id: <20130226235620.808973902@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235619.844721947@linuxfoundation.org>
References: <20130226235619.844721947@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/tty/tty_ioctl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/tty/tty_ioctl.c
+++ b/drivers/tty/tty_ioctl.c
@@ -617,7 +617,7 @@ static int set_termios(struct tty_struct
 	if (opt & TERMIOS_WAIT) {
 		tty_wait_until_sent(tty, 0);
 		if (signal_pending(current))
-			return -EINTR;
+			return -ERESTARTSYS;
 	}
 
 	tty_set_termios(tty, &tmp_termios);
@@ -684,7 +684,7 @@ static int set_termiox(struct tty_struct
 	if (opt & TERMIOS_WAIT) {
 		tty_wait_until_sent(tty, 0);
 		if (signal_pending(current))
-			return -EINTR;
+			return -ERESTARTSYS;
 	}
 
 	mutex_lock(&tty->termios_mutex);


