Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933726AbaJUVb6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 17:31:58 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:49126 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933458AbaJUVb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 17:31:56 -0400
Date: Tue, 21 Oct 2014 14:32:12 -0700
From: Darren Hart <dvhart@infradead.org>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>
Subject: Re: [PATCH] dell-wmi: Update code for processing WMI events
Message-ID: <20141021213212.GE20951@vmdeb7>
References: <1413843324-13662-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1413843324-13662-1-git-send-email-pali.rohar@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 12:15:24AM +0200, Pali Rohár wrote:
> WMI buffer can contains more events. First value in buffer is length of event
> followed by data of specified length. After that is next length and next data.
> When length is zero then there is no more events in bufffer.
> 
> This patch adds support for processing all events in buffer (not only first)
> and parse more event types (not only hotkey events). Because of variable length
> of events sometimes BIOS fills more hotkeys (or other values) into single WMI
> event. In this case this patch process also these multiple hotkeys (and not
> only first one).
> 
> Some event types are just ignored because kernel is not interested for them
> (e.g. NIC Link status, battery unplug, ...).
> 
> This patch is based on DSDT table from Dell Latitude E6440. Code should be
> backward compatible so will process other events of old types same as before
> this patch.
> 
> This patch also fixes problem when in kernel log are written messages about
> unknown WMI events. Now all know events are parsed and those which are not
> interesting for kernel are dropped without unknown message.

This should probably be done in a separate patch.

> 
> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> Tested-by: Pali Rohár <pali.rohar@gmail.com>

Well yes, I should hope so ;-)

