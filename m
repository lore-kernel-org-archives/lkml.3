Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932943AbaKMLBb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 06:01:31 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:64499 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932503AbaKMLB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 06:01:28 -0500
MIME-Version: 1.0
In-Reply-To: <20141113103525.GA17038@mwanda>
References: <20141113103525.GA17038@mwanda>
Date: Thu, 13 Nov 2014 13:01:27 +0200
Message-ID: <CAE1zot+cvXbAYOZn444J=XakDLzWgZaDmMHMeUUwLHWavc9UAQ@mail.gmail.com>
Subject: Re: [patch 1/2 -next] mfd: dln2: add a limit check for invalid "echo"
From: Octavian Purdila <octavian.purdila@intel.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2014 at 12:35 PM, Dan Carpenter
<dan.carpenter@oracle.com> wrote:
> We check the other variables and traditionally we don't trust data from
> USB devices so adding a check here is normal.  This silences a static
> checker warning.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> I am unsure if this fix is correct and I don't have the hardware.
> Please review this one carefully.  The "goto out;" seems to use the
> invalid data and I don't understand why.
>
> diff --git a/drivers/mfd/dln2.c b/drivers/mfd/dln2.c
> index 9765a17..3101e5e 100644
> --- a/drivers/mfd/dln2.c
> +++ b/drivers/mfd/dln2.c
> @@ -280,6 +280,11 @@ static void dln2_rx(struct urb *urb)
>                 goto out;
>         }
>
> +       if (echo >= DLN2_MAX_RX_SLOTS) {
> +               dev_warn(dev, "invalid echo %d\n", echo);
> +               goto out;
> +       }
> +
>         data = urb->transfer_buffer + sizeof(struct dln2_header);
>         len = urb->actual_length - sizeof(struct dln2_header);
>

Hi Dan,

Thanks for the patch. You are right that we need to check echo, but
only in the case that it is not an event. In that case the echo
counter increments for every event and can easily be greater the
DLN2_MAX_RX_SLOTS. So the correct patch is to check in
dln2_transfer_complete() that rx_slot is valid. I will follow-up with
a patch for that shortly.
