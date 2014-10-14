Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932499AbaJNOFc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 10:05:32 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:62387 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755286AbaJNOFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 10:05:31 -0400
Message-ID: <543D2DA8.7030600@martingkelly.com>
Date: Tue, 14 Oct 2014 07:05:28 -0700
From: Martin Kelly <martin@martingkelly.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xenproject.org, x86@kernel.org
CC: mingo@redhat.com, Martin Kelly <martkell@amazon.com>, hpa@zytor.com,
        boris.ostrovsky@oracle.com, tglx@linutronix.de
Subject: Re: [Xen-devel] [PATCH 1/2] x86: separate out sanitize_e820_map return
 codes
References: <1413253817-6943-1-git-send-email-martin@martingkelly.com> <543CEDFD.6020501@citrix.com>
In-Reply-To: <543CEDFD.6020501@citrix.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2014 02:33 AM, David Vrabel wrote:
> On 14/10/14 03:30, Martin Kelly wrote:
>> Previously, sanitize_e820_map returned -1 in all cases in which it did
>> nothing. However, sanitize_e820_map can do nothing either because the
>> input map has size 1 (this is ok) or because the input map passed in is
>> invalid (likely an issue). It is nice for the caller to be able to
>> distinguish the two cases and treat them separately.
> 
> Wouldn't it be more sensible to return 0 (success) in the case of a
> single entry map?  IMO, a 1 entry map is by definition sanitized.
> 
> David
> 

I had that thought as I writing the patch, but I was worried about breaking callers. Luckily, it appears there are only 11 callers in the kernel, and all except one either:
(1) Don't check the return value of sanitize_e820_map or
(2) Check against 0 rather than < 0

One caller is checking for < 0: arch/x86/kernel/e820.c:finish_e820_parsing :
        if (userdef) {
                u32 nr = e820.nr_map;

                if (sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &nr) < 0)
                        early_panic("Invalid user supplied memory map");
                e820.nr_map = nr;

                printk(KERN_INFO "e820: user-defined physical RAM map:\n");
                e820_print_map("user");
        }

This seems like a bug, as if the user-defined memory map is size 1, there will be an erroneous panic.

I will issue a new revision to change the return values to 0 or -1, with 0 including the size 1 case. In addition, I will add a patch to either change all the callers to actually check this value or to panic in the error case of sanitize_e820_map itself. Which do you think is a cleaner approach?
