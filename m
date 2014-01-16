Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752425AbaAPE3t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 23:29:49 -0500
Received: from SpacedOut.fries.net ([67.64.210.234]:45746 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855AbaAPE3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 23:29:46 -0500
From: David Fries <David@Fries.net>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <zbr@ioremap.net>, GregKH <greg@kroah.com>
Subject: [PATCH 00/14] w1: async netlink, search, fixes, and improvements
Date: Wed, 15 Jan 2014 22:29:11 -0600
Message-Id: <1389846566-28862-1-git-send-email-David@Fries.net>
X-Mailer: git-send-email 1.7.10.4
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.3.9 (SpacedOut.fries.net [127.0.0.1]); Wed, 15 Jan 2014 22:29:36 -0600 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series aims to extend and improve the netlink interface to
the one wire system.  Netlink is exposed as a socket interface which
is normally assumed to be asynchronous which only blocks waiting on
incoming packets or a fulls end buffer, but were executed on the
calling thread.  A bus device search can be a lengthy operation and
temperature conversion can take 750 ms.  With this patch series those
lengthy operations are now processed on the thread originally created
to do automatic searching, which gives it a reason to exist when
automatic search is disabled.  Some other improvements for netlink is
additional commands to add, remove, and list the known slaves, and
send replies only to the requester.  They were previously multicast to
everyone listening on the group, this required an additional argument
to cn_netlink_send.  This also takes the bus_mutex for netlink and
search for masters that didn't already do so.

Search improvements include returning all devices found, as the first
that wouldn't fit in a packet would be lost.  I marked only this patch
for the stable tree, though you would have to have a lot of devices on
one bus to hit it.  I had a fix to support aborting from netlink
rather than just avoiding the oops as the previous patch did.
The search can now pick up where it left off, along with setting the
maximum number of slaves to search for at a time, a large network
could split up the search operation into multiple passes.  ds2490 USB
dongle now gains support for hardware search and along with not
undoing the interface selection operation takes the search for my
network from 23.16 seconds to .307346 seconds.

The largest single change is to change the comment style for DocBook
to process in addition to comment some additional functions and
data structures.

