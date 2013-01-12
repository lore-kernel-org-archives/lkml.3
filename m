Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317Ab3ALLHL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 06:07:11 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:17286 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005Ab3ALLHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 06:07:09 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Sat, 12 Jan 2013 03:06:46 -0800
Message-ID: <50F143C3.3060900@nvidia.com>
Date: Sat, 12 Jan 2013 16:36:43 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFT 3/3] ARM: tegra: dts: seaboard: enable keyboard
References: <1357911185-11048-1-git-send-email-ldewangan@nvidia.com> <1357911185-11048-3-git-send-email-ldewangan@nvidia.com> <50F09BC7.90607@wwwdotorg.org> <20130111232438.GN23505@n2100.arm.linux.org.uk> <50F09FCB.70809@wwwdotorg.org> <20130111233615.GO23505@n2100.arm.linux.org.uk> <50F0A2A8.3080401@wwwdotorg.org> <50F13C34.3020808@nvidia.com> <20130112104730.GQ23505@n2100.arm.linux.org.uk>
In-Reply-To: <20130112104730.GQ23505@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 12 January 2013 04:17 PM, Russell King - ARM Linux wrote:
> On Sat, Jan 12, 2013 at 04:04:28PM +0530, Laxman Dewangan wrote:
>> Going through clock driver, the clk_get() should return error pointer or
>> valid pointer, atleast not NULL.
> No.  clk_get() will return whatever value the 'clk' pointer found in
> the clk_lookup structure contains.  Or it will return an error pointer.
>
> This topic has had enough discussion in the past that I'll say: go and
> look up in the archives emails from me on this subject.  I've been very
> clear over the years about this.
>
>> Probably our clock driver is returning to NULL and hence issue is
>> becasue whole world, it  check for IS_ERR or !IS_ERR() and null clk
>> pointer treated as !IS_ERR().
> Probably not.  As far as _drivers_ go, either the clk cookie is an error
> (IS_ERR() is true) _OR_ it is valid to be passed back into the clock API.
> You will find statements from me in the past to that: whatever clk_get()
> returns which is _not_ an error must be accepted by the rest of the clk
> API.

Ok, Should we document that after clk_get(), we should check for 
IS_ERR() only for validation. The way you explain earlier.
Documentation does not have this.
/**
         struct clk *clk;
         clk = clk_get(NULL, "my_gateable_clk");

         clk_prepare(clk);
         clk_enable(clk);
**/

The clk.h explain this:
  * Returns a struct clk corresponding to the clock producer, or
  * valid IS_ERR() condition containing errno.


The IS_ERR() return false for the null pointer. So as per you, it should 
be valid if the IS_ERR() false for returned pointer and hence NULL 
pointer should be valid for the clock driver.

Now we need to change the tegra_periph_reset_*() to accept the null pointer.


> Drivers never dereference the returned clk, so why should they care about
> anything other than "is it an error" given by IS_ERR().  (notice the lack
> of question mark, that's not a question to be answered.)

The issue is that information is getting passed to other part fo driver 
where it is dereferencing the pointer. Probably we need to work on the 
reset part also to move as part of clock driver to avoid this crash.


