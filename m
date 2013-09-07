Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751244Ab3IGI66 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 04:58:58 -0400
Received: from trent.utfs.org ([94.185.90.103]:49355 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751072Ab3IGI65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 04:58:57 -0400
X-Greylist: delayed 456 seconds by postgrey-1.27 at vger.kernel.org; Sat, 07 Sep 2013 04:58:56 EDT
Date: Sat, 7 Sep 2013 01:51:16 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: Vasiliy Kulikov <segoon@openwall.com>
Subject: proc hidepid=2 and SGID programs
Message-ID: <alpine.DEB.2.11.1309070133340.21301@trent.utfs.org>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I was wondering why I cannot see processes that were started from SGID 
programs:

================================
$ grep ^proc /proc/mounts
proc /proc proc rw,nosuid,nodev,noexec,relatime,hidepid=2 0 0

$ ls -n `which ssh-agent`
-rwxr-sr-x 1 0 103 132748 Feb  8  2013 /usr/bin/ssh-agent

$ eval `ssh-agent`
Agent pid 3177

$ ps -o euid,ruid,suid,egid,rgid,sgid,pid,comm -p 3177
 EUID  RUID  SUID  EGID  RGID  SGID   PID COMMAND

$ sudo ps -o euid,ruid,suid,egid,rgid,sgid,pid,comm -p 3177
 EUID  RUID  SUID  EGID  RGID  SGID   PID COMMAND
 1000  1000  1000  1000  1000   103  3177 ssh-agent
================================

Although the binary has the SGID bit set, the process seems to belong to 
myself (uid/gid 1000), as it probably dropped ssh-group permissions after 
start. But the PID is not visible in /proc and I cannot "find" it:

================================
$ pgrep ssh-agent; echo $?
1

$ pkill ssh-agent; echo $?
1

$ kill 3177; echo $?
0
================================

Because I knew the PID, I could terminate it of course. Is this expected 
behaviour? Shouldn't my own processes be visible to myself, even with 
/proc mounted with the hidepid=2 option?

Christian.
-- 
BOFH excuse #412:

Radial Telemetry Infiltration
