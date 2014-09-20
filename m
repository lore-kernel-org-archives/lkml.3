Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924AbaITUnB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 16:43:01 -0400
Received: from smtprelay2.synopsys.com ([198.182.60.111]:37034 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754934AbaITUm7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 16:42:59 -0400
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: Alan Stern <stern@rowland.harvard.edu>, Petr Mladek <pmladek@suse.cz>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>,
        Joe Lawrence <joe.lawrence@stratus.com>, Jiri Kosina <jkosina@suse.cz>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3 0/6] usb: hub: convert khubd into workqueue
Thread-Topic: [PATCH v3 0/6] usb: hub: convert khubd into workqueue
Thread-Index: AQHP1B9bcm7MVl0xDEOZ6DfHMQG8MZwJT8YAgAErtJA=
Date: Sat, 20 Sep 2014 20:41:21 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E0304844D9FFC@US01WEMBX2.internal.synopsys.com>
References: <1411140744-21424-1-git-send-email-pmladek@suse.cz>
 <Pine.LNX.4.44L0.1409191536000.1133-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1409191536000.1133-100000@iolanthe.rowland.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.9.64.241]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: linux-usb-owner@vger.kernel.org [mailto:linux-usb-owner@vger.kernel.org] On Behalf Of Alan Stern
> Sent: Friday, September 19, 2014 12:39 PM
> 
> On Fri, 19 Sep 2014, Petr Mladek wrote:
> 
> > The 3rd version of the patchset is slightly reordered and refactored
> > as suggested earlier. See below for more details.
> >
> > IMHO, the result is more clean. But feel free to ask me to revert it.
> > I do not want to make the review more complicated. Well, I double checked
> > the diff of patches files between v2 and v3. It is pretty small and only
> > the expected changes are there.
> >
> > Changes in:
> >     + v3:
> > 	+ split the optimization of hub->hdev reference counting
> > 	  into separate patch; usable standalone (1st patch)
> >
> > 	+ switch order of the two patches that convert the kthread
> > 	  and that remove the while cycle in hub_event(); it is
> > 	  cleaner (2nd and 3rd patch)
> >
> > 	+ use ordered workqueue by default; it makes it compatible
> > 	  with the original kthread solution (3rd patch)
> >
> >         + added optional patch that allows to process events
> > 	  in parallel (6th patch)
> >
> > 	+ fixed the suggested stylistic problems (2nd and 3rd patch)
> >
> >
> >     + v2:
> > 	+ solved potential races:
> > 	  	 + get hub->kref in kick_hub_wq()
> > 		 + call usb_get_dev(hdev) in hub_probe()
> > 		   and 	usb_put_dev(hdev) in hub_release()
> > 		 + INIT_WORK only once in hub_probe()
> >
> > 	 + do not call cancel_work_sync() in hub_disconnect()
> > 	   to keep it fast
> >
> > 	 + rename kick_khubd() to kick_hub_wq() already
> > 	   in the first patch; IMHO, it is cleaner while
> > 	   adding only very few changes
> >
> >
> > The workqueue API is well defined and tested. It has many options
> > that could be used to tune the scheduling. The code is usually
> > easier and thus more safe. It allows to avoid the extra thread
> > in most cases. It has has clearly defined behavior vrt. system suspend.
> >
> > This patchset converts khubd into the workqueue. It saves one thread,
> > lock, and list.
> >
> > It  looks huge but the main change is in the first patch. The rest is
> > simple renaming of functions, comments and documentation.
> >
> >
> > Thanks a lot Alan Stern and Tejun Heo for hints and guidance.
> >
> > The patches can be applied either against Linus' tree or linux-next.
> 
> Very nice work.  I haven't tried it out, but it all looks good.  No
> doubt we will be able to sort out unforeseen troubles if any arise,
> without much difficulty.

Hmm. What are the odds that some old kernel monitoring program, in an
ancient Fedora distribution let's say, will be checking for 'khubd' in
the kernel process list? Pretty high I would think.

I guess we'll find out once this hits mainline ;)

-- 
Paul

