Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933AbaDCJtG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 05:49:06 -0400
Received: from smtp.citrix.com ([66.165.176.89]:1702 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751834AbaDCJtC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 05:49:02 -0400
X-IronPort-AV: E=Sophos;i="4.97,786,1389744000"; 
   d="scan'208";a="117600444"
Message-ID: <533D2E8A.90101@citrix.com>
Date: Thu, 3 Apr 2014 10:48:58 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Paul Durrant <Paul.Durrant@citrix.com>
CC: Zoltan Kiss <zoltan.kiss@citrix.com>,
        Ian Campbell <Ian.Campbell@citrix.com>, Wei Liu <wei.liu2@citrix.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jonathan Davies <Jonathan.Davies@citrix.com>
Subject: Re: [Xen-devel] [PATCH] grant-table, xen-netback: Introduce helper
 functions for grant copy operations
References: <1396458349-30112-1-git-send-email-zoltan.kiss@citrix.com> <9AAE0902D5BC7E449B7C8E4E778ABCD02BB106@AMSPEX01CL01.citrite.net>
In-Reply-To: <9AAE0902D5BC7E449B7C8E4E778ABCD02BB106@AMSPEX01CL01.citrite.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/14 09:12, Paul Durrant wrote:
> Zoltan Kiss wrote:
>>
>> Create helper functions for grant copy operations and use them in netback.
>>
[...]
>> --- a/drivers/net/xen-netback/netback.c
>> +++ b/drivers/net/xen-netback/netback.c
>> @@ -275,23 +275,29 @@ static void xenvif_gop_frag_copy(struct xenvif *vif,
>> struct sk_buff *skb,
>>  			bytes = MAX_BUFFER_OFFSET - npo->copy_off;
>>
>>  		copy_gop = npo->copy + npo->copy_prod++;
>> -		copy_gop->flags = GNTCOPY_dest_gref;
>> -		copy_gop->len = bytes;
>>
>>  		if (foreign_vif) {
>> -			copy_gop->source.domid = foreign_vif->domid;
>> -			copy_gop->source.u.ref = foreign_gref;
>> -			copy_gop->flags |= GNTCOPY_source_gref;
>> +			gnttab_set_copy_op_ref_to_ref(copy_gop,
>> +						      foreign_gref,
>> +						      npo->copy_gref,
>> +						      foreign_vif->domid,
>> +						      offset,
>> +						      vif->domid,
>> +						      npo->copy_off,
>> +						      bytes,
>> +						      GNTCOPY_dest_gref |
>> +						      GNTCOPY_source_gref);
> 
> Can't you lose the flags here (and in the other variants)? Since
> they are implied by the variant of the function they could just be hardcoded
> there, couldn't they?

Even with that change these are still functions with 7 or 8 parameters
with no obvious order.  That's just awful.  The open-coded struct
initialization is better.

David
