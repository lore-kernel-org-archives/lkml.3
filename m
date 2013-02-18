Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717Ab3BRCox (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 21:44:53 -0500
Received: from fox.seas.upenn.edu ([158.130.68.12]:34613 "EHLO
	fox.seas.upenn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755344Ab3BRCow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 21:44:52 -0500
X-Greylist: delayed 310 seconds by postgrey-1.27 at vger.kernel.org; Sun, 17 Feb 2013 21:44:51 EST
Message-ID: <51219432.8020902@seas.upenn.edu>
Date: Sun, 17 Feb 2013 21:38:42 -0500
From: Rafi Rubin <rafi@seas.upenn.edu>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
CC: Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: ntrig: use input_configured() callback to set the
 name
References: <1360335090-24024-1-git-send-email-benjamin.tissoires@gmail.com>
In-Reply-To: <1360335090-24024-1-git-send-email-benjamin.tissoires@gmail.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.9.8327,1.0.431,0.0.0000
 definitions=2013-02-18_01:2013-02-15,2013-02-18,1970-01-01 signatures=0
X-PP-Spam-Details: rule=add_spam_details policy=default score=0 spamscore=0 ipscore=0
 suspectscore=2 phishscore=0 bulkscore=0 adultscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=6.0.2-1211240000
 definitions=main-1302170326
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Looks good, and I can confirm it works fine.

Signed-off-by: Rafi Rubin <rafi@seas.upenn.edu>

On 02/08/13 09:51, Benjamin Tissoires wrote:
> The use of input_configured() allows the ntrig driver to actually 
> change the name of the input and its bitmask before it is added to
> the input subsystem. Thus, the logs are coherents and udev catch
> the real bitmask when the device is added.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com> 
> --- drivers/hid/hid-ntrig.c | 68
> ++++++++++++++++++++++++------------------------- 1 file changed,
> 34 insertions(+), 34 deletions(-)
> 
> diff --git a/drivers/hid/hid-ntrig.c b/drivers/hid/hid-ntrig.c 
> index 2ffc0e3..7757e82 100644 --- a/drivers/hid/hid-ntrig.c +++
> b/drivers/hid/hid-ntrig.c @@ -858,12 +858,43 @@ not_claimed_input: 
> return 1; }
> 
> +static void ntrig_input_configured(struct hid_device *hid, +
> struct hid_input *hidinput) + +{ +	struct input_dev *input =
> hidinput->input; + +	if (hidinput->report->maxfield < 1) +
> return; + +	switch (hidinput->report->field[0]->application) { +
> case HID_DG_PEN: +		input->name = "N-Trig Pen"; +		break; +	case
> HID_DG_TOUCHSCREEN: +		/* These keys are redundant for fingers,
> clear them +		 * to prevent incorrect identification */ +
> __clear_bit(BTN_TOOL_PEN, input->keybit); +
> __clear_bit(BTN_TOOL_FINGER, input->keybit); +		__clear_bit(BTN_0,
> input->keybit); +		__set_bit(BTN_TOOL_DOUBLETAP, input->keybit); +
> /* +		 * The physical touchscreen (single touch) +		 * input has a
> value for physical, whereas +		 * the multitouch only has logical
> input +		 * fields. +		 */ +		input->name =
> (hidinput->report->field[0]->physical) ? +							"N-Trig
> Touchscreen" : +							"N-Trig MultiTouch"; +		break; +	} +} + 
> static int ntrig_probe(struct hid_device *hdev, const struct
> hid_device_id *id) { int ret; struct ntrig_data *nd; -	struct
> hid_input *hidinput; -	struct input_dev *input; struct hid_report
> *report;
> 
> if (id->driver_data) @@ -901,38 +932,6 @@ static int
> ntrig_probe(struct hid_device *hdev, const struct hid_device_id
> *id) goto err_free; }
> 
> - -	list_for_each_entry(hidinput, &hdev->inputs, list) { -		if
> (hidinput->report->maxfield < 1) -			continue; - -		input =
> hidinput->input; -		switch
> (hidinput->report->field[0]->application) { -		case HID_DG_PEN: -
> input->name = "N-Trig Pen"; -			break; -		case HID_DG_TOUCHSCREEN: 
> -			/* These keys are redundant for fingers, clear them -			 * to
> prevent incorrect identification */ -			__clear_bit(BTN_TOOL_PEN,
> input->keybit); -			__clear_bit(BTN_TOOL_FINGER, input->keybit); -
> __clear_bit(BTN_0, input->keybit); -
> __set_bit(BTN_TOOL_DOUBLETAP, input->keybit); -			/* -			 * The
> physical touchscreen (single touch) -			 * input has a value for
> physical, whereas -			 * the multitouch only has logical input -
> * fields. -			 */ -			input->name = -
> (hidinput->report->field[0] -				 ->physical) ? -				"N-Trig
> Touchscreen" : -				"N-Trig MultiTouch"; -			break; -		} -	} - /*
> This is needed for devices with more recent firmware versions */ 
> report =
> hdev->report_enum[HID_FEATURE_REPORT].report_id_hash[0x0a]; if
> (report) { @@ -1023,6 +1022,7 @@ static struct hid_driver
> ntrig_driver = { .remove = ntrig_remove, .input_mapping =
> ntrig_input_mapping, .input_mapped = ntrig_input_mapped, +
> .input_configured = ntrig_input_configured, .usage_table =
> ntrig_grabbed_usages, .event = ntrig_event, };

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJRIZQxAAoJEPILXytRLnK26REP+weeAIqA4kfDn+tWqFOXIbcL
u65bkvNQmlEqx/mUeO7i7+tOsgTJnKpMy3ec5zsfyZd5DKs2yc3DTvrNXZbnqumZ
NkUYe7+aob1ge4+edJKw9nWDHp2E1sCm7VDNXVcEUTQN1ntMp/BjMenhDjgWhXVw
/3meslXrD3TOvXx/FzDLzJdV1WdBPeOHTHZq/yxsI3Z5jWCFba/Xz1CHc62sd2Og
hRTe9CthK3Hq9EQJXOc8qSBgNkhQ6XtBZb7KTw7FXAyKH3htus6t3c57ZPqGUUER
i6rasUYs3QGQQDG3tEU4wnWEtkS0i+9SO9L8tkUJwTKmdn7rDd5oAwovwMghkEkb
L1+tKL8EamC1oD8CMfHa7zCOTlkfTT0eRJiyHIErWpxn+VQxx2fpR7/MS2fF9n60
ecNGCRGrQo1UvIpYHmmGfigptcp6kyDgl8H9KBjafbQI5OWrJanwPi3aIXYhZmo8
XLjqCRJfgeJKFZD3mTdgqKL0hpNldskNUUauFD5GJblAB3UQ/MZ5Nmm+hWi3Y7y2
e0zxkPzw1puBFNNA06KLUNJ1DyibBZTPua1h36bD+OtqcRXIi8cdMHVf7bZhWSUK
ePVxgYjbgybAh4gMTgRQP/ucEuc6eDHGQ6MRe16ezwk3+fvUiLPntAtTXro1e3ck
nN0+r/NQSn7PKOdCqgeF
=ltkV
-----END PGP SIGNATURE-----
