Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119Ab3APOGa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 09:06:30 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:52098 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754130Ab3APOG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 09:06:28 -0500
Date: Wed, 16 Jan 2013 18:00:13 +0400
From: Volokh Konstantin <volokh84@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        mchehab@redhat.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, dhowells@redhat.com,
        rdunlap@xenotime.net, hans.verkuil@cisco.com, justinmattock@gmail.com
Subject: Re: [PATCH 3/4] staging: media: go7007: i2c GPIO initialization
 Reset i2c stuff for GO7007_BOARDID_ADLINK_MPG24 need reset GPIO always when
 encoder initialize
Message-ID: <20130116140013.GB20944@VPir>
References: <1358341251-10087-1-git-send-email-volokh84@gmail.com>
 <1358341251-10087-3-git-send-email-volokh84@gmail.com>
 <20130116133608.GH4584@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130116133608.GH4584@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2013 at 04:36:08PM +0300, Dan Carpenter wrote:
> You've added the writes for GO7007_BOARDID_ADLINK_MPG24 but removed
> them for GO7007_BOARDID_XMEN and GO7007_BOARDID_XMEN_III.  Won't
> that break those boards?
>
I don`t remove code for GO7007_BOARDID_XMEN and GO7007_BOARDID_XMEN_III.
case there are auto reusing for XMen and XMen-III:
look old code:
if ((go->board_id == GO7007_BOARDID_XMEN ||
				go->board_id == GO7007_BOARDID_XMEN_III) &&
			go->i2c_adapter_online) {
		union i2c_smbus_data data;

		/* Check to see if register 0x0A is 0x76 */
		i2c_smbus_xfer(&go->i2c_adapter, 0x21, I2C_CLIENT_SCCB,
			I2C_SMBUS_READ, 0x0A, I2C_SMBUS_BYTE_DATA, &data);
		if (data.byte != 0x76) {
			if (assume_endura) {
				go->board_id = GO7007_BOARDID_ENDURA;
				usb->board = board = &board_endura;
				go->board_info = &board->main_info;
				strncpy(go->name, "Pelco Endura",
					sizeof(go->name));
			} else {
				u16 channel;
-				/* set GPIO5 to be an output, currently low */
-				go7007_write_addr(go, 0x3c82, 0x0000);
-				go7007_write_addr(go, 0x3c80, 0x00df);
				/* read channel number from GPIO[1:0] */
				go7007_read_addr(go, 0x3c81, &channel);
				channel &= 0x3;
>>>				go->board_id = GO7007_BOARDID_ADLINK_MPG24;
Here any XMen or XMen-III will reassigned as Adlink-mpg24 id
so any i2c initialization will reassigned to that id and we can use that id in
init_encoder.
				usb->board = board = &board_adlink_mpg24;
				go->board_info = &board->main_info;
				go->channel_number = channel;
				snprintf(go->name, sizeof(go->name),
					"Adlink PCI-MPG24, channel #%d",
					channel);
			}
		}
	}
> regards,
> dan carpenter
> 
> 
