Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965240AbaCTTkU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 15:40:20 -0400
Received: from smtp-out-028.synserver.de ([212.40.185.28]:1064 "EHLO
	smtp-out-025.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933552AbaCTTkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 15:40:14 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 7923
Message-ID: <532B4446.9060607@metafoo.de>
Date: Thu, 20 Mar 2014 20:40:54 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Songhee Baek <sbaek@nvidia.com>, Arun Shamanna Lakshmi <aruns@nvidia.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "tiwai@suse.de" <tiwai@suse.de>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH] ASoC: Add support for multi register mux
References: <1395186692-11735-1-git-send-email-aruns@nvidia.com> <20140318235941.GT11706@sirena.org.uk> <781A12BB53C15A4BB37291FDE08C03F3A05CB21E46@HQMAIL02.nvidia.com> <20140320114829.GC11706@sirena.org.uk> <532B3161.6080808@wwwdotorg.org> <20140320183638.GI11706@sirena.org.uk> <532B3C03.7030208@metafoo.de>
In-Reply-To: <532B3C03.7030208@metafoo.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2014 08:05 PM, Lars-Peter Clausen wrote:
> On 03/20/2014 07:36 PM, Mark Brown wrote:
>> On Thu, Mar 20, 2014 at 12:20:17PM -0600, Stephen Warren wrote:
>>> On 03/20/2014 05:48 AM, Mark Brown wrote:
>>>> On Wed, Mar 19, 2014 at 04:44:00PM -0700, Arun Shamanna Lakshmi wrote:
>>
>>>>> If each bit of a 32 bit register maps to an input of a mux, then with
>>>>> the current 'soc_enum' structure we cannot have more than 64 inputs
>>>>> for the mux (because of reg and reg2 only).
>>
>>>> What makes you say that?  We currently have devices in mainline which
>>>> have well over 32 inputs to muxes.
>>
>>> I think their register layout is different.
>>
>>> I found a number of large muxes where the register stores a 'integer'
>>> indicating which mux input to select, e.g. Arizona, WM2200, etc. In this
>>> case, an N-bit register could support up to 2^N inputs.
>>
>>> However, the registers in the Tegra AHUB use 1 bit position per input,
>>> and require you to set one single bit at a time. Hence, an N bit
>>> register (or string of registers) can support up to N inputs. In more
>>> recent Tegra chips, we have at least >32 inputs and I think Arun was
>>> saying even >64 inputs. That requires 2 or 3 or more .reg fields in
>>> struct soc_enum.
>>
>> Right, that was my guess too (the mail wasn't terribly clear with the
>> formatting, references to unpublished documents and so on) but that's
>> not a straight mux, it's a value mux, and the limit with the current
>> code is much lower on 32 bit systems (like at least some of the K1s)
>> since muxes only use one of the current register fields.
>
> It might make sense to add special code for supported muxes with a one-hot
> encoding instead of using a value mux. Having an large array where each
> entry is just 1<<n is a bit ugly in my opinion, especially if the value
> needs to be able to be larger than 2**64. But anyway the patch that modifies
> the soc_enum struct should also add the code that makes use of the new
> struct layout.

On the other hand this can actually already be implemented without any core 
changes by using a virtual mux and connecting a supply widget to each input 
which sets the bit for that input. DAPM will take care that only one of the 
supply widgets is enabled at a time.

- Lars

