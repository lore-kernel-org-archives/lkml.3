Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758185Ab3EGH5L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 03:57:11 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52210 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755257Ab3EGH5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 03:57:10 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.9
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-2
Message-ID: <5188B3BE.9040104@jp.fujitsu.com>
Date: Tue, 07 May 2013 16:56:46 +0900
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        lisa.mitchell@hp.com, kumagai-atsushi@mxc.nes.nec.co.jp,
        ebiederm@xmission.com, zhangyanfei@cn.fujitsu.com,
        akpm@linux-foundation.org, cpw@sgi.com, jingbai.ma@hp.com
Subject: Re: [PATCH v4 5/8] vmcore: copy ELF note segments in the 2nd kernel
 per page vmcore objects
References: <20130413002000.18245.21513.stgit@localhost6.localdomain6> <20130413002133.18245.91528.stgit@localhost6.localdomain6> <20130429193611.GQ8204@redhat.com>
In-Reply-To: <20130429193611.GQ8204@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/04/30 4:36), Vivek Goyal wrote:
> On Sat, Apr 13, 2013 at 09:21:33AM +0900, HATAYAMA Daisuke wrote:
>
> [..]
>> ELF notes are per-cpu, so total size of ELF note segments increases
>> according to the number of CPUs. The current maximum number of CPUs on
>> x86_64 is 5192, and there's already system with 4192 CPUs in SGI,
>> where total size amounts to 1MB. This can be larger in the neare
>> futrue or possibly even now on another architecture. Thus, to avoid
>> the case where memory allocation for large block fails, we allocate
>> vmcore objects per pages.
>
> IIRC, eric had suggested using vmalloc() and remap_vmalloc_range(). What's
> wrong with that? That should keep your vc_list relatively smaller.
>

Yes, it's handy if it's possible to remap them in vmalloc space, but the 
problem here is that remap_vmalloc_range requires the first argument vma 
to cover full range of the requested map. This becomes problem when 
requested area for mmap() overlaps multiple objects, for example, ELF 
headers and memory refered to by the first PT_LOAD program header.

To use remap_vmalloc_range, it's necessary to prepare a new variant 
similar to remap_pfn_range by which we can remap different objects 
separately to a single vma.

/**
  *      remap_vmalloc_range  -  map vmalloc pages to userspace
  *      @vma:           vma to cover (map full range of vma)
  *      @addr:          vmalloc memory
  *      @pgoff:         number of pages into addr before first page to map
  *
  *      Returns:        0 for success, -Exxx on failure
  *
  *      This function checks that addr is a valid vmalloc'ed area, and
  *      that it is big enough to cover the vma. Will return failure if
  *      that criteria isn't met.
  *
  *      Similar to remap_pfn_range() (see mm/memory.c)
  */
int remap_vmalloc_range(struct vm_area_struct *vma, void *addr,
                                                 unsigned long pgoff)


-- 
Thanks.
HATAYAMA, Daisuke

