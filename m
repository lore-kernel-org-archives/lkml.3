Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756405AbaIZXbc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 19:31:32 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:33931 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756316AbaIZXb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 19:31:29 -0400
Date: Sat, 27 Sep 2014 00:31:25 +0100
From: Ross Lagerwall <rosslagerwall@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Subject: Mount propagation issue
Message-ID: <20140926233125.GA6918@hobo.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have encountered a strange bug (on 3.14, 3.16.3 and master) regarding
mount namespaces and a particular directory.  Somehow, mounts are being
mounted successfully but disappearing when the process dies, but only
for /mnt/puppy, not for any other directory in the system:

# grep puppy /proc/mounts            # nothing mounted yet
# mount -t tmpfs tmpfs /mnt/puppy
# grep puppy /proc/mounts            # no output

# mount -t tmpfs tmpfs /mnt/puppy2
# grep puppy /proc/mounts
tmpfs /mnt/puppy2 tmpfs rw,relatime 0 0

Furthermore, I wrote a program to mount /mnt/puppy and immediately
read /proc/mounts:
# grep puppy /proc/mounts            # no output
# ./mounter
tmpfs /mnt/puppy tmpfs rw,relatime 0 0
# grep puppy /proc/mounts            # no output

Finally, I note that the problem seems to occur if the mount needs to be
propagated to the default namespace (note that systemd causes namespaces
to be shared by default):
# unshare -m

subshell # mount -t tmpfs tmpfs /mnt/puppy
subshell # grep puppy /proc/mounts   # no output
subshell # mount --make-rprivate /
subshell # mount -t tmpfs tmpfs /mnt/puppy
subshell # grep puppy /proc/mounts   # success!
tmpfs /mnt/puppy tmpfs rw,relatime 0 0
subshell # umount /mnt/puppy
subshell # exit

# mount --make-rprivate /            # back in the default namespace
# mount -t tmpfs tmpfs /mnt/puppy
# grep puppy /proc/mounts            # no output

I hope someone has an idea of what's going on or how to debug this
because I've run out of ideas...

Thanks!
-- 
Ross Lagerwall
