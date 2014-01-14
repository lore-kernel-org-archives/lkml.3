Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607AbaANXwq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 18:52:46 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34971 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094AbaANXwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 18:52:43 -0500
Date: Tue, 14 Jan 2014 15:52:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Han Pingtian <hanpt@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
        David Rientjes <rientjes@google.com>, Mel Gorman <mgorman@suse.de>,
        linux-mm@kvack.org, Dave Hansen <dave.hansen@intel.com>
Subject: Re: [RFC] mm: show message when updating min_free_kbytes in thp
Message-Id: <20140114155241.7891fce1fb2b9dfdcde15a8c@linux-foundation.org>
In-Reply-To: <20140114200720.GM4106@localhost.localdomain>
References: <52C5AA61.8060701@intel.com>
	<20140103033303.GB4106@localhost.localdomain>
	<52C6FED2.7070700@intel.com>
	<20140105003501.GC4106@localhost.localdomain>
	<20140106164604.GC27602@dhcp22.suse.cz>
	<20140108101611.GD27937@dhcp22.suse.cz>
	<20140110081744.GC9437@dhcp22.suse.cz>
	<20140114200720.GM4106@localhost.localdomain>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jan 2014 04:07:20 +0800 Han Pingtian <hanpt@linux.vnet.ibm.com> wrote:

> min_free_kbytes may be raised during THP's initialization. Sometimes,
> this will change the value being set by user. Showing message will
> clarify this confusion.
> 
> Only show this message when changing the value set by user according to
> Michal Hocko's suggestion.
> 
> Showing the old value of min_free_kbytes according to Dave Hansen's
> suggestion. This will give user the chance to restore old value of
> min_free_kbytes.
> 

This is all a bit nasty, isn't it?  THP goes and alters min_free_kbytes
to improve its own reliability, but min_free_kbytes is also
user-modifiable.  And over many years we have trained a *lot* of users
to alter min_free_kbytes.  Often to prevent nasty page allocation
failure warnings from net drivers.

So there are probably quite a lot of people out there who are manually
rubbing out THP's efforts.  And there may also be people who are
setting min_free_kbytes to a value which is unnecessarily high for more
recent kernels.

I don't know what to do about this mess though :(

> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -130,8 +130,14 @@ static int set_recommended_min_free_kbytes(void)
>  			      (unsigned long) nr_free_buffer_pages() / 20);
>  	recommended_min <<= (PAGE_SHIFT-10);
>  
> -	if (recommended_min > min_free_kbytes)
> +	if (recommended_min > min_free_kbytes) {
> +		if (user_min_free_kbytes >= 0)
> +			pr_info("raising min_free_kbytes from %d to %lu "
> +				"to help transparent hugepage allocations\n",
> +				min_free_kbytes, recommended_min);

hm, recommended_min shouldn't have had long type.  Oh well, we've done
worse things.

>  		min_free_kbytes = recommended_min;
> +	}
>  	setup_per_zone_wmarks();
>  	return 0;
>  }

