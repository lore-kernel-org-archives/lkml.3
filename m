Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964792Ab3CHQT1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 11:19:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28605 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759799Ab3CHQT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 11:19:26 -0500
Date: Fri, 8 Mar 2013 11:19:12 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Jingbai Ma <jingbai.ma@hp.com>
Cc: mingo@redhat.com, kumagai-atsushi@mxc.nes.nec.co.jp, ebiederm@xmission.com,
        hpa@zytor.com, yinghai@kernel.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        "Mitchell, Lisa (MCLinux in Fort Collins)" <lisa.mitchell@hp.com>
Subject: Re: [RFC PATCH 0/5] crash dump bitmap: scan memory pages in kernel
 to speedup kernel dump process
Message-ID: <20130308161912.GD8219@redhat.com>
References: <20130307145808.29098.41592.stgit@k.asiapacific.hpqcorp.net>
 <20130307152108.GC2790@redhat.com>
 <5139B827.3050500@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5139B827.3050500@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 08, 2013 at 06:06:31PM +0800, Jingbai Ma wrote:

[..]
> >- First of all it is doing more stuff in first kernel. And that runs
> >   contrary to kdump design where we want to do stuff in second kernel.
> >   After a kernel crash, you can't trust running kernel's data structures.
> >   So to improve reliability just do minial stuff in crashed kernel and
> >   get out quickly.
> 
> I agreed with you, the first kernel should do as less as possible.
> Intuitively, filter memory pages in the first kernel will harm the
> reliability of kernel dump, but let's think it thoroughly:
> 
> 1. It only relies on the memory management data structure that
> makedumpfile also relies on, so no any reliability degradation at
> this point.

Its not same. If there is something wrong with memory management
data structures, you can panic() again and self lock yourself and
never even transition to the second kernel.

With makedumpfile, if something is wrong, either we will save wrong
bits or get segmentation fault. But one can still try to be careful
or save whole dump and try to get specific pieces out.

So it it is not apples to apples comparison.

[..]
> >Looks like now hpa and yinghai have done the work to be able to load
> >kdump kernel above 4GB. I am assuming this also removes the restriction
> >that we can only reserve 512MB or 896MB in second kernel. If that's
> >the case, then I don't see why people can't get away with reserving
> >64MB per TB.
> 
> That's true. With kernel 3.9-rc1 with kexec-tools 2.0.4, capture
> kernel will have enough memory to run. And makedumpfile could be
> always run at non-cyclic mode, but we still concern about the kernel
> dump performance on systems with huge memory (above 4TB).

I would think that lets first try to make mmap() on /proc/vmcore work and
optimize makefumpfile to make use of it and then see if performance is
acceptable or not on large machines. And then take it from there.

Thanks
Vivek
