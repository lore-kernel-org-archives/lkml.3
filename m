Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695AbaBCBPS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 20:15:18 -0500
Received: from SpacedOut.fries.net ([67.64.210.234]:58488 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbaBCBPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 20:15:16 -0500
From: David Fries <David@Fries.net>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <zbr@ioremap.net>
Subject: [PATCH 0/4] w1: refcnt fix, skip non-error send, docs
Date: Sun,  2 Feb 2014 19:14:59 -0600
Message-Id: <1391390104-31154-1-git-send-email-David@Fries.net>
X-Mailer: git-send-email 1.7.10.4
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.3.9 (SpacedOut.fries.net [127.0.0.1]); Sun, 02 Feb 2014 19:15:07 -0600 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I could submit these patches as in, which would require the previous
set, or I could merge the documentation into the previous set and
resubmit them all since they haven't made it into the kernel tree yet.
Opinions?

Here's a small refcnt fix, skipping sending non-error messages, and
documentation and comment updates.

non-error error messages:
Currently every master or slave command is sending a response with
w1_netlink_send_error no matter if there is an error or not.  This
makes commands like list slaves W1_CMD_LIST_SLAVES or W1_CMD_READ
return two messages, one with data and one without.  That is a problem
with the list slaves because they are identical except for one having
data and one not, and since there could be no slaves known to the
kernel you can't just discard the no data case, unless the program
were to expect two replies.  So I propose only sending the error reply
if there is an error, in which case there wouldn't be a normal reply
(such as read).  This would mean commands like write would no longer
return a response unless there was an error.  If an application wanted
to verify the kernel received the write message it could follow it by
a read to verify the data or just that read came after write and had a
response so write must have completed without error.  I think it is
safe to do away with the extra replies.  If someone sees a big enough
need for this, I could modify it so all commands return one response,
with commands like write always calling send error even if there
wasn't one.

It seems the way I read Documentation/connector/connector.txt not all
requests (from user space), must have a reply, and it does say
delivery isn't guaranteed as memory pressure can discard them, so I
think it's safe to drop the no error sending.

refcnt:
hub 7-0:1.0: port 2 disabled by hub (EMI?), re-enabling...
which is where the ds2490 was attached, which it would normally
recover just fine, except this time the kernel just printed,
w1_master_driver w1_bus_master1: Waiting for w1_bus_master1 to become free: refcnt=2.
and I had to reboot.  It hasn't been reproduced by removing and
replugging the ds2490.  In digging through the code I did find a
refcnt leak that could cause the problem.  I verified it leaked a
refcnt by modifying my program to send a command without data, and
verified it is fixed after.  I wouldn't have thought my program would
have sent an incomplete request, so I don't know what actually caused
the original refcnt problem, so it may still be there.

