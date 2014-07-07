Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382AbaGGUef (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 16:34:35 -0400
Received: from mail-yh0-f73.google.com ([209.85.213.73]:47400 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbaGGUed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 16:34:33 -0400
Date: Mon, 7 Jul 2014 13:34:32 -0700
From: Loic Prylli <loicp@google.com>
To: Dan Aloni <dan@kernelim.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, timo.teras@iki.fi,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH] net: Fix NETDEV_CHANGE notifier usage causing spurious
 arp flush
Message-ID: <20140707203432.GB25441@google.com>
References: <1404275983-7908-1-git-send-email-loicp@google.com>
 <20140702070349.GA11943@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140702070349.GA11943@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2014 at 10:03:49AM +0300, Dan Aloni wrote:
> On Tue, Jul 01, 2014 at 09:39:43PM -0700, Loic Prylli wrote:
> > A bug was introduced in NETDEV_CHANGE notifier sequence causing the
> > arp table to be sometimes spuriously cleared (including manual arp
> > entries marked permanent), upon network link carrier changes.
> > 
> > The changed argument for the notifier was applied only to a single
> > caller of NETDEV_CHANGE, missing among others netdev_state_change().
> > So upon net_carrier events induced by the network, which are
> > triggering a call to netdev_state_change(), arp_netdev_event() would
> > decide whether to clear or not arp cache based on random/junk stack
> > values (a kind of read buffer overflow).
> [..]
> >  {
> >  	if (dev->flags & IFF_UP) {
> > -		call_netdevice_notifiers(NETDEV_CHANGE, dev);
> > +		struct netdev_notifier_change_info change_info;
> > +
> > +		change_info.flags_changed = 0;
> 
> I think it would be safer to do:
> 
>    struct netdev_notifier_change_info change_info = {};
> 
> So that when future fields are added to the struct and this call-site
> happens to be forgotten, they will get 0 by default rather than
> random stack values.

Thanks for the review. Will take into account suggestion. For the
record, another (possibly bigger) trap from the preexisting code that
remains (and caused the bug) is NETDEV_CHANGE being the only netdev
notifier with a different special calling sequence. Since calls to
NETDEV_CHANGE notifier have been reduced over time to the two
instances in net/core/dev.c, it hopefully won't be a problem (and
fixing that maintainability issue would be out-of-scope of this simple
low-risk bug fix).
