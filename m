Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565AbaFJWKI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 18:10:08 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:41850 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633AbaFJWKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 18:10:05 -0400
Date: Tue, 10 Jun 2014 15:10:01 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Luiz Capitulino <lcapitulino@redhat.com>
cc: akpm@linux-foundation.org, andi@firstfloor.org, riel@redhat.com,
        yinghai@kernel.org, isimatu.yasuaki@jp.fujitsu.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] x86: numa: drop ZONE_ALIGN
In-Reply-To: <20140609231920.08a1b0f9@redhat.com>
Message-ID: <alpine.DEB.2.02.1406101506290.32203@chino.kir.corp.google.com>
References: <20140608181436.17de69ac@redhat.com> <alpine.DEB.2.02.1406081524580.21744@chino.kir.corp.google.com> <20140609144355.63a91968@redhat.com> <alpine.DEB.2.02.1406091453570.5271@chino.kir.corp.google.com> <20140609231920.08a1b0f9@redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jun 2014, Luiz Capitulino wrote:

> > > > > diff --git a/arch/x86/include/asm/numa.h b/arch/x86/include/asm/numa.h
> > > > > index 4064aca..01b493e 100644
> > > > > --- a/arch/x86/include/asm/numa.h
> > > > > +++ b/arch/x86/include/asm/numa.h
> > > > > @@ -9,7 +9,6 @@
> > > > >  #ifdef CONFIG_NUMA
> > > > >  
> > > > >  #define NR_NODE_MEMBLKS		(MAX_NUMNODES*2)
> > > > > -#define ZONE_ALIGN (1UL << (MAX_ORDER+PAGE_SHIFT))
> > > > >  
> > > > >  /*
> > > > >   * Too small node sizes may confuse the VM badly. Usually they
> > > > > diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
> > > > > index 1d045f9..69f6362 100644
> > > > > --- a/arch/x86/mm/numa.c
> > > > > +++ b/arch/x86/mm/numa.c
> > > > > @@ -200,8 +200,6 @@ static void __init setup_node_data(int nid, u64 start, u64 end)
> > > > >  	if (end && (end - start) < NODE_MIN_SIZE)
> > > > >  		return;
> > > > >  
> > > > > -	start = roundup(start, ZONE_ALIGN);
> > > > > -
> > > > >  	printk(KERN_INFO "Initmem setup node %d [mem %#010Lx-%#010Lx]\n",
> > > > >  	       nid, start, end - 1);
> > > > >  
> > > > 
> > > > What ensures this start address is page aligned from the BIOS?
> > > 
> > > To which start address do you refer to?
> > 
> > The start address displayed in the dmesg is not page aligned anymore with 
> > your change, correct?  
> 
> I have to check that but I don't expect this to happen because my
> understanding of the code is that what's rounded up here is just discarded
> in free_area_init_node(). Am I wrong?
> 

NODE_DATA(nid)->node_start_pfn needs to be accurate if 
node_set_online(nid).  Since there is no guarantee about page alignment 
from the ACPI spec, removing the roundup() entirely could cause the 
address shift >> PAGE_SIZE to be off by one.  I, like you, do not see the 
need for the ZONE_ALIGN above, but I think we agree that it should be 
replaced with PAGE_SIZE instead.
