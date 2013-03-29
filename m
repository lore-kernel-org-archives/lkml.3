Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236Ab3C2QnY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 12:43:24 -0400
Received: from smtprelay-h21.telenor.se ([195.54.99.196]:54656 "EHLO
	smtprelay-h21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755011Ab3C2QnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 12:43:21 -0400
X-SENDER-IP: [85.230.168.206]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AshaAOPDVVFV5qjOPGdsb2JhbABDixO3SwQBgQgXAwEBAQE4NYIfAQEEARoNExwjBQsIAw4TJQ8FDRgKGhOIAgMJCrYcDYlbFYxBgTSBHQeCX2EDlQuBX4YRhWCIJzs
X-IronPort-AV: E=Sophos;i="4.87,374,1363129200"; 
   d="scan'208";a="301620747"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Fri, 29 Mar 2013 17:44:07 +0100
To: Valyushkov Ivan <ktopisal@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Feature: Support ALPS v6.
Message-ID: <20130329164407.GA1997@polaris.bitmath.org>
References: <1364112088-15111-1-git-send-email-ktopisal@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364112088-15111-1-git-send-email-ktopisal@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ivan,

> Tested on Dell 7720. Works fine.
> 
> Signed-off-by: Valyushkov Ivan <ktopisal@gmail.com>
> ---
>  drivers/input/mouse/alps.c |  464 +++++++++++++++++++++++++++++++++++++++++---
>  drivers/input/mouse/alps.h |    2 +
>  2 files changed, 443 insertions(+), 23 deletions(-)

This patch does not seem to apply to Linus' tree, nor to next. What
tree is it based on?

> 
> diff --git a/drivers/input/mouse/alps.c b/drivers/input/mouse/alps.c
> index e229fa3..38361bc 100644
> --- a/drivers/input/mouse/alps.c
> +++ b/drivers/input/mouse/alps.c
> @@ -15,6 +15,8 @@
>   * the Free Software Foundation.
>   */
>  
> +#define DEBUG
> +

Looks like the patch needs to be cleaned a bit.

>  #include <linux/slab.h>
>  #include <linux/input.h>
>  #include <linux/input/mt.h>
> @@ -30,9 +32,6 @@
>  #define ALPS_V3_X_MAX	2000
>  #define ALPS_V3_Y_MAX	1400
>  
> -#define ALPS_BITMAP_X_BITS	15
> -#define ALPS_BITMAP_Y_BITS	11
> -
>  #define ALPS_CMD_NIBBLE_10	0x01f2
>  
>  static const struct alps_nibble_commands alps_v3_nibble_commands[] = {
> @@ -84,6 +83,12 @@ static const struct alps_nibble_commands alps_v4_nibble_commands[] = {
>  #define ALPS_PS2_INTERLEAVED	0x80	/* 3-byte PS/2 packet interleaved with
>  					   6-byte ALPS packet */
>  
> +/* Set these based upon protocol version */
> +static int ALPS_X_MAX;   /* right edge */
> +static int ALPS_Y_MAX;   /* bottom edge */
> +static int ALPS_BITMAP_X_BITS; /* mt number of x bits */
> +static int ALPS_BITMAP_Y_BITS; /* mt number of y bits */
> +
>  static const struct alps_model_info alps_model_data[] = {
>  	{ { 0x32, 0x02, 0x14 },	0x00, ALPS_PROTO_V2, 0xf8, 0xf8, ALPS_PASS | ALPS_DUALPOINT },	/* Toshiba Salellite Pro M10 */
>  	{ { 0x33, 0x02, 0x0a },	0x00, ALPS_PROTO_V1, 0x88, 0xf8, 0 },				/* UMAX-530T */
> @@ -112,6 +117,9 @@ static const struct alps_model_info alps_model_data[] = {
>  	{ { 0x73, 0x02, 0x64 },	0x9b, ALPS_PROTO_V3, 0x8f, 0x8f, ALPS_DUALPOINT },
>  	{ { 0x73, 0x02, 0x64 },	0x9d, ALPS_PROTO_V3, 0x8f, 0x8f, ALPS_DUALPOINT },
>  	{ { 0x73, 0x02, 0x64 },	0x8a, ALPS_PROTO_V4, 0x8f, 0x8f, 0 },
> +	{ { 0x73, 0x03, 0x0a }, 0x1d, ALPS_PROTO_V5, 0x8f, 0x8f, ALPS_DUALPOINT },  /* Dell Latitude E6430 */
> +	{ { 0x73, 0x03, 0x50 }, 0x0d, ALPS_PROTO_V6, 0xc8, 0xc8, 0 }, /* Dell Inspiron N5110 */
> +	{ { 0x73, 0x03, 0x50 }, 0x02, ALPS_PROTO_V6, 0xc8, 0xc8, 0 } /* Dell Inspiron 17R 7720 */
>  };
>  
>  /*
> @@ -355,9 +363,9 @@ static int alps_process_bitmap(unsigned int x_map, unsigned int y_map,
>  		}
>  	}
>  
> -	*x1 = (ALPS_V3_X_MAX * (2 * x_low.start_bit + x_low.num_bits - 1)) /
> +	*x1 = (ALPS_X_MAX * (2 * x_low.start_bit + x_low.num_bits - 1)) /
>  	      (2 * (ALPS_BITMAP_X_BITS - 1));
> -	*y1 = (ALPS_V3_Y_MAX * (2 * y_low.start_bit + y_low.num_bits - 1)) /
> +	*y1 = (ALPS_Y_MAX * (2 * y_low.start_bit + y_low.num_bits - 1)) /
>  	      (2 * (ALPS_BITMAP_Y_BITS - 1));
>  
>  	if (fingers > 1) {
> @@ -388,7 +396,7 @@ static void alps_report_semi_mt_data(struct input_dev *dev, int num_fingers,
>  	alps_set_slot(dev, 1, num_fingers == 2, x2, y2);
>  }
>  
> -static void alps_process_trackstick_packet_v3(struct psmouse *psmouse)
> +static void alps_process_trackstick_packet_v3_v5(struct psmouse *psmouse)
>  {
>  	struct alps_data *priv = psmouse->private;
>  	unsigned char *packet = psmouse->packet;
> @@ -448,7 +456,7 @@ static void alps_process_trackstick_packet_v3(struct psmouse *psmouse)
>  	return;
>  }
>  
> -static void alps_process_touchpad_packet_v3(struct psmouse *psmouse)
> +static void alps_process_touchpad_packet_v3_v5(struct psmouse *psmouse)
>  {
>  	struct alps_data *priv = psmouse->private;
>  	unsigned char *packet = psmouse->packet;
> @@ -579,7 +587,7 @@ static void alps_process_touchpad_packet_v3(struct psmouse *psmouse)
>  	}
>  }
>  
> -static void alps_process_packet_v3(struct psmouse *psmouse)
> +static void alps_process_packet_v3_v5(struct psmouse *psmouse)
>  {
>  	unsigned char *packet = psmouse->packet;
>  
> @@ -592,11 +600,11 @@ static void alps_process_packet_v3(struct psmouse *psmouse)
>  	 * of packets.
>  	 */
>  	if (packet[5] == 0x3f) {
> -		alps_process_trackstick_packet_v3(psmouse);
> +		alps_process_trackstick_packet_v3_v5(psmouse);
>  		return;
>  	}
>  
> -	alps_process_touchpad_packet_v3(psmouse);
> +	alps_process_touchpad_packet_v3_v5(psmouse);
>  }
>  
>  static void alps_process_packet_v4(struct psmouse *psmouse)
> @@ -696,6 +704,91 @@ static void alps_process_packet_v4(struct psmouse *psmouse)
>  	input_sync(dev);
>  }
>  
> +/* This is similar logic to alps_process_touchpad_packet_v3_v5.   The
> +   bitfield positions are different.
> +*/
> +static void alps_process_packet_v6(struct psmouse *psmouse)
> +{
> +	struct alps_data *priv = psmouse->private;
> +	unsigned char *packet = psmouse->packet;
> +	struct input_dev *dev = psmouse->dev;
> +	int x, y, z;
> +	int left, right, middle;
> +	int x1 = 0, y1 = 0, x2 = 0, y2 = 0;
> +	int fingers = 0;
> +	unsigned long int x_bitmap, y_bitmap;
> +
> +	/* multitouch packet */
> +	if (priv->multi_packet) {
> +		if (packet[0] & 0x20) {
> +			fingers = ((packet[0] & 0x6) >> 1 |
> +				(packet[0] & 0x10) >> 2);
> +			x_bitmap = ((packet[2] & 0x60) >> 5) |
> +				((packet[4] & 0x7f) << 2)  |
> +				((packet[5] & 0x7f) << 9)  |
> +				((packet[3] & 0x07) << 16) |
> +				((packet[3] & 0x70) << 15) |
> +				((packet[0] & 0x01) << 22);
> +			y_bitmap = (packet[1] & 0x7f) |
> +				((packet[2] & 0x1f) << 7);
> +			alps_process_bitmap(x_bitmap, y_bitmap,
> +				&x1, &y1, &x2, &y2);
> +			packet = priv->multi_data;
> +		} else {
> +			priv->multi_packet = 0;
> +		}
> +	}
> +
> +	if (packet[0] & 0x20)
> +		return;
> +
> +	if (!priv->multi_packet && (packet[0] & 0x2)) {
> +		priv->multi_packet = 1;
> +		memcpy(priv->multi_data, packet, sizeof(priv->multi_data));
> +		return;
> +	}
> +	priv->multi_packet = 0;
> +
> +	left = packet[3] & 0x1;
> +	right = packet[3] & 0x2;
> +	middle = packet[3] & 0x4;
> +
> +	x = ((packet[1] & 0x7f) | ((packet[4] & 0x0f) << 7));
> +	y = ((packet[2] & 0x7f) | ((packet[4] & 0xf0) << 3));
> +	z = (packet[0] & 4) ? 0 : packet[5] & 0x7f;
> +
> +	if (x && y && !z)
> +		return;
> +
> +	if (!fingers) {
> +		x1 = x;
> +		y1 = y;
> +		fingers = z > 0 ? 1 : 0;
> +	}
> +
> +	if (z > 64)
> +		input_report_key(dev, BTN_TOUCH, 1);
> +	else
> +		input_report_key(dev, BTN_TOUCH, 0);

It is ok to pass boolean variables in a single call.

> +
> +		alps_report_semi_mt_data(dev, fingers, x1, y1, x2, y2);
> +
> +		input_mt_report_finger_count(dev, fingers);
> +
> +		input_report_key(dev, BTN_LEFT, left);
> +		input_report_key(dev, BTN_RIGHT, right);
> +		input_report_key(dev, BTN_MIDDLE, middle);

Strange indentation here.

> +
> +	if (z > 0) {
> +		input_report_abs(dev, ABS_X, x);
> +		input_report_abs(dev, ABS_Y, y);
> +	}
> +	input_report_abs(dev, ABS_PRESSURE, z);
> +
> +	input_sync(dev);
> +}
> +
> +
>  static void alps_process_packet(struct psmouse *psmouse)
>  {
>  	struct alps_data *priv = psmouse->private;
> @@ -707,11 +800,17 @@ static void alps_process_packet(struct psmouse *psmouse)
>  		alps_process_packet_v1_v2(psmouse);
>  		break;
>  	case ALPS_PROTO_V3:
> -		alps_process_packet_v3(psmouse);
> +		alps_process_packet_v3_v5(psmouse);
>  		break;
>  	case ALPS_PROTO_V4:
>  		alps_process_packet_v4(psmouse);
>  		break;
> +	case ALPS_PROTO_V5:
> +		alps_process_packet_v3_v5(psmouse);
> +		break;
> +	case ALPS_PROTO_V6:
> +		alps_process_packet_v6(psmouse);
> +		break;
>  	}
>  }
>  
> @@ -731,6 +830,12 @@ static void alps_report_bare_ps2_packet(struct psmouse *psmouse,
>  	input_report_rel(dev2, REL_Y,
>  		packet[2] ? ((packet[0] << 3) & 0x100) - packet[2] : 0);
>  
> +	/* log buttons, REL_X, REL_Y */
> +	psmouse_dbg(psmouse, "bare_ps2_packet: %x %d %d\n",
> +		packet[0]&7,
> +		packet[1] - ((packet[0]<<4)&0x100),
> +		((packet[0] << 3) & 0x100) - packet[2]);
> +
>  	input_sync(dev2);
>  }
>  
> @@ -767,8 +872,9 @@ static psmouse_ret_t alps_handle_interleaved_ps2(struct psmouse *psmouse)
>  		      psmouse->packet[5]) & 0x80) ||
>  		    (!alps_is_valid_first_byte(priv->i, psmouse->packet[6]))) {
>  			psmouse_dbg(psmouse,
> -				    "refusing packet %4ph (suspected interleaved ps/2)\n",
> -				    psmouse->packet + 3);
> +				    "refusing packet %x %x %x %x (suspected interleaved ps/2)\n",
> +				    psmouse->packet[3], psmouse->packet[4],
> +				    psmouse->packet[5], psmouse->packet[6]);
>  			return PSMOUSE_BAD_DATA;
>  		}
>  
> @@ -830,8 +936,9 @@ static void alps_flush_packet(unsigned long data)
>  		     psmouse->packet[4] |
>  		     psmouse->packet[5]) & 0x80) {
>  			psmouse_dbg(psmouse,
> -				    "refusing packet %3ph (suspected interleaved ps/2)\n",
> -				    psmouse->packet + 3);
> +				    "refusing packet %x %x %x (suspected interleaved ps/2)\n",
> +				    psmouse->packet[3], psmouse->packet[4],
> +				    psmouse->packet[5]);
>  		} else {
>  			alps_process_packet(psmouse);
>  		}
> @@ -870,12 +977,18 @@ static psmouse_ret_t alps_process_byte(struct psmouse *psmouse)
>  	}
>  
>  	/* Bytes 2 - pktsize should have 0 in the highest bit */
> -	if (psmouse->pktcnt >= 2 && psmouse->pktcnt <= psmouse->pktsize &&
> -	    (psmouse->packet[psmouse->pktcnt - 1] & 0x80)) {
> -		psmouse_dbg(psmouse, "refusing packet[%i] = %x\n",
> -			    psmouse->pktcnt - 1,
> -			    psmouse->packet[psmouse->pktcnt - 1]);
> -		return PSMOUSE_BAD_DATA;
> +
> +	/* This test is not valid for V6 multi-touch mode!
> +		Need to restructure this code down the road */
> +	if (model->proto_version != ALPS_PROTO_V6) {
> +
> +		if (psmouse->pktcnt >= 2 && psmouse->pktcnt <= psmouse->pktsize &&
> +					(psmouse->packet[psmouse->pktcnt - 1] & 0x80)) {
> +			psmouse_dbg(psmouse, "refusing packet[%i] = %x\n",
> +						psmouse->pktcnt - 1,
> +						psmouse->packet[psmouse->pktcnt - 1]);
> +			return PSMOUSE_BAD_DATA;
> +		}
>  	}
>  
>  	if (psmouse->pktcnt == psmouse->pktsize) {
> @@ -981,7 +1094,11 @@ static int alps_enter_command_mode(struct psmouse *psmouse,
>  		return -1;
>  	}
>  
> -	if (param[0] != 0x88 && param[1] != 0x07) {
> +	/* Warning - cannot determine model yet because some devices have same
> +		E7 response but are differentiated by the command mode response
> +	*/
> +	if ((param[0] != 0x88 && param[1] != 0x07) /* For V1-V5 */
> +		&& (param[0] != 0x73 && param[1] != 0x01)) {  /* For V6 */
>  		psmouse_dbg(psmouse,
>  			    "unknown response while entering command mode: %2.2x %2.2x %2.2x\n",
>  			    param[0], param[1], param[2]);
> @@ -1088,6 +1205,10 @@ static const struct alps_model_info *alps_get_model(struct psmouse *psmouse, int
>  				psmouse_dbg(psmouse,
>  					    "Unknown command mode response %2.2x\n",
>  					    param[0]);
> +			else
> +				psmouse_dbg(psmouse,
> +							"Model=%d, proto_version=%d\n",
> +							i, model->proto_version);
>  		}
>  	}
>  
> @@ -1517,6 +1638,261 @@ error:
>  	return -1;
>  }
>  
> +static int alps_hw_init_v5(struct psmouse *psmouse)
> +{
> +	struct ps2dev *ps2dev = &psmouse->ps2dev;
> +	unsigned char param[4];
> +
> +	ps2_command(ps2dev, NULL, PSMOUSE_CMD_RESET_BAT);
> +	ps2_command(ps2dev, NULL, PSMOUSE_CMD_RESET_BAT);
> +
> +	ps2_command(ps2dev, NULL, PSMOUSE_CMD_SETSTREAM);
> +	ps2_command(ps2dev, NULL, PSMOUSE_CMD_RESET_WRAP);
> +	ps2_command(ps2dev, param, PSMOUSE_CMD_GETINFO);
> +
> +	ps2_command(ps2dev, NULL, PSMOUSE_CMD_RESET_WRAP);
> +	param[0] = 0x01;
> +	ps2_command(ps2dev, param, PSMOUSE_CMD_SETRES);
> +	ps2_command(ps2dev, NULL, PSMOUSE_CMD_SETSCALE21);
> +	param[0] = 0x01;
> +	ps2_command(ps2dev, param, PSMOUSE_CMD_SETRES);
> +	param[0] = 0x64;
> +	ps2_command(ps2dev, param, PSMOUSE_CMD_SETRATE);
> +	ps2_command(ps2dev, param, PSMOUSE_CMD_GETINFO);
> +	param[0] = 0x64;
> +	ps2_command(ps2dev, param, PSMOUSE_CMD_SETRATE);
> +	ps2_command(ps2dev, NULL, PSMOUSE_CMD_RESET_DIS);
> +	ps2_command(ps2dev, NULL, PSMOUSE_CMD_SETSTREAM);
> +
> +	ps2_command(ps2dev, NULL, PSMOUSE_CMD_SETSCALE21);
> +	ps2_command(ps2dev, NULL, PSMOUSE_CMD_SETSCALE21);
> +	ps2_command(ps2dev, NULL, PSMOUSE_CMD_SETSCALE21);
> +	ps2_command(ps2dev, param, PSMOUSE_CMD_GETINFO);
> +
> +	ps2_command(ps2dev, NULL, PSMOUSE_CMD_SETSCALE11);
> +	ps2_command(ps2dev, NULL, PSMOUSE_CMD_SETSCALE11);
> +	ps2_command(ps2dev, NULL, PSMOUSE_CMD_SETSCALE11);
> +	param[0] = 0xc8;
> +	ps2_command(ps2dev, param, PSMOUSE_CMD_SETRATE);
> +	param[0] = 0x14;
> +	ps2_command(ps2dev, param, PSMOUSE_CMD_SETRATE);
> +	ps2_command(ps2dev, NULL, PSMOUSE_CMD_SETSTREAM);
> +
> +	ps2_command(ps2dev, NULL, PSMOUSE_CMD_RESET_WRAP);
> +	ps2_command(ps2dev, param, PSMOUSE_CMD_GETINFO);
> +	ps2_command(ps2dev, NULL, PSMOUSE_CMD_RESET_WRAP);
> +	param[0] = 0x01;
> +	ps2_command(ps2dev, param, PSMOUSE_CMD_SETRES);
> +	ps2_command(ps2dev, NULL, PSMOUSE_CMD_SETSCALE21);
> +	param[0] = 0x01;
> +	ps2_command(ps2dev, param, PSMOUSE_CMD_SETRES);
> +	param[0] = 0x64;
> +	ps2_command(ps2dev, param, PSMOUSE_CMD_SETRATE);
> +	param[0] = 0x64;
> +	ps2_command(ps2dev, param, PSMOUSE_CMD_SETRATE);
> +	ps2_command(ps2dev, NULL, PSMOUSE_CMD_SETSCALE21);
> +	ps2_command(ps2dev, NULL, PSMOUSE_CMD_RESET_WRAP);
> +	param[0] = 0x01;
> +	ps2_command(ps2dev, param, PSMOUSE_CMD_SETRES);
> +	ps2_command(ps2dev, NULL, PSMOUSE_CMD_SETSCALE21);
> +	param[0] = 0x01;
> +	ps2_command(ps2dev, param, PSMOUSE_CMD_SETRES);
> +	param[0] = 0x14;
> +	ps2_command(ps2dev, param, PSMOUSE_CMD_SETRATE);
> +	ps2_command(ps2dev, param, PSMOUSE_CMD_GETINFO);
> +
> +	ps2_command(ps2dev, NULL, PSMOUSE_CMD_SETPOLL);
> +	ps2_command(ps2dev, NULL, PSMOUSE_CMD_SETSCALE21);
> +	ps2_command(ps2dev, NULL, PSMOUSE_CMD_RESET_WRAP);
> +	param[0] = 0x01;
> +	ps2_command(ps2dev, param, PSMOUSE_CMD_SETRES);
> +	ps2_command(ps2dev, NULL, PSMOUSE_CMD_SETSCALE21);
> +	ps2_command(ps2dev, NULL, PSMOUSE_CMD_RESET_WRAP);
> +	param[0] = 0x01;
> +	ps2_command(ps2dev, param, PSMOUSE_CMD_SETRES);
> +	ps2_command(ps2dev, NULL, PSMOUSE_CMD_SETSCALE21);
> +	param[0] = 0xc8;
> +	ps2_command(ps2dev, param, PSMOUSE_CMD_SETRATE);
> +	ps2_command(ps2dev, param, PSMOUSE_CMD_GETINFO);
> +
> +	ps2_command(ps2dev, NULL, PSMOUSE_CMD_RESET_WRAP);
> +	param[0] = 0x01;
> +	ps2_command(ps2dev, param, PSMOUSE_CMD_SETRES);
> +	ps2_command(ps2dev, NULL, PSMOUSE_CMD_SETSCALE21);
> +	param[0] = 0x01;
> +	ps2_command(ps2dev, param, PSMOUSE_CMD_SETRES);
> +	param[0] = 0x00;
> +	ps2_command(ps2dev, param, PSMOUSE_CMD_SETRES);
> +
> +	ps2_command(ps2dev, NULL, PSMOUSE_CMD_SETPOLL);
> +	ps2_command(ps2dev, NULL, PSMOUSE_CMD_SETPOLL);
> +	ps2_command(ps2dev, NULL, PSMOUSE_CMD_RESET_WRAP);
> +	param[0] = 0x01;
> +	ps2_command(ps2dev, param, PSMOUSE_CMD_SETRES);
> +	ps2_command(ps2dev, NULL, PSMOUSE_CMD_SETSCALE21);
> +	param[0] = 0x01;
> +	ps2_command(ps2dev, param, PSMOUSE_CMD_SETRES);
> +	param[0] = 0x64;
> +	ps2_command(ps2dev, param, PSMOUSE_CMD_SETRATE);
> +	ps2_command(ps2dev, param, PSMOUSE_CMD_GETINFO);
> +
> +	param[0] = 0x64;
> +	ps2_command(ps2dev, param, PSMOUSE_CMD_SETRATE);
> +	ps2_command(ps2dev, NULL, PSMOUSE_CMD_SETSCALE21);
> +	ps2_command(ps2dev, NULL, PSMOUSE_CMD_SETSTREAM);
> +	param[0] = 0x64;
> +	ps2_command(ps2dev, param, PSMOUSE_CMD_SETRATE);
> +	ps2_command(ps2dev, param, PSMOUSE_CMD_ENABLE);
> +
> +	return 0;
> +}

Eww... please tell me there is a more compressed way to initialize the device.

> +
> +static int alps_hw_init_v6(struct psmouse *psmouse)
> +{
> +	struct alps_data *priv = psmouse->private;
> +	struct ps2dev *ps2dev = &psmouse->ps2dev;
> +	unsigned char param[4];
> +
> +	/* Doesn't seem to be necessary but we keep here in case
> +		registers need to be used */
> +	priv->nibble_commands = alps_v3_nibble_commands;
> +
> +	priv->addr_command = PSMOUSE_CMD_RESET_WRAP;
> +	ps2_command(ps2dev, param, PSMOUSE_CMD_RESET_BAT);
> +	if (param[0] != PSMOUSE_RET_BAT && param[1] != PSMOUSE_RET_ID)
> +		psmouse_dbg(psmouse, "Bad reset %2.2x %2.2x", param[0], param[1]);
> +
> +	ps2_command(ps2dev, param, PSMOUSE_CMD_RESET_BAT);
> +	if (param[0] != PSMOUSE_RET_BAT && param[1] != PSMOUSE_RET_ID)
> +		psmouse_dbg(psmouse, "Bad reset %2.2x %2.2x", param[0], param[1]);
> +
> +	ps2_command(ps2dev, param, PSMOUSE_CMD_GETID);
> +
> +	/* E6 report */
> +	param[0] = 0;
> +	ps2_command(ps2dev, &param[0], PSMOUSE_CMD_SETRES);
> +	ps2_command(ps2dev, NULL, PSMOUSE_CMD_SETSCALE11);
> +	ps2_command(ps2dev, NULL, PSMOUSE_CMD_SETSCALE11);
> +	ps2_command(ps2dev, NULL, PSMOUSE_CMD_SETSCALE11);
> +	ps2_command(ps2dev, param, PSMOUSE_CMD_GETINFO);
> +
> +	/* ?? */
> +	param[0] = 0x03;
> +	ps2_command(ps2dev, &param[0], PSMOUSE_CMD_SETRES);
> +
> +	/* Set 9-byte to 8-byte */
> +	param[0] = 0xc8;
> +	param[1] = 0x64;
> +	param[2] = 0x50;
> +	if (ps2_command(ps2dev, &param[0], PSMOUSE_CMD_SETRATE) ||
> +		ps2_command(ps2dev, &param[1], PSMOUSE_CMD_SETRATE) ||
> +		ps2_command(ps2dev, &param[2], PSMOUSE_CMD_SETRATE) ||
> +		ps2_command(ps2dev, param, PSMOUSE_CMD_GETID))
> +		return -1;
> +
> +	/* Set rate and enable data reporting? */
> +	param[0] = 0xc8;
> +	param[1] = 0x50;
> +	ps2_command(ps2dev, &param[0], PSMOUSE_CMD_SETRATE);
> +	ps2_command(ps2dev, &param[0], PSMOUSE_CMD_SETRATE);
> +	ps2_command(ps2dev, &param[1], PSMOUSE_CMD_SETRATE);
> +	ps2_command(ps2dev, NULL, PSMOUSE_CMD_GETID);
> +
> +	param[0] = 0x64;
> +	param[1] = 0x03;
> +	ps2_command(ps2dev, &param[0], PSMOUSE_CMD_SETRATE);
> +	ps2_command(ps2dev, &param[1], PSMOUSE_CMD_SETRES);
> +
> +	ps2_command(ps2dev, NULL, PSMOUSE_CMD_ENABLE);
> +	ps2_command(ps2dev, NULL, PSMOUSE_CMD_DISABLE);
> +
> +	ps2_command(ps2dev, param, PSMOUSE_CMD_RESET_BAT);
> +	if (param[0] != PSMOUSE_RET_BAT && param[1] != PSMOUSE_RET_ID)
> +		psmouse_dbg(psmouse, "Bad reset %2.2x %2.2x", param[0], param[1]);
> +
> +	/* E7 report */
> +	ps2_command(ps2dev, NULL, PSMOUSE_CMD_SETSCALE21);
> +	ps2_command(ps2dev, NULL, PSMOUSE_CMD_SETSCALE21);
> +	ps2_command(ps2dev, NULL, PSMOUSE_CMD_SETSCALE21);
> +	ps2_command(ps2dev, param, PSMOUSE_CMD_GETINFO);
> +
> +	/* Enter command mode */
> +	alps_enter_command_mode(psmouse, param);
> +
> +	/* exit command mode */
> +	ps2_command(ps2dev, NULL, PSMOUSE_CMD_SETSTREAM);
> +
> +	ps2_command(ps2dev, NULL, PSMOUSE_CMD_SETPOLL);
> +	ps2_command(ps2dev, NULL, PSMOUSE_CMD_SETPOLL);
> +	ps2_command(ps2dev, param, PSMOUSE_CMD_GETINFO);
> +	/* param should be bf 1a 04 */
> +
> +	ps2_command(ps2dev, NULL, PSMOUSE_CMD_SETSTREAM);
> +	ps2_command(ps2dev, NULL, PSMOUSE_CMD_SETSTREAM);
> +	ps2_command(ps2dev, param, PSMOUSE_CMD_GETINFO);
> +	/* param should be 89 95 84 */
> +
> +	ps2_command(ps2dev, NULL, PSMOUSE_CMD_SETPOLL);
> +	ps2_command(ps2dev, NULL, PSMOUSE_CMD_SETPOLL);
> +	param[0] = 0x28;
> +	param[1] = 0x50;
> +	ps2_command(ps2dev, &param[0], PSMOUSE_CMD_SETRATE);
> +	ps2_command(ps2dev, &param[1], PSMOUSE_CMD_SETRATE);
> +
> +	/* Enter command mode */
> +	alps_enter_command_mode(psmouse, param);
> +
> +	ps2_command(ps2dev, NULL, PSMOUSE_CMD_RESET_WRAP);
> +	ps2_command(ps2dev, NULL, PSMOUSE_CMD_SETPOLL);
> +	ps2_command(ps2dev, NULL, PSMOUSE_CMD_SETPOLL);
> +	ps2_command(ps2dev, NULL, PSMOUSE_CMD_RESET_DIS);
> +	ps2_command(ps2dev, NULL, PSMOUSE_CMD_SETSCALE11);
> +	ps2_command(ps2dev, NULL, PSMOUSE_CMD_SETPOLL);
> +
> +	param[0] = 0x64;
> +	ps2_command(ps2dev, &param[0], PSMOUSE_CMD_SETRATE);
> +	ps2_command(ps2dev, NULL, PSMOUSE_CMD_RESET_WRAP);
> +	ps2_command(ps2dev, NULL, PSMOUSE_CMD_SETPOLL);
> +	ps2_command(ps2dev, NULL, PSMOUSE_CMD_SETSCALE21);
> +	ps2_command(ps2dev, NULL, PSMOUSE_CMD_SETSCALE21);
> +	param[0] = 0x64;
> +	ps2_command(ps2dev, &param[0], PSMOUSE_CMD_SETRATE);
> +	ps2_command(ps2dev, NULL, PSMOUSE_CMD_SETPOLL);
> +
> +	/* out of cmd mode? */
> +	ps2_command(ps2dev, NULL, PSMOUSE_CMD_SETSTREAM);
> +	ps2_command(ps2dev, NULL, PSMOUSE_CMD_DISABLE);
> +	ps2_command(ps2dev, NULL, PSMOUSE_CMD_SETSTREAM);
> +	ps2_command(ps2dev, NULL, PSMOUSE_CMD_SETSTREAM);
> +
> +	param[0] = 0x64;
> +	param[1] = 0x28;
> +	ps2_command(ps2dev, &param[0], PSMOUSE_CMD_SETRATE);
> +	ps2_command(ps2dev, &param[1], PSMOUSE_CMD_SETRATE);
> +
> +	ps2_command(ps2dev, NULL, PSMOUSE_CMD_SETSTREAM);
> +	ps2_command(ps2dev, NULL, PSMOUSE_CMD_SETSTREAM);
> +
> +	param[0] = 0x50;
> +	param[1] = 0x0a;
> +	ps2_command(ps2dev, &param[0], PSMOUSE_CMD_SETRATE);
> +	ps2_command(ps2dev, &param[1], PSMOUSE_CMD_SETRATE);
> +
> +	ps2_command(ps2dev, NULL, PSMOUSE_CMD_SETSTREAM);
> +
> +	param[0] = 0x50;
> +	ps2_command(ps2dev, &param[0], PSMOUSE_CMD_SETRATE);
> +	ps2_command(ps2dev, NULL, PSMOUSE_CMD_SETSCALE11);
> +
> +	param[0] = 0x03;
> +	ps2_command(ps2dev, &param[0], PSMOUSE_CMD_SETRES);
> +
> +	ps2_command(ps2dev, NULL, PSMOUSE_CMD_ENABLE);
> +
> +	return 0;
> +}

Ditto.

> +
> +
>  static int alps_hw_init(struct psmouse *psmouse)
>  {
>  	struct alps_data *priv = psmouse->private;
> @@ -1534,6 +1910,12 @@ static int alps_hw_init(struct psmouse *psmouse)
>  	case ALPS_PROTO_V4:
>  		ret = alps_hw_init_v4(psmouse);
>  		break;
> +	case ALPS_PROTO_V5:
> +		ret = alps_hs_init_v5(psmouse);
> +		break;
> +	case ALPS_PROTO_V6:
> +		ret = alps_hw_init_v6(psmouse);
> +		break;
>  	}
>  
>  	return ret;
> @@ -1618,7 +2000,7 @@ int alps_init(struct psmouse *psmouse)
>  	case ALPS_PROTO_V3:
>  	case ALPS_PROTO_V4:
>  		set_bit(INPUT_PROP_SEMI_MT, dev1->propbit);
> -		input_mt_init_slots(dev1, 2, 0);
> +		input_mt_init_slots(dev1, 2);

Nope - please refresh your patch to apply to Linus' tree.

>  		input_set_abs_params(dev1, ABS_MT_POSITION_X, 0, ALPS_V3_X_MAX, 0, 0);
>  		input_set_abs_params(dev1, ABS_MT_POSITION_Y, 0, ALPS_V3_Y_MAX, 0, 0);
>  
> @@ -1629,6 +2011,42 @@ int alps_init(struct psmouse *psmouse)
>  		input_set_abs_params(dev1, ABS_X, 0, ALPS_V3_X_MAX, 0, 0);
>  		input_set_abs_params(dev1, ABS_Y, 0, ALPS_V3_Y_MAX, 0, 0);
>  		break;
> +	case ALPS_PROTO_V5:
> +		set_bit(INPUT_PROP_SEMI_MT, dev1->propbit);
> +		input_mt_init_slots(dev1, 2);
> +		ALPS_BITMAP_X_BITS = 15;
> +		ALPS_BITMAP_Y_BITS = 11;
> +		ALPS_X_MAX = 2000;
> +		ALPS_Y_MAX = 1400;
> +		input_set_abs_params(dev1, ABS_MT_POSITION_X, 0, ALPS_X_MAX, 0, 0);
> +		input_set_abs_params(dev1, ABS_MT_POSITION_Y, 0, ALPS_Y_MAX, 0, 0);
> +
> +		set_bit(BTN_TOOL_DOUBLETAP, dev1->keybit);
> +		set_bit(BTN_TOOL_TRIPLETAP, dev1->keybit);
> +		set_bit(BTN_TOOL_QUADTAP, dev1->keybit);
> +
> +		input_set_abs_params(dev1, ABS_X, 0, ALPS_X_MAX, 0, 0);
> +		input_set_abs_params(dev1, ABS_Y, 0, ALPS_Y_MAX, 0, 0);
> +		break;
> +	case ALPS_PROTO_V6:
> +		set_bit(INPUT_PROP_SEMI_MT, dev1->propbit);
> +		ALPS_BITMAP_X_BITS = 23;
> +		ALPS_BITMAP_Y_BITS = 12;
> +		ALPS_X_MAX = 1360;
> +		ALPS_Y_MAX =  660;
> +
> +		input_mt_init_slots(dev1, 2);
> +		input_set_abs_params(dev1, ABS_MT_POSITION_X, 0, ALPS_X_MAX, 0, 0);
> +		input_set_abs_params(dev1, ABS_MT_POSITION_Y, 0, ALPS_Y_MAX, 0, 0);
> +
> +		set_bit(BTN_TOOL_DOUBLETAP, dev1->keybit);
> +		set_bit(BTN_TOOL_TRIPLETAP, dev1->keybit);
> +		set_bit(BTN_TOOL_QUADTAP, dev1->keybit);
> +
> +		input_set_abs_params(dev1, ABS_X, 0, ALPS_X_MAX, 0, 0);
> +		input_set_abs_params(dev1, ABS_Y, 0, ALPS_Y_MAX, 0, 0);
> +
> +		break;
>  	}
>  
>  	input_set_abs_params(dev1, ABS_PRESSURE, 0, 127, 0, 0);
> diff --git a/drivers/input/mouse/alps.h b/drivers/input/mouse/alps.h
> index ae1ac35..75a06af 100644
> --- a/drivers/input/mouse/alps.h
> +++ b/drivers/input/mouse/alps.h
> @@ -16,6 +16,8 @@
>  #define ALPS_PROTO_V2	1
>  #define ALPS_PROTO_V3	2
>  #define ALPS_PROTO_V4	3
> +#define ALPS_PROTO_V5	4
> +#define ALPS_PROTO_V6	5
>  
>  struct alps_model_info {
>          unsigned char signature[3];
> -- 
> 1.7.7.6
> 

Thanks,
Henrik
