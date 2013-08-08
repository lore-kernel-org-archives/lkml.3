Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933637Ab3HHGOd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 02:14:33 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:34184 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932632Ab3HHGOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 02:14:32 -0400
MIME-Version: 1.0
X-Originating-IP: [31.210.183.242]
In-Reply-To: <20130808055032.GA3898@neilslaptop.think-freely.org>
References: <1375866164-21933-1-git-send-email-alonid@postram.com>
	<20130808055032.GA3898@neilslaptop.think-freely.org>
Date: Thu, 8 Aug 2013 09:14:31 +0300
Message-ID: <CAOE7D0tj3suE8bnpd4ijL1zVLr83OB28KdRR7OOLkEnDOCM4_A@mail.gmail.com>
Subject: Re: [PATCH] netconsole: avoid a crash with multiple sysfs writers
From: Dan Aloni <alonid@postram.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 8, 2013 at 8:50 AM, Neil Horman <nhorman@tuxdriver.com> wrote:
>
> On Wed, Aug 07, 2013 at 12:02:44PM +0300, Dan Aloni wrote:
[..]
>
> > When my 'ifup eth' script was fired multiple times and ran concurrent o> @@ -682,7 +689,11 @@ restart:
> >                                * we might sleep in __netpoll_cleanup()
> >                                */
> >                               spin_unlock_irqrestore(&target_list_lock, flags);
> > +
> > +                             mutex_lock(&nt->mutex);
> >                               __netpoll_cleanup(&nt->np);
> > +                             mutex_unlock(&nt->mutex);
> > +
> NAK, you can't hold a mutex while calling __netpoll_cleanup.  __netpoll_cleanup
> may sleep and its illegal to hold a mutex while doing so.
> Neil
>

To my understanding, it mostly depends on locking order, and having
sleeplocks in the outer order and spinlocks in the inner order is
valid as long the locking order is not reversed.

Also, drivers/net/team/team.c - another netpoll user, already does the
same thing I intended in this patch - it locks the outer team->lock
mutex in team_uninit() while calling team_port_del() and then
team_port_disable_netpoll() calls __netpoll_cleanup().
