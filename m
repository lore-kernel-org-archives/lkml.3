Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761386Ab3BLPVK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 10:21:10 -0500
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:38740 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758258Ab3BLPVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 10:21:08 -0500
Date: Tue, 12 Feb 2013 07:21:07 -0800 (PST)
From: Andy King <acking@vmware.com>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, gregkh@linuxfoundation.org,
        davem@davemloft.net, pv-drivers@vmware.com
Message-ID: <1675407061.963254.1360682467627.JavaMail.root@vmware.com>
In-Reply-To: <5118FEA9.2080201@redhat.com>
References: <1360196636-9357-1-git-send-email-acking@vmware.com> <1360196636-9357-2-git-send-email-acking@vmware.com> <5118FEA9.2080201@redhat.com>
Subject: Re: [PATCH 1/1] VSOCK: Introduce VM Sockets
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.113.163.68]
X-Mailer: Zimbra 8.0.2_GA_5569 (ZimbraWebClient - GC24 (Mac)/8.0.2_GA_5569)
Thread-Topic: VSOCK: Introduce VM Sockets
Thread-Index: fbcLzOd8oom6Dq4OLGpObN+q9DlUgw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gerd,

> > +struct vsock_transport {
...
> Whoa.  This has grown *alot*.  Care to explain this please?  Patch
> creating a Documentation/virtual/vsock.txt would be cool.

Yes, it grew because of the notification stuff, which I'd forgotten
about until I removed the vmci header from the core code.  You are
free to use empty functions for these if they don't make any sense
for virtio.  The alternative is for us to move the entire body of
vsock_stream_recv/send into the transport, where we can hide the
notification stuff, but it seems like folks will just end up
duplicating a lot of code then.

> stream_has_data + stream_has_space + stream_rcvhiwat look like they
> are needed for buffer management.  Details please (especially for
> stream_rcvhiwat).

stream_has_data: Returns amount of data available (in bytes) in the
socket's receive buffer, or -1 if empty.

stream_has_space: Returns amount of space available (in bytes) in the
socket's send buffer, or -1 if full.

stream_rcvhiwat: The upper bound on the socket's receive buffer.
Which technically is the same as the value returned by
get_buffer_size(), so perhaps we could substitute that here and
drop this one.

> What is stream_is_active?

For the VMCI transport, it indicates if the underlying queuepair is
still around (i.e., make sure we haven't torn it down while sleeping
in a blocking send or receive).  Perhaps it's not the best name?

> What is *_allow?

It's very basic filtering.  We have specific addresses that we don't
allow, and we look for them in the allow() functions.  You can just
return true if you like.

> What are all those notify_* calls?

They're to do with signaling and flow-control.  Again, they might
not make any sense at all, but it's hard to know without having
written another transport :)

> Why do you need vsock_transport_{send,recv}_notify_data structs?
> Can't this live in vsock_sock->trans?

Those have to be setup on a per-call basis (per-thread), so it's
just easier to have them on the stack of the send/recv calls.  If
you think there's a better name, or a better way to allocate them,
I'm all ears.

Thanks!
- Andy
