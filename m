Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909AbaHTTxu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 15:53:50 -0400
Received: from duck.fensystems.co.uk ([212.13.204.60]:44827 "EHLO
	duck.fensystems.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbaHTTxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 15:53:49 -0400
Message-ID: <53F4FCC9.1030405@fensystems.co.uk>
Date: Wed, 20 Aug 2014 20:53:45 +0100
From: Michael Brown <mbrown@fensystems.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: =?UTF-8?B?TWFudGFzIE1pa3VsxJduYXM=?= <grawity@gmail.com>,
        Matt Fleming <matt@console-pimps.org>
CC: Yinghai Lu <yinghai@kernel.org>, Matt Fleming <matt.fleming@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-efi@vger.kernel.org
Subject: Re: Loading initrd above 4G causes freeze on boot
References: <53E62EEF.9040801@gmail.com>	<CAE9FiQVXkojPnTr4EQE7h2YhWqa5VBYRSCadB0B1qDL+eGY8jg@mail.gmail.com>	<20140809192302.GJ15082@console-pimps.org>	<CAPWNY8X+pRf4GuYAzKj-co0fkLMY0KNw+wB4KA8eaJ0QbE4MnA@mail.gmail.com>	<CAE9FiQVDURMvgVd55-onMDejCZT+OZ2vrr92wx8FJMKRNSX_GA@mail.gmail.com>	<CAPWNY8WvyAt5oT3cJ53A07tbfZctE9Y-m5f2Nucgc3hVvCgdjQ@mail.gmail.com>	<20140813140219.GP15082@console-pimps.org>	<CAPWNY8WdA+Q+WjXirGOsrYjMGp+69sCqYa8ST7_owQeVhQkT0w@mail.gmail.com>	<20140813184449.GV15082@console-pimps.org>	<20140820170520.GF29733@console-pimps.org> <CAPWNY8V_gFutOcow5rBUSz2updGzf4hkQ98qBZ9WRGkb_sA2jA@mail.gmail.com>
In-Reply-To: <CAPWNY8V_gFutOcow5rBUSz2updGzf4hkQ98qBZ9WRGkb_sA2jA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/08/14 20:05, Mantas Mikulėnas wrote:
> On Wed, Aug 20, 2014 at 8:05 PM, Matt Fleming <matt@console-pimps.org> wrote:
>> On Wed, 13 Aug, at 07:44:49PM, Matt Fleming wrote:
>>>
>>> At this point, I think modifying the max address is the best way to
>>> debug this further, and figure out what address causes the hang.
>>
>> Mantas, did you manage to get to the bottom of this issue?
>
> I experimented with some things (like setting chunk size to a few kB
> to see if it hangs earlier or only at the very end; etc.), and finally
> found out that it stops freezing if I pad the initrd file to a
> multiple of 512 bytes :/ That is, 5684268 bytes will freeze, 5684736
> bytes will not.
>
> ...In other words, seems like it cannot read chunks that aren't
> multiples of 512 into a location above 4 GB. Or something like that...

I haven't been following this thread closely, but that immediately 
sounds like a problem within the EFI_DISK_IO_PROTOCOL implementation 
(which is responsible for handling smaller-than-block-sized reads). 
Looking at the EDK2 implementation in 
MdeModulePkg/Universal/Disk/DiskIoDxe/DiskIo.c, the memory management 
does appear to be somewhat inventive.  In particular, there's a frequent 
pattern in DiskIoCreateSubtaskList() equivalent to:

   if ( blocking_io ) {
      buffer = some_static_buffer;
   } else {
      buffer = malloc ( len );
      if ( ! buffer )
         goto single_shared_error_label;
   }
   ... do not record whether or not buffer was dynamically allocated ...
   ... use buffer as part of an asynchronous I/O operation ...
   ... eventually choose whether or not to free buffer, and hope the 
choice is correct ...

It's not at all obvious that memory is freed correctly, especially under 
some of the error paths within that code.

I can't immediately see anything that should fail with a pointer above 
4G, but I wouldn't be surprised to find a path that causes a double free 
or similar error.

Apologies if I've missed something critical earlier in the thread, 
making my ramblings are totally irrelevant.

Michael
