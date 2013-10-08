Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845Ab3JHAYF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 20:24:05 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:40984 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591Ab3JHAYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 20:24:02 -0400
Message-ID: <52535098.70405@gmail.com>
Date: Tue, 08 Oct 2013 11:23:52 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Janani Venkataraman <jananive@in.ibm.com>, linux-kernel@vger.kernel.org
CC: amwang@redhat.com, rdunlap@xenotime.net, andi@firstfloor.org,
        aravinda@linux.vnet.ibm.com, hch@lst.de, mhiramat@redhat.com,
        jeremy.fitzhardinge@citrix.com, xemul@parallels.com,
        suzuki@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com,
        adobriyan@gmail.com, tarundsk@linux.vnet.ibm.com, vapier@gentoo.org,
        roland@hack.frob.com, tj@kernel.org, ananth@linux.vnet.ibm.com,
        gorcunov@openvz.org, avagin@openvz.org, oleg@redhat.com,
        eparis@redhat.com, d.hatayama@jp.fujitsu.com, james.hogan@imgtec.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: [PATCH 02/19] Make vma_dump_size() generic
References: <20131004102532.1612.24185.stgit@f19-x64> <20131004103043.1612.56980.stgit@f19-x64>
In-Reply-To: <20131004103043.1612.56980.stgit@f19-x64>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/13 20:30, Janani Venkataraman wrote:
> From:Suzuki K. Poulose <suzuki@in.ibm.com>
> 
> vma_dump_size calculates the file size of a vma area in the core file. It
> assumes the vma belongs to the "current". Make it generic to work for any task.
> This will be reused by application core dump infrastructure.
> 
> Signed-off-by: Suzuki K. Poulose <suzuki@in.ibm.com>
> ---

> -static unsigned long vma_dump_size(struct vm_area_struct *vma,
> +unsigned long vma_dump_size(struct task_struct *p, struct vm_area_struct *vma,
>  					unsigned long mm_flags)
>  {
>  #define FILTER(type)    (mm_flags & (1UL << MMF_DUMP_##type))
> @@ -143,10 +143,18 @@ static unsigned long vma_dump_size(struct vm_area_struct *vma,
>  		 * Switch to the user "segment" for get_user(),
>  		 * then put back what elf_core_dump() had in place.
>  		 */
> -		set_fs(USER_DS);
> - 		if (unlikely(get_user(word, header)))
> - 			word = 0;
> -		set_fs(fs);
> +		if (p->mm == current->mm) {
> +			mm_segment_t fs = get_fs();

It looks like you missed the removal of the old:

	mm_segment_t fs = get_fs();

above? Just below if (FILTER(ELF_HEADERS)).

~Ryan
