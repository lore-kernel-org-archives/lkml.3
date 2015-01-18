Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751633AbbARS4X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 13:56:23 -0500
Received: from mail-qa0-f41.google.com ([209.85.216.41]:48766 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbbARS4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 13:56:22 -0500
MIME-Version: 1.0
From: enh <enh@google.com>
Date: Sun, 18 Jan 2015 10:56:00 -0800
Message-ID: <CAJgzZooYNtdFmZkSBgu8HgOjW2Qr-ZUBUEgZC2mVpLTh7cUqRQ@mail.gmail.com>
Subject: PROBLEM: no ENOENT from utimensat with UTIME_OMIT
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

utimensat always returns success if both times are UTIME_OMIT, even if
the file doesn't exist or dirfd is invalid.

$ cat x.c
#include <fcntl.h>
#include <sys/stat.h>

int main(int argc, char* argv) {
 struct timespec times[2] = { { 0, UTIME_OMIT }, { 0, UTIME_OMIT } };
 struct stat sb;

 stat("does-not-exist", &sb); // -ENOENT
 utimensat(AT_FDCWD, "does-not-exist", times, 0); // 0!
 utimensat(-1, "does-not-exist", times, 0); // 0!
 stat("does-not-exist", &sb); // -ENOENT

 return 0;
}
$ cc x.c -o x
$ strace -e stat,utimensat ./x
stat("does-not-exist", 0x7fff240d9190)  = -1 ENOENT (No such file or directory)
utimensat(AT_FDCWD, "does-not-exist", {UTIME_OMIT, UTIME_OMIT}, 0) = 0
utimensat(-1, "does-not-exist", {UTIME_OMIT, UTIME_OMIT}, 0) = 0
stat("does-not-exist", 0x7fff240d9190)  = -1 ENOENT (No such file or directory)
+++ exited with 0 +++
$

the above output is from a 3.13 kernel, but the bug is present at ToT:

https://github.com/torvalds/linux/blob/master/fs/utimes.c#L194

POSIX says "If both tv_nsec fields are set to UTIME_OMIT, no ownership
or permissions check shall be performed for the file, but other error
conditions may still be detected (including [EACCES] errors related to
the path prefix)." so i think that the "may" there means that strictly
this is in spec, but it's somewhat unhelpful.

fwiw, NetBSD seems to have the opposite mistake: they unconditionally
call namei so it would appear that they'll return errors for files
that do exist but where the caller doesn't have permission.

 --elliott
