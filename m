Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761332Ab3EBSNQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 14:13:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40269 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760863Ab3EBSNP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 14:13:15 -0400
Message-ID: <1367518532.7757.14.camel@dcbw.foobar.com>
Subject: Re: [GIT] Networking
From: Dan Williams <dcbw@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: mirqus@gmail.com, torvalds@linux-foundation.org, hayeswang@realtek.com,
        akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 02 May 2013 13:15:32 -0500
In-Reply-To: <20130502.140648.1138582574178897490.davem@davemloft.net>
References: <20130502.133947.387694205526879673.davem@davemloft.net>
	 <CAHXqBF+Xb0ZVo2tO-0m59JJDrwy5vYX6=jLbts_ZAv5Pk+7SCw@mail.gmail.com>
	 <20130502.135542.1332946768988319212.davem@davemloft.net>
	 <20130502.140648.1138582574178897490.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-05-02 at 14:06 -0400, David Miller wrote:
> From: David Miller <davem@davemloft.net>
> Date: Thu, 02 May 2013 13:55:42 -0400 (EDT)
> 
> > From: Michał Mirosław <mirqus@gmail.com>
> > Date: Thu, 2 May 2013 19:47:25 +0200
> > 
> >> Are you sure it's "flags"? /sys/class/net/*/features were removed some
> >> time ago, and flags don't depend on NETIF_F_*.
> > 
> > Oh, it's flags, which is printed in raw hex by net/core/net-sysfs.c:
> > 
> > NETDEVICE_SHOW(flags, fmt_hex);
> 
> Oh you're right, I'm confusing netdev->flags with netdev->features, my bad.

Was just going to ask about that.  NM only cares about 'flags', not
features, at this point in time.  Relevant code for carrier notification
in NM, using libnl helpers:

	link_obj = (struct rtnl_link *) obj;
	flags = rtnl_link_get_flags (link_obj);
	ifidx = rtnl_link_get_ifindex (link_obj);

	nm_log_dbg (LOGD_HW, "netlink link message: iface idx %d flags 0x%X",
ifidx, flags);

	if (flags & IFF_LOWER_UP)
		g_signal_emit (self, signals[CARRIER_ON], 0, ifidx);
	else
		g_signal_emit (self, signals[CARRIER_OFF], 0, ifidx);

So it's got to be something else other than the netdev features ordering
that's screwing up for Linus.  I'm sure we'd have heard about it a long,
long time ago if something had messed up dev->flags bits...

Dan


