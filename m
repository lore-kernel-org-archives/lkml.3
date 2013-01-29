Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909Ab3A2TJN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 14:09:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12103 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754038Ab3A2TJK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 14:09:10 -0500
Date: Tue, 29 Jan 2013 20:07:41 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Lingzhu Xiang <lxiang@redhat.com>, Roman Rakus <rrakus@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] tty: set_termios/set_termiox should not return -EINTR
Message-ID: <20130129190741.GA28004@redhat.com>
References: <20130129190720.GA28000@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130129190720.GA28000@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Cc: stable@kernel.org
---

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

