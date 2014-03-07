Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753116AbaCGSlL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 13:41:11 -0500
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:52605 "HELO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752347AbaCGSlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 13:41:09 -0500
MIME-Version: 1.0
In-Reply-To: <531A0911.4040304@redhat.com>
References: <1393615016-9187-1-git-send-email-zoltan.kiss@citrix.com>
	<5319F272.1070101@redhat.com>
	<CALnjE+q=fejHPsjVj9+jnypJCUHfCDFc553U48WR48Tjcf3FZw@mail.gmail.com>
	<531A0911.4040304@redhat.com>
Date: Fri, 7 Mar 2014 10:41:08 -0800
Message-ID: <CALnjE+oMCexif_D3e41F8o9DXn=v6hshj3y-g+bLPoCWtSELww@mail.gmail.com>
Subject: Re: [PATCH] openvswitch: Orphan frags before sending to userspace via
 Netlink to avoid guest stall
From: Pravin Shelar <pshelar@nicira.com>
To: Thomas Graf <tgraf@redhat.com>
Cc: Zoltan Kiss <zoltan.kiss@citrix.com>, Jesse Gross <jesse@nicira.com>,
        "dev@openvswitch.org" <dev@openvswitch.org>,
        xen-devel@lists.xenproject.org, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 7, 2014 at 9:59 AM, Thomas Graf <tgraf@redhat.com> wrote:
> On 03/07/2014 06:28 PM, Pravin Shelar wrote:
>>
>> Problem is mapping SKBTX_DEV_ZEROCOPY pages to userspace. skb_zerocopy
>> is not doing that.
>>
>> Unless I missing something, Current netlink code can not handle
>> skb-frags with zero copy. So we have to copy skb anyways and no need
>> to orphan-frags here.
>> If you are planning on handling skb-frags without copying then
>> skb_orphan_frags should be done in netlink.
>
>
> If you look at the second part of skb_zerocopy() this is exactly what
> it is doing unless the target skb has sufficient linear space
> preallocated. At least unless mmap is enabled in which case we would
> have to copy again until we have implemented a way to pass page refs
> via the nl ring buffer.
>

What is problem with passing page ref with get_page() to new skb as
long as it is accessed kernel?

I think we should set SKBTX_DEV_ZEROCOPY flag for new skb in
skb_zerocopy() to track such pages but no need call
skb_orphan_frags().

> So I think Zoltan is correct in orphaning frags that come from f.e.
> a tun device via zerocopy_sg_from_iovec().