> ---
>  drivers/platform/x86/dell-wmi.c |  157 +++++++++++++++++++++++++++++++--------
>  1 file changed, 127 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/platform/x86/dell-wmi.c b/drivers/platform/x86/dell-wmi.c
> index 25721bf..3d15949 100644
> --- a/drivers/platform/x86/dell-wmi.c
> +++ b/drivers/platform/x86/dell-wmi.c
> @@ -145,11 +145,35 @@ static const u16 bios_to_linux_keycode[256] __initconst = {
>  
>  static struct input_dev *dell_wmi_input_dev;
>  
> +static void dell_wmi_process_key(int reported_key)
> +{
> +	const struct key_entry *key;
> +
> +	key = sparse_keymap_entry_from_scancode(dell_wmi_input_dev,
> +						reported_key);
> +	if (!key) {
> +		pr_info("Unknown key %x pressed\n", reported_key);
> +		return;
> +	}
> +
> +	pr_debug("Key %x pressed\n", reported_key);
> +
> +	/* Don't report brightness notifications that will also come via ACPI */
> +	if ((key->keycode == KEY_BRIGHTNESSUP ||
> +	     key->keycode == KEY_BRIGHTNESSDOWN) && acpi_video)
> +		return;
> +
> +	sparse_keymap_report_entry(dell_wmi_input_dev, key, 1, true);
> +}
> +
>  static void dell_wmi_notify(u32 value, void *context)
>  {
>  	struct acpi_buffer response = { ACPI_ALLOCATE_BUFFER, NULL };
>  	union acpi_object *obj;
>  	acpi_status status;
> +	acpi_size buffer_size;
> +	u16 *buffer_entry, *buffer_end;
> +	int len, i;
>  
>  	status = wmi_get_event_data(value, &response);
>  	if (status != AE_OK) {
> @@ -158,44 +182,117 @@ static void dell_wmi_notify(u32 value, void *context)
>  	}
>  
>  	obj = (union acpi_object *)response.pointer;
> +	if (!obj) {
> +		pr_info("no response\n");
> +		return;
> +	}


If you intend to print this, it should probably be a bit more informative. Is
"info" the right level here? I would imagine either WARN if this was a bad
thing, or DEBUG if this is more for debugging the driver.


> -	if (obj && obj->type == ACPI_TYPE_BUFFER) {
> -		const struct key_entry *key;
> -		int reported_key;
> -		u16 *buffer_entry = (u16 *)obj->buffer.pointer;
> -		int buffer_size = obj->buffer.length/2;
> -
> -		if (buffer_size >= 2 && dell_new_hk_type && buffer_entry[1] != 0x10) {
> -			pr_info("Received unknown WMI event (0x%x)\n",
> -				buffer_entry[1]);
> -			kfree(obj);
> -			return;
> -		}
> +	if (obj->type != ACPI_TYPE_BUFFER) {
> +		pr_info("bad response type %x\n", obj->type);
> +		kfree(obj);
> +		return;
> +	}
> +
> +	pr_debug("Received WMI event (%*ph)\n",
> +		obj->buffer.length, obj->buffer.pointer);
>  
> -		if (buffer_size >= 3 && (dell_new_hk_type || buffer_entry[1] == 0x0))
> -			reported_key = (int)buffer_entry[2];
> +	buffer_entry = (u16 *)obj->buffer.pointer;
> +	buffer_size = obj->buffer.length/2;
> +
> +	if (!dell_new_hk_type) {
> +		if (buffer_size >= 3 && buffer_entry[1] == 0x0)
> +			dell_wmi_process_key(buffer_entry[2]);
>  		else if (buffer_size >= 2)
> -			reported_key = (int)buffer_entry[1] & 0xffff;
> -		else {
> +			dell_wmi_process_key(buffer_entry[1]);


Why can we drop the 0xffff mask now?


> +		else
>  			pr_info("Received unknown WMI event\n");
> -			kfree(obj);
> -			return;
> +		kfree(obj);
> +		return;
> +	}
> +
> +	buffer_end = buffer_entry + buffer_size;
> +
> +	while (buffer_entry < buffer_end) {
> +
> +		len = buffer_entry[0];
> +		if (len == 0)
> +			break;
> +
> +		len++;
> +


Why increment len here? Are you trying to avoid a "len + 1" in the comparisons
below? If so, is using "len * 2" in the debug message below correct? Please
clarify.


> +		if (buffer_entry+len > buffer_end) {


See coding style documentation on operators. Please run patches through
checkpatch.


> +			pr_info("Invalid length of WMI event\n");

info doesn't see correct here either.

> +			break;
>  		}
>  
> -		key = sparse_keymap_entry_from_scancode(dell_wmi_input_dev,
> -							reported_key);
> -		if (!key) {
> -			pr_info("Unknown key %x pressed\n", reported_key);
> -		} else if ((key->keycode == KEY_BRIGHTNESSUP ||
> -			    key->keycode == KEY_BRIGHTNESSDOWN) && acpi_video) {
> -			/* Don't report brightness notifications that will also
> -			 * come via ACPI */
> -			;
> -		} else {
> -			sparse_keymap_report_entry(dell_wmi_input_dev, key,
> -						   1, true);
> +		pr_debug("Process buffer (%*ph)\n", len*2, buffer_entry);
> +
> +		switch (buffer_entry[1]) {
> +		case 0x00:
> +			for (i = 2; i < len; ++i) {
> +				switch (buffer_entry[i]) {
> +				case 0xe043:
> +					/* NIC Link is Up */
> +					pr_debug("NIC Link is Up\n");
> +					break;
> +				case 0xe044:
> +					/* NIC Link is Down */
> +					pr_debug("NIC Link is Down\n");
> +					break;
> +				case 0xe045:
> +					/* Unknown event but defined in DSDT */
> +				default:
> +					/* Unknown event */
> +					pr_info("Unknown WMI event type 0x00: "
> +						"0x%x\n", (int)buffer_entry[i]);
> +					break;
> +				}
> +			}
> +			break;
> +		case 0x10:
> +			/* Keys pressed */
> +			for (i = 2; i < len; ++i)
> +				dell_wmi_process_key(buffer_entry[i]);
> +			break;
> +		case 0x11:
> +			for (i = 2; i < len; ++i) {
> +				switch (buffer_entry[i]) {
> +				case 0xfff0:
> +					/* Battery unplugged */
> +					pr_debug("Battery unplugged\n");
> +					break;
> +				case 0xfff1:
> +					/* Battery inserted */
> +					pr_debug("Battery inserted\n");
> +					break;
> +				case 0x01e1:
> +				case 0x02ea:
> +				case 0x02eb:
> +				case 0x02ec:
> +				case 0x02f6:
> +					/* Keyboard backlight level changed */
> +					pr_debug("Keyboard backlight level "
> +						 "changed\n");
> +					break;
> +				default:
> +					/* Unknown event */
> +					pr_info("Unknown WMI event type 0x11: "
> +						"0x%x\n", (int)buffer_entry[i]);
> +					break;
> +				}
> +			}
> +			break;
> +		default:
> +			/* Unknown event */
> +			pr_info("Unknown WMI event type 0x%x\n",
> +				(int)buffer_entry[1]);
> +			break;
>  		}
> +
> +		buffer_entry += len;
> +
>  	}
> +
>  	kfree(obj);
>  }
>  
> -- 
> 1.7.9.5
> 
> 

-- 
Darren Hart
Intel Open Source Technology Center
