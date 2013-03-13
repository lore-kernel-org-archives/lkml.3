Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933582Ab3CMOhh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 10:37:37 -0400
Received: from multi.imgtec.com ([194.200.65.239]:25019 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751901Ab3CMOhg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 10:37:36 -0400
Message-ID: <51408F1D.8010600@imgtec.com>
Date: Wed, 13 Mar 2013 14:37:17 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Seungwon Jeon <tgih.jun@samsung.com>
CC: <linux-mmc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "'Jaehoon Chung'" <jh80.chung@samsung.com>,
        "'Chris Ball'" <cjb@laptop.org>
Subject: Re: [PATCH] mmc: dw_mmc: setpower on MMC_POWER_{UP,OFF}
References: <1363085012-9220-1-git-send-email-james.hogan@imgtec.com> <002301ce1ff5$e42f8090$ac8e81b0$%jun@samsung.com>
In-Reply-To: <002301ce1ff5$e42f8090$ac8e81b0$%jun@samsung.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="EUC-KR"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_03_13_14_37_21
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/03/13 14:20, Seungwon Jeon wrote:
> Hi James,
> 
> On Tuesday, March 12, 2013, James Hogan wrote:
>> Call the setpower platform callback in response to set_ios with
>> ios->power_mode == MMC_POWER_UP or MMC_POWER_OFF, instead of from the
>> card detect work function.
>>
>> This appears to fix a problem I have where a card stuck in a funny state
>> doesn't get properly cleared by the power being turned off, presumably
>> due to lack of power sequencing. This resulted in the following log
>> messages after boot:
>>
>> mmc0: error -110 whilst initialising SD card
>> mmc_host mmc0: Bus speed (slot 0) = 99840000Hz (slot req 300000Hz, actual 298922HZ div = 167)
>> mmc0: error -110 whilst initialising SD card
>> mmc_host mmc0: Bus speed (slot 0) = 99840000Hz (slot req 200000Hz, actual 199680HZ div = 250)
>> mmc0: error -110 whilst initialising SD card
>> mmc_host mmc0: Bus speed (slot 0) = 99840000Hz (slot req 195765Hz, actual 195764HZ div = 255)
>> mmc0: error -110 whilst initialising SD card
>> mmc_host mmc0: Bus speed (slot 0) = 99840000Hz (slot req 400000Hz, actual 399360HZ div = 125)
>> mmc0: error -110 whilst initialising SD card
>> mmc_host mmc0: Bus speed (slot 0) = 99840000Hz (slot req 300000Hz, actual 298922HZ div = 167)
>>
>> Signed-off-by: James Hogan <james.hogan@imgtec.com>
>> Cc: Seungwon Jeon <tgih.jun@samsung.com>
> 
> This patch is reasonable.
> I just want to know though.
> I guess this problem is happened when card is inserted as soon as card is removed.
> If not, could you explain your situation more?

Hi,

It initially started happening after the patch by Yuvaraj CD ("mmc:
dw_mmc: enable controller interrupt before calling mmc_start_host").
Basically after hard resetting the board the card would be in a dodgy
state, and I'd get these elusive errors after boot (see the above patch
thread for details). It was specifically the position of the prink that
it was sensitive to (I have a JTAG console turned on which adds big
latencies to prinks, so it's clearly some kind of race). Unplugging the
card cleared the problem, as did cutting the power to the card for a
sufficient amount of time. While trying to debug the messages I saw
these power callbacks and thought I'd try them as they seem like a much
better place to control the card power, and seem to match other host
drivers too, and it fixed the problem, I presume due to the intentional
delays around those calls. It is of course possible that the race is
just hiding again, but I think the patch is an improvement regardless.

Cheers
James

