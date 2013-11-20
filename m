Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672Ab3KTI5D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 03:57:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29753 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855Ab3KTI5B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 03:57:01 -0500
Date: Wed, 20 Nov 2013 11:00:09 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Michael Dalton <mwdalton@google.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Jason Wang <jasowang@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        lf-virt <virtualization@lists.linux-foundation.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net] virtio-net: fix page refcnt leaking when fail to
 allocate frag skb
Message-ID: <20131120090009.GC19341@redhat.com>
References: <1384848307-7217-1-git-send-email-jasowang@redhat.com>
 <1384869828.8604.97.camel@edumazet-glaptop2.roam.corp.google.com>
 <20131119204909.GA15004@redhat.com>
 <1384896996.8604.120.camel@edumazet-glaptop2.roam.corp.google.com>
 <20131119215312.GE15004@redhat.com>
 <1384898411.8604.127.camel@edumazet-glaptop2.roam.corp.google.com>
 <CANJ5vP+ZxtDf8OzREpyDpgh8JLnWGEjkUcS388hi+AOjdu0fZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANJ5vP+ZxtDf8OzREpyDpgh8JLnWGEjkUcS388hi+AOjdu0fZw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 05:34:16PM -0800, Michael Dalton wrote:
> Hi,
> 
> After further reflection I think we're looking at two related issues:
> (a) a memory leak that Jason has identified that occurs when a memory
> allocation fails in receive_mergeable. Jasons commit solves this issue.
> (b) virtio-net does not dequeue all buffers for a packet in the
> case that an error occurs on receive and mergeable receive buffers is
> enabled.
> 
> For (a), this bug is new and due to changes in 2613af0ed18a, and the
> net impact is memory leak on the physical page. However, I believe (b)
> has always been possible in some form because if page_to_skb() returns
> NULL (e.g., due to SKB allocation failure), receive_mergeable is never
> called. AFAICT this is also the behavior prior to 2613af0ed18a.
> 
> The net impact of (b) would be that virtio-net would interpret a packet
> buffer that is in the middle of a mergeable packet as the start of a
> new packet, which is definitely also a bug (and the buffer contents
> could contain bytes that resembled a valid virtio-net header).
> 
> A solution for (b) will require handling both the page_to_skb memory
> allocation failures and the memory allocation failures in
> receive_mergeable introduced by 2613af0ed18a.
> 
> Best,
> 
> Mike


Absolutely. I missed this fact yesterday night but I can see it clearly
in the morning.

