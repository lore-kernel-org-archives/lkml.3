Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757409Ab3BRAQV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 19:16:21 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35761 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756737Ab3BRAQT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 19:16:19 -0500
From: "Hatayama, Daisuke" <d.hatayama@jp.fujitsu.com>
To: Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>
CC: "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lisa.mitchell@hp.com" <lisa.mitchell@hp.com>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "cpw@sgi.com" <cpw@sgi.com>, "vgoyal@redhat.com" <vgoyal@redhat.com>
Subject: RE: [PATCH 00/13] kdump, vmcore: support mmap() on /proc/vmcore
Thread-Topic: [PATCH 00/13] kdump, vmcore: support mmap() on /proc/vmcore
Thread-Index: AQHOCpvL8aX2yiTBRUyAIHdrD1hHz5h5tOyAgAUPZbA=
Date: Mon, 18 Feb 2013 00:16:15 +0000
Message-ID: <33710E6CAA200E4583255F4FB666C4E20AC96A42@G01JPEXMBYT03>
References: <20130214100945.22466.4172.stgit@localhost6.localdomain6>
 <20130215125701.75d134af8fd3d99f7853e014@mxc.nes.nec.co.jp>
In-Reply-To: <20130215125701.75d134af8fd3d99f7853e014@mxc.nes.nec.co.jp>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.124.101.76]
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>
Subject: Re: [PATCH 00/13] kdump, vmcore: support mmap() on /proc/vmcore
Date: Fri, 15 Feb 2013 12:57:01 +0900

> On Thu, 14 Feb 2013 19:11:43 +0900
> HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com> wrote:

<cut>
>> TODO
>> ====
>> 
>> - fix makedumpfile to use mmap() on /proc/vmcore and benchmark it to
>>   confirm whether we can see enough performance improvement.
> 
> As a first step, I'll make a prototype patch for benchmarking unless you
> have already done it.
> 

I have an idea, but I've not started developing it yet.

I think threre are the two points we should optimize. One is
write_kdump_pages() that reads target page frames, compresses them if
necessary, and writes each page frame data in order, and the other is
__exclude_unnecessary_pages() that reads mem_map array into page_cache
and processes it for filtering.

Optimising the former seems trivial by mmap(), but we have to consider
more for the latter case since it is virtually contiguous but not
guranteed to be physically contiguous; mem_map is mapped in the
virtual memory map region. Hence, the current implementation reads
mem_map array one by one in 4KB page with virtual-to-physical
translation. This is critical in performance and not sutable for
optimization by mmap(). We should fix this anyway.

My idea here is to focus on the fact that virtual memory map region is
actually mapped using PMD level page entry, i.e. 4MB page, if
currently used processor supports large pages. By this, the page
entries gained by each page translation is guranteed to be physically
contiguous in at least 4MB length. Looking at the benchmark, the
performance improvement is already saturated in 4MB case. So I guess
we can see enough performance improvement by mmap()ing mem_map array
in this 4MB page units.

Thanks.
HATAYAMA, Daisuke

