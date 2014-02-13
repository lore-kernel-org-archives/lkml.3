Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891AbaBMBgx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 20:36:53 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54109 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644AbaBMBgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 20:36:52 -0500
Date: Wed, 12 Feb 2014 17:39:02 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: David Miller <davem@davemloft.net>
Cc: mst@redhat.com, linux-kernel@vger.kernel.org, jasowang@redhat.com,
        virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        qinchuanyu@huawei.com, joern@logfs.org, anatol.pomozov@gmail.com,
        nab@linux-iscsi.org
Subject: Re: [PATCH net 1/3] kref: add kref_sub_return
Message-ID: <20140213013902.GA21261@kroah.com>
References: <1392222846-26699-1-git-send-email-mst@redhat.com>
 <1392222846-26699-2-git-send-email-mst@redhat.com>
 <20140212165630.GA22991@kroah.com>
 <20140212.190637.328045386111912135.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140212.190637.328045386111912135.davem@davemloft.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 07:06:37PM -0500, David Miller wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Date: Wed, 12 Feb 2014 08:56:30 -0800
> 
> > On Wed, Feb 12, 2014 at 06:38:21PM +0200, Michael S. Tsirkin wrote:
> >> It is sometimes useful to get the value of the reference count after
> >> decrement.
> >> For example, vhost wants to execute some periodic cleanup operations
> >> once number of references drops below a specific value, before it
> >> reaches zero (for efficiency).
> > 
> > You should never care about what the value of the kref is, if you are
> > using it correctly :)
> 
> It isn't being used to determine when to destroy things.
> 
> They use it to as a heuristic of when to trigger polling.
> 
> Each ubuf attached gets a kref to the higher level virtio_net buffer
> holding object, they want to trigger polling when that reference drops
> to 1 or lower.
> 
> Right now they are reading the atomic refcount directly, which
> I think is much worse than this helper.

Yes, that's horrible as well, but as was already pointed out in this
thread, you can't rely on that value to really be "1" after reading it
due to the way krefs work, what happened if someone else just grabbed
it?

If all they want is a "count" for when to start polling, then use a
separate atomic count, but don't abuse the kref interface for this, I
don't think that will work properly at all.

thanks,

greg k-h
