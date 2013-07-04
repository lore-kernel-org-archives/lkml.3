Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017Ab3GDFEh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 01:04:37 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44455 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754111Ab3GDFEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 01:04:35 -0400
Date: Thu, 4 Jul 2013 13:41:13 +0900
From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: <toshi.okajima@jp.fujitsu.com>
Subject: [BUG] Failed to open a file after setgid
Message-ID: <20130704134113.dd7b366a45fcdc00f001dba8@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 3.2.0beta9 (GTK+ 2.24.11; i686-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys!

I encountered that a file cannot be opened even if the process has a valid 
access authority for the file on linux-3.10. 

This problem is caused since the group list which getgroups() returns includes 
wrong ID as the group ID after setgid(). These groups include egid of the process 
before calling setgid().

Since man 3p getgroups says as follows, including egid of process itself is
no problem.

======
The getgroups() function shall fill in the array grouplist with the current
supplementary group IDs of  the  calling  process.  It  is implementation-defined
whether getgroups() also returns the effective group ID in the grouplist array.
======

However, it should be the current egid after setgid() instead of the past egid.
So, I consider this behavior is a bug. How do you think?

Here is the step to reproduce:
////////////////////////////////////////////////////////////////////////////////
1. Create a file and set its file access permission/attribute as follows:
 # touch /dummy
 # chmod 505 /dummy
 # chown 0:0 /dummy
 # ls -lnd /
 drwxrwxrwx. 29 0 0 4096 Jul  4 11:46 /
 # ls -ln /dummy
 -r-x---r-x 1 0 0 0 Jul  4 11:46 /dummy
 # id
 uid=0(root) gid=0(root) groups=0(root),3(sys),4(adm),10(wheel)
 # su - tmpuser
 $ id
 uid=1000(tmpuser) gid=100(users) groups=100(users),99(nobody)

2. Run the following program as the privileged user (root)
  # cd /tmp
  # cat source_ng.c
---------------------------------------------------------------------------
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <string.h>
#include <errno.h>
int main(void)
{
        int gid = setgid(100);
        int uid = setuid(1000);
        int fd;
        int groups;
        int i;
        gid_t gids[10];

        groups = getgroups(10, gids);
        for (i = 0; i < groups; i++)
                printf("[group %d] %d\n", i, gids[i]);
        fd = open("/dummy", O_RDONLY);
        if (fd < 0) {
                fprintf(stderr, "open: %s(%d)\n", strerror(errno), errno);
                return 1;
        }
        return 0;
}
  ---------------------------------------------------------------------------
  # make source_ng
  # /tmp/source_ng

  Additional information: 
    The program terminates successfully when tmpuser runs it directly. 
  # su - tmpuser
  $ /tmp/source_ng
  $ echo $?
  0  
////////////////////////////////////////////////////////////////////////////////

This problem happens since root group (0) is still included in the group list
which getgroups() returns. Then, the process is regarded as belonging to these 
groups and prohibited to access to the file.

Expected Result:
This program returns without any errors.
(getgroups() returns the group list including the primary group of the current 
user but not the one of the past user after setgid()) 
  # /tmp/source_ng
  [group 0] 100	
  [group 1] 3                   
  [group 2] 4
  [group 3] 10

Actual Result:
This program returns with error (EACCES).
(getgroups() returns the group list including the primary group of the past
user but not the one of the current user after setgid()) 
  # /tmp/source_ng
  [group 0] 0	// I expect the value is the current egid but not the past egid.
  [group 1] 3                   
  [group 2] 4
  [group 3] 10
  open: Permission denied(13)

Or, setgid() has not a bug but the parameter which the pam library and 
so on give setgroups() including the primary group is wrong? 

Thanks,
toshi.okajima
