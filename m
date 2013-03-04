Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757731Ab3CDDrS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 22:47:18 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33191 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757447Ab3CDDoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:44:54 -0500
Message-Id: <20130304033710.123345993@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:37:33 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Oleg Nesterov <oleg@redhat.com>,
        Roman Rakus <rrakus@redhat.com>, Lingzhu Xiang <lxiang@redhat.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 026/153] tty: set_termios/set_termiox should not return -EINTR
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/tty/tty_ioctl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/tty/tty_ioctl.c
+++ b/drivers/tty/tty_ioctl.c
@@ -618,7 +618,7 @@ static int set_termios(struct tty_struct
 	if (opt & TERMIOS_WAIT) {
 		tty_wait_until_sent(tty, 0);
 		if (signal_pending(current))
-			return -EINTR;
+			return -ERESTARTSYS;
 	}
 
 	tty_set_termios(tty, &tmp_termios);
@@ -685,7 +685,7 @@ static int set_termiox(struct tty_struct
 	if (opt & TERMIOS_WAIT) {
 		tty_wait_until_sent(tty, 0);
 		if (signal_pending(current))
-			return -EINTR;
+			return -ERESTARTSYS;
 	}
 
 	mutex_lock(&tty->termios_mutex);


