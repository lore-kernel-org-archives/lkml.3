Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826AbaLOH7k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 02:59:40 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:61116 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbaLOH7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 02:59:32 -0500
Date: Sun, 14 Dec 2014 23:59:19 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: KY Srinivasan <kys@microsoft.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "mcb30@ipxe.org" <mcb30@ipxe.org>
Subject: Re: [PATCH V3 1/1] Drivers: hv: vmbus: Fix a bug in
 vmbus_establish_gpadl()
Message-ID: <20141215075919.GA12088@newt.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	KY Srinivasan <kys@microsoft.com>,
	"gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"olaf@aepfle.de" <olaf@aepfle.de>,
	"apw@canonical.com" <apw@canonical.com>,
	"jasowang@redhat.com" <jasowang@redhat.com>,
	"mcb30@ipxe.org" <mcb30@ipxe.org>
References: <1418260380-8774-1-git-send-email-kys@microsoft.com>
 <20141211021019.GA5648@hudson.localdomain>
 <BY2PR0301MB0711EC29782DB872564AB81AA06F0@BY2PR0301MB0711.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BY2PR0301MB0711EC29782DB872564AB81AA06F0@BY2PR0301MB0711.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KY Srinivasan,

On Mon, Dec 15, 2014 at 07:00:45AM +0000, KY Srinivasan wrote:
> 
> 
> > -----Original Message-----
> > From: Jeremiah Mahler [mailto:jmmahler@gmail.com]
> > Sent: Wednesday, December 10, 2014 6:10 PM
> > To: KY Srinivasan
> > Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> > devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> > jasowang@redhat.com; mcb30@ipxe.org
> > Subject: Re: [PATCH V3 1/1] Drivers: hv: vmbus: Fix a bug in
> > vmbus_establish_gpadl()
> > 
> > K. Y. Srinivasan,
> > 
> > On Wed, Dec 10, 2014 at 05:13:00PM -0800, K. Y. Srinivasan wrote:
> > > Correctly compute the local (gpadl) handle.
> > 
> > This description is still too sparse for me.  How was it computed before and
> > why was this incorrect?  Pretend like you are trying to explain your patch to
> > someone who has no idea what you did.
> > 
> > > I would like to thank Michael Brown <mcb30@ipxe.org> for seeing this bug.
> > >
> > > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > > Reported-by: Michael Brown <mcb30@ipxe.org>
> > > ---
> > > Changes in V2: Added the Reported-by tag.
> > > Changes in V3: Cleaned up the commit log.
> > >
> > >  drivers/hv/channel.c |    4 ++--
> > >  1 files changed, 2 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c index
> > > 433f72a..c76ffbe 100644
> > > --- a/drivers/hv/channel.c
> > > +++ b/drivers/hv/channel.c
> > > @@ -366,8 +366,8 @@ int vmbus_establish_gpadl(struct vmbus_channel
> > *channel, void *kbuffer,
> > >  	unsigned long flags;
> > >  	int ret = 0;
> > >
> > > -	next_gpadl_handle =
> > atomic_read(&vmbus_connection.next_gpadl_handle);
> > > -	atomic_inc(&vmbus_connection.next_gpadl_handle);
> > > +	next_gpadl_handle =
> > > +
> > 	(atomic_inc_return(&vmbus_connection.next_gpadl_handle) - 1);
> > >
> > Tell me if I understand this correctly.
> > 
> > Before it read the handle and incremented it.
> > 
> >   y = x + 1
> > 
> > Now it reads the handle, increments it, then decrements it.
> > 
> >   y = (x + 1) - 1 = x
> 
> This code can be executed concurrently on multiple CPUs. We want to ensure that each call to
> establish gpadl gets a unique local handle. The earlier code was buggy in that we would read the
> handle and then atomically increment it. Thus, multiple CPUs could read the identical current
> value which would be their local handle. What we want is the ability to atomically read and increment
> the value - this would ensure that each caller got a unique value even if they executed the code
> concurrently on multiple CPUs. The API atomic_inc_return(), atomically increments and returns the
> incremented value. We locally decrement this value to emulate the logic of "read the current value and
> atomically increment the value.
> 
> Hope this helps,
> 
> K. Y
> > 
[...]

So to avoid concurrency issues you used a single atomic operation
instead of two separate operations.  That make sense.  But it still
doesn't explain why you changed the calculation by subtracting 1.

-- 
- Jeremiah Mahler
