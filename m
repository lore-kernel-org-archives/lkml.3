Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751197AbaCGEwU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 23:52:20 -0500
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:33949 "HELO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750834AbaCGEwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 23:52:19 -0500
X-Greylist: delayed 363 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Mar 2014 23:52:19 EST
MIME-Version: 1.0
In-Reply-To: <5318ABC0.4040307@citrix.com>
References: <1393615016-9187-1-git-send-email-zoltan.kiss@citrix.com>
	<5318ABC0.4040307@citrix.com>
Date: Thu, 6 Mar 2014 20:46:15 -0800
Message-ID: <CALnjE+rWc=n_F+1jSLQtPrgKSvvxONEkkYxWEHon2_KVNG9z3Q@mail.gmail.com>
Subject: Re: [PATCH] openvswitch: Orphan frags before sending to userspace via
 Netlink to avoid guest stall
From: Pravin Shelar <pshelar@nicira.com>
To: Zoltan Kiss <zoltan.kiss@citrix.com>
Cc: Jesse Gross <jesse@nicira.com>, Thomas Graf <tgraf@redhat.com>,
        "dev@openvswitch.org" <dev@openvswitch.org>,
        xen-devel@lists.xenproject.org, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 6, 2014 at 9:09 AM, Zoltan Kiss <zoltan.kiss@citrix.com> wrote:
> Do you have any feedback on this? I'm also adding KVM list as they might be
> interested in this.
>
> Zoli
>
>
> On 28/02/14 19:16, Zoltan Kiss wrote:
>>
>> The kernel datapath now switched to zerocopy Netlink messages, but that
>> also
>> means that the pages on frags array are sent straight to userspace. If
>> those
>> pages came outside the kernel, we have to swap them out with local copies.
>>
>> Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>

I do not think this is required, netlink zero copy only maps
pre-allocated buffers to user-space.

But I found bug in datapath user-space queue code. I am not sure how
this can work with skb fragments and MMAP-netlink socket.
Here is what happens, OVS allocates netlink skb and adds fragments to
skb using skb_zero_copy(), then calls genlmsg_unicast().
But if netlink sock is mmped then netlink-send queues netlink
allocated skb->head (linear data of skb) and ignore skb frags.

Currently this is not problem with OVS vswitchd since it does not use
netlink MMAP sockets. But if vswitchd stats using MMAP-netlink socket,
it can break it.
