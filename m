Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933280AbaEMM5Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 08:57:24 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:41758 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932547AbaEMM5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 08:57:21 -0400
Message-ID: <537216AC.4090401@ti.com>
Date: Tue, 13 May 2014 18:27:16 +0530
From: George Cherian <george.cherian@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Daniel Mack <zonque@gmail.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v3 0/5] Add support for SW babble Control
References: <1399969905-3509-1-git-send-email-george.cherian@ti.com> <5371EA01.3080307@gmail.com> <537208A9.4020507@ti.com> <53720E0F.3070008@gmail.com>
In-Reply-To: <53720E0F.3070008@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/13/2014 5:50 PM, Daniel Mack wrote:
> On 05/13/2014 01:57 PM, George Cherian wrote:
>> On 5/13/2014 3:16 PM, Daniel Mack wrote:
>>> On 05/13/2014 10:31 AM, George Cherian wrote:
>>>> Series add support for SW babble control logic found in
>>>> new silicon versions of AM335x. Runtime differentiation of
>>>> silicon version is done by checking the BABBLE_CTL register.
>>>> For newer silicon the register default value read is 0x4 and
>>>> for older versions its 0x0.
>>> I tested this on a AM33xx platform and don't see any regression at
>>> least. This hardware has MUSB_BABBLE_CTL == MUSB_BABBLE_RCV_DISABLE.
>>> Anything particular you want me to test as well?
>> Are you seeing a wrapper restart done always or does it continue with a
>> restart
>> after the babble condition?
> MUSB_BABBLE_CTL == MUSB_BABBLE_RCV_DISABLE, so sw_babble_control() is
> called from dsps_musb_reset(). However, MUSB_BABBLE_CTL still returns
> 0x04 (MUSB_BABBLE_RCV_DISABLE) inside that function, which means
> (babble_ctl & MUSB_BABBLE_STUCK_J) is false, and hence
> sw_babble_control() returns 1.
Ah.... Missed a critical portion....
My bad...

I never enabled the MUSB_BABBLE_SW_SESSION_CTRL in the MUSB_BABBLE_CTL reg.
can you try with the following patch.

diff --git a/drivers/usb/musb/musb_dsps.c b/drivers/usb/musb/musb_dsps.c
index 1ae6681..1160cd1 100644
--- a/drivers/usb/musb/musb_dsps.c
+++ b/drivers/usb/musb/musb_dsps.c
@@ -477,8 +477,11 @@ static int dsps_musb_init(struct musb *musb)
  	 * logic enabled.
  	 */
  	val = dsps_readb(musb->mregs, MUSB_BABBLE_CTL);
-	if (val == MUSB_BABBLE_RCV_DISABLE)
+	if (val == MUSB_BABBLE_RCV_DISABLE) {
  		glue->sw_babble_enabled = true;
+		val |= MUSB_BABBLE_SW_SESSION_CTRL;
+	        dsps_writeb(musb->mregs, MUSB_BABBLE_CTL, val);
+	}
  
  	ret = dsps_musb_dbg_init(musb, glue);
  	if (ret)
-- 1.8.3.1

I will resend the series, if this works fine.
Thanks for all your help.

>   Consequently, the glue is fully reset in
> this case. Does this help?
>
> FWIW, this is the output of dsps_musb_reset() with dev_dbg() enabled:
>
> [   54.066124] CAUTION: musb: Babble Interrupt Occurred
> [   54.071856] usb 1-1: USB disconnect, device number 8
> [   54.159495] musb-hdrc musb-hdrc.0.auto: babble: MUSB_BABBLE_CTL value 4
> [   54.166446] musb-hdrc musb-hdrc.0.auto: STUCK_J is reset
>
>
> I only have one exact USB device to reproduce the babble condition, so I
> guess this is all I can do for now.
Same with me also . I also have only one device with which i get the issue.
>
>
> Thanks,
> Daniel
>


-- 
-George

