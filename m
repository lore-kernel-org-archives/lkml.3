Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757013AbaGBVZu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 17:25:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38149 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755868AbaGBVZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 17:25:48 -0400
Date: Wed, 2 Jul 2014 17:25:29 -0400
From: Luiz Capitulino <lcapitulino@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch] mm, hugetlb: generalize writes to nr_hugepages
Message-ID: <20140702172529.347f2dd2@redhat.com>
In-Reply-To: <alpine.DEB.2.02.1406301655480.27587@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1406301655480.27587@chino.kir.corp.google.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jun 2014 16:57:06 -0700 (PDT)
David Rientjes <rientjes@google.com> wrote:

> Three different interfaces alter the maximum number of hugepages for an
> hstate:
> 
>  - /proc/sys/vm/nr_hugepages for global number of hugepages of the default
>    hstate,
> 
>  - /sys/kernel/mm/hugepages/hugepages-X/nr_hugepages for global number of
>    hugepages for a specific hstate, and
> 
>  - /sys/kernel/mm/hugepages/hugepages-X/nr_hugepages/mempolicy for number of
>    hugepages for a specific hstate over the set of allowed nodes.
> 
> Generalize the code so that a single function handles all of these writes 
> instead of duplicating the code in two different functions.
> 
> This decreases the number of lines of code, but also reduces the size of
> .text by about half a percent since set_max_huge_pages() can be inlined.
> 
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  mm/hugetlb.c | 61 ++++++++++++++++++++++++++----------------------------------
>  1 file changed, 26 insertions(+), 35 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1734,21 +1734,13 @@ static ssize_t nr_hugepages_show_common(struct kobject *kobj,
>  	return sprintf(buf, "%lu\n", nr_huge_pages);
>  }
>  
> -static ssize_t nr_hugepages_store_common(bool obey_mempolicy,
> -			struct kobject *kobj, struct kobj_attribute *attr,
> -			const char *buf, size_t len)
> +static ssize_t __nr_hugepages_store_common(bool obey_mempolicy,
> +					   struct hstate *h, int nid,
> +					   unsigned long count, size_t len)
>  {
>  	int err;
> -	int nid;
> -	unsigned long count;
> -	struct hstate *h;
>  	NODEMASK_ALLOC(nodemask_t, nodes_allowed, GFP_KERNEL | __GFP_NORETRY);
>  
> -	err = kstrtoul(buf, 10, &count);
> -	if (err)
> -		goto out;
> -
> -	h = kobj_to_hstate(kobj, &nid);
>  	if (hstate_is_gigantic(h) && !gigantic_page_supported()) {
>  		err = -EINVAL;
>  		goto out;
> @@ -1784,6 +1776,23 @@ out:
>  	return err;
>  }
>  
> +static ssize_t nr_hugepages_store_common(bool obey_mempolicy,
> +					 struct kobject *kobj, const char *buf,
> +					 size_t len)
> +{
> +	struct hstate *h;
> +	unsigned long count;
> +	int nid;
> +	int err;
> +
> +	err = kstrtoul(buf, 10, &count);
> +	if (err)
> +		return err;
> +
> +	h = kobj_to_hstate(kobj, &nid);
> +	return __nr_hugepages_store_common(obey_mempolicy, h, nid, count, len);
> +}
> +
>  static ssize_t nr_hugepages_show(struct kobject *kobj,
>  				       struct kobj_attribute *attr, char *buf)
>  {
> @@ -1793,7 +1802,7 @@ static ssize_t nr_hugepages_show(struct kobject *kobj,
>  static ssize_t nr_hugepages_store(struct kobject *kobj,
>  	       struct kobj_attribute *attr, const char *buf, size_t len)
>  {
> -	return nr_hugepages_store_common(false, kobj, attr, buf, len);
> +	return nr_hugepages_store_common(false, kobj, buf, len);
>  }
>  HSTATE_ATTR(nr_hugepages);
>  
> @@ -1812,7 +1821,7 @@ static ssize_t nr_hugepages_mempolicy_show(struct kobject *kobj,
>  static ssize_t nr_hugepages_mempolicy_store(struct kobject *kobj,
>  	       struct kobj_attribute *attr, const char *buf, size_t len)
>  {
> -	return nr_hugepages_store_common(true, kobj, attr, buf, len);
> +	return nr_hugepages_store_common(true, kobj, buf, len);
>  }
>  HSTATE_ATTR(nr_hugepages_mempolicy);
>  #endif
> @@ -2248,36 +2257,18 @@ static int hugetlb_sysctl_handler_common(bool obey_mempolicy,
>  			 void __user *buffer, size_t *length, loff_t *ppos)
>  {
>  	struct hstate *h = &default_hstate;
> -	unsigned long tmp;
> +	unsigned long tmp = h->max_huge_pages;
>  	int ret;
>  
> -	if (!hugepages_supported())
> -		return -ENOTSUPP;

Shouldn't you add this check to __nr_hugepages_store_common()? Otherwise
looks good to me.

> -
> -	tmp = h->max_huge_pages;
> -
> -	if (write && hstate_is_gigantic(h) && !gigantic_page_supported())
> -		return -EINVAL;
> -
>  	table->data = &tmp;
>  	table->maxlen = sizeof(unsigned long);
>  	ret = proc_doulongvec_minmax(table, write, buffer, length, ppos);
>  	if (ret)
>  		goto out;
>  
> -	if (write) {
> -		NODEMASK_ALLOC(nodemask_t, nodes_allowed,
> -						GFP_KERNEL | __GFP_NORETRY);
> -		if (!(obey_mempolicy &&
> -			       init_nodemask_of_mempolicy(nodes_allowed))) {
> -			NODEMASK_FREE(nodes_allowed);
> -			nodes_allowed = &node_states[N_MEMORY];
> -		}
> -		h->max_huge_pages = set_max_huge_pages(h, tmp, nodes_allowed);
> -
> -		if (nodes_allowed != &node_states[N_MEMORY])
> -			NODEMASK_FREE(nodes_allowed);
> -	}
> +	if (write)
> +		ret = __nr_hugepages_store_common(obey_mempolicy, h,
> +						  NUMA_NO_NODE, tmp, *length);
>  out:
>  	return ret;
>  }
> 

