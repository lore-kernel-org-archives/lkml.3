Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932103AbaLHLLU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 06:11:20 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:9161 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752144AbaLHLLS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 06:11:18 -0500
X-IronPort-AV: E=Sophos;i="5.07,537,1413244800"; 
   d="scan'208";a="201740009"
Message-ID: <54858753.1070801@citrix.com>
Date: Mon, 8 Dec 2014 11:11:15 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Luis Henriques <luis.henriques@canonical.com>,
        Stefan Bader <stefan.bader@canonical.com>
CC: Wei Liu <wei.liu2@citrix.com>, Ian Campbell <Ian.Campbell@citrix.com>,
        <netdev@vger.kernel.org>, Kamal Mostafa <kamal@canonical.com>,
        <linux-kernel@vger.kernel.org>, Paul Durrant <paul.durrant@citrix.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Zoltan Kiss <zoltan.kiss@citrix.com>, <xen-devel@lists.xenproject.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [Xen-devel] [PATCH] xen-netfront: Fix handling packets on compound
 pages with skb_linearize
References: <1407778343-13622-1-git-send-email-zoltan.kiss@citrix.com>	<547C2CFC.7060908@canonical.com> <20141208101936.GA7491@hercules>
In-Reply-To: <20141208101936.GA7491@hercules>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/14 10:19, Luis Henriques wrote:
> On Mon, Dec 01, 2014 at 09:55:24AM +0100, Stefan Bader wrote:
>> On 11.08.2014 19:32, Zoltan Kiss wrote:
>>> There is a long known problem with the netfront/netback interface: if the guest
>>> tries to send a packet which constitues more than MAX_SKB_FRAGS + 1 ring slots,
>>> it gets dropped. The reason is that netback maps these slots to a frag in the
>>> frags array, which is limited by size. Having so many slots can occur since
>>> compound pages were introduced, as the ring protocol slice them up into
>>> individual (non-compound) page aligned slots. The theoretical worst case
>>> scenario looks like this (note, skbs are limited to 64 Kb here):
>>> linear buffer: at most PAGE_SIZE - 17 * 2 bytes, overlapping page boundary,
>>> using 2 slots
>>> first 15 frags: 1 + PAGE_SIZE + 1 bytes long, first and last bytes are at the
>>> end and the beginning of a page, therefore they use 3 * 15 = 45 slots
>>> last 2 frags: 1 + 1 bytes, overlapping page boundary, 2 * 2 = 4 slots
>>> Although I don't think this 51 slots skb can really happen, we need a solution
>>> which can deal with every scenario. In real life there is only a few slots
>>> overdue, but usually it causes the TCP stream to be blocked, as the retry will
>>> most likely have the same buffer layout.
>>> This patch solves this problem by linearizing the packet. This is not the
>>> fastest way, and it can fail much easier as it tries to allocate a big linear
>>> area for the whole packet, but probably easier by an order of magnitude than
>>> anything else. Probably this code path is not touched very frequently anyway.
>>>
>>> Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
>>> Cc: Wei Liu <wei.liu2@citrix.com>
>>> Cc: Ian Campbell <Ian.Campbell@citrix.com>
>>> Cc: Paul Durrant <paul.durrant@citrix.com>
>>> Cc: netdev@vger.kernel.org
>>> Cc: linux-kernel@vger.kernel.org
>>> Cc: xen-devel@lists.xenproject.org
>>
>> This does not seem to be marked explicitly as stable. Has someone already asked
>> David Miller to put it on his stable queue? IMO it qualifies quite well and the
>> actual change should be simple to pick/backport.
>>
> 
> Thank you Stefan, I'm queuing this for the next 3.16 kernel release.

Don't backport this yes.  It's broken.  It produces malformed requests
and netback will report a fatal error and stop all traffic on the VIF.

David
