Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461AbaBABJc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 20:09:32 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:30429 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120AbaBABJb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 20:09:31 -0500
From: "Pearson, Greg" <greg.pearson@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: "vgoyal@redhat.com" <vgoyal@redhat.com>,
        "d.hatayama@jp.fujitsu.com" <d.hatayama@jp.fujitsu.com>,
        "holzheu@linux.vnet.ibm.com" <holzheu@linux.vnet.ibm.com>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "paul.gortmaker@windriver.com" <paul.gortmaker@windriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vmcore: prevent PT_NOTE p_memsz overflow during header
 update
Thread-Topic: [PATCH] vmcore: prevent PT_NOTE p_memsz overflow during header
 update
Thread-Index: AQHPHtqFuSja1fPh8UeGdozh9BV3pJqflj4A
Date: Sat, 1 Feb 2014 01:07:29 +0000
Message-ID: <52EC48D0.4000503@hp.com>
References: <1391209566-4734-1-git-send-email-greg.pearson@hp.com>
 <20140131151651.26ff54cd7bd06fc5feb6fcc6@linux-foundation.org>
In-Reply-To: <20140131151651.26ff54cd7bd06fc5feb6fcc6@linux-foundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329
 Thunderbird/17.0.5
x-originating-ip: [16.216.198.110]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <31DC996F2A49D9469A2F951B236978A7@Compaq.com>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2014 04:16 PM, Andrew Morton wrote:
> On Fri, 31 Jan 2014 16:06:06 -0700 Greg Pearson <greg.pearson@hp.com> wrote:
>
>> Currently, update_note_header_size_elf64() and
>> update_note_header_size_elf32() will add the size
>> of a PT_NOTE entry to real_sz even if that causes real_sz
>> to exceeds max_sz. This patch corrects the while loop logic
>> in those routines to ensure that does not happen.
>>
>> ...
>>
>> Occasionally, a second entry is encountered with very
>> large n_namesz and n_descsz sizes:
>>
>>    n_namesz = 0x80000008
>>    n_descsz = 0x510ae163
>>    n_type   = 0x80000008
> Hang on.
>
>> --- a/fs/proc/vmcore.c
>> +++ b/fs/proc/vmcore.c
>> @@ -468,12 +468,13 @@ static int __init update_note_header_size_elf64(const Elf64_Ehdr *ehdr_ptr)
>>   			return rc;
>>   		}
>>   		nhdr_ptr = notes_section;
>> -		while (real_sz < max_sz) {
>> -			if (nhdr_ptr->n_namesz == 0)
>> -				break;
>> +		while (nhdr_ptr->n_namesz != 0) {
>>   			sz = sizeof(Elf64_Nhdr) +
>>   				((nhdr_ptr->n_namesz + 3) & ~3) +
>>   				((nhdr_ptr->n_descsz + 3) & ~3);
>> +			/* Silently drop further PT_NOTE entries */
>> +			if ((real_sz + sz) > max_sz)
>> +				break;
> If we are encountering notes with these crazy sizes then what is
> preventing (real_sx + sz) from wrapping through zero, which would
> defeat this check?
>
>

As far as I know the only consequence of dropping a PT_NOTE entry is 
that it would not be available in the crash dump for use in debugging. 
I'm not sure how important this data might be for triage. I'm guessing 
that in cases where one of these strange PT_NOTE entries shows up with a 
size that causes an overflow it probably isn't even a real PT_NOTE entry 
so dropping it won't matter, but that's a guess at this point since I'm 
still trying to figure out how the bogus entries were created.

I think the wrap case is handled ok by the current code since "real_sz" 
and "sz" are both declared as u64, while the "n_namesz" and "n_descsz" 
fields are declared as u32. This is true for both the elf32 and elf64 case.

Adding a pr_warn() is probably a good idea, then I can remove the comment.

--
Greg




