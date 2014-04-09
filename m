Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758037AbaDIDhb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 23:37:31 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:47834 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756572AbaDIDha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 23:37:30 -0400
From: David Fries <David@Fries.net>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 0/3] w1: fixes and bundling replies
Date: Tue,  8 Apr 2014 22:37:06 -0500
Message-Id: <1397014629-27478-1-git-send-email-David@Fries.net>
X-Mailer: git-send-email 1.7.10.4
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.3.9 (SpacedOut.fries.net [127.0.0.1]); Tue, 08 Apr 2014 22:37:26 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A program can bundle a sequence of commands in one netlink packet but
the kernel was having to reply in many different packets, this adds a
flag W1_CN_BUNDLE in the cn_msg.flags to allow the kernel to bundle
the replies in to one message.  This is opt in to avoid breaking
programs that aren't expecting additional messages.

Netlink connector now has a new call cn_netlink_send_multi, which
allow sending multiple cn_msg structures in a nlmsghdr structure.

I tested with my client program that will bundle up 14 temperature
sensor conversions, then after a delay, bundle up another set of
commands to read all 14 with the bundle bit set.  I also tested with a
two year old version of the software that sends requests two one slave
at a time (bundling only the write/read to get the data out), and
doesn't have code to read the bundling the this patch adds.  Both
operate correctly running at the same time.

 Documentation/connector/connector.txt |   15 +-
 Documentation/w1/w1.generic           |    2 +-
 Documentation/w1/w1.netlink           |   13 +-
 drivers/connector/connector.c         |   17 +-
 drivers/w1/w1.h                       |    8 -
 drivers/w1/w1_netlink.c               |  673 ++++++++++++++++++++-------------
 drivers/w1/w1_netlink.h               |   36 ++
 include/linux/connector.h             |    1 +
 8 files changed, 489 insertions(+), 276 deletions(-)

[PATCH 1/3] w1: fix netlink refcnt leak on error path
[PATCH 2/3] connector: allow multiple messages to be sent in one
[PATCH 3/3] w1: optional bundling of netlink kernel replies
