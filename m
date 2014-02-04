Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751415AbaBDFvu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 00:51:50 -0500
Received: from SpacedOut.fries.net ([67.64.210.234]:34299 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbaBDFvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 00:51:41 -0500
Date: Mon, 3 Feb 2014 23:51:31 -0600
From: David Fries <david@fries.net>
To: "zbr@ioremap.net" <zbr@ioremap.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] w1: refcnt fix, skip non-error send, docs
Message-ID: <20140204055131.GI5342@spacedout.fries.net>
References: <1391390104-31154-1-git-send-email-David@Fries.net>
 <9071391471978@web15j.yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9071391471978@web15j.yandex.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.3.9 (SpacedOut.fries.net [127.0.0.1]); Mon, 03 Feb 2014 23:51:32 -0600 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 04, 2014 at 03:59:38AM +0400, zbr@ioremap.net wrote:
> Hi
> 
> 03.02.2014, 05:15, "David Fries" <David@Fries.net>:
> 
> >  I could submit these patches as in, which would require the previous
> >  set, or I could merge the documentation into the previous set and
> >  resubmit them all since they haven't made it into the kernel tree yet.
> >  Opinions?
> >
> >  Here's a small refcnt fix, skipping sending non-error messages, and
> >  documentation and comment updates.
> >
> >  non-error error messages:
> >  Currently every master or slave command is sending a response with
> >  w1_netlink_send_error no matter if there is an error or not.  This
> >  makes commands like list slaves W1_CMD_LIST_SLAVES or W1_CMD_READ
> >  return two messages, one with data and one without.  That is a problem
> >  with the list slaves because they are identical except for one having
> >  data and one not, and since there could be no slaves known to the
> >  kernel you can't just discard the no data case, unless the program
> >  were to expect two replies.  So I propose only sending the error reply
> >  if there is an error, in which case there wouldn't be a normal reply
> >  (such as read).  This would mean commands like write would no longer
> >  return a response unless there was an error.  If an application wanted
> >  to verify the kernel received the write message it could follow it by
> >  a read to verify the data or just that read came after write and had a
> >  response so write must have completed without error.  I think it is
> >  safe to do away with the extra replies.  If someone sees a big enough
> >  need for this, I could modify it so all commands return one response,
> >  with commands like write always calling send error even if there
> >  wasn't one.
> 
> I created this protocol to handle cases like nothing is returned, but yet userspace knows
> operations has been completed. Also, you can not really change it at this time - there are
> already userspace application which may depend on the last ack to find out its request completed.
> 
> Reference counter fix is correct, please submit it in the separate patch.

Help me understand what the protocol is supposed to be.  Assuming
there aren't any errors, is there supposed to be a
w1_netlink_send_error generated reply per netlink packet (cn_msg), per
w1_netlink_msg, or per w1_netlink_cmd?

What about the cn_msg seq and ack values?  I assume the kernel
response should carry the same seq number as the request, but what
should the ack be set to?

-- 
David Fries <david@fries.net>    PGP pub CB1EE8F0
http://fries.net/~david/
