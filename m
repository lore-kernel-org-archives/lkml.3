Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934133Ab3BMPI3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 10:08:29 -0500
Received: from service87.mimecast.com ([91.220.42.44]:58543 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755679Ab3BMPI1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 10:08:27 -0500
Message-ID: <1360768102.4045.107.camel@hornet>
Subject: Re: [RFC PATCH] virt_mmio: fix signature checking for BE guests
From: Pawel Moll <pawel.moll@arm.com>
To: Marc Zyngier <Marc.Zyngier@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>
Date: Wed, 13 Feb 2013 15:08:22 +0000
In-Reply-To: <1360765538-18097-1-git-send-email-marc.zyngier@arm.com>
References: <1360765538-18097-1-git-send-email-marc.zyngier@arm.com>
X-Mailer: Evolution 3.6.2-0ubuntu0.1
Mime-Version: 1.0
X-OriginalArrivalTime: 13 Feb 2013 15:08:23.0481 (UTC) FILETIME=[F78A7290:01CE09FB]
X-MC-Unique: 113021315082503001
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-02-13 at 14:25 +0000, Marc Zyngier wrote:
> Using readl() to read the magic value and then memcmp() to check it
> fails on BE, as bytes will be the other way around (by virtue of
> the registers to follow the endianess of the guest).

Hm. Interesting. I missed the fact that readl() as a "PCI operation"
will always assume LE values...

> Fix it by encoding the magic as an integer instead of a string.
> So I'm not completely sure this is the right fix, 

It seems right, however...

> - Using __raw_readl() instead. Is that a generic enough API?
> 
... this implies that either the spec is wrong (as it should say: the
device registers are always LE, in the PCI spirit) or all readl()s & co.
should be replaced with __raw equivalents.

Having said that, does the change make everything else work with a BE
guest? (I assume we're talking about the guest being BE, right? ;-) If
so it means that the host is not following the current spec and it
treats all the registers as LE.

> - Reading the MAGIC register byte by byte. Is that allowed? The spec
>   only says it is 32bit wide.

And the spirit of the spec was: _exactly 32bit wide_. It's just simpler
to implement one access width on the host side.

Paweł


