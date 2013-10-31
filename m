Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302Ab3JaTWc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 15:22:32 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:13805 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852Ab3JaTWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 15:22:31 -0400
X-IronPort-AV: E=Sophos;i="4.93,611,1378857600"; 
   d="scan'208";a="66876217"
Message-ID: <5272ADF3.2000301@citrix.com>
Date: Thu, 31 Oct 2013 19:22:27 +0000
From: Zoltan Kiss <zoltan.kiss@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: <ian.campbell@citrix.com>, <jonathan.davies@citrix.com>,
        <wei.liu2@citrix.com>, <xen-devel@lists.xenproject.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH net-next RFC 1/5] xen-netback: Introduce TX
 grant map definitions
References: <1383094220-14775-1-git-send-email-zoltan.kiss@citrix.com> <1383094220-14775-2-git-send-email-zoltan.kiss@citrix.com> <5270DF3602000078000FDFBE@nat28.tlf.novell.com>
In-Reply-To: <5270DF3602000078000FDFBE@nat28.tlf.novell.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.133]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/10/13 09:28, Jan Beulich wrote:
>>>> On 30.10.13 at 01:50, Zoltan Kiss <zoltan.kiss@citrix.com> wrote:
>> @@ -119,13 +126,22 @@ struct xenvif {
>>   	pending_ring_idx_t pending_cons;
>>   	u16 pending_ring[MAX_PENDING_REQS];
>>   	struct pending_tx_info pending_tx_info[MAX_PENDING_REQS];
>> +	grant_handle_t grant_tx_handle[MAX_PENDING_REQS];
>>
>>   	/* Coalescing tx requests before copying makes number of grant
>>   	 * copy ops greater or equal to number of slots required. In
>>   	 * worst case a tx request consumes 2 gnttab_copy.
>>   	 */
>>   	struct gnttab_copy tx_copy_ops[2*MAX_PENDING_REQS];
>> +	struct gnttab_unmap_grant_ref tx_unmap_ops[MAX_PENDING_REQS];
>> +	struct gnttab_map_grant_ref tx_map_ops[MAX_PENDING_REQS];
>> +	/* passed to gnttab_[un]map_refs with pages under (un)mapping */
>> +	struct page *pages_to_gnt[MAX_PENDING_REQS];
>
> I think you will want to try to limit the structure size here by putting
> things into unions that can't be used at the same time: Without
> having looked at the later patches yet, it seems quite unlikely that
> map and unmap can be used simultaneously. And the total of copy
> and map can't also be used at the same time, as for each pending
> request you would use either up to two copy slots or a single map
> slot. I didn't look for further opportunities of sharing space.

Indeed, map and unmap can't be done at the same time, so it's safe to 
put them into union. But I'm afraid grant_tx_handle and pages_to_gnt 
can't share space with other members.
tx_copy_ops is a different topic, let's discuss that in it's own thread ...

Thanks,

Zoli

