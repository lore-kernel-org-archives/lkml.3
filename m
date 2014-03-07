Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640AbaCGR76 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 12:59:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35202 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751975AbaCGR74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 12:59:56 -0500
Message-ID: <531A0911.4040304@redhat.com>
Date: Fri, 07 Mar 2014 18:59:45 +0100
From: Thomas Graf <tgraf@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Pravin Shelar <pshelar@nicira.com>
CC: Zoltan Kiss <zoltan.kiss@citrix.com>, Jesse Gross <jesse@nicira.com>,
        "dev@openvswitch.org" <dev@openvswitch.org>,
        xen-devel@lists.xenproject.org, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] openvswitch: Orphan frags before sending to userspace
 via Netlink to avoid guest stall
References: <1393615016-9187-1-git-send-email-zoltan.kiss@citrix.com>	<5319F272.1070101@redhat.com> <CALnjE+q=fejHPsjVj9+jnypJCUHfCDFc553U48WR48Tjcf3FZw@mail.gmail.com>
In-Reply-To: <CALnjE+q=fejHPsjVj9+jnypJCUHfCDFc553U48WR48Tjcf3FZw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2014 06:28 PM, Pravin Shelar wrote:
> Problem is mapping SKBTX_DEV_ZEROCOPY pages to userspace. skb_zerocopy
> is not doing that.
>
> Unless I missing something, Current netlink code can not handle
> skb-frags with zero copy. So we have to copy skb anyways and no need
> to orphan-frags here.
> If you are planning on handling skb-frags without copying then
> skb_orphan_frags should be done in netlink.

If you look at the second part of skb_zerocopy() this is exactly what
it is doing unless the target skb has sufficient linear space
preallocated. At least unless mmap is enabled in which case we would
have to copy again until we have implemented a way to pass page refs
via the nl ring buffer.

So I think Zoltan is correct in orphaning frags that come from f.e.
a tun device via zerocopy_sg_from_iovec().
