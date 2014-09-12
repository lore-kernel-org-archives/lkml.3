Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501AbaILQkr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 12:40:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52927 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbaILQkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 12:40:45 -0400
Date: Fri, 12 Sep 2014 09:40:45 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luciano Coelho <luca@coelho.fi>, Kalle Valo <kvalo@adurom.com>,
        dri-devel@lists.freedesktop.org, linux-wireless@vger.kernel.org
Subject: Re: [RFC v2] device coredump: add new device coredump class
Message-ID: <20140912164045.GA27663@kroah.com>
References: <1409907054-17596-1-git-send-email-johannes@sipsolutions.net>
 <20140905221314.GA1533@kroah.com>
 <1410165487.7983.8.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410165487.7983.8.camel@jlt4.sipsolutions.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2014 at 10:38:07AM +0200, Johannes Berg wrote:
> On Fri, 2014-09-05 at 15:13 -0700, Greg Kroah-Hartman wrote:
> 
> > > +	/*
> > > +	 * this seems racy, but I don't see a notifier or such on
> > > +	 * a struct device to know when it goes away?
> > > +	 */
> > > +	if (devcd->failing_dev->kobj.sd)
> > > +		sysfs_delete_link(&devcd->failing_dev->kobj, &dev->kobj,
> > > +				  "dev_coredump");
> > 
> > What is this link?  It should "just go away" if this:
> > 
> > > +	put_device(devcd->failing_dev);
> > 
> > was the last put_device() call on the failing_dev, right?  So you
> > shouldn't need to make this call to sysfs_delete_link().
> 
> I looked at this again, and it's the other way around. This is the link
> that Daniel requested, from the original device to the one that's being
> freed. For whatever reason though, symlinks don't automatically go away
> when freed:
> 
> (with a test patch that makes "mac80211-hwsim" crash whenever we have
> radar)
> 
> # echo 1 > /sys/kernel/debug/ieee80211/phy0/hwsim/dfs_simulate_radar
> # ls /sys/class/devcoredump/
> devcd1
> # ls /sys/class/devcoredump/devcd1/
> data            failing_device/ power/          subsystem/      uevent
> # ls -l /sys/class/mac80211_hwsim/hwsim0/dev_coredump
> lrwxrwxrwx 1 root root 0 Sep  8 08:34 /sys/class/mac80211_hwsim/hwsim0/dev_coredump -> ../../devcoredump/devcd1
> # echo > /sys/class/devcoredump/devcd1/data
> # ls /sys/class/devcoredump/
> # ls -l /sys/class/mac80211_hwsim/hwsim0/dev_coredump
> lrwxrwxrwx 1 root root 0 Sep  8 08:34 /sys/class/mac80211_hwsim/hwsim0/dev_coredump -> ../../devcoredump/devcd1
> 
> (but the link is now dead)
> 
> Maybe I'm creating the links in the wrong way so they don't
> automatically get removed when the struct device is released?

No, you are correct, sorry for the noise, I thought the symlink was the
other way around for some reason.

greg k-h
