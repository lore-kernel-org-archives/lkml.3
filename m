Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758696Ab3DASIe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 14:08:34 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:35958 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757640Ab3DASId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 14:08:33 -0400
Date: Mon, 1 Apr 2013 14:08:32 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Theodore Ts'o" <tytso@alum.mit.edu>
cc: Kernel development list <linux-kernel@vger.kernel.org>
Subject: Files are created with the wrong permissions
Message-ID: <Pine.LNX.4.44L0.1304011352420.1036-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ted or anybody else:

In preparation for a software upgrade, I just repartitioned and
reformmated my server.  After restoring the contents from a backup and
booting, I find that new files are not being created with the right
permissions, which obviously causes lots of problems.

Here's an example of a simple test program:


#include <stdio.h>
#include <fcntl.h>

int main()
{
	unsigned	m;
	int		fd;

	m = umask(0);
	printf("Original umask: %03o\n", m);

	fd = open("b", O_RDWR | O_CREAT | O_EXCL, 0777);
	printf("fd: %d\n", fd);
	if (fd != -1)
		close(fd);

	return 0;
}


Since the umask is set to 0, the "b" file should be created with its 
permissions set to -rwxrwxrwx.  That's not what happens.

The results vary as I run the program in different directories.  For
example, running as root in /root, I get:

	-r-xr-x--- 1 root root 0 Apr  1 13:56 b

But in /var, I get:

	-rwxr-xr-x 1 root root 0 Apr  1 14:05 b

In other places I get:

	-rwx------ 1 root root 0 Apr  1 13:57 b

or

	-rwxr-x--- 1 root root 0 Apr  1 14:00 b

or

	-rwxr-xr-x 1 root root 0 Apr  1 13:58 b

or even the expected result:

	-rwxrwxrwx 1 root root 0 Apr  1 13:42 b

Can anybody suggest the reason for this and how to fix it?

One fact that might be relevant: The original filesystems were ext3, 
but I reformatted the partitions as ext4.  The restore was done using 
tar with the --xattrs option.  Could that be responsible?  lsattr shows 
only:

# lsattr -d /root
-------------e- /root

Note: This happens under both the 3.6 and 3.8 kernels.

Thanks for any help.

Alan Stern

