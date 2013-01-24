Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131Ab3AXJsF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 04:48:05 -0500
Received: from mx0.aculab.com ([213.249.233.131]:54942 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752869Ab3AXJr7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 04:47:59 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] vhost-net: fall back to vmalloc if high-order allocation fails
Date: Thu, 24 Jan 2013 09:45:50 -0000
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B711E@saturn3.aculab.com>
In-Reply-To: <87k3r31vbc.fsf@silenus.orebokech.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] vhost-net: fall back to vmalloc if high-order allocation fails
Thread-Index: Ac35qo0ZiCxfFowiSim2BiKXxTNlLQAaS1xQ
References: <87k3r31vbc.fsf@silenus.orebokech.com>
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Romain Francoise" <romain@orebokech.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc: <kvm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	n = kmalloc(sizeof *n, GFP_KERNEL | __GFP_NOWARN);
> +	if (!n)
> +		n = vmalloc(sizeof *n);

I'm slightly confused by this construct.
I thought kmalloc(... GFP_KERNEL) would sleep waiting for
memory (rather than return NULL).

I realise that (for multi-page sizes) that kmalloc() and
vmalloc() both need to find a contiguous block of kernel
virtual addresses - in different address ranges, and
that vmalloc() then has to find physical memory pages
(which will not be contiguous).

I think this means that kmalloc() is likely to be faster
(if it doesn't have to sleep), but that vmalloc() is
allocating from a much larger resource.

This make me that that large allocations that are not
temporary should probably be allocated with vmalloc().

Is there a 'NO_SLEEP' flag to kmalloc()? is that all
GFP_ATOMIC requests? If so you might try a non-sleeping
kmalloc() with a vmalloc() if it fails.

This all looks as though there should be a GFP_NONCONTIG
flag (or similar) so that kmalloc() can make a decision itself.

Of at least a wrapper - like the one for free().

	David



