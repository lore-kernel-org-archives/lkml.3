Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756523Ab3KFLeb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 06:34:31 -0500
Received: from smtp.citrix.com ([66.165.176.89]:48791 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756390Ab3KFLea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 06:34:30 -0500
X-IronPort-AV: E=Sophos;i="4.93,646,1378857600"; 
   d="scan'208";a="71102916"
Message-ID: <527A2943.7050400@citrix.com>
Date: Wed, 6 Nov 2013 11:34:27 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Anthony Liguori <anthony@codemonkey.ws>
CC: Matt Wilson <msw@linux.com>,
        =?UTF-8?B?Um9nZXIgUGF1IE1vbm7DqQ==?= <roger.pau@citrix.com>,
        Ian Campbell <Ian.Campbell@citrix.com>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xen.org>, David Vrabel <david.vrabel@citrix.com>,
        Matt Wilson <msw@amazon.com>
Subject: Re: [Xen-devel] [PATCH] grant-table: don't set m2p override if	kmap_ops
 is not set
References: <1383650649-13971-1-git-send-email-roger.pau@citrix.com>	<5278E64C.40200@citrix.com> <527904EC.9090402@citrix.com>	<20131105145607.GB25836@phenom.dumpdata.com>	<5279085E.7070703@citrix.com>	<1383664090.13961.88.camel@kazak.uk.xensource.com>	<527916EE.6060104@citrix.com>	<20131105200616.GA23362@u109add4315675089e695.ant.amazon.com> <878ux2vade.fsf@codemonkey.ws>
In-Reply-To: <878ux2vade.fsf@codemonkey.ws>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/13 20:53, Anthony Liguori wrote:
> Matt Wilson <msw@linux.com> writes:
> 
>> On Tue, Nov 05, 2013 at 05:03:58PM +0100, Roger Pau Monné wrote:
>>> On 05/11/13 16:08, Ian Campbell wrote:
>>>> On Tue, 2013-11-05 at 16:01 +0100, Roger Pau Monné wrote:
>>>>> On 05/11/13 15:56, Konrad Rzeszutek Wilk wrote:
>>>>>> On Tue, Nov 05, 2013 at 03:47:08PM +0100, Roger Pau Monné wrote:
>>>>>>> On 05/11/13 13:36, David Vrabel wrote:
>>>>>>>> On 05/11/13 11:24, Roger Pau Monne wrote:
>>>>>>>>> IMHO there's no reason to set a m2p override if the mapping is done in
>>>>>>>>> kernel space, so only set the m2p override when kmap_ops is set.
>>>>>>>>
>>>>>>>> Can you provide a more detailed reasoning about why this is safe?
>>>>>>>
>>>>>>> To tell the truth, I don't understand why we need to use the m2p
>>>>>>> override for kernel space only mappings, my understanding is that this
>>>>>>> m2p override is needed for user space mappings only (where we actually
>>>>>>> end up doing two mappings, one in kernel space and one in user space).
>>>>>>> For kernel space I don't see why we need to do anything else than
>>>>>>> setting the right p2m translation.
>>>>>>
>>>>>> We needed the m2p when doing DMA operations. As the driver would
>>>>>> want the bus address (so p2m) and then when unmapping the DMA we
>>>>>> only get the bus address  - so we needed to do a m2p lookup.

No. A m2p lookup should not be needed for DMA unmap.

We only need the p2m lookup on DMA map to get the bus address -- there's
should be nothing to do on the unmap.

However, there is dma_mark_clean(phys_to_virt(phys), size) call in
xen_unmap_single() which would require the m2p lookup but this call is
not necessary as dma_mark_clean() is a no-op for anything except ia64
and we do not care about ia64.

>>>>> OK, we need a m2p (that we already have in machine_to_phys_mapping),
>>>>> what I don't understand is why we need the m2p override.
>>>>
>>>> The m2p is a host global table.
>>>>
>>>> For a foreign page grant mapped into the current domain the m2p will
>>>> give you the foreign (owner) domain's p from the m, not the local one.
>>>
>>> Yes, you are completely right, then I have to figure out why blkback
>>> works fine with this patch applied (or at least it seems to work fine).
>>
>> blkback also works for me when testing a similar patch. I'm still
>> confused. One thing with your proposed patch: I'm not sure that you're
>> putting back the correct mfn.

Matt, Anthony, I presume you have profiling results or performance data
that support this proposed change?  Can you provide them?

> It's perfectly fine to store a foreign pfn in the m2p table.  The m2p
> override table is used by the grant device to allow a reverse lookup of
> the real mfn to a pfn even if it's foreign.
> 
> blkback doesn't actually need this though.  This was introduced in:
> 
> commit 5dc03639cc903f887931831d69895facb5260f4b
> Author: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Date:   Tue Mar 1 16:46:45 2011 -0500
> 
>     xen/blkback: Utilize the M2P override mechanism for GNTMAP_host_map
> 
> Purely as an optimization.  In practice though due to lock contention it
> slows things down.

The full changeset description for this change doesn't make sense to me.

    xen/blkback: Utilize the M2P override mechanism for GNTMAP_host_map

    Instead of doing copy grants lets do mapping grants using
    the M2P(and P2M) override mechanism.

As all it is doing is replacing set_phys_to_machine() calls with
m2p_add_override().

David
