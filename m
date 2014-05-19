Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932148AbaESOB1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 10:01:27 -0400
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:46150 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754479AbaESOBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 10:01:25 -0400
Date: Mon, 19 May 2014 16:01:19 +0200
From: Florian Westphal <fw@strlen.de>
To: David Newall <davidn@davidnewall.com>
Cc: Stephen Hemminger <stephen@networkplumber.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        bridge@lists.linux-foundation.org
Subject: Re: Revert 462fb2af9788a82a534f8184abfde31574e1cfa0 (bridge :
 Sanitize skb before it enters the IP stack)
Message-ID: <20140519140119.GA24523@breakpoint.cc>
References: <537621AC.1060409@davidnewall.com>
 <5379FFFD.1050705@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5379FFFD.1050705@davidnewall.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Newall <davidn@davidnewall.com> wrote:
> Having received no feedback of substance from netdev, I now address
> my previous email to a wider audience for discussion and in
> preparation for submitting a patch based closely on that below.
> 
> This email is not addressed to Bandan Das <bandan.das@stratus.com>,
> who is the author of the commit I propose reverting, as his email
> address is no longer current.  I believe I have otherwise addressed
> all appropriate recipients and will circulate a formal patch to the
> same recipients if no adverse comments are received.  (That would
> surprise me.)
> 
> -------- Original Message --------
> Subject: 	Revert 462fb2af9788a82a534f8184abfde31574e1cfa0 (bridge :
> Sanitize skb before it enters the IP stack)
> Date: 	Sat, 17 May 2014 00:03:16 +0930
> From: 	David Newall <davidn@davidnewall.com>
> To: 	Lukas Tribus <luky-37@hotmail.com>, Eric Dumazet
> <eric.dumazet@gmail.com>, Netdev <netdev@vger.kernel.org>
> CC: 	fw@strlen.de <fw@strlen.de>
> 
> 
> 
> We should revert commit 462fb2af9788a82a534f8184abfde31574e1cfa0 (bridge
> : Sanitize skb before it enters the IP stack) because it corrupts IP
> packets with RR or TS options set, only partially updating the IP header
> and leaving an incorrect checksum.
> 
> The argument for introducing the change is at lkml.org/lkml/2010/8/30/391:
> 
> The bridge layer can overwrite the IPCB using the
> BR_INPUT_SKB_CB macro. In br_nf_dev_queue_xmit,
> if we recieve a packet greater in size than the bridge
> device MTU, we call ip_fragment which in turn will lead to
> icmp_send calling ip_options_echo if the DF flag is set.
> ip_options_echo will then incorrectly try to parse the IPCB as
> IP options resulting in a buffer overflow.
> This change refills the CB area back with IP
> options before ip_fragment calls icmp_send. If we fail parsing,
> we zero out the IPCB area to guarantee that the stack does
> not get corrupted.
>
> A bridge should not fragment packets; an *ethernet* bridge should not
> need to.  Fragmenting packets is the job of higher level protocol.

Well, did you test what happens if we try to refrag a packet
containing ip options after the revert?

can happen e.g. when using netfilter conntrack on top of a bridge.
