Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751603AbaBXBkv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 20:40:51 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:39588 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbaBXBku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 20:40:50 -0500
From: Nathaniel Yazdani <n1ght.4nd.d4y@gmail.com>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH for-next 0/4] epoll: combined control/wait syscall
Date: Sun, 23 Feb 2014 17:40:30 -0800
Message-Id: <1393206034-18080-1-git-send-email-n1ght.4nd.d4y@gmail.com>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Everyone,

Being a new feature, this is obviously targeted for the next release
cycle. There's been some interest in a kevent()-like interface to
eventpoll, which this patch set aims to fulfill by adding an epoll()
system call (couldn't think of a more descriptive name, suggestions
welcome). The current struct epoll_event as used by epoll_{ctl,wait}()
to pass eventpoll entries to/from userspace is insufficient for this,
since eventpoll needs to know which file descriptor to associate with
each new entry. Thus, struct epoll is added, holding the event mask,
a user identifier, and the file descriptor. The internal eventpoll
mechanism has been made structure-agnostic to keep things neat and
orderly (this is where the majority of changes happened). This isn't
ready to be applied just yet; system call table entries still need to
be added (is there a standard way of doing this?), and documentation
will of course be necessary

A quick note about terminology: I use the term 'eventpoll entry' to refer
to a combination of an event mask, userspace identifier, and a file
descriptor. This in contrast to the past where an epoll event could mean
either an event mask or an item in the eventpoll itself. Hopefully this
will help avoid any confusion :)

Nate Yazdani
 fs/eventpoll.c                 | 508 +++++++++++++++++++++++++----------------
 include/linux/syscalls.h       |   4 +
 include/uapi/linux/eventpoll.h |   6 +
 3 files changed, 320 insertions(+), 198 deletions(-)
