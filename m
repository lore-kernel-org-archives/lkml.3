Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047AbaCGRTp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 12:19:45 -0500
Received: from na3sys009aog138.obsmtp.com ([74.125.149.19]:41812 "HELO
	na3sys009aog138.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753219AbaCGRTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 12:19:43 -0500
MIME-Version: 1.0
In-Reply-To: <5319EC8E.2010606@redhat.com>
References: <1393615016-9187-1-git-send-email-zoltan.kiss@citrix.com>
	<5318ABC0.4040307@citrix.com>
	<CALnjE+rWc=n_F+1jSLQtPrgKSvvxONEkkYxWEHon2_KVNG9z3Q@mail.gmail.com>
	<5319EC8E.2010606@redhat.com>
Date: Fri, 7 Mar 2014 09:19:41 -0800
Message-ID: <CALnjE+oDM=ga_C6T_-9i2UNwv=K4g-+y-LJA04nh+=WmoeuNXw@mail.gmail.com>
Subject: Re: [PATCH] openvswitch: Orphan frags before sending to userspace via
 Netlink to avoid guest stall
From: Pravin Shelar <pshelar@nicira.com>
To: Thomas Graf <tgraf@redhat.com>
Cc: Zoltan Kiss <zoltan.kiss@citrix.com>, Jesse Gross <jesse@nicira.com>,
        "dev@openvswitch.org" <dev@openvswitch.org>,
        xen-devel@lists.xenproject.org, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 7, 2014 at 7:58 AM, Thomas Graf <tgraf@redhat.com> wrote:
> On 03/07/2014 05:46 AM, Pravin Shelar wrote:
>>
>> But I found bug in datapath user-space queue code. I am not sure how
>> this can work with skb fragments and MMAP-netlink socket.
>> Here is what happens, OVS allocates netlink skb and adds fragments to
>> skb using skb_zero_copy(), then calls genlmsg_unicast().
>> But if netlink sock is mmped then netlink-send queues netlink
>> allocated skb->head (linear data of skb) and ignore skb frags.
>>
>> Currently this is not problem with OVS vswitchd since it does not use
>> netlink MMAP sockets. But if vswitchd stats using MMAP-netlink socket,
>> it can break it.
>
>
> The secret is out ;-)
>
> I was very surprised too when I noticed that it worked. It's not just
> OVS, it's nfqueue as well. The reason is that an netlink mmaped skb is
> setup with a giant tailroom in netlink_ring_setup_skb():
>
>         skb->end        = skb->tail + size;
>
For OVS use-case, the size is linear part of skb. so I think for
mmap-netlink socket it will fail.

> and skb_zerocopy() will consume whatever tailroom is available first:
>
>         /* dont bother with small payloads */
>         if (len <= skb_tailroom(to)) {
>                 skb_copy_bits(from, 0, skb_put(to, len), len);
>                 return;
>         }
>
> I was planning to fix this while adding GSO support to the upcall as
> that is the moment when this bug would really surface.

ok.
