Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759346Ab3HNDD7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 23:03:59 -0400
Received: from ozlabs.org ([203.10.76.45]:50132 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759278Ab3HNDD6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 23:03:58 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Michal Marek <mmarek@suse.cz>, Andi Kleen <andi@firstfloor.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        anton@samba.org
Subject: Re: [PATCH] Handle non ABS crc symbols
In-Reply-To: <520A90E9.7080206@suse.cz>
References: <1376077524-27573-1-git-send-email-andi@firstfloor.org> <520A90E9.7080206@suse.cz>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Wed, 14 Aug 2013 11:16:16 +0930
Message-ID: <87fvudkpsn.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Marek <mmarek@suse.cz> writes:
> Added Rusty to CC.
>
> Dne 9.8.2013 21:45, Andi Kleen napsal(a):
>> From: Andi Kleen <ak@linux.intel.com>
>> 
>> For some reason I managed to trick gcc into create CRC symbols that
>> are not absolute anymore, but weak.
>> 
>> Make modpost handle this case.
>> 
>> Andrew, this should fix the bizarre warning. Seems like a toolchain
>> bug to me.
>> 
>> Signed-off-by: Andi Kleen <ak@linux.intel.com>

Do you also end up with relocated CRCs, like ppc does?

See ARCH_RELOCATES_KCRCTAB in kernel/module.c.

Cheers,
Rusty.

>> ---
>>  scripts/mod/modpost.c | 15 +++++++--------
>>  1 file changed, 7 insertions(+), 8 deletions(-)
>> 
>> diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
>> index 6216434..b3dd735 100644
>> --- a/scripts/mod/modpost.c
>> +++ b/scripts/mod/modpost.c
>> @@ -599,18 +599,17 @@ static void handle_modversions(struct module *mod, struct elf_info *info,
>>  	else
>>  		export = export_from_sec(info, get_secindex(info, sym));
>>  
>> +	/* CRC'd symbol */
>> +	if (strncmp(symname, CRC_PFX, strlen(CRC_PFX)) == 0) {
>> +		crc = (unsigned int) sym->st_value;
>> +		sym_update_crc(symname + strlen(CRC_PFX), mod, crc,
>> +				export);
>> +	}
>> +
>>  	switch (sym->st_shndx) {
>>  	case SHN_COMMON:
>>  		warn("\"%s\" [%s] is COMMON symbol\n", symname, mod->name);
>>  		break;
>> -	case SHN_ABS:
>> -		/* CRC'd symbol */
>> -		if (strncmp(symname, CRC_PFX, strlen(CRC_PFX)) == 0) {
>> -			crc = (unsigned int) sym->st_value;
>> -			sym_update_crc(symname + strlen(CRC_PFX), mod, crc,
>> -					export);
>> -		}
>> -		break;
>>  	case SHN_UNDEF:
>>  		/* undefined symbol */
>>  		if (ELF_ST_BIND(sym->st_info) != STB_GLOBAL &&
>> 
