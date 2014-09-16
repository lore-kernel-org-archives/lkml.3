Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078AbaIPIG7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 04:06:59 -0400
Received: from mga01.intel.com ([192.55.52.88]:55306 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752026AbaIPIG4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 04:06:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,533,1406617200"; 
   d="scan'208";a="477807338"
From: "Ren, Qiaowei" <qiaowei.ren@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
CC: "x86@kernel.org" <x86@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v8 09/10] x86, mpx: cleanup unused bound tables
Thread-Topic: [PATCH v8 09/10] x86, mpx: cleanup unused bound tables
Thread-Index: AQHPzZ4ZD4a5PLioWE2GYqpHSFSgo5wCLPaAgAFBGSA=
Date: Tue, 16 Sep 2014 08:06:23 +0000
Message-ID: <9E0BE1322F2F2246BD820DA9FC397ADE017AE487@shsmsx102.ccr.corp.intel.com>
References: <1410425210-24789-1-git-send-email-qiaowei.ren@intel.com>
 <1410425210-24789-10-git-send-email-qiaowei.ren@intel.com>
 <541751DF.8090706@intel.com>
In-Reply-To: <541751DF.8090706@intel.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2014-09-16, Hansen, Dave wrote:
> On 09/11/2014 01:46 AM, Qiaowei Ren wrote:
>> +/*
>> + * Free the backing physical pages of bounds table 'bt_addr'.
>> + * Assume start...end is within that bounds table.
>> + */
>> +static int __must_check zap_bt_entries(struct mm_struct *mm,
>> +		unsigned long bt_addr,
>> +		unsigned long start, unsigned long end) {
>> +	struct vm_area_struct *vma;
>> +
>> +	/* Find the vma which overlaps this bounds table */
>> +	vma = find_vma(mm, bt_addr);
>> +	/*
>> +	 * The table entry comes from userspace and could be
>> +	 * pointing anywhere, so make sure it is at least
>> +	 * pointing to valid memory.
>> +	 */
>> +	if (!vma || !(vma->vm_flags & VM_MPX) ||
>> +			vma->vm_start > bt_addr ||
>> +			vma->vm_end < bt_addr+MPX_BT_SIZE_BYTES)
>> +		return -EINVAL;
> 
> If someone did *ANYTHING* to split the VMA, this check would fail.  I
> think that's a little draconian, considering that somebody could do a
> NUMA policy on part of a VM_MPX VMA and cause it to be split.
> 
> This check should look across the entire 'bt_addr ->
> bt_addr+MPX_BT_SIZE_BYTES' range, find all of the VM_MPX VMAs, and zap
> only those.
> 
> If we encounter a non-VM_MPX vma, it should be ignored.
>
Ok.

>> +	if (ret == -EFAULT)
>> +		return ret;
>> +
>> +	/*
>> +	 * unmap those bounds table which are entirely covered in this
>> +	 * virtual address region.
>> +	 */
> 
> Entirely covered *AND* not at the edges, right?
> 
Yes.

>> +	bde_start = mm->bd_addr + MPX_GET_BD_ENTRY_OFFSET(start);
>> +	bde_end = mm->bd_addr + MPX_GET_BD_ENTRY_OFFSET(end-1);
>> +	for (bd_entry = bde_start + 1; bd_entry < bde_end; bd_entry++) {
> 
> This needs a big fat comment that it is only freeing the bounds tables that are 1.
> fully covered 2. not at the edges of the mapping, even if full aligned
> 
> Does this get any nicer if we have unmap_side_bts() *ONLY* go after
> bounds tables that are partially owned by the region being unmapped?
> 
> It seems like we really should do this:
> 
> 	for (each bt fully owned)
> 		unmap_single_bt()
> 	if (start edge unaligned)
> 		free start edge
> 	if (end edge unaligned)
> 		free end edge
> 
> I bet the unmap_side_bts() code gets simpler if we do that, too.
> 
Maybe. I will try this.

Thanks,
Qiaowei
