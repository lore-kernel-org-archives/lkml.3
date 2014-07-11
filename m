Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438AbaGKBtL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 21:49:11 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:4877 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586AbaGKBtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 21:49:09 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 10 Jul 2014 18:42:03 -0700
Message-ID: <53BF4292.1060009@nvidia.com>
Date: Fri, 11 Jul 2014 10:49:06 +0900
From: Alexandre Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Ben Skeggs <bskeggs@redhat.com>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gnurou@gmail.com" <gnurou@gmail.com>
Subject: Re: [PATCH 0/3] drm/gk20a: support for reclocking
References: <1404977677-22248-1-git-send-email-acourbot@nvidia.com> <20140710094300.GP23218@tbergstrom-lnx.Nvidia.com>
In-Reply-To: <20140710094300.GP23218@tbergstrom-lnx.Nvidia.com>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2014 06:43 PM, Peter De Schrijver wrote:
> On Thu, Jul 10, 2014 at 09:34:34AM +0200, Alexandre Courbot wrote:
>> This series adds support for reclocking on GK20A. The first two patches touch
>> the clock subsystem to allow GK20A to operate, by making the presence of the
>> thermal and voltage devices optional, and allowing pstates to be provided
>> directly instead of being probed using the BIOS (which Tegra does not have).
>>
>> The last patch adds the GK20A clock device. Arguably the clock can be seen as a
>> stripped-down version of what is seen on NVE0, however instead of using NVE0
>> support has been written from scratch using the ChromeOS kernel as a basis.
>> There are several reasons for this:
>>
>> - The ChromeOS driver uses a lookup table for the P coefficient which I could
>>    not find in the NVE0 driver,
>> - Some registers that NVE0 expects to find are not present on GK20A (e.g.
>>    0x137120 and 0x137140),
>> - Calculation of MNP is done differently from what is performed in
>>    nva3_pll_calc(), and it might be interesting to compare the two methods,
>> - All the same, the programming sequence is done differently in the ChromeOS
>>    driver and NVE0 could possibly benefit from it (?)
>>
>> It would be interesting to try and merge both, but for now I prefer to have the
>> two coexisting to ensure proper operation on GK20A and besure I don't break
>> dGPU support. :)
>>
>> Regarding the first patch, one might argue that I could as well add thermal
>> and voltage devices to GK20A. The reason this is not done is because these
>> currently depend heavily on the presence of a BIOS, and will require a rework
>> similar to that done in patch 2 for clocks. I would like to make sure this
>> approach is approved because applying it to other subdevs.
>
> I think this should use CCF so we can use pre and post rate change notifiers
> to hookup vdd_gpu DVS.

Do you mean that we should turn the Nouveau gk20a clock driver into a 
consumer of this CCF clock? I have nothing against this, but note that 
Nouveau can also perform DVS on its own, as the pstates can also contain 
a voltage to be applied to the volt device (not yet implemented in this 
series).

The question then becomes whether we want an additional layer of 
abstraction on these devices and whether the pre/post rate change 
notifiers give us any advantage compared to what Nouveau currently proposes.

