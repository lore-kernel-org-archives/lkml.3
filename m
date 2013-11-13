Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758872Ab3KMLeP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 06:34:15 -0500
Received: from mail-ve0-f172.google.com ([209.85.128.172]:40437 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754386Ab3KMLeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 06:34:13 -0500
MIME-Version: 1.0
Date: Wed, 13 Nov 2013 03:34:13 -0800
Message-ID: <CAGr1u3vZU_Pxwu1nSab0PExNPQsE0xiSpcoMbUQ7MeGbJzBAjA@mail.gmail.com>
Subject: 3.12 Regression: dcache: Translating dentry into pathname without
 taking rename_lock 232d2d60
From: Michael Marineau <michael.marineau@coreos.com>
To: Waiman Long <Waiman.Long@hp.com>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

Commit 232d2d60aa5469bb097f55728f65146bd49c1d25 causes intermittent
errors in /proc/*/fd/* where readlink returns "/" instead of the
correct path. This can be reproduced by the script below which copies
the kernel source directory structure while obsessively looking up
directory fds in proc from another process. Reverting
232d2d60aa5469bb097f55728f65146bd49c1d25 after two related commits
48f5ec21d9c67e881ff35343988e290ef5cf933f
1812997720ab90d029548778c55d7315555e1fef fixes the issue.

Cheers,
Mike


#!/usr/bin/python

import os
import subprocess
import tempfile

KERNEL_SOURCE="/home/marineam/git/linux"
TEMP_DIR=tempfile.mkdtemp()

# Copy the directory tree, can skip most of the files
rsync = subprocess.Popen(["rsync", "--exclude=*.*", "-a",
                            KERNEL_SOURCE, TEMP_DIR])

def check_entry(dir_path, name):
    expect = "%s/%s" % (dir_path, name)
    if os.path.islink(expect):
        return

    fd = os.open(expect, os.O_RDONLY)
    # It takes some pounding on proc to be likely to hit an error
    for i in xrange(100):
        got = os.readlink("/proc/self/fd/%d" % fd)
        if got != expect:
            print "Got %s instead of %s" % (got, expect)

    os.close(fd)

try:
    for dirpath, dirnames, filenames in os.walk(KERNEL_SOURCE):
        for name in dirnames:
            check_entry(dirpath, name)
finally:
    rsync.wait()
    subprocess.call(["rm", "-rf", TEMP_DIR])
