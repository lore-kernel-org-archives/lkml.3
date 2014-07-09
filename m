Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844AbaGINbx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 09:31:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24506 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753923AbaGINbw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 09:31:52 -0400
Date: Wed, 9 Jul 2014 09:31:37 -0400
From: Luiz Capitulino <lcapitulino@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch] mm, hugetlb: generalize writes to nr_hugepages
Message-ID: <20140709093137.5a6ab051@redhat.com>
In-Reply-To: <20140708151113.dd1469faea6177959356620b@linux-foundation.org>
References: <alpine.DEB.2.02.1406301655480.27587@chino.kir.corp.google.com>
	<20140702172529.347f2dd2@redhat.com>
	<alpine.DEB.2.02.1407021743340.4970@chino.kir.corp.google.com>
	<20140708151113.dd1469faea6177959356620b@linux-foundation.org>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jul 2014 15:11:13 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 2 Jul 2014 17:44:46 -0700 (PDT) David Rientjes <rientjes@google.com> wrote:
> 
> > > > @@ -2248,36 +2257,18 @@ static int hugetlb_sysctl_handler_common(bool obey_mempolicy,
> > > >  			 void __user *buffer, size_t *length, loff_t *ppos)
> > > >  {
> > > >  	struct hstate *h = &default_hstate;
> > > > -	unsigned long tmp;
> > > > +	unsigned long tmp = h->max_huge_pages;
> > > >  	int ret;
> > > >  
> > > > -	if (!hugepages_supported())
> > > > -		return -ENOTSUPP;
> > > 
> > > Shouldn't you add this check to __nr_hugepages_store_common()? Otherwise
> > > looks good to me.
> > > 
> > 
> > Hmm, I think you're right but I don't think __nr_hugepages_store_common() 
> > is the right place: if we have a legitimate hstate for the sysfs tunables 
> > then we should support hugepages.  I think this should be kept in 
> > hugetlb_sysctl_handler_common().
> 
> This?

Yes.

> 
> --- a/mm/hugetlb.c~mm-hugetlb-generalize-writes-to-nr_hugepages-fix
> +++ a/mm/hugetlb.c
> @@ -2260,6 +2260,9 @@ static int hugetlb_sysctl_handler_common
>  	unsigned long tmp = h->max_huge_pages;
>  	int ret;
>  
> +	if (!hugepages_supported())
> +		return -ENOTSUPP;
> +
>  	table->data = &tmp;
>  	table->maxlen = sizeof(unsigned long);
>  	ret = proc_doulongvec_minmax(table, write, buffer, length, ppos);
> _
> 

