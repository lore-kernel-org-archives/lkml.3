Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426Ab3HALtl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 07:49:41 -0400
Received: from mail-qe0-f44.google.com ([209.85.128.44]:33132 "EHLO
	mail-qe0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753450Ab3HALtk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 07:49:40 -0400
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
Subject: Re: [PATCH] Xen: Fix retry calls into PRIVCMD_MMAPBATCH*.
From: Andres Lagar-Cavilla <andreslc@gridcentric.ca>
In-Reply-To: <51FA4547.7080408@citrix.com>
Date: Thu, 1 Aug 2013 07:49:37 -0400
Cc: Andres Lagar-Cavilla <andreslc@gridcentric.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andres Lagar-Cavilla <andres@lagarcavilla.com>,
        <boris.ostrovsky@oracle.com>
Content-Transfer-Encoding: 7BIT
Message-Id: <5373EBB3-5CF1-4A2F-B821-1DD788877F75@gridcentric.ca>
References: <1375203632-23854-1-git-send-email-andres@lagarcavilla.org> <2BE2F119-7375-4C8D-933D-9BCD5A9B7552@gridcentric.ca> <51FA4547.7080408@citrix.com>
To: David Vrabel <david.vrabel@citrix.com>
X-Mailer: Apple Mail (2.1503)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug 1, 2013, at 7:23 AM, David Vrabel <david.vrabel@citrix.com> wrote:

> On 01/08/13 04:30, Andres Lagar-Cavilla wrote:
>> -- Resend as I haven't seen this hit the lists. Maybe some smtp misconfig. Apologies. Also expanded cc --
>> 
>> When a foreign mapper attempts to map guest frames that are paged out,
>> the mapper receives an ENOENT response and will have to try again
>> while a helper process pages the target frame back in.
>> 
>> Gating checks on PRIVCMD_MMAPBATCH* ioctl args were preventing retries
>> of mapping calls.
> 
> This breaks the auto_translated_physmap case as will allocate another
> set of empty pages and leak the previous set.

David,
not able to follow you here. Under what circumstances will another set of empty pages be allocated? And where? are we talking page table pages?

> 
> This privcmd_enforce_singleshot_mapping() stuff seems very odd anyway.
> Does anyone know what it was for originally?  It would be preferrable if
> we could update the mappings with a new set of foreign MFNs without
> having to tear down the VMA and recreate a new VMA.

I believe it's mostly historical. I agree with you on principle, but recreating VMAs is super-cheap.

Andres
> 
>> --- a/drivers/xen/privcmd.c
>> +++ b/drivers/xen/privcmd.c
> [...]
>> +/* For MMAPBATCH*. This allows asserting the singleshot mapping
>> + * on a per pfn/pte basis. Mapping calls that fail with ENOENT
>> + * can be then retried until success. */
> 
> Comment coding style.
> 
> David

