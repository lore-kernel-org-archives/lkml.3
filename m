Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764577Ab3DDTNM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 15:13:12 -0400
Received: from numascale.com ([213.162.240.84]:51153 "EHLO numascale.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764428Ab3DDTNL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 15:13:11 -0400
X-Greylist: delayed 4041 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Apr 2013 15:13:10 EDT
Message-ID: <515DC0FA.1040408@numascale.com>
Date: Thu, 04 Apr 2013 20:05:46 +0200
From: Steffen Persvold <sp@numascale.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>,
        Daniel J Blueman <daniel@numascale-asia.com>,
        Tony Luck <tony.luck@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, amd, mce: Prevent potential cpu-online oops
References: <1365090720-12652-1-git-send-email-daniel@numascale-asia.com> <20130404161340.GF32271@pd.tnic>
In-Reply-To: <20130404161340.GF32271@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cpanel21.proisp.no
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - numascale.com
X-Get-Message-Sender-Via: cpanel21.proisp.no: authenticated_id: sp@numascale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/4/2013 6:13 PM, Borislav Petkov wrote:
> On Thu, Apr 04, 2013 at 11:52:00PM +0800, Daniel J Blueman wrote:
>> On platforms where all Northbridges may not be visible (due to routing, eg on
>> NumaConnect systems), prevent oopsing due to stale pointer access when
>> offlining cores.
>>
>> Signed-off-by: Steffen Persvold <sp@numascale.com>
>> Signed-off-by: Daniel J Blueman <daniel@numascale-asia.com>
> 
> Huh, what's up?
> 
> This one is almost reverting 21c5e50e15b1a which you wrote in the first
> place. What's happening? What stale pointer access, where? We have the
> if (nb ..) guards there.
> 
> This commit message needs a *lot* more explanation about what's going
> on and why we're reverting 21c5e50e15b1a. And why the special handling
> for shared banks? I presume you offline some of the cores and there's a
> dangling pointer but again, there are the nb validity guards...
> 
> /me is genuinely confused.
> 

You get oopses when offlining cores when there's no NB struct for the shared MC4 bank. In threshold_remove_bank(), there's no "if (!nb)" guard :

	if (shared_bank[bank]) {
		if (!atomic_dec_and_test(&b->cpus)) {
			__threshold_remove_blocks(b);
			per_cpu(threshold_banks, cpu)[bank] = NULL;
			return;
		} else {
			/*
			 * the last CPU on this node using the shared bank is
			 * going away, remove that bank now.
			 */
			nb = node_to_amd_nb(amd_get_nb_id(cpu));
			nb->bank4 = NULL;
		}
	}


nb->bank4 = NULL will oops, since nb is NULL.

It made more sense (to me) to skip the creation of MC4 all together if you can't find the matching northbridge since you can't reliably do the dec_and_test() reference counting on the shared bank when you don't have the common NB struct for all the shared cores.

Or am I just smoking the wrong stuff ?

Cheers,
Steffen



