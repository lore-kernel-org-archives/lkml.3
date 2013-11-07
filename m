Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382Ab3KGLM4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 06:12:56 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:51985 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783Ab3KGLMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 06:12:55 -0500
X-IronPort-AV: E=Sophos;i="4.93,651,1378857600"; 
   d="scan'208";a="68985386"
Message-ID: <527B75B4.20700@citrix.com>
Date: Thu, 7 Nov 2013 11:12:52 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Roger Pau Monne <roger.pau@citrix.com>
CC: <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH v3] p2m: use GNTTABOP_unmap_and_duplicate if available
References: <1383579524-12465-1-git-send-email-roger.pau@citrix.com>
In-Reply-To: <1383579524-12465-1-git-send-email-roger.pau@citrix.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/13 15:38, Roger Pau Monne wrote:
> The new GNTTABOP_unmap_and_duplicate operation doesn't zero the
> mapping passed in new_addr, allowing us to perform batch unmaps in p2m
> code without requiring the use of a multicall.

I have recently investigated some problems that were caused by a user
space process using gntdev.  It was unmapping page that still had
outstanding I/O.  This caused a number of failures:

1. Oopses due to swiotlb_bounce() attempting to memcpy() back to a page
that now has a read-only mapping to a scratch page MFN.

2. Bad page errors due to the balloon page being freed by gntdev while
the page count > 1 and the balloon driver setting page count to 1 and
freeing the page.

I think we need to take a step back and look at the design of the gntdev
device to make it handle misbehaved or crashing programs.

In particular, I think we need to use regular (non-ballooned) pages and
restore their original direct mappings when grant unmapping.  My initial
thoughts are that this would require a GNTTABOP_unmap_and_replace
variant that takes a GFN direct instead of a finding the GFN via a
virtual address.

I think it is best to hold off on any optimization attempts here until
we get the gntdev design right.

David
