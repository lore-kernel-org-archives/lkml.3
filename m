Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910Ab3CDMVl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 07:21:41 -0500
Received: from mail-wi0-f196.google.com ([209.85.212.196]:54678 "EHLO
	mail-wi0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756660Ab3CDMV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 07:21:27 -0500
MIME-Version: 1.0
In-Reply-To: <51347A6E.8010608@iskon.hr>
References: <CAAO_Xo7sEH5W_9xoOjax8ynyjLCx7GBpse+EU0mF=9mEBFhrgw@mail.gmail.com>
	<51347A6E.8010608@iskon.hr>
Date: Mon, 4 Mar 2013 20:21:25 +0800
Message-ID: <CAAO_Xo6bWo4QOvdowLG88NoQr2AEq4jxCWHQXeA8g-VBT4Yk9Q@mail.gmail.com>
Subject: Re: Inactive memory keep growing and how to release it?
From: Lenky Gao <lenky.gao@gmail.com>
To: Zlatko Calusic <zlatko.calusic@iskon.hr>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/4 Zlatko Calusic <zlatko.calusic@iskon.hr>:
>
> The drop_caches mechanism doesn't free dirty page cache pages. And your bash
> script is creating a lot of dirty pages. Run it like this and see if it
> helps your case:
>
> sync; echo 3 > /proc/sys/vm/drop_caches

Thanks for your advice.

The inactive memory still cannot be reclaimed after i execute the sync command:

# cat /proc/meminfo | grep Inactive\(file\);
Inactive(file):   882824 kB
# sync;
# echo 3 > /proc/sys/vm/drop_caches
# cat /proc/meminfo | grep Inactive\(file\);
Inactive(file):   777664 kB

I find these page becomes orphaned in this function, but do not understand why:

/*
 * If truncate cannot remove the fs-private metadata from the page, the page
 * becomes orphaned.  It will be left on the LRU and may even be mapped into
 * user pagetables if we're racing with filemap_fault().
 *
 * We need to bale out if page->mapping is no longer equal to the original
 * mapping.  This happens a) when the VM reclaimed the page while we waited on
 * its lock, b) when a concurrent invalidate_mapping_pages got there first and
 * c) when tmpfs swizzles a page between a tmpfs inode and swapper_space.
 */
static int
truncate_complete_page(struct address_space *mapping, struct page *page)
{
...

My file system type is ext3, mounted with the opteion data=journal and
it is easy to reproduce.


-- 
Regards,

Lenky
