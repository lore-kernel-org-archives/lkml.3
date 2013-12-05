Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244Ab3LEXVQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 18:21:16 -0500
Received: from mail-yh0-f45.google.com ([209.85.213.45]:40099 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458Ab3LEXVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 18:21:03 -0500
Date: Thu, 5 Dec 2013 15:21:00 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
cc: Toshi Kani <toshi.kani@hp.com>, akpm@linux-foundation.org,
        mingo@kernel.org, hpa@zytor.com, tglx@linutronix.de,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] mm, x86: Skip NUMA_NO_NODE while parsing SLIT
In-Reply-To: <52A054A0.6060108@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.02.1312051517130.7717@chino.kir.corp.google.com>
References: <1386191348-4696-1-git-send-email-toshi.kani@hp.com> <52A054A0.6060108@jp.fujitsu.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Dec 2013, Yasuaki Ishimatsu wrote:

> (2013/12/05 6:09), Toshi Kani wrote:
> > When ACPI SLIT table has an I/O locality (i.e. a locality unique
> > to an I/O device), numa_set_distance() emits the warning message
> > below.
> > 
> >   NUMA: Warning: node ids are out of bound, from=-1 to=-1 distance=10
> > 
> > acpi_numa_slit_init() calls numa_set_distance() with pxm_to_node(),
> > which assumes that all localities have been parsed with SRAT previously.
> > SRAT does not list I/O localities, where as SLIT lists all localities
> 
> > including I/Os.  Hence, pxm_to_node() returns NUMA_NO_NODE (-1) for
> > an I/O locality.  I/O localities are not supported and are ignored
> > today, but emitting such warning message leads unnecessary confusion.
> 
> In this case, the warning message should not be shown. But if SLIT table
> is really broken, the message should be shown. Your patch seems to not care
> for second case.
> 

It's a subtle problem of the difference in the definition of a "NUMA node" 
between the ACPI specification and how it is defined in the kernel.  The 
specification allows I/O buses to define a NUMA node and the kernel 
doesn't setup a separate node id for them, so there's no way to 
distinguish between an erroneous SLIT and system localities that only 
include I/O devices.  If that were to change in the future we could remove 
this limitation since pxm_to_node() wouldn't return NUMA_NO_NODE for 
Toshi's config.  A follow-up patch that adds the comment about why this is 
done has been proposed to be folded into this patch.
