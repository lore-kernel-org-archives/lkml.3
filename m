Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751794AbaASR70 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 12:59:26 -0500
Received: from mail-bk0-f53.google.com ([209.85.214.53]:48572 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbaASR7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 12:59:23 -0500
Message-ID: <52DC1272.1020005@gmail.com>
Date: Sun, 19 Jan 2014 18:59:14 +0100
From: wiebittewas <wiebittewas@googlemail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 3.10.27: BUG on accessing /proc under high load
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=68991

because http://kernelnewbies.org/FoundBug says, a bug-msg should be
created in bugzilla as well as send to this list, I just follow this...

currently I don't have the time for this list, so please do a CC to me.

when doing a find /proc -type f -exec sha512sum {} \; x-hundred times
parallel, this can lead in a BUG within d_path.

as I can see in the oops and the objdump (filed at bugzilla), the
problems occurs in fs/dcache.c:d_path(), testing for existance of a
function and then calling it:

if (path->dentry->d_op && path->dentry->d_op->d_dname)
   return path->dentry->d_op->d_dname(path->dentry, buf, buflen);

looking at fs/proc/base.c:proc_pid_readlink() "path" is initialized in
one of the getlink-functions within proc.c: proc_cwd_link() or
proc_root_link()

in both functions first the task-structure is get by get_roc_task() and
if 's not NULL, then locked and then the wanted fs_struct is
acquired/locked.

now I don't have enough experience, but maybe beetween getting the
task-struct and locking it, the task may be already invalidated because
it exited, so the lock should be done in get_proc_task() or at least it
should be checked after locking, if the task is still alive....???

