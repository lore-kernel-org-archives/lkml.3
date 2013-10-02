Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242Ab3JBAhS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 20:37:18 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46725 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328Ab3JBAhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 20:37:15 -0400
Message-ID: <524B6AB0.6030009@jp.fujitsu.com>
Date: Tue, 01 Oct 2013 20:37:04 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: ccross@android.com
CC: linux-kernel@vger.kernel.org, penberg@kernel.org, dave.hansen@intel.com,
        peterz@infradead.org, mingo@kernel.org, oleg@redhat.com,
        ebiederm@xmission.com, jan.glauber@gmail.com, rob@landley.net,
        akpm@linux-foundation.org, gorcunov@openvz.org, rientjes@google.com,
        dave@gnu.org, keescook@chromium.org, xemul@parallels.com,
        liwanp@linux.vnet.ibm.com, walken@google.com, mgorman@suse.de,
        riel@redhat.com, jiang.liu@huawei.com, khlebnikov@openvz.org,
        paulmck@linux.vnet.ibm.com, dhowells@redhat.com, arnd@arndb.de,
        davej@redhat.com, holt@sgi.com, rafael.j.wysocki@intel.com,
        shli@fusionio.com, sasha.levin@oracle.com,
        kosaki.motohiro@jp.fujitsu.com, hughd@google.com, hannes@cmpxchg.org,
        a.p.zijlstra@chello.nl, linux-doc@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCHv2 2/2] mm: add a field to store names for private anonymous
 memory
References: <1380658901-11666-1-git-send-email-ccross@android.com> <1380658901-11666-2-git-send-email-ccross@android.com>
In-Reply-To: <1380658901-11666-2-git-send-email-ccross@android.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static void seq_print_vma_name(struct seq_file *m, struct vm_area_struct *vma)
> +{
> +	const char __user *name = vma_get_anon_name(vma);
> +	struct mm_struct *mm = vma->vm_mm;
> +
> +	unsigned long page_start_vaddr;
> +	unsigned long page_offset;
> +	unsigned long num_pages;
> +	unsigned long max_len = NAME_MAX;
> +	int i;
> +
> +	page_start_vaddr = (unsigned long)name & PAGE_MASK;
> +	page_offset = (unsigned long)name - page_start_vaddr;
> +	num_pages = DIV_ROUND_UP(page_offset + max_len, PAGE_SIZE);
> +
> +	seq_puts(m, "[anon:");
> +
> +	for (i = 0; i < num_pages; i++) {
> +		int len;
> +		int write_len;
> +		const char *kaddr;
> +		long pages_pinned;
> +		struct page *page;
> +
> +		pages_pinned = get_user_pages(current, mm, page_start_vaddr,
> +				1, 0, 0, &page, NULL);
> +		if (pages_pinned < 1) {
> +			seq_puts(m, "<fault>]");
> +			return;
> +		}
> +
> +		kaddr = (const char *)kmap(page);
> +		len = min(max_len, PAGE_SIZE - page_offset);

You can't show the name if the name is placed in end of page.


