Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760323Ab3B0Qei (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 11:34:38 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:48612 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754751Ab3B0QeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 11:34:25 -0500
Date: Wed, 27 Feb 2013 08:34:19 -0800
From: Jeff Layton <jlayton@samba.org>
To: "Stefan (metze) Metzmacher" <metze@samba.org>
Cc: Dave Chiluk <chiluk@canonical.com>, Steve French <sfrench@samba.org>,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] CIFS: Decrease reconnection delay when switching nics
Message-ID: <20130227083419.0af9deaf@corrin.poochiereds.net>
In-Reply-To: <512DE8A6.9030000@samba.org>
References: <1361831310-24260-1-git-send-email-chiluk@canonical.com>
	<512DE8A6.9030000@samba.org>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.13; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Feb 2013 12:06:14 +0100
"Stefan (metze) Metzmacher" <metze@samba.org> wrote:

> Hi Dave,
> 
> > When messages are currently in queue awaiting a response, decrease amount of
> > time before attempting cifs_reconnect to SMB_MAX_RTT = 10 seconds. The current
> > wait time before attempting to reconnect is currently 2*SMB_ECHO_INTERVAL(120
> > seconds) since the last response was recieved.  This does not take into account
> > the fact that messages waiting for a response should be serviced within a
> > reasonable round trip time.
> 
> Wouldn't that mean that the client will disconnect a good connection,
> if the server doesn't response within 10 seconds?
> Reads and Writes can take longer than 10 seconds...
> 

Where does this magic value of 10s come from? Note that a slow server
can take *minutes* to respond to writes that are long past the EOF.

> > This fixes the issue where user moves from wired to wireless or vice versa
> > causing the mount to hang for 120 seconds, when it could reconnect considerably
> > faster.  After this fix it will take SMB_MAX_RTT (10 seconds) from the last
> > time the user attempted to access the volume or SMB_MAX_RTT after the last
> > echo.  The worst case of the latter scenario being
> > 2*SMB_ECHO_INTERVAL+SMB_MAX_RTT+small scheduling delay (about 130 seconds).
> > Statistically speaking it would normally reconnect sooner.  However in the best
> > case where the user changes nics, and immediately tries to access the cifs
> > share it will take SMB_MAX_RTT=10 seconds.
> 
> I think it would be better to detect the broken connection
> by using an AF_NETLINK socket listening for RTM_DELADDR
> messages?
> 
> metze
> 

Ick -- that sounds horrid ;)

Dave, this problem sounds very similar to the one that your colleague
Chris J Arges was trying to solve several months ago. You may want to
go back and review that thread. Perhaps you can solve both problems at
the same time here...

-- 
Jeff Layton <jlayton@samba.org>
