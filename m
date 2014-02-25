Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373AbaBYQoO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 11:44:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29184 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752908AbaBYQoN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 11:44:13 -0500
Date: Tue, 25 Feb 2014 11:43:42 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, mjg59@srcf.ucam.org, greg@kroah.com,
        jkosina@suse.cz
Subject: Re: [PATCH 07/11] kexec: Create a relocatable object called purgatory
Message-ID: <20140225164342.GC2701@redhat.com>
References: <1390849071-21989-1-git-send-email-vgoyal@redhat.com>
 <1390849071-21989-8-git-send-email-vgoyal@redhat.com>
 <530B989B.8010507@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <530B989B.8010507@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 11:08:11AM -0800, H. Peter Anvin wrote:
> On 01/27/2014 10:57 AM, Vivek Goyal wrote:
> > +
> > +/**
> > + * memcpy - Copy one area of memory to another
> > + * @dest: Where to copy to
> > + * @src: Where to copy from
> > + * @count: The size of the area.
> > + */
> > +static void *memcpy(void *dest, const void *src, unsigned long count)
> > +{
> > +	char *tmp = dest;
> > +	const char *s = src;
> > +
> > +	while (count--)
> > +		*tmp++ = *s++;
> > +	return dest;
> > +}
> > +
> > +static int memcmp(const void *cs, const void *ct, size_t count)
> > +{
> > +	const unsigned char *su1, *su2;
> > +	int res = 0;
> > +
> > +	for (su1 = cs, su2 = ct; 0 < count; ++su1, ++su2, count--)
> > +		if ((res = *su1 - *su2) != 0)
> > +			break;
> > +	return res;
> > +}
> > +
> 
> <bikeshed>
> 
> There multiple implementations of memcpy(), memcmp() and memset() in
> this patchset, and they make my eyes want to bleed (especially
> memcmp()).  Can we centralize there, and perhaps even share code with
> the stuff in arch/x86/boot already?
> 
> </bikeshed>

Hi hpa,

There is multiple implementation of memcpy() only (sha256.c and
purgatory.c). I will merge the two and make them use single definition of
memcpy().

I can't see multiple implementation of memcpy() and memcmp() in purgatory
code.

W.r.t sharing the code with arch/x86/boot/, I am not sure how to do it.

I see two implementations of memcpy() under arch/x86/boot.

One is in copy.S. This is assembly code and looks like is supposed to
run in 16bit mode. (code16).

Other one is in compressed/misc.c and there are two definitions, one
for 32bit and one fore 64bit.

I am not sure why there is a need to write memcpy() in assembly when
C will do just fine for my case. I don't have to write two versions of
memcpy() and use it both for 32bit and 64bit.

So I can just make all the purgatory code share same version of memcpy(),
memcmp() and memset(), is that fine. I have taken implementations of
these functions from lib/string.c

Thanks
Vivek

> 
> 	-hpa
