Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814AbaBYOLP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 09:11:15 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:54499 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752439AbaBYOLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 09:11:13 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Lan Tianyu <tianyu.lan@intel.com>, Lv Zheng <lv.zheng@intel.com>,
        Alan Cox <alan.cox@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] gpio / ACPI: Embed events list directly into struct acpi_gpio_chip
Date: Tue, 25 Feb 2014 15:26:12 +0100
Message-ID: <46469934.18k5deNECp@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1393257611-18031-5-git-send-email-mika.westerberg@linux.intel.com>
References: <1393257611-18031-1-git-send-email-mika.westerberg@linux.intel.com> <1393257611-18031-5-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 24, 2014 06:00:09 PM Mika Westerberg wrote:
> It is not necessary to have events as a pointer to list in struct
> acpi_gpio_chip. Instead we can embed the list_head directly to struct
> acpi_gpio_chip itself. This makes event handling a bit simpler because now
> we don't need to check whether the pointer is NULL or not.

It looks like I should have reviewed the whole series before commenting [2/6].

Well, my modified comment would be "Why don't you fold this one into [2/6]?", then.

> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> ---
>  drivers/gpio/gpiolib-acpi.c | 35 +++++++++++++----------------------
>  1 file changed, 13 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/gpio/gpiolib-acpi.c b/drivers/gpio/gpiolib-acpi.c
> index cb99dc2c552e..c60db4ddc166 100644
> --- a/drivers/gpio/gpiolib-acpi.c
> +++ b/drivers/gpio/gpiolib-acpi.c
> @@ -28,7 +28,7 @@ struct acpi_gpio_event {
>  
>  struct acpi_gpio_chip {
>  	struct gpio_chip *chip;
> -	struct list_head *events;
> +	struct list_head events;
>  };
>  
>  static int acpi_gpiochip_find(struct gpio_chip *gc, void *data)
> @@ -106,8 +106,7 @@ static void acpi_gpiochip_request_interrupts(struct acpi_gpio_chip *achip)
>  	struct acpi_buffer buf = {ACPI_ALLOCATE_BUFFER, NULL};
>  	struct gpio_chip *chip = achip->chip;
>  	struct acpi_resource *res;
> -	acpi_handle handle, evt_handle;
> -	struct list_head *events = NULL;
> +	acpi_handle handle;
>  	acpi_status status;
>  	unsigned int pin;
>  	int irq, ret;
> @@ -120,19 +119,12 @@ static void acpi_gpiochip_request_interrupts(struct acpi_gpio_chip *achip)
>  	if (!handle)
>  		return;
>  
> +	INIT_LIST_HEAD(&achip->events);
> +
>  	status = acpi_get_event_resources(handle, &buf);
>  	if (ACPI_FAILURE(status))
>  		return;
>  
> -	status = acpi_get_handle(handle, "_EVT", &evt_handle);
> -	if (ACPI_SUCCESS(status)) {
> -		events = kzalloc(sizeof(*events), GFP_KERNEL);
> -		if (events) {
> -			INIT_LIST_HEAD(events);
> -			achip->events = events;
> -		}
> -	}
> -
>  	/*
>  	 * If a GPIO interrupt has an ACPI event handler method, or _EVT is
>  	 * present, set up an interrupt handler that calls the ACPI event
> @@ -168,14 +160,19 @@ static void acpi_gpiochip_request_interrupts(struct acpi_gpio_chip *achip)
>  				data = ev_handle;
>  			}
>  		}
> -		if (!handler && events) {
> +		if (!handler) {
>  			struct acpi_gpio_event *event;
> +			acpi_handle evt_handle;
> +
> +			status = acpi_get_handle(handle, "_EVT", &evt_handle);
> +			if (ACPI_FAILURE(status))
> +				continue;
>  
>  			event = kzalloc(sizeof(*event), GFP_KERNEL);
>  			if (!event)
>  				continue;
>  
> -			list_add_tail(&event->node, events);
> +			list_add_tail(&event->node, &achip->events);
>  			event->evt_handle = evt_handle;
>  			event->pin = pin;
>  			event->irq = irq;
> @@ -207,23 +204,17 @@ static void acpi_gpiochip_request_interrupts(struct acpi_gpio_chip *achip)
>   */
>  static void acpi_gpiochip_free_interrupts(struct acpi_gpio_chip *achip)
>  {
> -	struct list_head *events;
>  	struct acpi_gpio_event *event, *ep;
>  	struct gpio_chip *chip = achip->chip;
>  
> -	if (!chip->dev || !chip->to_irq || !achip->events)
> +	if (!chip->dev || !chip->to_irq)
>  		return;
>  
> -	events = achip->events;
> -	achip->events = NULL;
> -
> -	list_for_each_entry_safe_reverse(event, ep, events, node) {
> +	list_for_each_entry_safe_reverse(event, ep, &achip->events, node) {
>  		devm_free_irq(chip->dev, event->irq, event);
>  		list_del(&event->node);
>  		kfree(event);
>  	}
> -
> -	kfree(events);
>  }
>  
>  struct acpi_gpio_lookup {
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
