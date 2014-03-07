Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247AbaCGM3l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 07:29:41 -0500
Received: from smtp.citrix.com ([66.165.176.89]:33519 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330AbaCGM3i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 07:29:38 -0500
X-IronPort-AV: E=Sophos;i="4.97,607,1389744000"; 
   d="scan'208";a="109088231"
Message-ID: <5319BBAE.7030109@citrix.com>
Date: Fri, 7 Mar 2014 12:29:34 +0000
From: Zoltan Kiss <zoltan.kiss@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Pravin Shelar <pshelar@nicira.com>
CC: Jesse Gross <jesse@nicira.com>, Thomas Graf <tgraf@redhat.com>,
        "dev@openvswitch.org" <dev@openvswitch.org>,
        <xen-devel@lists.xenproject.org>, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH] openvswitch: Orphan frags before sending to userspace
 via Netlink to avoid guest stall
References: <1393615016-9187-1-git-send-email-zoltan.kiss@citrix.com>	<5318ABC0.4040307@citrix.com> <CALnjE+rWc=n_F+1jSLQtPrgKSvvxONEkkYxWEHon2_KVNG9z3Q@mail.gmail.com>
In-Reply-To: <CALnjE+rWc=n_F+1jSLQtPrgKSvvxONEkkYxWEHon2_KVNG9z3Q@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.133]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/14 04:46, Pravin Shelar wrote:
> On Thu, Mar 6, 2014 at 9:09 AM, Zoltan Kiss <zoltan.kiss@citrix.com> wrote:
>> Do you have any feedback on this? I'm also adding KVM list as they might be
>> interested in this.
>>
>> Zoli
>>
>>
>> On 28/02/14 19:16, Zoltan Kiss wrote:
>>>
>>> The kernel datapath now switched to zerocopy Netlink messages, but that
>>> also
>>> means that the pages on frags array are sent straight to userspace. If
>>> those
>>> pages came outside the kernel, we have to swap them out with local copies.
>>>
>>> Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
>
> I do not think this is required, netlink zero copy only maps
> pre-allocated buffers to user-space.
How do you mean "pre-allocated"? By who?

As far as I've seen the skb in this function came straight from the 
device (vif in our case), and skb_zerocopy just copy the frags to 
user_skb, which is sent to the userspace. Those frags contain pages from 
guest, and it's a bad idea to pass them to userspace: e.g if userspace 
dies in the meantime, what happens with them? Also, in Xen's case they 
are actually not mapped to userspace, so accessing them can lead to garbage.

Zoli
