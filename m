Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902AbaDCLNu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 07:13:50 -0400
Received: from rrzmta1.uni-regensburg.de ([194.94.155.51]:52530 "EHLO
	rrzmta1.uni-regensburg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716AbaDCLNr convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:1:1>);
	Thu, 3 Apr 2014 07:13:47 -0400
Message-Id: <533D5E88020000A10001520E@gwsmtp1.uni-regensburg.de>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Thu, 03 Apr 2014 13:13:44 +0200
From: "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>
To: <linux-kernel@vger.kernel.org>
Subject: Q: setting the process name for ps
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Currently one has to fiddle with argv[] in-place when trying to change the process name "cmd") in Linux. However if you want to change the thread name ("comm"), there is a syscall (prctl(PR_SET_NAME, ...)) for it.

For comparison, in HP-UX there is also a syscall to change the process name for ps:
---
#include        <sys/pstat.h>

union pstun     psu;

psu.pst_command = "foobar";
pstat(PSTAT_SETCMD, psu, strlen("foobar") - 1, 0, 0);
---

To be fair, HP-XU also has syscalls to get processes, threads and arguments:
pstat_getlwp()
pstat_getproc()
pstat_getcommandline()

As Linux is different, I wonder whether there are any plans to provide a syscall to change the process name.

For those who aren't afraid of ugly code, here's a quick-and-dirty example how to change the process name in Linux (apologies, you guys know, but those who Google may not:
---
#include        <stdlib.h>
#include        <stdio.h>
#include        <string.h>
#include        <unistd.h>
#include        <time.h>

static  int     delay(void)
{
        struct timespec ts;

        ts.tv_sec = 10;
        ts.tv_nsec = 0;
        return nanosleep(&ts, NULL);
}

int     main(int argc, char *argv[])
{
        int             l = strlen(argv[0]);

        if ( argc > 1 )
                l += 1 + strlen(argv[1]);
        if (l  < 20 ) {
                printf("provide a long argument\n");
                return 1;
        }
        printf("look: unchanged\n"); delay();
        sprintf(argv[0], "proc %d", getpid());
        printf("look: process title\n"); delay();
        return 0;
}
---

As I'm not subscribed to LKML, please keep me CC'd on you replies!

Thanks & regards,
Ulrich Windl


