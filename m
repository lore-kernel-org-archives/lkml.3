Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756506AbaJaQwd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 12:52:33 -0400
Received: from mail-ig0-f169.google.com ([209.85.213.169]:47552 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbaJaQwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 12:52:31 -0400
Date: Fri, 31 Oct 2014 09:52:26 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Henrik Rydberg <rydberg@euromail.se>, Hans de Goede <hdegoede@redhat.com>,
        Peter Hutterer <peter.hutterer@who-t.net>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Daniel Kurtz <djkurtz@chromium.org>,
        Chung-yih Wang <cywang@chromium.org>
Subject: Re: [PATCH 2/2] Input: synaptics: remove duplicated code
Message-ID: <20141031165226.GC32331@dtor-ws>
References: <1414693987-6059-1-git-send-email-benjamin.tissoires@redhat.com>
 <1414693987-6059-2-git-send-email-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414693987-6059-2-git-send-email-benjamin.tissoires@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ Daniel & Chung-yih

On Thu, Oct 30, 2014 at 02:33:07PM -0400, Benjamin Tissoires wrote:
> synaptics_profile_sensor_process() and synaptics_report_mt_data() now
> share the exact same code. Remove one implementation and rely on the
> other where it was used.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> ---
>  drivers/input/mouse/synaptics.c | 38 +-------------------------------------
>  1 file changed, 1 insertion(+), 37 deletions(-)
> 
> diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
> index fd89249..8ae1841 100644
> --- a/drivers/input/mouse/synaptics.c
> +++ b/drivers/input/mouse/synaptics.c
> @@ -851,42 +851,6 @@ static void synaptics_image_sensor_process(struct psmouse *psmouse,
>  	synaptics_report_mt_data(psmouse, sgm, num_fingers);
>  }
>  
> -static void synaptics_profile_sensor_process(struct psmouse *psmouse,
> -					     struct synaptics_hw_state *sgm,
> -					     int num_fingers)
> -{
> -	struct input_dev *dev = psmouse->dev;
> -	struct synaptics_data *priv = psmouse->private;
> -	struct synaptics_hw_state *hw[2] = { sgm, &priv->agm };
> -	struct input_mt_pos pos[2];
> -	int slot[2], nsemi, i;
> -
> -	nsemi = clamp_val(num_fingers, 0, 2);
> -
> -	for (i = 0; i < nsemi; i++) {
> -		pos[i].x = hw[i]->x;
> -		pos[i].y = synaptics_invert_y(hw[i]->y);
> -	}
> -
> -	input_mt_assign_slots(dev, slot, pos, nsemi);
> -
> -	for (i = 0; i < nsemi; i++) {
> -		input_mt_slot(dev, slot[i]);
> -		input_mt_report_slot_state(dev, MT_TOOL_FINGER, true);
> -		input_report_abs(dev, ABS_MT_POSITION_X, pos[i].x);
> -		input_report_abs(dev, ABS_MT_POSITION_Y, pos[i].y);
> -		input_report_abs(dev, ABS_MT_PRESSURE, hw[i]->z);
> -	}
> -
> -	input_mt_drop_unused(dev);
> -	input_mt_report_pointer_emulation(dev, false);
> -	input_mt_report_finger_count(dev, num_fingers);
> -
> -	synaptics_report_buttons(psmouse, sgm);
> -
> -	input_sync(dev);
> -}
> -
>  /*
>   *  called for each full received packet from the touchpad
>   */
> @@ -951,7 +915,7 @@ static void synaptics_process_packet(struct psmouse *psmouse)
>  	}
>  
>  	if (cr48_profile_sensor) {
> -		synaptics_profile_sensor_process(psmouse, &hw, num_fingers);
> +		synaptics_report_mt_data(psmouse, &hw, num_fingers);
>  		return;
>  	}
>  
> -- 
> 2.1.0
> 

-- 
Dmitry
