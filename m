Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604AbaBCU16 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 15:27:58 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:48129 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbaBCU15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 15:27:57 -0500
Message-ID: <52EFFC03.8070701@oracle.com>
Date: Mon, 03 Feb 2014 15:28:51 -0500
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH -v2] x86, microcode, AMD: Sanity-check initrd image
References: <52E8230F.7080300@oracle.com> <52E83903.5040908@oracle.com> <20140128232219.GO815@pd.tnic> <20140130151321.GC23342@pd.tnic> <52EAAAD5.2010301@oracle.com> <20140130195413.GH23342@pd.tnic> <20140203175526.GB4281@pd.tnic> <52EFEA57.4000709@oracle.com> <20140203193000.GD4281@pd.tnic> <52EFEFFE.6010608@oracle.com> <20140203195212.GF4281@pd.tnic>
In-Reply-To: <20140203195212.GF4281@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2014 02:52 PM, Borislav Petkov wrote:
> On Mon, Feb 03, 2014 at 02:37:34PM -0500, Boris Ostrovsky wrote:
>> It exploded when 'if (!container)' check was done *after* relocation,
>> which made container non-zero. If you do the check *before* then I
>> think you will catch the fact that container is empty.
> Ah, right, this was it.
>
> Ok, just remove the signature check then and give it a try pls:

Yes, this fixes the bug. And it loads microcode for a good binary.

For these two patches:
Tested-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>

(You might want to rename the final patch to something else since you 
are not checking the blob anymore).

Thanks.

-boris



>
> --
> diff --git a/arch/x86/kernel/cpu/microcode/amd_early.c b/arch/x86/kernel/cpu/microcode/amd_early.c
> index 41537ae7c31d..362994511be1 100644
> --- a/arch/x86/kernel/cpu/microcode/amd_early.c
> +++ b/arch/x86/kernel/cpu/microcode/amd_early.c
> @@ -37,12 +37,10 @@ static __initdata char ucode_path[] = "kernel/x86/microcode/AuthenticAMD.bin";
>   
>   static struct cpio_data __init find_ucode_in_initrd(void)
>   {
> -	struct cpio_data ret;
>   	long offset = 0;
>   	char *path;
>   	void *start;
>   	size_t size;
> -	u32 *hdr;
>   
>   #ifdef CONFIG_X86_32
>   	struct boot_params *p;
> @@ -60,21 +58,7 @@ static struct cpio_data __init find_ucode_in_initrd(void)
>   	start   = (void *)(boot_params.hdr.ramdisk_image + PAGE_OFFSET);
>   	size    = boot_params.hdr.ramdisk_size;
>   #endif
> -
> -	ret = find_cpio_data(path, start, size, &offset);
> -	if (!ret.data)
> -		return ret;
> -
> -	/* Verify we didn't get some garbage from the initrd. */
> -	hdr = (u32 *)ret.data;
> -
> -	if (hdr[0] != UCODE_MAGIC ||
> -	    hdr[1] != UCODE_EQUIV_CPU_TABLE_TYPE ||
> -	    hdr[2] == 0) {
> -		ret.data = NULL;
> -		ret.size = 0;
> -	}
> -	return ret;
> +	return find_cpio_data(path, start, size, &offset);
>   }
>   
>   static size_t compute_container_size(u8 *data, u32 total_size)
> --
>

