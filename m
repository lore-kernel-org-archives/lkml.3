Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175AbaBNACE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 19:02:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:37574 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbaBNACC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 19:02:02 -0500
Date: Thu, 13 Feb 2014 16:03:20 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: David Miller <davem@davemloft.net>
Cc: mst@redhat.com, linux-kernel@vger.kernel.org, jasowang@redhat.com,
        virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        qinchuanyu@huawei.com, joern@logfs.org, anatol.pomozov@gmail.com,
        nab@linux-iscsi.org
Subject: Re: [PATCH net 1/3] kref: add kref_sub_return
Message-ID: <20140214000320.GC15564@kroah.com>
References: <20140212.190637.328045386111912135.davem@davemloft.net>
 <20140213013902.GA21261@kroah.com>
 <20140212.230506.1305102368255894549.davem@davemloft.net>
 <20140212.230953.770721407102955395.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140212.230953.770721407102955395.davem@davemloft.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 11:09:53PM -0500, David Miller wrote:
> From: David Miller <davem@davemloft.net>
> Date: Wed, 12 Feb 2014 23:05:06 -0500 (EST)
> 
> > From: Greg KH <gregkh@linuxfoundation.org>
> > Date: Wed, 12 Feb 2014 17:39:02 -0800
> > 
> >> Yes, that's horrible as well, but as was already pointed out in this
> >> thread, you can't rely on that value to really be "1" after reading it
> >> due to the way krefs work, what happened if someone else just grabbed
> >> it?
> >> 
> >> If all they want is a "count" for when to start polling, then use a
> >> separate atomic count, but don't abuse the kref interface for this, I
> >> don't think that will work properly at all.
> > 
> > They want to know which thread of control decrements the count to "1"
> > as buffers are released.
> > 
> > That seems entirely reasonable to me.
> > 
> > They could add another atomic counter for this, but that's rather
> > silly since the kref already has an atomic they can use for this
> > purpose.
> 
> If you still can't understand what they are trying to do, they want to
> do something precisely when the number of pending buffers is dropped
> to 1 or less.
> 
> They are using krefs to track how many buffers are attached at a given
> moment.
> 
> The counter can re-increment after the decrement to 1 or less occurs,
> they don't care.
> 
> But they want precisely the entity that drops it down to 1 or less to
> perform that action.
> 
> Just reading the atomic value directly, they cannot do this.

That makes sense, but is still totally crazy for what a kref was
designed to do.  I'm really wary of giving access to the count of the
kref like this as it will almost always be abused (it's been asked for
before, but not like this.)

So how about just "open coding" a kref for this structure, as it wants
something that doesn't fit into the kref model, and should be pretty
simple to do (you can ensure you get the locking right, unlike almost
all users of krefs, as Al Viro constantly points out to me...)

thanks,

greg k-h
