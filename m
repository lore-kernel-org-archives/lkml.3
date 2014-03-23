Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105AbaCWB2J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 21:28:09 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:53166 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbaCWB2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 21:28:07 -0400
From: David Fries <David@Fries.net>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <zbr@ioremap.net>
Subject: [RFC] w1: fixes and bundling replies
Date: Sat, 22 Mar 2014 20:27:44 -0500
Message-Id: <1395538067-4029-1-git-send-email-David@Fries.net>
X-Mailer: git-send-email 1.7.10.4
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.3.9 (SpacedOut.fries.net [127.0.0.1]); Sat, 22 Mar 2014 20:27:59 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 01:07:28AM +0400, Evgeniy Polyakov wrote:
> Your approach and patch seem correct, but I worry about how old
> commands are processed.  Do I get it right, that replies to old
> non-bundle commands are queued back instead of sending immediately,
> but since it is not bundle but single command, queued reply is being
> sent 'almost' immediately?  Basically, nothing changed to old
> clients, but there is new way to send batch requests now?

Yes, with the previous patch set, if a client sent one command per
message they would get the replies in individual packets.  However in
some cases clients had to bundle multiple commands in one message.
For instance when using a slave command to read a temperature sensor
it takes one W1_CMD_WRITE command to send a W1_READ_SCRATCHPAD, then
another W1_CMD_READ command to read the data back and they have to be
sent in the same W1_SLAVE_CMD because there can't be a reset between
the two write and read, and you can't do that with a slave command.
You can with master commands, but if you are going to issue individual
reset, write, and read commands why would you not bundle them?

Here is a new set of patches making bundling opt in.

In this version of the patch, W1_CN_BUNDLE set in the cn_msg.flags
enables the kernel to bundle the reply, otherwise replies aren't
bundled.

The previous patch separated the data replies and status replies
because they have a different ack value which is in the cn_msg and
cn_netlink_send could only send one cn_msg in a call.  I didn't much
like that solution because now status and data replies were out of
order.  This version creates cn_netlink_send_mult which takes a length
which allows multiple cn_msg structures to be sent at once (inside one
nlmsghdr, so clients can see there are more cn_msg structures to
read), so now status and data messages can be sent in order.

This is somewhat suboptimal as each command has a status reply and
possibly a data reply, each requiring a different ack, so even if a
client sent multiple commands in one w1_netlink_msg like,

cn_msg [ack  ], w1_netlink_msg, w1_netlink_cmd [read], w1_netlink_cmd [read]

the response can't pack the commands into one w1_netlink_msg because
of the ack, so there's duplicate of cn_msg and w1_netlink_msg
structures,

cn_msg [seq+1], w1_netlink_msg, w1_netlink_cmd [data]
cn_msg [ack  ], w1_netlink_msg, w1_netlink_cmd [status]
cn_msg [seq+1], w1_netlink_msg, w1_netlink_cmd [data]
cn_msg [ack  ], w1_netlink_msg, w1_netlink_cmd [status]

cn_msg is 20 bytes, w1_netlink_msg 12, so compared to sending separate
packets with all the context switches, select overhead and such,
bundling is going to be well worth it.

Another alternative could be one cn_msg [seq+1] with the data, and
followed by cn_msg [ack ] with the status messages, but they are back
to out of order.

I wasn't completely sure what to call the new sending function, I
decided on mult for multiple cn_netlink_send_mult, cn_netlink_send_len
as another idea, or if there are any better ideas let me know.

I tested with my client program that will bundle up 14 temperature
sensor conversions, then after a delay, bundle up another set of
commands to read all 14 with the bundle bit set.  I also tested with a
two year old version of the software that sends requests two one slave
at a time (bundling only the write/read to get the data out), and
doesn't have code to read the bundling the this patch adds.  Both
operate correctly running at the same time.

Posted before, no changes

connector support for sending multiple cn_msg

bundling,
corrects ack value to previous ack or seq + 1
corrects the variables to be name consistently

 Documentation/connector/connector.txt |   15 +-
 Documentation/w1/w1.generic           |    2 +-
 Documentation/w1/w1.netlink           |   13 +-
 drivers/connector/connector.c         |   17 +-
 drivers/w1/w1.h                       |    8 -
 drivers/w1/w1_netlink.c               |  673 ++++++++++++++++++++-------------
 drivers/w1/w1_netlink.h               |   36 ++
 include/linux/connector.h             |    1 +
 8 files changed, 489 insertions(+), 276 deletions(-)
