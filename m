Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090AbaCZASM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 20:18:12 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:35448 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035AbaCZASK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 20:18:10 -0400
Message-ID: <53321CB6.5050706@oracle.com>
Date: Tue, 25 Mar 2014 20:17:58 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Michal Hocko <mhocko@suse.cz>, Pekka Enberg <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: mm: slub: gpf in deactivate_slab
References: <53208A87.2040907@oracle.com> <5331A6C3.2000303@oracle.com> <20140325165247.GA7519@dhcp22.suse.cz> <alpine.DEB.2.10.1403251205140.24534@nuc> <5331B9C8.7080106@oracle.com> <alpine.DEB.2.10.1403251308590.26471@nuc>
In-Reply-To: <alpine.DEB.2.10.1403251308590.26471@nuc>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/2014 02:10 PM, Christoph Lameter wrote:
> On Tue, 25 Mar 2014, Sasha Levin wrote:
>
>> So here's the full trace. There's obviously something wrong here since we
>> pagefault inside the section that was supposed to be running with irqs
>> disabled
>> and I don't see another cause besides this.
>>
>> The unreliable entries in the stack trace also somewhat suggest that the
>> fault is with the code I've pointed out.
>
> Looks like there was some invalid data fed to the function and the page
> fault with interrupts disabled is the result of following and invalid
> pointer.
>
> Is there more context information available? What are the options set for
> the cache that the operation was performed on?

It seems like it's a regular allocation from the inode_cachep kmem_cache:

	inode = kmem_cache_alloc(inode_cachep, GFP_KERNEL);

I'm not sure if there's anything special about this cache, codewise it's
created as follows:


         inode_cachep = kmem_cache_create("inode_cache",
                                          sizeof(struct inode),
                                          0,
                                          (SLAB_RECLAIM_ACCOUNT|SLAB_PANIC|
                                          SLAB_MEM_SPREAD),
                                          init_once);


I'd be happy to dig up any other info required, I'm just not too sure
what you mean by options for the cache?


Thanks,
Sasha
