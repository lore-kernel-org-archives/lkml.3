Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934048Ab3LIQRm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 11:17:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50286 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932923Ab3LIQRj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 11:17:39 -0500
Message-ID: <52A5ECF4.6030301@redhat.com>
Date: Mon, 09 Dec 2013 17:16:52 +0100
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: linux-sunxi@googlegroups.com, Chen-Yu Tsai <wens@csie.org>
CC: Giuseppe Cavallaro <peppe.cavallaro@st.com>, netdev@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [linux-sunxi] Re: [PATCH 04/10] net: stmmac: sunxi platfrom extensions
 for GMAC in Allwinner A20 SoC's
References: <1386350983-13281-1-git-send-email-wens@csie.org> <1386350983-13281-5-git-send-email-wens@csie.org> <52A5A52C.50605@st.com>
In-Reply-To: <52A5A52C.50605@st.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 12/09/2013 12:10 PM, srinivas kandagatla wrote:
> Hi Chen,
> Good to know that Allwinner uses gmac.
>
> On ST SoC, we have very similar requirements, before we merge any of
> these changes I think we need to come up with common way to solve both
> Allwinner and ST SOCs use cases.
>
> I have already posted few patches on to net-dev
> http://lkml.org/lkml/2013/11/12/243 to add Glue driver on top of stmmac
> driver.
>
>
> There are few reasons for the way I have done it.
>
> 1> I did not want to modify gmac driver in any sense to when a new SOC
> support is added.
> 2> As the SOC specific glue logic sits on top of standard GMAC IP, it
> makes sense to represent it proper harware hierarchy.

On top often is not the correct term / how things are done in practice.

Most of the time the glue are modifications to the ip block, iow in
hardware they are not nested / hierarchical at all. We've had similar
constructs for ahci platform drivers and there we are actively trying to
move away from the whole nested platform devices as that has various
issues:

1) It is wrong / does not reflect reality
2) It breaks deferred probing which is often used on SOCs

I actually think Wens' approach using a SOC specific init function
in platform data is sound, and this is also used a lot else where.

As for using the nested approach elsewhere, I only know about AHCI
platform driver doing that, and there we are actively trying to move
away from it.


Now reading this has also made me take a closer look at wens' patch
for this. Wens, I see that you directly modify registers in the ccm
that is a big no-no instead you should add a helper function to
sunxi-clk.c and use that, see ie:
https://bitbucket.org/emiliolopez/linux/commits/2b95847d9aa4aa13317dd7358ffcbd951dcb5eff?at=master


Giuseppe, I get the feeling the 0x148 registers st-gmac is using is
the same story, but I could be wrong. One important reason why accessing
regs like this directly is a big no no is because it is impossible to
do proper locking between multiple users, so 2 users doing read / modify / write
could end up racing. So accesses to such registers should always happen
through a single driver.


Regards,

Hans
