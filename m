Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536AbaBCW6s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 17:58:48 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:38023 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbaBCW6q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 17:58:46 -0500
From: "Pearson, Greg" <greg.pearson@hp.com>
To: Vivek Goyal <vgoyal@redhat.com>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "d.hatayama@jp.fujitsu.com" <d.hatayama@jp.fujitsu.com>,
        "holzheu@linux.vnet.ibm.com" <holzheu@linux.vnet.ibm.com>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "paul.gortmaker@windriver.com" <paul.gortmaker@windriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] vmcore: prevent PT_NOTE p_memsz overflow during
 header update
Thread-Topic: [PATCH v2] vmcore: prevent PT_NOTE p_memsz overflow during
 header update
Thread-Index: AQHPISg9LvBzMOIrUUOU6K2ntVTGwpqkJHGA
Date: Mon, 3 Feb 2014 22:57:58 +0000
Message-ID: <52F01EF5.506@hp.com>
References: <1391458718-11994-1-git-send-email-greg.pearson@hp.com>
 <20140203213813.GH10795@redhat.com>
In-Reply-To: <20140203213813.GH10795@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329
 Thunderbird/17.0.5
x-originating-ip: [16.216.198.110]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <9EE68DECD1A545409772CE931FCEE066@Compaq.com>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2014 02:38 PM, Vivek Goyal wrote:
> On Mon, Feb 03, 2014 at 01:18:38PM -0700, Greg Pearson wrote:
>
> [..]
>> diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
>> index 2ca7ba0..051c803 100644
>> --- a/fs/proc/vmcore.c
>> +++ b/fs/proc/vmcore.c
>> @@ -468,12 +468,14 @@ static int __init update_note_header_size_elf64(const Elf64_Ehdr *ehdr_ptr)
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
>> +				pr_warn("Warning: dropping PT_NOTE entry\n");
>> +				break;
>> +			}
> Hi Greg,
>
> Couple of minor nits.
>
> I think it is a good idea to give more data in warning which tells why
> are we dropping a note entry. May be something like.
>
> "Warning: Total note entry size exceeded PT_NOTE memsz. Dropping PT_NOTE entry, n_namesz=<> n_descsz=<>".

Sounds good I'll add more information to the pr_warn().

>
> Secondly, if there is only on note entry in a PT_NOTE header and we drop
> it, then that PT_NOTE header is empty and needs to be cleaned up.
>
> I think you will have to modify get_note_number_and_size_elf64() and
> other relevant functions which are not expecting ->p_memsz=0.

What about treating this as an error condition and adding a check to the 
update_note_header_size_elf32()/update_note_header_size_elf64() routines 
that would return a failure, something like the following at the end of 
the routine:

     if (real_sz == 0)
         return -EINVAL

I could also add a pr_warn() with a message indicating no PT_NOTE 
entries were found.

This seems like a lower risk change to handle the case I'm currently 
seeing as opposed to changing the code to handle a p_memsz==0.

Thoughts?

--
Greg





