Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603AbaBRAg7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 19:36:59 -0500
Received: from mail.skyhub.de ([78.46.96.112]:59164 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754210AbaBRAg5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 19:36:57 -0500
Date: Tue, 18 Feb 2014 01:36:54 +0100
From: Borislav Petkov <bp@alien8.de>
To: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
Cc: dougthompson@xmission.com, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] EDAC, MCE, AMD: Fix code to prevent NULL dereference
Message-ID: <20140218003654.GK4559@pd.tnic>
References: <1392659391-2411-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
 <20140217182729.GE4559@pd.tnic>
 <5302625C.4050700@amd.com>
 <20140217194153.GG4559@pd.tnic>
 <53028EE8.20106@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <53028EE8.20106@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 04:36:24PM -0600, Aravind Gopalakrishnan wrote:
> snapshot of the oops from simulating on my system:
> [   28.846200] [Hardware Error]: MC0 Error:
> [   28.846218] BUG: unable to handle kernel NULL pointer dereference
> at           (null)
> [   28.846232] IP: [<ffffffff81608526>] amd_decode_mce+0x526/0x900

Ok, I see it now.

mce_amd_inj.c calls directly amd_decode_mce() which is wrong. What it
should do, instead, is what mce_log does:

	ret = atomic_notifier_call_chain(&x86_mce_decoder_chain, 0, mce);
	...


and send the mce struct through the notifier chain so that if we haven't
registered on it, we don't decode the error.

> Shall I work up the patch with both sets of changes and resend?

Just replace the amd_decode_mce() call in mce_amd_inj.c with the above
call to the notifier and it should work, AFAICT. We should still add the
hunk I sent you earlier to take care of the module case. Oh, and make
amd_decode_mce() static so that nothing outside of mce_amd.c uses it.

I might be missing something but it is too late now and I'm going to bed
- more fun tomorrow :-)

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
