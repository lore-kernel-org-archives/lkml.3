Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750801Ab3JNE5Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 00:57:25 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40211 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740Ab3JNE5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 00:57:23 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.9
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-2
Message-ID: <525B7898.6010802@jp.fujitsu.com>
Date: Mon, 14 Oct 2013 13:52:40 +0900
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vivek Goyal <vgoyal@redhat.com>, Jan Willeke <willeke@de.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, kexec@lists.infradead.org
Subject: Re: mmap for /proc/vmcore broken since 3.12-rc1
References: <20131002140356.63706540@holzheu> <524D0ADF.2010507@jp.fujitsu.com> <52521FA5.3040101@jp.fujitsu.com> <CACVxJT8S7kA92=80DWVmVJJvbnaQ6WkyvsiFq4wP37WHV=tfuA@mail.gmail.com> <52552C9F.2030404@jp.fujitsu.com> <20131012203250.GA3458@p183.telecom.by>
In-Reply-To: <20131012203250.GA3458@p183.telecom.by>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/10/13 5:32), Alexey Dobriyan wrote:
> On Wed, Oct 09, 2013 at 07:14:55PM +0900, HATAYAMA Daisuke wrote:
>> Hello,
>>
>> (2013/10/08 21:49), Alexey Dobriyan wrote:
>>> On Mon, Oct 7, 2013 at 5:42 AM, HATAYAMA Daisuke
>>> <d.hatayama@jp.fujitsu.com> wrote:
>>>
>>>> +static unsigned long
>>>> +get_unmapped_area_vmcore(struct file *filp, unsigned long addr,
>>>> +                        unsigned long len, unsigned long pgoff,
>>>> +                        unsigned long flags)
>>>> +{
>>>> +#ifdef CONFIG_MMU
>>>> +       return current->mm->get_unmapped_area(filp, addr, len, pgoff,
>>>> flags);
>>>> +#else
>>>> +       return -EIO;
>>>> +#endif
>>>> +}
>>>> +
>>>>    static const struct file_operations proc_vmcore_operations = {
>>>>           .read           = read_vmcore,
>>>>           .llseek         = default_llseek,
>>>>           .mmap           = mmap_vmcore,
>>>> +       .get_unmapped_area = get_unmapped_area_vmcore,
>>>
>>> I think current->mm->get_unmapped_area should be used by core proc code.
>>
>> What do you actually suggest here? You mean moving this code in proc code?
>> I don't think you suggest so.
>
> Please, try this patch, I don't have kexec setup handy.
>
> --- a/fs/proc/inode.c
> +++ b/fs/proc/inode.c
> @@ -291,7 +291,11 @@ static unsigned long proc_reg_get_unmapped_area(struct file *file, unsigned long
>   	int rv = -EIO;
>   	unsigned long (*get_unmapped_area)(struct file *, unsigned long, unsigned long, unsigned long, unsigned long);
>   	if (use_pde(pde)) {
> -		get_unmapped_area = pde->proc_fops->get_unmapped_area;
> +		get_unmapped_area = current->mm->get_unmapped_area;
> +#ifdef CONFIG_MMU
> +		if (pde->proc_fops->get_unmapped_area)
> +			get_unmapped_area = pde->proc_fops->get_unmapped_area;
> +#endif
>   		if (get_unmapped_area)
>   			rv = get_unmapped_area(file, orig_addr, len, pgoff, flags);
>   		unuse_pde(pde);
>

Slight modification to #ifdef ...

get_unmapped_area = NULL;
#ifdef CONFIG_MMU
get_unmapped_area = current->mm->get_unmapped_area
#endif
if (pde->proc_fops->get_unmapped_area)
   get_unmapped_area = pde->proc_fops->get_unmapped_area;

And, I found the bug. The variable rv should have been defined as unsigned
long. sizeof(int) is 4 bytes but sizeof(long) is 8 bytes at least on x86_64.

The reason why returned value looked like kernel virtual address was due to
signed extension performed during conversion from negative 32-bit signed
integer to 64-bit unsigned long integer.

Hmm, I first checked signature of related functions but overlooked...

Anyway, I'll post fixing patch soon.

-- 
Thanks.
HATAYAMA, Daisuke

