Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376Ab3KNLVe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 06:21:34 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:38907 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801Ab3KNLVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 06:21:32 -0500
X-IronPort-AV: E=Sophos;i="4.93,699,1378857600"; 
   d="scan'208";a="71859999"
Message-ID: <5284B238.6020601@citrix.com>
Date: Thu, 14 Nov 2013 11:21:28 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Dario Faggioli <dario.faggioli@citrix.com>
CC: Elena Ufimtseva <ufimtseva@gmail.com>, <xen-devel@lists.xenproject.org>,
        <akpm@linux-foundation.org>, <wency@cn.fujitsu.com>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tangchen@cn.fujitsu.com>,
        <mingo@redhat.com>, <hpa@zytor.com>, <boris.ostrovsky@oracle.com>,
        <tglx@linutronix.de>, <stefano.stabellini@eu.citrix.com>,
        <ian.campbell@citrix.com>
Subject: Re: [Xen-devel] [PATCH 1/2] xen: vnuma support for PV guests running
 as domU.
References: <1384400179-24404-1-git-send-email-ufimtseva@gmail.com>	 <1384400179-24404-2-git-send-email-ufimtseva@gmail.com> <1384414000.29902.25.camel@Abyss>
In-Reply-To: <1384414000.29902.25.camel@Abyss>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/11/13 07:26, Dario Faggioli wrote:
> On mer, 2013-11-13 at 22:36 -0500, Elena Ufimtseva wrote:
>> +	/*
>> +	 * Set the "dummy" node and exit without error so Linux
>> +	 * will not try any NUMA init functions which might break
>> +	 * guests in the future. This will discard all previous
>> +	 * settings.
>> +	 */
> IIRC, it's more something that was already happening (the breakage, I
> mean), than a "safety net" for the unforeseeable future. Might be worth
> giving some context about it, perhaps referencing the email thread or
> the git commit hash in the comment.

Yes, a comment like:

/*
 * Set a dummy node and return success.  This prevents calling any
 * hardware-specific initializers which do not work in a PV guest.
 */

is better.  No need to refer to any specific threads.  It's pretty clear
that any hardware-specific init isn't appropriate for a PV guest.

>> +	if (rc != 0) {
>> +		for (i = 0; i < MAX_LOCAL_APIC; i++)
>> +			set_apicid_to_node(i, NUMA_NO_NODE);
>> +		nodes_clear(numa_nodes_parsed);
>> +		nodes_clear(node_possible_map);
>> +		nodes_clear(node_online_map);
>> +		node_set(0, numa_nodes_parsed);
>> +		numa_add_memblk(0, 0, PFN_PHYS(max_pfn));
>> +	}
>> +	return 0;
>>
> Ok, so, we always return 'success', as we were saying during last round.
> However, we do not call dummy_numa_init() directly, and instead we do
> all these stuff, with the last two statements being exactly what
> dummy_numa_init() does. Reason is linking, i.e., the fact that
> dummy_numa_init() is not exported and you can't reach it from here,
> right?

I think this bit is fine as-is.

David
