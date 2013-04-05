Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163051Ab3DEWXK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 18:23:10 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:36840 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162991Ab3DEWXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 18:23:08 -0400
Message-ID: <515F4ECB.9050105@gmail.com>
Date: Fri, 05 Apr 2013 18:23:07 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, Hillf Danton <dhillf@gmail.com>,
        linux-kernel@vger.kernel.org, kosaki.motohiro@gmail.com
Subject: Re: [PATCH 07/10] mbind: add hugepage migration code to mbind()
References: <1363983835-20184-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1363983835-20184-8-git-send-email-n-horiguchi@ah.jp.nec.com> <20130325134926.GZ2154@dhcp22.suse.cz>
In-Reply-To: <20130325134926.GZ2154@dhcp22.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> -	if (!new_hpage)
>> +	/*
>> +	 * Getting a new hugepage with alloc_huge_page() (which can happen
>> +	 * when migration is caused by mbind()) can return ERR_PTR value,
>> +	 * so we need take care of the case here.
>> +	 */
>> +	if (!new_hpage || IS_ERR_VALUE(new_hpage))
>>  		return -ENOMEM;
> 
> Please no. get_new_page returns NULL or a page. You are hooking a wrong
> callback here. The error value doesn't make any sense here. IMO you
> should just wrap alloc_huge_page by something that returns NULL or page.

I suggest just opposite way. new_vma_page() always return ENOMEM, ENOSPC etc instad 
of NULL. and caller propegate it to userland.
I guess userland want to distingush why mbind was failed.

Anyway, If new_vma_page() have a change to return both NULL and -ENOMEM. That's a bug.

