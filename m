Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224AbaCEQhc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 11:37:32 -0500
Received: from mail.skyhub.de ([78.46.96.112]:33265 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817AbaCEQha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 11:37:30 -0500
Date: Wed, 5 Mar 2014 17:37:22 +0100
From: Borislav Petkov <bp@alien8.de>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org,
        greg@kroah.com, jkosina@suse.cz
Subject: Re: [PATCH 08/11] kexec-bzImage: Support for loading bzImage using
 64bit entry
Message-ID: <20140305163722.GC28317@pd.tnic>
References: <1390849071-21989-1-git-send-email-vgoyal@redhat.com>
 <1390849071-21989-9-git-send-email-vgoyal@redhat.com>
 <20140227213629.GP18191@pd.tnic>
 <20140228163134.GG28744@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140228163134.GG28744@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 28, 2014 at 11:31:35AM -0500, Vivek Goyal wrote:
> Thanks for taking time to review this large patchset.

Sure, np. Thanks for your patience in explaining stuff which is unclear
to me.

> > > +struct bzimage64_data {
> > > +	/*
> > > +	 * Temporary buffer to hold bootparams buffer. This should be
> > > +	 * freed once the bootparam segment has been loaded.
> > > +	 */
> > > +	void *bootparams_buf;
> > > +};
> > 
> > Why a struct if it is going to have only one member?
> 
> Well, I had started with a generic idea of bootloader being able to store
> some data in image and retrieve it later. Finally it turned out to be only
> one field in current implementation.
> 
> But I still like it as it allows storing more data down the line. There
> is no other place where we can store bootloader specific data. So this
> is the mechanism I created.

Right, but people would ask so you probably should hold down this
intention in a comment somewhere.

> > What's 2*512? Two sectors?
> 
> Yep, two sectors.

Also a comment or a nicely-named define then.

> So Documentation/x86/boot.txt says following.
> 
> 
> If the "HdrS" (0x53726448) magic number is not found at offset 0x202,
> the boot protocol version is "old".  Loading an old kernel, the
> following parameters should be assumed:
> 
>         Image type = zImage
>         initrd not supported
>         Real-mode kernel must be located at 0x90000.
> 
> So if it is old version then it is zImage (and not bzImage). So pr_debug()
> message seems to be correct that image one is trying to load is not
> bzImage and this loader will not handle this image.

Ok, old == zImage, got it.

> Yep, that's LOADED_HIGH check. I think if LOADED_HIGH is not set, then
> that means protected mode code needs to be loaded at 0x10000 and I think
> that also means that it is zImage and not bzImage.

Yes, hpa confirmed this in IRC just now.

> That's how boot.txt defines it. Look at 64-bit BOOT PROTOCOL.
> 
> 0x0202 + byte value at offset 0x0201
> 
> Now one can argue that create some new defines to represent those magic
> numbers and include that file in kexec-bzimage loader. I will see what
> can I do.

Yeah, I was simply commenting it with the innocent onlooker hat on.
FWIW, referring to boot.txt in a comment should be helpful enough for
people who don't have an idea where to look, methinks.

> Hmm.., I have seen all kinds of alignments. But anyway, if you prefer
> that, I will change atleast some of them.

It is most readable this way, but this is only my opinion so consider it
only as a suggestion.

> I meant in general I have not done any EFI handling. I am not even
> sure what needs to be done for EFI. I am just going through memory
> map and filling up E820 map in bootparams so that second kernel knows
> what are the memory areas available.
> 
> At some point of time we need to start passing EFI memory map to
> second kernel. (All the new code you and dave young have added to
> make kexec work on EFI systems).

Right, the efi runtime pieces are already in sysfs but you'd need to put
them somewhere for the second kernel to find out. Maybe make it part of
the bzImage or supply it separately...

> I wanted to that in a separate patch. This patch series is alredy very
> big. bzImage signing and verification also I am planning to post in a
> separate series.

Right.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
