Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932119AbaAGDR1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 22:17:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25432 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753005AbaAGDR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 22:17:26 -0500
Message-ID: <52CB71B2.4070005@redhat.com>
Date: Tue, 07 Jan 2014 11:17:06 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, mst@redhat.com,
        john.r.fastabend@intel.com, nhorman@tuxdriver.com
Subject: Re: [PATCH net 1/2] macvlan: forbid L2 fowarding offload for macvtap
References: <1388978467-2075-1-git-send-email-jasowang@redhat.com> <20140106.154740.590358835696689785.davem@davemloft.net>
In-Reply-To: <20140106.154740.590358835696689785.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2014 04:47 AM, David Miller wrote:
> From: Jason Wang <jasowang@redhat.com>
> Date: Mon,  6 Jan 2014 11:21:06 +0800
>
>> L2 fowarding offload will bypass the rx handler of real device. This will make
>> the packet could not be forwarded to macvtap device. Another problem is the
>> dev_hard_start_xmit() called for macvtap does not have any synchronization.
>>
>> Fix this by forbidding L2 forwarding for macvtap.
>>
>> Cc: John Fastabend <john.r.fastabend@intel.com>
>> Cc: Neil Horman <nhorman@tuxdriver.com>
>> Signed-off-by: Jason Wang <jasowang@redhat.com>
> I think I agree with Neil that the rx_handler change might be the best
> way to fix this.  That change seems to have a lot of nice unintended
> side effects, no?

Not all sides effects are nice.

One obvious issue is it disables the multiqueue macvtap transmission,
since all queues will contend on a single qdisc lock of macvlan. And
even more, multiqueue macvtap support creating and destroying a queue on
demand which is not supported by L2 forwarding offload.

So L2 forwarding offload needs more fixes to let the multiqueue macvtap
works. Currently, we really need this patch to make sure macvtap works
as expected.
