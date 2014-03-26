Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038AbaCZTiF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 15:38:05 -0400
Received: from smtp-out-239.synserver.de ([212.40.185.239]:1482 "EHLO
	smtp-out-085.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751580AbaCZTiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 15:38:04 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 5255
Message-ID: <53332CC7.6060800@metafoo.de>
Date: Wed, 26 Mar 2014 20:38:47 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Arun Shamanna Lakshmi <aruns@nvidia.com>
CC: lgirdwood@gmail.com, broonie@kernel.org, swarren@wwwdotorg.org,
        Songhee Baek <sbaek@nvidia.com>, alsa-devel@alsa-project.org,
        tiwai@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH] ASoC: Add support for multi register mux
References: <1395792156-4178-1-git-send-email-aruns@nvidia.com>
In-Reply-To: <1395792156-4178-1-git-send-email-aruns@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2014 01:02 AM, Arun Shamanna Lakshmi wrote:
> If the mux uses 1 bit position per input, and requires to set one
> single bit at a time, then an N bit register can support up to N
> inputs. In more recent Tegra chips, we have at least greater than
> 64 inputs which requires at least 2 .reg fields in struct soc_enum.
>
> Signed-off-by: Arun Shamanna Lakshmi <aruns@nvidia.com>
> Signed-off-by: Songhee Baek <sbaek@nvidia.com>

The way you describe this it seems to me that a value array for this kind of 
mux would look like.

0x00000000, 0x00000000, 0x00000001
0x00000000, 0x00000000, 0x00000002
0x00000000, 0x00000000, 0x00000003
0x00000000, 0x00000000, 0x00000004
0x00000000, 0x00000000, 0x00000008
...

That seems to be extremely tedious. If the MUX uses a one hot encoding how 
about storing the index of the bit in the values array and use (1 << value) 
when writing the value to the register?

[...]
>   /* enumerated kcontrol */
>   struct soc_enum {

There doesn't actually be any code that is shared between normal enums and 
wide enums. This patch doubles the size of the soc_enum struct, how about 
having a separate struct for wide enums?

> -	int reg;
> +	int reg[SOC_ENUM_MAX_REGS];
>   	unsigned char shift_l;
>   	unsigned char shift_r;
>   	unsigned int items;
> -	unsigned int mask;
> +	unsigned int mask[SOC_ENUM_MAX_REGS];

If you make mask and reg pointers instead of arrays this should be much more 
flexible and not be limited to 3 registers.

>   	const char * const *texts;
>   	const unsigned int *values;
> +	unsigned int num_regs;
>   };
>

