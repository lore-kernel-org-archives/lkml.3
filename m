Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887AbaJGNkS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 09:40:18 -0400
Received: from relay.parallels.com ([195.214.232.42]:51733 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216AbaJGNkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 09:40:16 -0400
Date: Tue, 7 Oct 2014 17:40:12 +0400
From: Andrew Vagin <avagin@parallels.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Andrey Vagin <avagin@openvz.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: [PATCH] mnt: don't allow to detach the namespace root
Message-ID: <20141007134011.GA569@paralelels.com>
References: <1412683212-28077-1-git-send-email-avagin@openvz.org>
 <20141007132431.GF7996@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="koi8-r"
Content-Disposition: inline
In-Reply-To: <20141007132431.GF7996@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [10.30.16.48]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2014 at 02:24:36PM +0100, Al Viro wrote:
> On Tue, Oct 07, 2014 at 04:00:12PM +0400, Andrey Vagin wrote:
> > This patch fixes a bug, which is triggered by following code:
> > while (1) {
> >         if (umount2("/", MNT_DETACH) ||
> > 	    setns(fd, CLONE_NEWNS))
> >                 return break;
> > }
> 
> Excuse me, but that makes no sense whatsoever (not to mention that
> reproducer won't compile - return break; alone is enough to make
> sure of that).
> 
> Could you post the real reproducer?

#define _GNU_SOURCE
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sched.h>
#include <unistd.h>
#include <sys/mount.h>

int main(int argc, char **argv)
{
	int fd;

	fd = open("/proc/self/ns/mnt", O_RDONLY);
	if (fd < 0)
		return 1;
	while (1) {
		if (umount2("/", MNT_DETACH) ||
		    setns(fd, CLONE_NEWNS))
			break;
	}

	return 0;
}

root@ubuntu:/home/avagin# gcc -Wall nsenter.c -o nsenter
root@ubuntu:/home/avagin# strace ./nsenter
execve("./nsenter", ["./nsenter"], [/* 22 vars */]) = 0
...
open("/proc/self/ns/mnt", O_RDONLY)     = 3
umount("/", MNT_DETACH)                 = 0
setns(3, 131072)                        = 0
umount("/", MNT_DETACH

