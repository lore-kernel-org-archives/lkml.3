Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145AbaEFVwU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 17:52:20 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:63415 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbaEFVwT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 17:52:19 -0400
Subject: Re: [PATCH 6/6] mm: Postpone the disabling of kmemleak early logging
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Content-Type: text/plain; charset=windows-1252
From: Catalin Marinas <catalin.marinas@arm.com>
In-Reply-To: <536926DD.30402@oracle.com>
Date: Tue, 6 May 2014 22:52:16 +0100
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Li Zefan <lizefan@huawei.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <49655FE2-17CA-433C-8F4A-76DD6C2FEF61@arm.com>
References: <1399038070-1540-1-git-send-email-catalin.marinas@arm.com> <1399038070-1540-7-git-send-email-catalin.marinas@arm.com> <5368FDBB.8070106@oracle.com> <20140506170549.GM23957@arm.com> <536926DD.30402@oracle.com>
To: Sasha Levin <sasha.levin@oracle.com>
X-Mailer: Apple Mail (2.1874)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 May 2014, at 19:15, Sasha Levin <sasha.levin@oracle.com> wrote:
> On 05/06/2014 01:05 PM, Catalin Marinas wrote:
>> On Tue, May 06, 2014 at 04:20:27PM +0100, Sasha Levin wrote:
>>> On 05/02/2014 09:41 AM, Catalin Marinas wrote:
>>>> Currently, kmemleak_early_log is disabled at the beginning of the
>>>> kmemleak_init() function, before the full kmemleak tracing is actually
>>>> enabled. In this small window, kmem_cache_create() is called by kmemleak
>>>> which triggers additional memory allocation that are not traced. This
>>>> patch moves the kmemleak_early_log disabling further down and at the
>>>> same time with full kmemleak enabling.
>>>> 
>>>> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
>>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>> 
>>> This patch makes the kernel die during the boot process:
>>> 
>>> [   24.471801] BUG: unable to handle kernel paging request at ffffffff922f2b93
>>> [   24.472496] IP: [<ffffffff922f2b93>] log_early+0x0/0xcd
>> 
>> Thanks for reporting this. I assume you run with
>> CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF enabled and kmemleak_early_log remains
>> set even though kmemleak is not in use.
>> 
>> Does the patch below fix it?
> 
> Nope, that didn't help as I don't have DEBUG_KMEMLEAK_DEFAULT_OFF enabled.
> 
> For reference:
> 
> $ cat .config | grep KMEMLEAK
> CONFIG_HAVE_DEBUG_KMEMLEAK=y
> CONFIG_DEBUG_KMEMLEAK=y
> CONFIG_DEBUG_KMEMLEAK_EARLY_LOG_SIZE=400
> # CONFIG_DEBUG_KMEMLEAK_TEST is not set
> # CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF is not set

I assume your dmesg shows some kmemleak error during boot? I’ll send
another patch tomorrow.

The code around kmemleak_init was changed by commit 8910ae896c8c
(kmemleak: change some global variables to int). It looks like it
wasn’t just a simple conversion but slightly changed the
kmemleak_early_log logic which led to false positives for the kmemleak
cache objects and that’s what my patch was trying to solve.

The failure is caused by kmemleak_alloc() still calling log_early() much
later after the __init section has been freed because kmemleak_early_log
hasn’t been set to 0 (the default off is one path, another is the
kmemleak_error path).

Catalin