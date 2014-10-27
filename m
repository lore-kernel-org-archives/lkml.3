Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503AbaJ0OoR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 10:44:17 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:37700 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043AbaJ0OoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 10:44:16 -0400
Date: Mon, 27 Oct 2014 07:44:11 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH 03/11] aiptek: Fix probable mask then right shift defects
Message-ID: <20141027144411.GA7594@dtor-ws>
References: <cover.1414387334.git.joe@perches.com>
 <8c6687a4d568c853ab649ba03d2477ee24bc6ff6.1414387334.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8c6687a4d568c853ab649ba03d2477ee24bc6ff6.1414387334.git.joe@perches.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

On Sun, Oct 26, 2014 at 10:24:59PM -0700, Joe Perches wrote:
> Precedence of & and >> is not the same and is not left to right.
> shift has higher precedence and should be done after the mask.

Looking at the protocol description the current code is exactly right.
We want to "move" button bits first as in packet type 1 they are in a
different place than in other packets.

I'll take a patch that adds parenthesis around shifts to make clear it
is intended.

Thanks.

> 
> Here the shifts are unnecessary and a non-zero value can be used
> as the test to set 1 or zero.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/input/tablet/aiptek.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/input/tablet/aiptek.c b/drivers/input/tablet/aiptek.c
> index e7f966d..dee2bb9 100644
> --- a/drivers/input/tablet/aiptek.c
> +++ b/drivers/input/tablet/aiptek.c
> @@ -489,9 +489,9 @@ static void aiptek_irq(struct urb *urb)
>  			 */
>  			jitterable = data[1] & 0x07;
>  
> -			left = (data[1] & aiptek->curSetting.mouseButtonLeft >> 2) != 0 ? 1 : 0;
> -			right = (data[1] & aiptek->curSetting.mouseButtonRight >> 2) != 0 ? 1 : 0;
> -			middle = (data[1] & aiptek->curSetting.mouseButtonMiddle >> 2) != 0 ? 1 : 0;
> +			left = data[1] & aiptek->curSetting.mouseButtonLeft ? 1 : 0;
> +			right = data[1] & aiptek->curSetting.mouseButtonRight ? 1 : 0;
> +			middle = data[1] & aiptek->curSetting.mouseButtonMiddle ? 1 : 0;
>  
>  			input_report_key(inputdev, BTN_LEFT, left);
>  			input_report_key(inputdev, BTN_MIDDLE, middle);
> -- 
> 2.1.2
> 

-- 
Dmitry
