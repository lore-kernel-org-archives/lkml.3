Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769AbaCGP6S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 10:58:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45499 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751033AbaCGP6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 10:58:16 -0500
Message-ID: <5319EC8E.2010606@redhat.com>
Date: Fri, 07 Mar 2014 16:58:06 +0100
From: Thomas Graf <tgraf@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Pravin Shelar <pshelar@nicira.com>, Zoltan Kiss <zoltan.kiss@citrix.com>
CC: Jesse Gross <jesse@nicira.com>,
        "dev@openvswitch.org" <dev@openvswitch.org>,
        xen-devel@lists.xenproject.org, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
Subject: Re: [PATCH] openvswitch: Orphan frags before sending to userspace
 via Netlink to avoid guest stall
References: <1393615016-9187-1-git-send-email-zoltan.kiss@citrix.com>	<5318ABC0.4040307@citrix.com> <CALnjE+rWc=n_F+1jSLQtPrgKSvvxONEkkYxWEHon2_KVNG9z3Q@mail.gmail.com>
In-Reply-To: <CALnjE+rWc=n_F+1jSLQtPrgKSvvxONEkkYxWEHon2_KVNG9z3Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2014 05:46 AM, Pravin Shelar wrote:
> But I found bug in datapath user-space queue code. I am not sure how
> this can work with skb fragments and MMAP-netlink socket.
> Here is what happens, OVS allocates netlink skb and adds fragments to
> skb using skb_zero_copy(), then calls genlmsg_unicast().
> But if netlink sock is mmped then netlink-send queues netlink
> allocated skb->head (linear data of skb) and ignore skb frags.
>
> Currently this is not problem with OVS vswitchd since it does not use
> netlink MMAP sockets. But if vswitchd stats using MMAP-netlink socket,
> it can break it.

The secret is out ;-)

I was very surprised too when I noticed that it worked. It's not just
OVS, it's nfqueue as well. The reason is that an netlink mmaped skb is
setup with a giant tailroom in netlink_ring_setup_skb():

	skb->end	= skb->tail + size;

and skb_zerocopy() will consume whatever tailroom is available first:

	/* dont bother with small payloads */
	if (len <= skb_tailroom(to)) {
		skb_copy_bits(from, 0, skb_put(to, len), len);
		return;
	}

I was planning to fix this while adding GSO support to the upcall as
that is the moment when this bug would really surface.
