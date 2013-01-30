Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756512Ab3A3Rq1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 12:46:27 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:34661 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754841Ab3A3RqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 12:46:21 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Ilya Zykov <ilya@ilyx.ru>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 0/4] Fix parallel master and slave pty opens
Date: Wed, 30 Jan 2013 12:43:48 -0500
Message-Id: <1359567832-25318-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.1
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series fixes 2 BUGs and 2 causes of master pty open failure.

Much of this could have been avoided by not calling the tty driver
close() routine if the open() was unsuccessful. Unfortunately, that
choice appears cast in stone, as many drivers depend on this behavior
for cleanup.

Ilya Zykov's latest test jig "stress_test_tty" (included below) passes
the parallel open test after applying these patches.
  peter@kvm:~/src/test$ ./stress_test_tty
  Thread open has been created.
  Parent normal exit
   Normal parent exit 0.

(NB: I did add a minor diagnostic to the test jig in pty_exit() so
it would print errno on error exit).

Peter Hurley (4):
  pty: Fix BUG()s when ptmx_open() errors out
  pty: Ignore slave pty close() if never successfully opened
  tty: Document required behavior of tty driver close()
  pty: Ignore slave open count for master pty open

 drivers/tty/pty.c          | 15 +++++++++++----
 include/linux/tty_driver.h |  1 +
 2 files changed, 12 insertions(+), 4 deletions(-)

/*
 *  stress_test_tty.c
 *
 *  Created on: Dec, 2012
 *  Copyright (C) 2012  Ilya Zykov
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include <stdio.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <termios.h>
#include <stdlib.h>
#include <pthread.h>
#include <signal.h>
#include <errno.h>

#define BUF_SIZE 2
#define ERROR_EXIT_CODE 1
#define parent child_id

static int
mfd=-1, sfd=-1, parent=1;

static pthread_t
pth_id;

static char
pty_name[24], buf[]={ '1', '\n' };


static void
pty_exit(int ret, char * exit_message){
	int err = errno;
        if (sfd >= 0) close(sfd);
        if (mfd >= 0) close(mfd);
        printf("%s %s %s exit %d. \n",exit_message?exit_message:"",
                ret?"Error":"Normal", parent?"parent":"child", ret?err:ret);
        exit(ret);
}

static void
pty_init(void){
        int ptn;
        if( (mfd=open("/dev/ptmx", O_RDWR )) < 0 )
                pty_exit(ERROR_EXIT_CODE,"Couldn't open /dev/ptmx. \n");
        if (ioctl(mfd, TIOCGPTN, &ptn) < 0 )
                pty_exit(ERROR_EXIT_CODE,"Couldn't get pty number. \n");
        snprintf(pty_name, sizeof(pty_name), "/dev/pts/%d", ptn);
        //printf("Slave pty name = %s.\n",pty_name);
        ptn=0;
        if (ioctl(mfd, TIOCSPTLCK, &ptn) < 0 )
                pty_exit(ERROR_EXIT_CODE,"Couldn't unlock pty slave. \n");
        if ( (sfd=open(pty_name, O_RDWR )) < 0 )
                pty_exit(ERROR_EXIT_CODE, "Couldn't open pty slave. \n");
}

static void *
pty_thread_open(void * arg) {
        static char ret[]="Thread open has been created.\n";
        printf(ret);
        do {
                close(open(pty_name, O_RDWR ));
        } while(1);
        return ret;
}

static void *
pty_thread_read(void * arg) {
        static char ret[]="Thread read has been created.\n";
        printf(ret);
        do {
                read(sfd, buf, BUF_SIZE);
        } while(1);
        return ret;
}

static void *
pty_thread_write(void * arg) {
        static char ret[]="Thread write has been created.\n";
        printf(ret);
        do {
                write(mfd, buf, BUF_SIZE);
        } while(1);
        return ret;
}
int main(int argc,char *argv[]) {
        pty_init();
        child_id=fork();
        if(parent) {
                sleep(100);
                kill(child_id, SIGINT);
                pty_exit(0,"Parent normal exit\n");
        }
        pthread_create(&pth_id, NULL, &pty_thread_open, 0);
/*	For WARNINGS.
        pthread_create(&pth_id, NULL, &pty_thread_write, 0);
        pthread_create(&pth_id, NULL, &pty_thread_read, 0);
*/
        do {
                close(sfd);
                close(mfd);
                pty_init();
        } while(1);
        return 0;
}

-- 
1.8.1.1

