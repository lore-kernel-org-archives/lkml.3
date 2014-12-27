Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751545AbaL0SOQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2014 13:14:16 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:36990 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795AbaL0SOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2014 13:14:14 -0500
Date: Sat, 27 Dec 2014 18:14:13 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Piotr Karbowski <piotr.karbowski@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [BUG] rename() from outside of the target dir breaks /proc exe
 symlink.
Message-ID: <20141227181412.GG22149@ZenIV.linux.org.uk>
References: <549EEEEA.1050306@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <549EEEEA.1050306@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 27, 2014 at 06:39:54PM +0100, Piotr Karbowski wrote:
> Hi,
> 
> There's something wrong about exe symlink that can be found insde
> /proc/<pid>/ directories. When the running binary is replaced with
> another, using rename() call, the symlink may point to wrong path.
> 
> As example let me use sshd. I have running sshd from /usr/sbin. If I
> replace /usr/sbin/sshd one could expect to see exe symlink pointing
> to '/usr/sbin/sshd (deleted)', it does work this way if the source
> of rename() was in the same directory or nested within, thus rename
> like:
> 
> rename("/usr/sbin/foo", "/usr/sbin/sshd")
> 
> and
> 
> rename("/usr/sbin/bar/sshd", "/usr/sbin/sshd")
> 
> ends with a proper '/usr/sbin/sshd (deleted)' symlink.
> 
> if however the source was outside of the target directory, the
> symlink will point to the source path of rename() calls with
> 'deleted' sufix.
> 
> Here's example:
> 
> sbin # for i in `pidof sshd`; do ls -l /proc/$i/exe; done
> lrwxrwxrwx 1 root root 0 Dec 27 18:09 /proc/29047/exe -> /usr/sbin/sshd
> 
> sbin # cp sshd /root/foo
> 
> sbin # strace -f perl -e 'rename("/root/foo", "/usr/sbin/sshd")'
> 2>&1 | grep sshd
> rename("/root/foo", "/usr/sbin/sshd")   = 0
> 
> sbin # for i in `pidof sshd`; do ls -l /proc/$i/exe; done
> lrwxrwxrwx 1 root root 0 Dec 27 18:09 /proc/29047/exe -> /root/sshd
> (deleted)
> 
> I am unable to find kernel version where it worked as one could
> presume thus I cannot offer to bisect commits to find the bad one.

That's because it never _had_ worked.  Note that opening the damn thing
will give the right file - it does not work by traversing the result of
readlink(2).  readlink(2) output on those is not promised to be useful
in all cases; often enough it is, but it won't work on cross-directory
renames, it can't be used to tell a filename that really ends with " (deleted)"
from a removed file, etc.  Moreover, it only very recently became usable for
victim names with the last component longer than 40 characters if you did an
overwriting rename.

What are you trying to use it for?
