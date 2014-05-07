Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752435AbaEGVVN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 17:21:13 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:35340 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111AbaEGVVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 17:21:12 -0400
Date: Wed, 7 May 2014 14:21:10 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Greg Thelen <gthelen@google.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch v3 2/6] mm, compaction: return failed migration target
 pages back to freelist
In-Reply-To: <20140507141534.d4def933b3a9999e7826df5c@linux-foundation.org>
Message-ID: <alpine.DEB.2.02.1405071420110.8454@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1404301744110.8415@chino.kir.corp.google.com> <alpine.DEB.2.02.1405011434140.23898@chino.kir.corp.google.com> <alpine.DEB.2.02.1405061920470.18635@chino.kir.corp.google.com> <alpine.DEB.2.02.1405061921040.18635@chino.kir.corp.google.com>
 <20140507141534.d4def933b3a9999e7826df5c@linux-foundation.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 May 2014, Andrew Morton wrote:

> > Memory compaction works by having a "freeing scanner" scan from one end of a 
> > zone which isolates pages as migration targets while another "migrating scanner" 
> > scans from the other end of the same zone which isolates pages for migration.
> > 
> > When page migration fails for an isolated page, the target page is returned to 
> > the system rather than the freelist built by the freeing scanner.  This may 
> > require the freeing scanner to continue scanning memory after suitable migration 
> > targets have already been returned to the system needlessly.
> > 
> > This patch returns destination pages to the freeing scanner freelist when page 
> > migration fails.  This prevents unnecessary work done by the freeing scanner but 
> > also encourages memory to be as compacted as possible at the end of the zone.
> > 
> > Reported-by: Greg Thelen <gthelen@google.com>
> 
> What did Greg actually report?  IOW, what if any observable problem is
> being fixed here?
> 

Greg reported by code inspection that he found isolated free pages were 
returned back to the VM rather than the compaction freelist.  This will 
cause holes behind the free scanner and cause it to reallocate additional 
memory if necessary later.
