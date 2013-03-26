Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757128Ab3CZXsk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 19:48:40 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:57138 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757328Ab3CZXsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 19:48:25 -0400
Message-ID: <1364341667.3512.11.camel@thor.lan>
Subject: Re: [PATCH v5 26/44] tty: Add read-recursive, writer-prioritized rw
 semaphore
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ilya Zykov <linux@izyk.ru>, Jiri Slaby <jslaby@suse.cz>,
        Sasha Levin <levinsasha928@gmail.com>, Dave Jones <davej@redhat.com>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Date: Tue, 26 Mar 2013 19:47:47 -0400
In-Reply-To: <20130319015936.GA21241@kroah.com>
References: <1361390599-15195-1-git-send-email-peter@hurleysoftware.com>
	 <1363034704-28036-1-git-send-email-peter@hurleysoftware.com>
	 <1363034704-28036-27-git-send-email-peter@hurleysoftware.com>
	 <20130318235815.GA5320@kroah.com> <1363654879.4568.42.camel@thor.lan>
	 <20130319015936.GA21241@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-03-18 at 18:59 -0700, Greg Kroah-Hartman wrote:
> > If you'd like, I can send you 6 or so short user test programs that
> > hang, crash, or deadlock inside 60 seconds on mainline and next, but not
> > with this patchset.
> 
> That would be interesting to have, please send them.
> 
> And I hope that they only lock up when run as root, but I'm afraid to
> ask that question...

Sorry Greg, I meant to get to this sooner.

This one is pretty straightforward. Does not require suid.
I would still recommend only running this in a disposable vm -- that's
what I do. The vm should have 6 cores to do real business.

It helps to hook up netconsole or whatever so you can see what kind of
progress it's making but don't use a slow framebuffer console because
that invariably locks up :). If it pauses for 5 secs., that's actually
correct behavior.

--- >% ---

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 pts_test3.c | 151 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 151 insertions(+)
 create mode 100644 pts_test3.c

diff --git a/pts_test3.c b/pts_test3.c
new file mode 100644
index 0000000..b673f17
--- /dev/null
+++ b/pts_test3.c
@@ -0,0 +1,151 @@
+/*
+ *  pts_test3.c
+ *
+ *  Created on: Dec, 2012
+ *  Copyright (C) 2012  Ilya Zykov
+ *
+ *  This program is free software: you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation, either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ *
+ *  Modified-by: Peter Hurley <peter@hurleysoftware.com>
+ */
+
+#include <stdio.h>
+#include <fcntl.h>
+#include <sys/ioctl.h>
+#include <termios.h>
+#include <stdlib.h>
+#include <pthread.h>
+#include <signal.h>
+
+#define BUF_SIZE 2
+#define ERROR_EXIT_CODE 1
+#define parent child_id
+
+static int
+mfd=-1, sfd=-1, parent=1;
+
+static pthread_t
+pth_id;
+
+static char
+pty_name[24], buf[]={ '1', '\n' };
+
+
+static void
+pty_exit(int ret, char * exit_message){
+        if (sfd >= 0) close(sfd);
+        if (mfd >= 0) close(mfd);
+        printf("%s %s %s exit. \n",exit_message?exit_message:"",
+                ret?"Error":"Normal", parent?"parent":"child");
+        exit(ret);
+}
+
+static void
+pty_init(void){
+        int ptn;
+        if( (mfd=open("/dev/ptmx", O_RDWR )) < 0 )
+                pty_exit(ERROR_EXIT_CODE,"Couldn't open /dev/ptmx. \n");
+        if (ioctl(mfd, TIOCGPTN, &ptn) < 0 )
+                pty_exit(ERROR_EXIT_CODE,"Couldn't get pty number. \n");
+        snprintf(pty_name, sizeof(pty_name), "/dev/pts/%d", ptn);
+        //printf("Slave pty name = %s.\n",pty_name);
+        ptn=0;
+        if (ioctl(mfd, TIOCSPTLCK, &ptn) < 0 )
+                pty_exit(ERROR_EXIT_CODE,"Couldn't unlock pty slave. \n");
+        if ( (sfd=open(pty_name, O_RDWR )) < 0 )
+                pty_exit(ERROR_EXIT_CODE, "Couldn't open pty slave. \n");
+}
+
+static void *
+pty_thread_open(void * arg) {
+        static const char ret[]="Thread open has been created.\n";
+        printf(ret);
+        do {
+                close(open(pty_name, O_RDWR ));
+        } while(1);
+        return ret;
+}
+
+static void *
+pty_thread_read(void * arg) {
+        static const char ret[]="Thread read has been created.\n";
+        printf(ret);
+        do {
+                read(sfd, buf, BUF_SIZE);
+        } while(1);
+        return ret;
+}
+
+static void *
+pty_thread_write(void * arg) {
+        static char ret[]="Thread write has been created.\n";
+        printf(ret);
+        do {
+                write(mfd, buf, BUF_SIZE);
+        } while(1);
+        return ret;
+}
+
+#define N_PPS 18
+
+static void *
+pty_thread_msetd(void * arg) {
+        static const char ret[]="Thread msetd has been created.\n";
+	static int ldisc;
+        printf(ret);
+        do {
+		ldisc = N_PPS;
+                ioctl(mfd, TIOCSETD, &ldisc);
+		ldisc = N_TTY;
+		ioctl(mfd, TIOCSETD, &ldisc);
+        } while(1);
+        return ret;
+}
+
+static void *
+pty_thread_ssetd(void * arg) {
+        static char ret[]="Thread ssetd has been created.\n";
+	static int ldisc;
+        printf(ret);
+        do {
+		ldisc = N_PPS;
+                ioctl(sfd, TIOCSETD, &ldisc);
+		ldisc = N_TTY;
+		ioctl(sfd, TIOCSETD, &ldisc);
+        } while(1);
+        return ret;
+}
+
+int main(int argc,char *argv[]) {
+        pty_init();
+        child_id=fork();
+        if(parent) {
+                sleep(100);
+                kill(child_id, SIGINT);
+                pty_exit(0,"Parent normal exit\n");
+        }
+        pthread_create(&pth_id, NULL, &pty_thread_open, 0);
+	/* For WARNINGS. */
+        pthread_create(&pth_id, NULL, &pty_thread_write, 0);
+        pthread_create(&pth_id, NULL, &pty_thread_read, 0);
+
+	pthread_create(&pth_id, NULL, &pty_thread_msetd, 0);
+	pthread_create(&pth_id, NULL, &pty_thread_ssetd, 0);
+        do {
+                close(sfd);
+                close(mfd);
+                pty_init();
+        } while(1);
+        return 0;
+}
-- 
1.8.1.2




