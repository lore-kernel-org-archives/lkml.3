Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481AbaL0RkA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2014 12:40:00 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:50323 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795AbaL0Rj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2014 12:39:59 -0500
Message-ID: <549EEEEA.1050306@gmail.com>
Date: Sat, 27 Dec 2014 18:39:54 +0100
From: Piotr Karbowski <piotr.karbowski@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [BUG] rename() from outside of the target dir breaks /proc exe symlink.
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

There's something wrong about exe symlink that can be found insde 
/proc/<pid>/ directories. When the running binary is replaced with 
another, using rename() call, the symlink may point to wrong path.

As example let me use sshd. I have running sshd from /usr/sbin. If I 
replace /usr/sbin/sshd one could expect to see exe symlink pointing to 
'/usr/sbin/sshd (deleted)', it does work this way if the source of 
rename() was in the same directory or nested within, thus rename like:

rename("/usr/sbin/foo", "/usr/sbin/sshd")

and

rename("/usr/sbin/bar/sshd", "/usr/sbin/sshd")

ends with a proper '/usr/sbin/sshd (deleted)' symlink.

if however the source was outside of the target directory, the symlink 
will point to the source path of rename() calls with 'deleted' sufix.

Here's example:

sbin # for i in `pidof sshd`; do ls -l /proc/$i/exe; done
lrwxrwxrwx 1 root root 0 Dec 27 18:09 /proc/29047/exe -> /usr/sbin/sshd

sbin # cp sshd /root/foo

sbin # strace -f perl -e 'rename("/root/foo", "/usr/sbin/sshd")' 2>&1 | 
grep sshd
rename("/root/foo", "/usr/sbin/sshd")   = 0

sbin # for i in `pidof sshd`; do ls -l /proc/$i/exe; done
lrwxrwxrwx 1 root root 0 Dec 27 18:09 /proc/29047/exe -> /root/sshd 
(deleted)

I am unable to find kernel version where it worked as one could presume 
thus I cannot offer to bisect commits to find the bad one.

The environment was kernel 3.17.4 x86_64 and the filesystem ext4.

-- Piotr.
