Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946Ab3KTO7e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 09:59:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32119 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750827Ab3KTO7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 09:59:32 -0500
Date: Wed, 20 Nov 2013 09:59:01 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>
Cc: "bhe@redhat.com" <bhe@redhat.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "d.hatayama@jp.fujitsu.com" <d.hatayama@jp.fujitsu.com>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "dyoung@redhat.com" <dyoung@redhat.com>,
        "chaowang@redhat.com" <chaowang@redhat.com>
Subject: Re: /proc/vmcore mmap() failure issue
Message-ID: <20131120145901.GB27924@redhat.com>
References: <20131113204130.GD7613@redhat.com>
 <5284A689.70903@jp.fujitsu.com>
 <20131114151359.GA3913@redhat.com>
 <5285EC60.1060906@jp.fujitsu.com>
 <20131115142617.GC6637@redhat.com>
 <0910DD04CBD6DE4193FCF86B9C00BE971BF592@BPXM01GP.gisp.nec.co.jp>
 <20131118135511.GA30637@redhat.com>
 <0910DD04CBD6DE4193FCF86B9C00BE971C3862@BPXM01GP.gisp.nec.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0910DD04CBD6DE4193FCF86B9C00BE971C3862@BPXM01GP.gisp.nec.co.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 05:29:16AM +0000, Atsushi Kumagai wrote:
> On 2013/11/18 22:56:10, kexec <kexec-bounces@lists.infradead.org> wrote:
> > On Mon, Nov 18, 2013 at 12:51:39AM +0000, Atsushi Kumagai wrote:
> > 
> > [..]
> > > > Is there any chance that you could look into fixing this. I have no 
> > > > experience writing code for makedumpfile.
> > > 
> > > I'll send a patch to fix this soon.
> > 
> > Thanks Atsushi.
> > 
> > Vivek
> 
> Vivek, could you test this patch ?
> 
> Thanks
> Atsushi Kumagai
> 
> 
> From: Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>
> Date: Wed, 20 Nov 2013 10:05:03 +0900
> Subject: [PATCH] Disable mmap() for reading fractional pages.
> 
> Since mmap() was introduced on /proc/vmcore, it fails
> for fractional pages which don't start or end at page boundary
> due to kernel issue.
> This patch disables mmap() temporarily for fractional pages
> to avoid this issue, so mmap() will be used only for aligned pages.
> 
> Signed-off-by: Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>

Hi Atsushi,

Even with this patch applied I see mmap() failure.

mem_map (39)
  mem_map    : ffffea0004e00000
  pfn_start  : 138000
  pfn_end    : 140000
read /proc/vmcore with mmap()
Excluding unnecessary pages        : [100.0 %] |STEP [Excluding
unnecessary pages] : 0.035925 seconds
Excluding unnecessary pages        : [100.0 %] \STEP [Excluding
unnecessary pages] : 0.035774 seconds
Excluding unnecessary pages        : [100.0 %] -STEP [Excluding
unnecessary pages] : 0.035229 seconds
Copying data                       : [ 40.9 %] -Can't map
[b98fd000-b9cfd000] with mmap()
read_from_vmcore: Can't read the dump memory(/proc/vmcore) with mmap().
readpage_elf: Can't read the dump memory(/proc/vmcore).
readmem: type_addr: 1, addr:bffba000, size:4096
read_pfn: Can't get the page data.
 Resource temporarily unavailable
makedumpfile Failed.
kdump: saving vmcore failed

Following is part of /proc/iomem on my system.

00100000-bffc283f : System RAM
  01000000-018c551d : Kernel code
  018c551e-01ef3f3f : Kernel data
  0204a000-02984fff : Kernel bss
  2e000000-35ffffff : Crash kernel
bffc2840-bfffffff : reserved

This is a different system than what I used last time. So I am not sure
if this is same error or something else. But one thing is clear that
System RAM last page is partial and we should face mmap() failure.

Thanks
Vivek
