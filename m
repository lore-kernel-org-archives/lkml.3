Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932433Ab3FQJqg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 05:46:36 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:46071 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932188Ab3FQJqe convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:6:2>);
	Mon, 17 Jun 2013 05:46:34 -0400
Message-Id: <51BEF71402000078000DEC12@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Mon, 17 Jun 2013 10:46:28 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Matt Fleming" <matt@console-pimps.org>, "Joey Lee" <JLee@suse.com>
Cc: "Zach Bobroff" <zacharyb@ami.com>, "Matt Fleming" <matt.fleming@intel.com>,
        "Matthew Garrett" <mjg59@srcf.ucam.org>, <linux-efi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH] x86, efi: retry ExitBootServices() on failure
References: <1370933558-10128-1-git-send-email-matt@console-pimps.org>
 <1371139233.6523.272.camel@linux-s257.site>
 <20130617092107.GA5440@console-pimps.org>
In-Reply-To: <20130617092107.GA5440@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 17.06.13 at 11:21, Matt Fleming <matt@console-pimps.org> wrote:
> On Fri, 14 Jun, at 12:00:33AM, joeyli wrote:
>> > From: Zach Bobroff <zacharyb@ami.com>
>> > --- a/arch/x86/boot/compressed/eboot.c
>> > +++ b/arch/x86/boot/compressed/eboot.c
>> > @@ -1037,18 +1037,20 @@ static efi_status_t exit_boot(struct boot_params *boot_params,
>> >  	efi_memory_desc_t *mem_map;
>> >  	efi_status_t status;
>> >  	__u32 desc_version;
>> > +	bool called_exit = false;
>> >  	u8 nr_entries;
>> >  	int i;
>> >  
>> >  	size = sizeof(*mem_map) * 32;
>> >  
>> >  again:
>> > -	size += sizeof(*mem_map);
>> > +	size += sizeof(*mem_map) * 2;
>> >  	_size = size;
>> >  	status = low_alloc(size, 1, (unsigned long *)&mem_map);
>> 
>> Can we know why increased the size of double *mem_map is big enough?
>> Does there have any real guarantee to be sufficient?
>  
> It's not guaranteed to be sufficient, it's simply a best guess. If we
> haven't allocated enough memory to store the memory map we should loop
> around to the 'again' label anyway. It's just an optimisation, right
> Zach?

If that were the case, the code change wouldn't be necessary at
all, i.e. the increment could remain to be a single array element
steps.

>> And, why would doubling the increment be necessary here, but not in
>> __get_map()?
>  
> Again, we'll grow the map if it isn't large enough.

But in single element steps only. The question though was why
doubling the step was necessary (and sufficient) there, but isn't
also necessary here.

To me, all this looks like it is being done on phenomenological basis,
taking a particular build of a particular firmware implementation as
the reference. Imo we shouldn't change the code in this way. This
also applies to the fact that the step is being doubled rather than
e.g. tripled: With it ending up a "again" anyway (see below), what's
the point of avoiding one more of the iterations?

Generic considerations would result in the increment being at least
3 * element size; twice the element size assumes that the allocator
would behave in certain ways (like returning the head or tail part of
a larger piece of memory).

>> >  	if (status != EFI_SUCCESS)
>> >  		return status;
>> >  
>> > +get_map:
>> 
>> The get_map label is being placed such that the size doesn't
>> get adjusted anymore, yet it is supposed to deal with an allocation
>> having happened during ExitBootServices(), which could have
>> grown the map.
>> 
>> Why doesn't direct goto 'again' label?
>  
> It makes more sense to query GetMemoryMap() directly first to get the
> required size of the memory map. Then we jump to 'again' and allocate
> the correct size.

Ah, okay, I didn't pay attention to this indirectly ending up at
"again".

>> >  	status = efi_call_phys5(sys_table->boottime->get_memory_map, &size,
>> >  				mem_map, &key, &desc_size, &desc_version);
>> >  	if (status == EFI_BUFFER_TOO_SMALL) {
>> > @@ -1074,8 +1076,20 @@ again:
>> >  	/* Might as well exit boot services now */
>> >  	status = efi_call_phys2(sys_table->boottime->exit_boot_services,
>> >  				handle, key);
>> > -	if (status != EFI_SUCCESS)
>> > -		goto free_mem_map;
>> > +	if (status != EFI_SUCCESS) {
>> > +		/*
>> > +		 * ExitBootServices() will fail if any of the event
>> > +		 * handlers change the memory map. In which case, we
>> > +		 * must be prepared to retry, but only once so that
>> > +		 * we're guaranteed to exit on repeated failures instead
>> > +		 * of spinning forever.
>> > +		 */
>> > +		if (called_exit)
>> > +			goto free_mem_map;
>> > +
>> > +		called_exit = true;
>> 
>> Why a single retry is having reasonable guarantees to work when the
>> original one failed (nothing prevents an event handler to do another
>> allocation the next time through).
>> 
>> Why not retry 3, 4, 5 or even unlimited times?
>  
> There has to be an upper limit on the number of retries. It seems fair
> to retry once but any more than that and it's more likely that there's a
> serious problem and we should bail.

I agree that there ought to be an upper limit. But a single retry here
again looks like a tailored solution to a particular observed (mis-)
behavior, rather than something resulting from general considerations.

Jan
