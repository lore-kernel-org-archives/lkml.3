Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500Ab3BNDUZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 22:20:25 -0500
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:49321 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752494Ab3BNDUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 22:20:24 -0500
Date: Wed, 13 Feb 2013 19:20:23 -0800 (PST)
From: Andy King <acking@vmware.com>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, gregkh@linuxfoundation.org,
        davem@davemloft.net, pv-drivers@vmware.com
Message-ID: <1218897172.1425846.1360812023655.JavaMail.root@vmware.com>
In-Reply-To: <511B739C.8000204@redhat.com>
References: <1360196636-9357-1-git-send-email-acking@vmware.com> <1360196636-9357-2-git-send-email-acking@vmware.com> <5118FEA9.2080201@redhat.com> <1675407061.963254.1360682467627.JavaMail.root@vmware.com> <511B739C.8000204@redhat.com>
Subject: Re: [PATCH 1/1] VSOCK: Introduce VM Sockets
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.113.163.67]
X-Mailer: Zimbra 8.0.2_GA_5569 (ZimbraWebClient - GC24 (Mac)/8.0.2_GA_5569)
Thread-Topic: VSOCK: Introduce VM Sockets
Thread-Index: fUWBBDbv1Iis0SfN8OI6z8QSZHGVHA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I've seen you have a notify_ops in the vmci bits.  Do you have different
> notify ops depending on socket type or something?  Does it make sense to
> move the notify ops ptr into "struct vsock_sock" maybe?

The notify stuff only applies to STREAMs.  However, we have two different
notify impls, one for legacy ESX and one for newer, and we figure out at
runtime which protocol we're using with the hypervisor and set the
callbacks appropriately.  The difference between the two is that the
newer one is much smarter and knows not to signal (the peer) quite so much,
i.e., it has some basic but sensible flow-control, which improves
performance quite a bit.  Again, that might not make any sense at all
for virtio.  Do you need to signal when you enqueue to a ring?  And is
there coalescing?  Dunno...

> And can we make it optional please (i.e. allow the function pointers to
> be NULL)?

They were originally allowed to be NULL, but I changed it in the last
round of patches while moving them into the transport, since I disliked
the NULL checks so much.  I can put them back, but that's a bigger
change, and I'm not sure we want to push large patches to Dave right
now :)

> Which problem you are trying to tackle with the notifications?

It's to do with signaling the peer, or more appropriately, trying to
avoid signaling the peer when possible.  The naive impl. is to signal
every time we enqueue or dequeue data (into our VMCI queuepairs).
But signaling is slow, since it involves a world exit, so we prefer
not to.  Which means we need to keep track of rate of flow and figure
out when we should and should not, and that's what all the notification
stuff does.  It's...ugly...

> > For the VMCI transport, it indicates if the underlying queuepair is
> > still around (i.e., make sure we haven't torn it down while sleeping
> > in a blocking send or receive).  Perhaps it's not the best name?
> 
> How you'd hit that?  Peer closing the socket while sleeping?  Other
> thread closing the socket wile sleeping?  Both?
> 
> I think a state field in struct vsock_sock would be a better solution here.

Hrm, lemme think about this one.

> 
> >> What is *_allow?
> > 
> > It's very basic filtering.  We have specific addresses that we don't
> > allow, and we look for them in the allow() functions.  You can just
> > return true if you like.
> 
> Can we make those calls optional too please?

Sure.

> The notify_*_init could return a opaque pointer instead.  But then
> you'll need a notify_*_free too.  And you can't place it on the stack
> and thus have a allocation in the hot path, which I guess you are trying
> to avoid in the first place.

Avoiding allocation is good, but at the same time, I wonder if it's not
a big deal compared with the time spent copying out of the buffers, in
which case it won't matter.  So maybe we can do this.

Thanks!
- Andy
