Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612AbaBCAaw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 19:30:52 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:43036 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550AbaBCAav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 19:30:51 -0500
From: Nathaniel Yazdani <n1ght.4nd.d4y@gmail.com>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/3] epoll: read(),write(),ioctl() interface
Date: Sun,  2 Feb 2014 16:30:27 -0800
Message-Id: <1391387430-6526-1-git-send-email-n1ght.4nd.d4y@gmail.com>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

This patch series adds support for read(), write(), and ioctl() operations
on eventpolls as well as an associated userspace structure to format the
eventpoll entries delivered via read()/write() buffers. The new structure,
struct epoll, differs from struct epoll_event mainly in that struct epoll
also holds the associated file descriptor. Using the normal I/O interface
to manipulate eventpolls is much neater than using epoll-specific syscalls
while also allowing for greater flexibility (theoretically, pipes could
be used to filter access). Specifically, write() creates, modifies, and/or
removes event entries stored in the supplied buffer, using the userspace
identifier to check whether an entry exists and removing it if no events
are set to trigger it, while read() simply waits for enough events to fill
the provided buffer. As timeout control is essential for polling to be
practical, ioctl() is used to configure an optional timeout, which is
infinite by default.

 Documentation/ioctl/ioctl-number.txt |   1 +
 fs/eventpoll.c                       | 534 ++++++++++++++++++++++++-----------
 include/uapi/linux/eventpoll.h       |  10 +
 3 files changed, 384 insertions(+), 161 deletions(-)
