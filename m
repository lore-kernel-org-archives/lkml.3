Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752311Ab3CTNq0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 09:46:26 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:54606 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764Ab3CTNqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 09:46:25 -0400
Message-ID: <1363787179.3333.6.camel@edumazet-glaptop>
Subject: Re: [PATCH net-next 1/2] net_sched: don't do precise pkt_len
 computation for untrusted packets
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jason Wang <jasowang@redhat.com>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, mst@redhat.com, edumazet@google.com,
        Daniel Borkmann <dborkman@redhat.com>
Date: Wed, 20 Mar 2013 06:46:19 -0700
In-Reply-To: <514954F0.2040604@redhat.com>
References: <1363333305-54398-1-git-send-email-jasowang@redhat.com>
	  <20130317.121026.733329595817911776.davem@davemloft.net>
	  <51482F14.9030407@redhat.com> <1363695040.21184.32.camel@edumazet-glaptop>
	 <1363697906.21184.53.camel@edumazet-glaptop> <514954F0.2040604@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-20 at 14:19 +0800, Jason Wang wrote:

> I was consider a just skb_reset_transport_header() here. Consider the
> transport header maybe checked and reset during header check for packets
> of gso or partial checksum. And bypass precise pkt len computation.
> 
> Some problems with skb_flow_dissect():
> 
> - it can only recognizes a subset of all ethernet protocols. The may
> blocks guest who may want to use other protocol such as IPX.

Oh yes IPX 

> - almost no check in the validity of the L4 protocol header which may be
> used by qdisc_pkt_len_init(), which may still give a chance to evil
> guest to use
> - gso_segs were untouched (still zero)
> 
> Another method is doing header check here which needs more work.

Most uses are caught by the helper.

So in the case dissection fails, just reset transport header instead of
dropping as I suggested.

Otherwise, set the transport header to the right value

-> precise qdisc pkt lengths.

Instead of pretending DODGY packets have no headers, at least try to do
the right thing.



