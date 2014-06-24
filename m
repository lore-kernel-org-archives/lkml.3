Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049AbaFXWZ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 18:25:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37328 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbaFXWZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 18:25:25 -0400
Date: Tue, 24 Jun 2014 15:25:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH] mm/vmalloc.c: add a schedule point to vmalloc()
Message-Id: <20140624152524.f65d62a08538a63b3dc96838@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.02.1406241517560.29176@chino.kir.corp.google.com>
References: <1403618407.3796.15.camel@edumazet-glaptop2.roam.corp.google.com>
	<alpine.DEB.2.02.1406241517560.29176@chino.kir.corp.google.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jun 2014 15:18:57 -0700 (PDT) David Rientjes <rientjes@google.com> wrote:

> On Tue, 24 Jun 2014, Eric Dumazet wrote:
> 
> > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > index f64632b67196..05a145ed1332 100644
> > --- a/mm/vmalloc.c
> > +++ b/mm/vmalloc.c
> > @@ -1602,6 +1602,7 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
> >  			goto fail;
> >  		}
> >  		area->pages[i] = page;
> > +		cond_resched();
> >  	}
> >  
> >  	if (map_vm_area(area, prot, &pages))
> 
> Now that we pass the gfp mask into vmalloc() and all allocations aren't 
> inherently GFP_KERNEL, I think this should only be done for (gfp_mask & 
> __GFP_WAIT).

spose so.

--- a/mm/vmalloc.c~mm-vmallocc-add-a-schedule-point-to-vmalloc-fix
+++ a/mm/vmalloc.c
@@ -1602,7 +1602,8 @@ static void *__vmalloc_area_node(struct
 			goto fail;
 		}
 		area->pages[i] = page;
-		cond_resched();
+		if (gfp_mask & __GFP_WAIT)
+			cond_resched();
 	}
 
 	if (map_vm_area(area, prot, &pages))


