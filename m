Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528Ab3K2Lun (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 06:50:43 -0500
Received: from mail.skyhub.de ([78.46.96.112]:57502 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752398Ab3K2Luk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 06:50:40 -0500
Date: Fri, 29 Nov 2013 12:50:29 +0100
From: Borislav Petkov <bp@alien8.de>
To: Dave Young <dyoung@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        greg@kroah.com, matt@console-pimps.org, toshi.kani@hp.com
Subject: Re: [PATCH v4 06/12] efi: export efi runtime memory mapping to sysfs
Message-ID: <20131129115029.GB4266@pd.tnic>
References: <1385445477-9665-1-git-send-email-dyoung@redhat.com>
 <1385445477-9665-7-git-send-email-dyoung@redhat.com>
 <20131127114402.GB32267@pd.tnic>
 <20131129094034.GI4186@dhcp-16-126.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131129094034.GI4186@dhcp-16-126.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 29, 2013 at 05:40:35PM +0800, Dave Young wrote:
> Matt are suggesting to below one, is it ok to you? I'm fine with both.
>
> The efi runtime services can only be switched to virtual mode once
> without rebooting. The kexec kernel must maintain the same physical
> to virtual address mappings as the first kernel. The mappings are
> exported to sysfs so userspace tools can reassemble them and pass them
> into the kexec kernel.

His is explaining it better so take his :)

> Is it always 4K, how about "in pages"?

Actually no, so "in pages" is better.

> Since we do not know the exact number of ranges, introducing a list
> or count the totoal range numbers before will add more code. Do you
> really think it's necessary?
>
> I tend to not fix every warnings from checkpatch if it's not a
> must-fix one.

No need for the list - I actually meant you simply use a tmp pointer for
each krealloc invocation - just look around the tree for examples.

Also think about what happens to the pointed-to memory when krealloc
returns NULL.

> suppose kexec runtime map preparing fails we still can get 1st kernel
> boot ok.

Yeah, nothing stops that - especially if you iterate over the mapped
regions a second time separately, for kexec.

Which reminds me, all that save_runtime_map code needs to be behind
CONFIG_KEXEC. We don't want to be doing this if KEXEC is not enabled.

> > What would be much cleaner IMO would be if you let efi_map_regions()
> > finish, *and*, *only* if it was successful iterate again over the
> > regions and do efi_save_runtime_map() on the runtime ones. This will
> > make the code much more readable too.
> 
> For simplifying the code, will do.

Right, and hide it behind CONFIG_KEXEC too, while you're at it.

> I did not add KEXEC because I thought it can be used for debugging
> purpose.

mfleming is thinking about it :)

> Will check and update, what tree are you using?

Always current Linus tree and tip/master. This helps catch issues like
that.

> Hmm, it's created in efi.c so I think we can not move it..

Ok, so we apparently export naked kobjects like that. All right, fair
enough.

...

> Thanks for catching, actually I have changed it in my local tree since
> your last comment about other file.

:)

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
