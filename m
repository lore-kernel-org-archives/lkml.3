Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916Ab3HUASa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 20:18:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40397 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687Ab3HUAS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 20:18:29 -0400
Date: Tue, 20 Aug 2013 17:18:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Rik van Riel <riel@redhat.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/4] mm/pgtable: Fix continue to preallocate pmds
 even if failure occurrence
Message-Id: <20130820171816.1b759e87.akpm@linux-foundation.org>
In-Reply-To: <5213fe45.660c420a.4066.ffffd8c7SMTPIN_ADDED_BROKEN@mx.google.com>
References: <1376981696-4312-1-git-send-email-liwanp@linux.vnet.ibm.com>
	<20130820160418.5639c4f9975b84dc8dede014@linux-foundation.org>
	<5213fe45.660c420a.4066.ffffd8c7SMTPIN_ADDED_BROKEN@mx.google.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Aug 2013 07:39:35 +0800 Wanpeng Li <liwanp@linux.vnet.ibm.com> wrote:

> >Nope.  If the error path is taken, free_pmds() will free uninitialised
> >items from pmds[], which is a local in pgd_alloc() and contains random
> >stack junk.  The kernel will crash.
> >
> >You could pass an nr_pmds argument to free_pmds(), or zero out the
> >remaining items on the error path.  However, although the current code
> >is a bit kooky, I don't see that it is harmful in any way.
> >
> 
> There is a check in free_pmds():
> 
> if (pmds[i])
> 	free_page((unsigned long)pmds[i]);
> 
> which will avoid the issue you mentioned.

pmds[i] is uninitialized.  It gets allocated
on the stack in pgd_alloc() and does not get zeroed.
