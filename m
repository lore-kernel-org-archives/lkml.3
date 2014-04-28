Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193AbaD1Aj7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 20:39:59 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:56198 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbaD1Aj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 20:39:58 -0400
Message-ID: <1398645587.3046.19.camel@ThinkPad-T5421>
Subject: Re: [PATCH] USB: serial: fix sysfs-attribute removal deadlock
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: Johan Hovold <jhovold@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, rafael.j.wysocki@intel.com
Date: Mon, 28 Apr 2014 08:39:47 +0800
In-Reply-To: <20140425101501.GD2206@localhost>
References: <1398245539-1618-1-git-send-email-jhovold@gmail.com>
	 <20140423141908.GA4781@htj.dyndns.org>
	 <1398328155.2805.100.camel@ThinkPad-T5421.cn.ibm.com>
	 <20140424143517.GC14460@htj.dyndns.org> <20140424145206.GB2206@localhost>
	 <1398392217.2805.150.camel@ThinkPad-T5421.cn.ibm.com>
	 <20140425101501.GD2206@localhost>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042800-4966-0000-0000-000009347874
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-04-25 at 12:15 +0200, Johan Hovold wrote:
> On Fri, Apr 25, 2014 at 10:16:57AM +0800, Li Zhong wrote:
> > On Thu, 2014-04-24 at 16:52 +0200, Johan Hovold wrote:
> 
> > > No, this isn't self removal. The driver-attribute (not device-attribute)
> > > store operation simply grabs a lock that is also held while the driver
> > > is being deregistered at module unload. Taking a reference to the module
> > > in this case will prevent deregistration while store is running.
> > > 
> > > But it seems like this can be solved for usb-serial by simply not
> > > holding the lock while deregistering.
> > 
> > I didn't look carefully about this lock. 
> > 
> > But I'm not sure whether there are such requirements for driver
> > attributes:
> > 
> > some lock needs be grabbed in the driver attributes store callbacks, and
> > the same lock also needs to be grabbed during driver unregister. 
> > 
> > If we have such requirements currently or in the future, I think they
> > could all be solved by breaking active protection after get the module
> > reference.
> 
> Yes, if we find any such cases, but I don't think it should be done
> generally (as in one of your earlier posts).

OK, maybe we only need to reconsider this only if we see some more
similar lockdep warnings in the future. 

> 
> Active protection is usually exactly what prevents the driver from being
> deregistered, and would only need to be broken to avoid any ABBA
> deadlocks from being reported by lockdep (the module reference would be
> enough to prevent the actual deadlock).

Yes, maybe try to get the module reference is not bad before writing to
driver attributes, as it doesn't make much sense to really call the
callbacks for the driver attribute if the driver is being unload.

And after we get the reference, it is safe for us to break the active.
But if we don't have such real cases(lockdep warnings), we actually
don't need to break it. 

Thanks, Zhong

> 
> Thanks,
> Johan
> 


