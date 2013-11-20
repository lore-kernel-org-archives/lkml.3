Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665Ab3KTBej (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 20:34:39 -0500
Received: from mail-oa0-f43.google.com ([209.85.219.43]:51937 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364Ab3KTBeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 20:34:37 -0500
MIME-Version: 1.0
In-Reply-To: <1384898411.8604.127.camel@edumazet-glaptop2.roam.corp.google.com>
References: <1384848307-7217-1-git-send-email-jasowang@redhat.com>
 <1384869828.8604.97.camel@edumazet-glaptop2.roam.corp.google.com>
 <20131119204909.GA15004@redhat.com> <1384896996.8604.120.camel@edumazet-glaptop2.roam.corp.google.com>
 <20131119215312.GE15004@redhat.com> <1384898411.8604.127.camel@edumazet-glaptop2.roam.corp.google.com>
From: Michael Dalton <mwdalton@google.com>
Date: Tue, 19 Nov 2013 17:34:16 -0800
Message-ID: <CANJ5vP+ZxtDf8OzREpyDpgh8JLnWGEjkUcS388hi+AOjdu0fZw@mail.gmail.com>
Subject: Re: [PATCH net] virtio-net: fix page refcnt leaking when fail to
 allocate frag skb
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        lf-virt <virtualization@lists.linux-foundation.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

After further reflection I think we're looking at two related issues:
(a) a memory leak that Jason has identified that occurs when a memory
allocation fails in receive_mergeable. Jasons commit solves this issue.
(b) virtio-net does not dequeue all buffers for a packet in the
case that an error occurs on receive and mergeable receive buffers is
enabled.

For (a), this bug is new and due to changes in 2613af0ed18a, and the
net impact is memory leak on the physical page. However, I believe (b)
has always been possible in some form because if page_to_skb() returns
NULL (e.g., due to SKB allocation failure), receive_mergeable is never
called. AFAICT this is also the behavior prior to 2613af0ed18a.

The net impact of (b) would be that virtio-net would interpret a packet
buffer that is in the middle of a mergeable packet as the start of a
new packet, which is definitely also a bug (and the buffer contents
could contain bytes that resembled a valid virtio-net header).

A solution for (b) will require handling both the page_to_skb memory
allocation failures and the memory allocation failures in
receive_mergeable introduced by 2613af0ed18a.

Best,

Mike
