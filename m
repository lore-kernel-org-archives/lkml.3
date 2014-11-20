Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757600AbaKTKbf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 05:31:35 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50808 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757185AbaKTKbd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 05:31:33 -0500
Message-ID: <1416479490.28599.13.camel@linux-0dmf.site>
Subject: Re: [PATCH v1] Input: elants_i2c: Add Elan touchscreen support
From: Oliver Neukum <oneukum@suse.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: scott <scott.liu@emc.com.tw>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, Vincent Wang <vincent.wang@emc.com.tw>,
        Jeff Chuang <jeff.chuang@emc.com.tw>,
        Benson Leung <bleung@chromium.org>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        David Herrmann <dh.herrmann@gmail.com>
Date: Thu, 20 Nov 2014 11:31:30 +0100
In-Reply-To: <20141120081113.GA37534@dtor-ws>
References: <1388146515-19481-1-git-send-email-scott.liu@emc.com.tw>
	 <20141120081113.GA37534@dtor-ws>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> +static int elants_i2c_sw_reset(struct i2c_client *client)
> +{
> +       const u8 soft_rst_cmd[] = { 0x77, 0x77, 0x77, 0x77 };
> +       int error;
> +
> +       error = elants_i2c_send(client, soft_rst_cmd,
> +                               sizeof(soft_rst_cmd));
> +       if (error) {
> +               dev_err(&client->dev, "software reset failed: %d\n",
> error);
> +               return error;
> +       }
> +
> +       /*
> +        * We should wait at least 10 msec (but no more than 40)
> before
> +        * sending fastboot or IAP command to the device.
> +        */
> +       msleep(30);

If timing is critical in both ways, you should take our guarantee
if sufficient sleep. I suggest you sleep 11msecs.


> +static int elants_i2c_initialize(struct elants_data *ts)
> +{
> +       struct i2c_client *client = ts->client;
> +       int error, retry_cnt;
> +       const u8 hello_packet[] = { 0x55, 0x55, 0x55, 0x55 };
> +       const u8 recov_packet[] = { 0x55, 0x55, 0x80, 0x80 };
> +       u8 buf[HEADER_SIZE];
> +

Strictly speaking you should disable preemption here.

> +       for (retry_cnt = 0; retry_cnt < MAX_RETRIES; retry_cnt++) {
> +               error = elants_i2c_sw_reset(client);
> +               if (error) {
> +                       /* Continue initializing if it's the last try
> */
> +                       if (retry_cnt < MAX_RETRIES - 1)
> +                               continue;
> +               }

	Regards
		Oliver

-- 
Oliver Neukum <oneukum@suse.de>

