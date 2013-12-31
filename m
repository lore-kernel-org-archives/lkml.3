Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465Ab3LaNRN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 08:17:13 -0500
Received: from server.atrad.com.au ([150.101.241.2]:38838 "EHLO
	server.atrad.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230Ab3LaNRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 08:17:12 -0500
X-Greylist: delayed 636 seconds by postgrey-1.27 at vger.kernel.org; Tue, 31 Dec 2013 08:17:11 EST
Date: Tue, 31 Dec 2013 23:35:12 +1030
From: Jonathan Woithe <jwoithe@just42.net>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org,
        Matthew Garrett <matthew.garrett@nebula.com>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        jwoithe@just42.net
Subject: Re: [PATCH 21/25] fujitsu-laptop: fix error return code
Message-ID: <20131231130512.GB20866@marvin.atrad.com.au>
References: <1388357260-4843-1-git-send-email-Julia.Lawall@lip6.fr>
 <1388357260-4843-22-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1388357260-4843-22-git-send-email-Julia.Lawall@lip6.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 29, 2013 at 11:47:36PM +0100, Julia Lawall wrote:
> These functions mix the use of result and error.  In acpi_fujitsu_add,
> result does not seem useful; it would seem reasonable to propagate the
> return value of acpi_bus_update_power in an error case.

Agreed.

> On the other hand, in the case of acpi_fujitsu_hotkey_add, there is an
> initialization of result that can lead to what looks like a failure case,
> but that does not abort the function.  The variable result is kept for
> this case.

The handling of result in acpi_fujitsu_hotkey_add() applies to machines
which I don't have physical access to - the code was contributed by others. 
My understanding is that on these machines the failure of the LED class
registration is not necessarily grounds for aborting the function
immediately.  That said, the change made to acpi_fujitsu_hotkey_add() in
this patch look correct to me: the err_stop label should be returning
"error", and consequently the acpi_bus_update_power() return should be saved
to "error".

Acked-off-by: Jonathan Woithe <jwoithe@just42.net>

> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> ---
> Not tested.  Not sure to be doing the right thing with result in the second
> case.
> 
>  drivers/platform/x86/fujitsu-laptop.c |   15 +++++++--------
>  1 file changed, 7 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/platform/x86/fujitsu-laptop.c b/drivers/platform/x86/fujitsu-laptop.c
> index 9d30d69..be02bcc 100644
> --- a/drivers/platform/x86/fujitsu-laptop.c
> +++ b/drivers/platform/x86/fujitsu-laptop.c
> @@ -633,7 +633,6 @@ static struct dmi_system_id fujitsu_dmi_table[] = {
>  
>  static int acpi_fujitsu_add(struct acpi_device *device)
>  {
> -	int result = 0;
>  	int state = 0;
>  	struct input_dev *input;
>  	int error;
> @@ -669,8 +668,8 @@ static int acpi_fujitsu_add(struct acpi_device *device)
>  	if (error)
>  		goto err_free_input_dev;
>  
> -	result = acpi_bus_update_power(fujitsu->acpi_handle, &state);
> -	if (result) {
> +	error = acpi_bus_update_power(fujitsu->acpi_handle, &state);
> +	if (error) {
>  		pr_err("Error reading power state\n");
>  		goto err_unregister_input_dev;
>  	}
> @@ -700,7 +699,7 @@ static int acpi_fujitsu_add(struct acpi_device *device)
>  		fujitsu->max_brightness = FUJITSU_LCD_N_LEVELS;
>  	get_lcd_level();
>  
> -	return result;
> +	return 0;
>  
>  err_unregister_input_dev:
>  	input_unregister_device(input);
> @@ -708,7 +707,7 @@ err_unregister_input_dev:
>  err_free_input_dev:
>  	input_free_device(input);
>  err_stop:
> -	return result;
> +	return error;
>  }
>  
>  static int acpi_fujitsu_remove(struct acpi_device *device)
> @@ -831,8 +830,8 @@ static int acpi_fujitsu_hotkey_add(struct acpi_device *device)
>  	if (error)
>  		goto err_free_input_dev;
>  
> -	result = acpi_bus_update_power(fujitsu_hotkey->acpi_handle, &state);
> -	if (result) {
> +	error = acpi_bus_update_power(fujitsu_hotkey->acpi_handle, &state);
> +	if (error) {
>  		pr_err("Error reading power state\n");
>  		goto err_unregister_input_dev;
>  	}
> @@ -907,7 +906,7 @@ err_free_input_dev:
>  err_free_fifo:
>  	kfifo_free(&fujitsu_hotkey->fifo);
>  err_stop:
> -	return result;
> +	return error;
>  }
>  
>  static int acpi_fujitsu_hotkey_remove(struct acpi_device *device)
> 
> --
