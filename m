Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443Ab3LCLOM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 06:14:12 -0500
Received: from smtp.citrix.com ([66.165.176.89]:32258 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752879Ab3LCLOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 06:14:10 -0500
X-IronPort-AV: E=Sophos;i="4.93,817,1378857600"; 
   d="scan'208";a="80041355"
Message-ID: <529DBCFE.9030004@citrix.com>
Date: Tue, 3 Dec 2013 12:14:06 +0100
From: =?UTF-8?B?Um9nZXIgUGF1IE1vbm7DqQ==?= <roger.pau@citrix.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Julien Grall <julien.grall@linaro.org>,
        David Vrabel <david.vrabel@citrix.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [Xen-devel] [PATCH RFC] xen-block: correctly define structures
 in public headers
References: <1386068254-1413-1-git-send-email-roger.pau@citrix.com> <1386068729.13256.8.camel@kazak.uk.xensource.com>
In-Reply-To: <1386068729.13256.8.camel@kazak.uk.xensource.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/13 12:05, Ian Campbell wrote:
> On Tue, 2013-12-03 at 11:57 +0100, Roger Pau Monne wrote:
>> Using __packed__ on the public interface is not correct, this
>> structures should be compiled using the native ABI, and __packed__
>> should only be used in the backend counterpart of those structures
>> (which needs to handle different ABIs).
>>
>> This was even worse in the ARM case, where the Linux kernel was
>> incorrectly using the X86_32 protocol ABI. This patch fixes it, but
>> also breaks compatibility, so an ARM DomU kernel compiled with
>> this patch will fail to communicate with PV disk devices unless the
>> Dom0 also has this patch.
> 
> This is acceptable IMHO, the ARM ABI is clearly defined and previous
> kernels were simply buggy. The fact that front and backend were
> equivalently buggy and so it happened to work is not an excuse.
> 
>> Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
>> Reported-by: Julien Grall <julien.grall@linaro.org>
>> Cc: Julien Grall <julien.grall@linaro.org>
>> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>> Cc: David Vrabel <david.vrabel@citrix.com>
>> Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
>> Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
>> ---
>>  include/xen/interface/io/blkif.h |   28 +++++++---------------------
>>  1 files changed, 7 insertions(+), 21 deletions(-)
>>
>> diff --git a/include/xen/interface/io/blkif.h b/include/xen/interface/io/blkif.h
>> index 65e1209..002ea22 100644
>> --- a/include/xen/interface/io/blkif.h
>> +++ b/include/xen/interface/io/blkif.h
>> @@ -141,14 +141,11 @@ struct blkif_request_segment_aligned {
>>  	/* @last_sect: last sector in frame to transfer (inclusive).     */
>>  	uint8_t     first_sect, last_sect;
>>  	uint16_t    _pad; /* padding to make it 8 bytes, so it's cache-aligned */
>> -} __attribute__((__packed__));
>> +};
>>  
>>  struct blkif_request_rw {
>>  	uint8_t        nr_segments;  /* number of segments                   */
>>  	blkif_vdev_t   handle;       /* only for read/write requests         */
>> -#ifdef CONFIG_X86_64
>> -	uint32_t       _pad1;	     /* offsetof(blkif_request,u.rw.id) == 8 */
>> -#endif
> 
> These padding fields would still serve a purpose even after removing the
> packing, which is to document/clarify where there are holes for various
> architectures. They could either be retained or perhaps replaced by a
> comment?

Those paddings are already present in drivers/block/xen-blkback/common.h
for each of the different ABIs, which I think is enough, but if I had
to, I would rather replace them with comments.

