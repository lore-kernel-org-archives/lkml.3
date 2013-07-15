Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717Ab3GOSpu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 14:45:50 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:35602 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638Ab3GOSps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 14:45:48 -0400
Message-ID: <1373913944.3745.16.camel@bwh-desktop.uk.level5networks.com>
Subject: Re: [PATCH net 2/2] usb/net/r815x: fix cast to restricted __le32
From: Ben Hutchings <bhutchings@solarflare.com>
To: Hayes Wang <hayeswang@realtek.com>
CC: <gregkh@linuxfoundation.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Date: Mon, 15 Jul 2013 19:45:44 +0100
In-Reply-To: <1373617576-2272-2-git-send-email-hayeswang@realtek.com>
References: <1373617576-2272-1-git-send-email-hayeswang@realtek.com>
	 <1373617576-2272-2-git-send-email-hayeswang@realtek.com>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-20016.005
X-TM-AS-Result: No--14.535500-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-07-12 at 16:26 +0800, Hayes Wang wrote:
> >> drivers/net/usb/r815x.c:38:16: sparse: cast to restricted __le32
> >> drivers/net/usb/r815x.c:67:15: sparse: cast to restricted __le32
> >> drivers/net/usb/r815x.c:69:13: sparse: incorrect type in assignment (different base types)
>    drivers/net/usb/r815x.c:69:13:    expected unsigned int [unsigned] [addressable] [assigned] [usertype] tmp
>    drivers/net/usb/r815x.c:69:13:    got restricted __le32 [usertype] <noident>
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>
> Spotted-by: kbuild test robot <fengguang.wu@intel.com>
> ---
>  drivers/net/usb/r815x.c | 21 ++++++++++++---------
>  1 file changed, 12 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/usb/r815x.c b/drivers/net/usb/r815x.c
> index 6516737..8523922 100644
> --- a/drivers/net/usb/r815x.c
> +++ b/drivers/net/usb/r815x.c
> @@ -26,16 +26,18 @@ static int pla_read_word(struct usb_device *udev, u16 index)
>  {
>  	int data, ret;
>  	u8 shift = index & 2;
> +	__le32 ocp_data;
>  
>  	index &= ~3;
>  
>  	ret = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
>  			      RTL815x_REQ_GET_REGS, RTL815x_REQT_READ,
> -			      index, MCU_TYPE_PLA, &data, sizeof(data), 500);
> +			      index, MCU_TYPE_PLA, &ocp_data, sizeof(ocp_data),
> +			      500);
[...]

There seems to be another bug here: USB buffers must be DMA-able,
therefore cannot be placed on the stack.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

