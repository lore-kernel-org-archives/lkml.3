Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760176Ab3CICOY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 21:14:24 -0500
Received: from mail-ia0-f172.google.com ([209.85.210.172]:64603 "EHLO
	mail-ia0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759947Ab3CICOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 21:14:22 -0500
Message-ID: <513A9AF7.4020909@gmail.com>
Date: Sat, 09 Mar 2013 10:14:15 +0800
From: Will Huck <will.huckk@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Lenky Gao <lenky.gao@gmail.com>
CC: Zlatko Calusic <zlatko.calusic@iskon.hr>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: Inactive memory keep growing and how to release it?
References: <CAAO_Xo7sEH5W_9xoOjax8ynyjLCx7GBpse+EU0mF=9mEBFhrgw@mail.gmail.com> <51347A6E.8010608@iskon.hr> <CAAO_Xo6bWo4QOvdowLG88NoQr2AEq4jxCWHQXeA8g-VBT4Yk9Q@mail.gmail.com>
In-Reply-To: <CAAO_Xo6bWo4QOvdowLG88NoQr2AEq4jxCWHQXeA8g-VBT4Yk9Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc experts. Hugh, Johannes,

On 03/04/2013 08:21 PM, Lenky Gao wrote:
> 2013/3/4 Zlatko Calusic <zlatko.calusic@iskon.hr>:
>> The drop_caches mechanism doesn't free dirty page cache pages. And your bash
>> script is creating a lot of dirty pages. Run it like this and see if it
>> helps your case:
>>
>> sync; echo 3 > /proc/sys/vm/drop_caches
> Thanks for your advice.
>
> The inactive memory still cannot be reclaimed after i execute the sync command:
>
> # cat /proc/meminfo | grep Inactive\(file\);
> Inactive(file):   882824 kB
> # sync;
> # echo 3 > /proc/sys/vm/drop_caches
> # cat /proc/meminfo | grep Inactive\(file\);
> Inactive(file):   777664 kB
>
> I find these page becomes orphaned in this function, but do not understand why:
>
> /*
>   * If truncate cannot remove the fs-private metadata from the page, the page
>   * becomes orphaned.  It will be left on the LRU and may even be mapped into
>   * user pagetables if we're racing with filemap_fault().
>   *
>   * We need to bale out if page->mapping is no longer equal to the original
>   * mapping.  This happens a) when the VM reclaimed the page while we waited on
>   * its lock, b) when a concurrent invalidate_mapping_pages got there first and
>   * c) when tmpfs swizzles a page between a tmpfs inode and swapper_space.
>   */
> static int
> truncate_complete_page(struct address_space *mapping, struct page *page)
> {
> ...
>
> My file system type is ext3, mounted with the opteion data=journal and
> it is easy to reproduce.
>
>

