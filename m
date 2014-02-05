Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113AbaBEQj6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 11:39:58 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:38226 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084AbaBEQj5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 11:39:57 -0500
From: "Pearson, Greg" <greg.pearson@hp.com>
To: Vivek Goyal <vgoyal@redhat.com>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "d.hatayama@jp.fujitsu.com" <d.hatayama@jp.fujitsu.com>,
        "holzheu@linux.vnet.ibm.com" <holzheu@linux.vnet.ibm.com>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "paul.gortmaker@windriver.com" <paul.gortmaker@windriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] vmcore: prevent PT_NOTE p_memsz overflow during
 header update
Thread-Topic: [PATCH v3] vmcore: prevent PT_NOTE p_memsz overflow during
 header update
Thread-Index: AQHPInepF7jjpBi8m0+cOpOVT5HFEpqm3KAA
Date: Wed, 5 Feb 2014 16:39:05 +0000
Message-ID: <52F26928.4050101@hp.com>
References: <1391556352-15881-1-git-send-email-greg.pearson@hp.com>
 <20140205133912.GC6042@redhat.com>
In-Reply-To: <20140205133912.GC6042@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329
 Thunderbird/17.0.5
x-originating-ip: [16.216.198.110]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <2CE267EB076B324390E2D20704813C38@Compaq.com>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2014 06:39 AM, Vivek Goyal wrote:
> On Tue, Feb 04, 2014 at 04:25:52PM -0700, Greg Pearson wrote:
>
> [..]
>> diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
>> index 2ca7ba0..88d4585 100644
>> --- a/fs/proc/vmcore.c
>> +++ b/fs/proc/vmcore.c
>> @@ -468,17 +468,24 @@ static int __init update_note_header_size_elf64(const Elf64_Ehdr *ehdr_ptr)
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
>> +			if ((real_sz + sz) > max_sz) {
>> +				pr_warn("Warning: Exceeded p_memsz, dropping PT_NOTE entry n_namesz=0x%x, n_descsz=0x%x\n",
>> +					nhdr_ptr->n_namesz, nhdr_ptr->n_descsz);
> You will need line break in pr_warn(). Too long a line. Limit it 80
> columns per line.

The checkpatch.pl script issues a warning when you break quoted strings, 
I have no personal preference. Just let me know if you want me to ignore 
the checkpatch warning and conform to the 80 column per line limit.

Also, I'm still debugging the reason why the corrupt entries show up, 
I'll continue to work on that.

Thanks

--
Greg


>
>> +				break;
>> +			}
>>   			real_sz += sz;
>>   			nhdr_ptr = (Elf64_Nhdr*)((char*)nhdr_ptr + sz);
>>   		}
>>   		kfree(notes_section);
>>   		phdr_ptr->p_memsz = real_sz;
>> +		if (real_sz == 0) {
>> +			pr_warn("Warning: Zero PT_NOTE entries found\n");
>> +			return -EINVAL;
> Given the fact that this is the first time I have heard about a PT_NOTE
> being corrup, I will be fine with this patch too. If one encounters
> an empty PT_NOTE, error out and don't create vmcore.
>
> So please repost this patch with line lenght fixed.
>
> Thanks
> Vivek
