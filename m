Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765AbaB1Q5j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 11:57:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36291 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752593AbaB1Q50 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 11:57:26 -0500
Date: Fri, 28 Feb 2014 11:56:28 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org,
        greg@kroah.com, jkosina@suse.cz
Subject: Re: [PATCH 09/11] kexec: Provide a function to add a segment at
 fixed address
Message-ID: <20140228165628.GH28744@redhat.com>
References: <1390849071-21989-1-git-send-email-vgoyal@redhat.com>
 <1390849071-21989-10-git-send-email-vgoyal@redhat.com>
 <20140227215232.GQ18191@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140227215232.GQ18191@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 10:52:32PM +0100, Borislav Petkov wrote:

[..]
> > +/* Add a kexec segment at fixed address provided by caller */
> > +int kexec_add_segment(struct kimage *image, char *buffer, unsigned long bufsz,
> > +			unsigned long memsz, unsigned long base)
> > +{
> > +	struct kexec_segment ksegment;
> > +	int ret;
> > +
> > +	/* Currently adding segment this way is allowed only in file mode */
> > +	if (!image->file_mode)
> > +		return -EINVAL;
> 
> Why the guard? On a quick scan, I don't see this function called by
> something else except on the kexec_file_load path...

This is more of future proofing it. I have been putting this check to
catch any accidental errors if somebody ends up calling this function
from old mode.

But I am not very particular about it. If you don't like it, I can get
rid of it.
 
> 
> > +
> > +	if (image->nr_segments >= KEXEC_SEGMENT_MAX)
> > +		return -EINVAL;
> > +
> > +	/*
> > +	 * Make sure we are not trying to add segment after allocating
> > +	 * control pages. All segments need to be placed first before
> > +	 * any control pages are allocated. As control page allocation
> > +	 * logic goes through list of segments to make sure there are
> > +	 * no destination overlaps.
> > +	 */
> > +	WARN_ONCE(!list_empty(&image->control_pages), "Adding kexec segment"
> 
> Maybe say at which address here:
> 
> ... "Adding a kexec segment at address 0x%lx.."
> 
> for a bit more helpful info.

I think address does not matter here. You can't add a segemnt after you
have allocated a control page. So I am not sure how printing address will
help.

> 
> > +			" after allocating control pages\n");
> > +
> > +	if (bufsz > memsz)
> > +		return -EINVAL;
> > +	if (memsz == 0)
> > +		return -EINVAL;
> > +
> > +	/* Align memsz to next page boundary */
> > +	memsz = ALIGN(memsz, PAGE_SIZE);
> 
> We even have PAGE_ALIGN for that.

Ok, there is not much difference between two, but I can use PAGE_ALIGN().

> 
> > +
> > +	/* Make sure base is atleast page size aligned */
> > +	if (base & (PAGE_SIZE - 1))
> 
> PAGE_ALIGNED even :)

Will use it. :-)

> 
> > +		return -EINVAL;
> > +
> > +	memset(&ksegment, 0, sizeof(struct kexec_segment));
> > +	ksegment.mem = base;
> > +	ksegment.memsz = memsz;
> > +
> > +	/* Validate memory range */
> > +	ret = walk_system_ram_res(base, base + memsz - 1, &ksegment,
> > +				validate_ram_range_callback);
> > +
> > +	/* If a valid range is found, 1 is returned */
> > +	if (ret != 1)
> 
> That's the retval of validate_ram_range_callback, right? So
> 
> 	if (!ret)
> 
> And shouldn't the convention be the opposite? 0 on success, !0 on error?

Ok, this one is little twisted.

walk_system_ram_res() stops calling callback function if callback
function returned non zero code.

So in this case, once we have found the range to be valid, we don't want
to continue to loop and look at any more ranges. So we return "1". If
we return "0" for success, outer loop of walk_system_ram_res() will
continue with next ranges.

Given the fact that "0" is interpreted as success by walk_system_ram_res()
and it continues with next set of ranges, I could not use 0 as final
measure of success. Negative returns are errors. So I thought of using
postive values of ret to indicate whether range was found or not.

If there are better ways to handle it, I am all for it.

Thanks
Vivek
