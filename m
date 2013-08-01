Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066Ab3HALYG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 07:24:06 -0400
Received: from smtp.citrix.com ([66.165.176.89]:35768 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751418Ab3HALYE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 07:24:04 -0400
X-IronPort-AV: E=Sophos;i="4.89,793,1367971200"; 
   d="scan'208";a="40720716"
Message-ID: <51FA4547.7080408@citrix.com>
Date: Thu, 1 Aug 2013 12:23:51 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Andres Lagar-Cavilla <andreslc@gridcentric.ca>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andres Lagar-Cavilla <andres@lagarcavilla.com>,
        <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH] Xen: Fix retry calls into PRIVCMD_MMAPBATCH*.
References: <1375203632-23854-1-git-send-email-andres@lagarcavilla.org> <2BE2F119-7375-4C8D-933D-9BCD5A9B7552@gridcentric.ca>
In-Reply-To: <2BE2F119-7375-4C8D-933D-9BCD5A9B7552@gridcentric.ca>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/13 04:30, Andres Lagar-Cavilla wrote:
> -- Resend as I haven't seen this hit the lists. Maybe some smtp misconfig. Apologies. Also expanded cc --
> 
> When a foreign mapper attempts to map guest frames that are paged out,
> the mapper receives an ENOENT response and will have to try again
> while a helper process pages the target frame back in.
> 
> Gating checks on PRIVCMD_MMAPBATCH* ioctl args were preventing retries
> of mapping calls.

This breaks the auto_translated_physmap case as will allocate another
set of empty pages and leak the previous set.

This privcmd_enforce_singleshot_mapping() stuff seems very odd anyway.
Does anyone know what it was for originally?  It would be preferrable if
we could update the mappings with a new set of foreign MFNs without
having to tear down the VMA and recreate a new VMA.

> --- a/drivers/xen/privcmd.c
> +++ b/drivers/xen/privcmd.c
[...]
> +/* For MMAPBATCH*. This allows asserting the singleshot mapping
> + * on a per pfn/pte basis. Mapping calls that fail with ENOENT
> + * can be then retried until success. */

Comment coding style.

David
