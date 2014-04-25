Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771AbaDYKPg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 06:15:36 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:55309 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636AbaDYKPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 06:15:30 -0400
Date: Fri, 25 Apr 2014 12:15:01 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Johan Hovold <jhovold@gmail.com>, Tejun Heo <tj@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, rafael.j.wysocki@intel.com
Subject: Re: [PATCH] USB: serial: fix sysfs-attribute removal deadlock
Message-ID: <20140425101501.GD2206@localhost>
References: <1398245539-1618-1-git-send-email-jhovold@gmail.com>
 <20140423141908.GA4781@htj.dyndns.org>
 <1398328155.2805.100.camel@ThinkPad-T5421.cn.ibm.com>
 <20140424143517.GC14460@htj.dyndns.org>
 <20140424145206.GB2206@localhost>
 <1398392217.2805.150.camel@ThinkPad-T5421.cn.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398392217.2805.150.camel@ThinkPad-T5421.cn.ibm.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 10:16:57AM +0800, Li Zhong wrote:
> On Thu, 2014-04-24 at 16:52 +0200, Johan Hovold wrote:

> > No, this isn't self removal. The driver-attribute (not device-attribute)
> > store operation simply grabs a lock that is also held while the driver
> > is being deregistered at module unload. Taking a reference to the module
> > in this case will prevent deregistration while store is running.
> > 
> > But it seems like this can be solved for usb-serial by simply not
> > holding the lock while deregistering.
> 
> I didn't look carefully about this lock. 
> 
> But I'm not sure whether there are such requirements for driver
> attributes:
> 
> some lock needs be grabbed in the driver attributes store callbacks, and
> the same lock also needs to be grabbed during driver unregister. 
> 
> If we have such requirements currently or in the future, I think they
> could all be solved by breaking active protection after get the module
> reference.

Yes, if we find any such cases, but I don't think it should be done
generally (as in one of your earlier posts).

Active protection is usually exactly what prevents the driver from being
deregistered, and would only need to be broken to avoid any ABBA
deadlocks from being reported by lockdep (the module reference would be
enough to prevent the actual deadlock).

Thanks,
Johan
