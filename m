Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465Ab3FDIxV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 04:53:21 -0400
Received: from mga11.intel.com ([192.55.52.93]:15653 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752372Ab3FDIxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 04:53:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,798,1363158000"; 
   d="scan'208";a="344447007"
Message-ID: <51ADAADD.4030209@linux.intel.com>
Date: Tue, 04 Jun 2013 11:52:45 +0300
From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        e1000-devel@lists.sourceforge.net,
        Willem de Bruijn <willemb@google.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eilon Greenstien <eilong@broadcom.com>,
        Or Gerlitz <or.gerlitz@gmail.com>, Alex Rosenbaum <alexr@mellanox.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Subject: Re: [PATCH v8 net-next 5/7] net: simple poll/select low latency socket
 poll
References: <20130603080107.18273.34279.stgit@ladj378.jer.intel.com>  <20130603080200.18273.52073.stgit@ladj378.jer.intel.com> <1370265324.24311.136.camel@edumazet-glaptop> <51ACA15C.4060101@linux.intel.com>
In-Reply-To: <51ACA15C.4060101@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2013 16:59, Eliezer Tamir wrote:
> On 03/06/2013 16:15, Eric Dumazet wrote:
>> On Mon, 2013-06-03 at 11:02 +0300, Eliezer Tamir wrote:
>>>       sock = file->private_data;
>>> -    return sock->ops->poll(file, sock, wait);
>>> +
>>> +    poll_result = sock->ops->poll(file, sock, wait);
>>> +
>>> +    if (!(poll_result & (POLLRDNORM | POLLERR | POLLRDHUP |
>>> POLLHUP)) &&
>>> +        sk_valid_ll(sock->sk) && sk_poll_ll(sock->sk, 1))
>>> +            poll_result = sock->ops->poll(file, sock, NULL);
>>> +
>>> +    return poll_result;
>>>   }
>>>
>>>   static int sock_mmap(struct file *file, struct vm_area_struct *vma)
>>>
>>
>>
>> In fact, for TCP, POLLOUT event being ready can also be triggered by
>> incoming messages, as the ACK might allow the user application to push
>> more data in the write queue.
>>
>> And you might check wait->_key to avoid testing flags that user is not
>> interested into.
>
> yes, comparing to _key is more correct.
> In any case this needs to be completely rewritten for support for
> working well with a large number of sockets.
>

Is it possible for wait to be NULL? (do we need to check for that?)
I see that poll_does_not_wait() checks for that, but I could not find
anywhere this is actually done.

-Eliezer

