Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611Ab3IYAND (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 20:13:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:32910 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755591Ab3IYANA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:13:00 -0400
Message-ID: <52422A6A.8080305@zytor.com>
Date: Tue, 24 Sep 2013 17:12:26 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Dave Young <dyoung@redhat.com>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Vivek Goyal <vgoyal@redhat.com>, linux-efi@vger.kernel.org
Subject: Re: [PATCH -v2] EFI: Runtime services virtual mapping
References: <e39e1065bddc2afee2cb6eed957e3ba8.squirrel@www.skyhub.de>
In-Reply-To: <e39e1065bddc2afee2cb6eed957e3ba8.squirrel@www.skyhub.de>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2013 07:56 AM, Borislav Petkov wrote:
> On Tue, September 24, 2013 2:45 pm, Dave Young wrote:
>> Think again about this, how about 1:1 map them from a base address
>> like -64G phy_addr -> (-64G + phy_addr), in this way we can avoid
>> depending on the previous region size.
> 
> Right, how we layout the regions is arbitrary as long as we start at
> the same VA and use the same regions, in the same order and of the same
> size...
> 
>> For the zero region problem, we can resolve it as a standalone
>> problem.
> 
> ... however, we still need to understand why it fails mapping the boot
> services region as some implementations apparently do call boot services
> even after ExitBootServices(). IOW, we need that region mapped in the
> kexec'ed kernel too.
> 

I am starting to think that we really should explicitly pass along the
EFI mappings to the secondary kernel.  This will also help if we have to
change the algorithm in a future kernel.

The most logical way to do this is to define a new setup_data type and
pass the entire set of physical-to-virtual mappings that way.

For example:

struct efi_mapping {
	u64 va;			/* Virtual start address */
	u64 pa;			/* Physical start address */
	u64 len;		/* Length in bytes */
	u64 type;		/* Mapping type */
	u64 reserved[3];	/* Reserved, must be zero */
};

Adding some reserved fields seems like a prudent precaution; the map
shouldn't be all that large anyway.

	-hpa

