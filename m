Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740AbaGHWLQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 18:11:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36821 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179AbaGHWLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 18:11:15 -0400
Date: Tue, 8 Jul 2014 15:11:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: Luiz Capitulino <lcapitulino@redhat.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch] mm, hugetlb: generalize writes to nr_hugepages
Message-Id: <20140708151113.dd1469faea6177959356620b@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.02.1407021743340.4970@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1406301655480.27587@chino.kir.corp.google.com>
	<20140702172529.347f2dd2@redhat.com>
	<alpine.DEB.2.02.1407021743340.4970@chino.kir.corp.google.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jul 2014 17:44:46 -0700 (PDT) David Rientjes <rientjes@google.com> wrote:

> > > @@ -2248,36 +2257,18 @@ static int hugetlb_sysctl_handler_common(bool obey_mempolicy,
> > >  			 void __user *buffer, size_t *length, loff_t *ppos)
> > >  {
> > >  	struct hstate *h = &default_hstate;
> > > -	unsigned long tmp;
> > > +	unsigned long tmp = h->max_huge_pages;
> > >  	int ret;
> > >  
> > > -	if (!hugepages_supported())
> > > -		return -ENOTSUPP;
> > 
> > Shouldn't you add this check to __nr_hugepages_store_common()? Otherwise
> > looks good to me.
> > 
> 
> Hmm, I think you're right but I don't think __nr_hugepages_store_common() 
> is the right place: if we have a legitimate hstate for the sysfs tunables 
> then we should support hugepages.  I think this should be kept in 
> hugetlb_sysctl_handler_common().

This?

--- a/mm/hugetlb.c~mm-hugetlb-generalize-writes-to-nr_hugepages-fix
+++ a/mm/hugetlb.c
@@ -2260,6 +2260,9 @@ static int hugetlb_sysctl_handler_common
 	unsigned long tmp = h->max_huge_pages;
 	int ret;
 
+	if (!hugepages_supported())
+		return -ENOTSUPP;
+
 	table->data = &tmp;
 	table->maxlen = sizeof(unsigned long);
 	ret = proc_doulongvec_minmax(table, write, buffer, length, ppos);
_

