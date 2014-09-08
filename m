Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479AbaIHIiS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 04:38:18 -0400
Received: from s3.sipsolutions.net ([5.9.151.49]:38419 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752962AbaIHIiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 04:38:16 -0400
Message-ID: <1410165487.7983.8.camel@jlt4.sipsolutions.net>
Subject: Re: [RFC v2] device coredump: add new device coredump class
From: Johannes Berg <johannes@sipsolutions.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luciano Coelho <luca@coelho.fi>, Kalle Valo <kvalo@adurom.com>,
        dri-devel@lists.freedesktop.org, linux-wireless@vger.kernel.org
Date: Mon, 08 Sep 2014 10:38:07 +0200
In-Reply-To: <20140905221314.GA1533@kroah.com>
References: <1409907054-17596-1-git-send-email-johannes@sipsolutions.net>
	 <20140905221314.GA1533@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-09-05 at 15:13 -0700, Greg Kroah-Hartman wrote:

> > +	/*
> > +	 * this seems racy, but I don't see a notifier or such on
> > +	 * a struct device to know when it goes away?
> > +	 */
> > +	if (devcd->failing_dev->kobj.sd)
> > +		sysfs_delete_link(&devcd->failing_dev->kobj, &dev->kobj,
> > +				  "dev_coredump");
> 
> What is this link?  It should "just go away" if this:
> 
> > +	put_device(devcd->failing_dev);
> 
> was the last put_device() call on the failing_dev, right?  So you
> shouldn't need to make this call to sysfs_delete_link().

I looked at this again, and it's the other way around. This is the link
that Daniel requested, from the original device to the one that's being
freed. For whatever reason though, symlinks don't automatically go away
when freed:

(with a test patch that makes "mac80211-hwsim" crash whenever we have
radar)

# echo 1 > /sys/kernel/debug/ieee80211/phy0/hwsim/dfs_simulate_radar
# ls /sys/class/devcoredump/
devcd1
# ls /sys/class/devcoredump/devcd1/
data            failing_device/ power/          subsystem/      uevent
# ls -l /sys/class/mac80211_hwsim/hwsim0/dev_coredump
lrwxrwxrwx 1 root root 0 Sep  8 08:34 /sys/class/mac80211_hwsim/hwsim0/dev_coredump -> ../../devcoredump/devcd1
# echo > /sys/class/devcoredump/devcd1/data
# ls /sys/class/devcoredump/
# ls -l /sys/class/mac80211_hwsim/hwsim0/dev_coredump
lrwxrwxrwx 1 root root 0 Sep  8 08:34 /sys/class/mac80211_hwsim/hwsim0/dev_coredump -> ../../devcoredump/devcd1

(but the link is now dead)

Maybe I'm creating the links in the wrong way so they don't
automatically get removed when the struct device is released?

johannes

